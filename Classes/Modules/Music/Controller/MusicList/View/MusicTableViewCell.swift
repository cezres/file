//
//  MusicTableViewCell.swift
//  file
//
//  Created by 翟泉 on 2016/10/14.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class MusicTableViewCell: UITableViewCell {
    
    private var numberLabel: UILabel!
    private var artworkImageView: UIImageView!
    private var songLabel: UILabel!
    private var singerLabel: UILabel!
    private var albumNameLabel: UILabel!
    private var durationLabel: UILabel!
    
    private var musicIndicator: ESTMusicIndicatorView!
    
    var state: ESTMusicIndicatorViewState = .stopped {
        didSet {
            musicIndicator.state = state
            numberLabel.isHidden = state != .stopped
        }
    }
    
    var number: Int = -1 {
        didSet {
            numberLabel.text = "\(number)"
        }
    }
    
    private var id: Int64 = 0
    
    func setup(_ music: Music) {
        guard id != music.id else {
            return
        }
        id = music.id
        
        artworkImageView.image = UIImage(named: "icon_audio")
        
        FileThumbnail.shared.thumbnail(file: File(path: music.url.path), callback: { [weak self](file, image) in
            guard let weakself = self else {
                return
            }
            if weakself.id == music.id {
                weakself.artworkImageView.image = image
            }
        })
        
        songLabel.text = music.song
        singerLabel.text = "歌手:\(music.singer)"
        albumNameLabel.text = "专辑:\(music.albumName)"
        durationLabel.text = String(format: "%02d:%02d", Int(music.duration/60), Int(music.duration) % 60)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundView = UIView()
        backgroundView?.backgroundColor = UIColor.white
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = ColorWhite(220)
        
//        let button = UIButton(type: .system)
//        button.setTitle("删除", for: .normal)
//        button.setTitleColor(UIColor.white, for: .normal)
//        button.backgroundColor = ColorRGB(253, 85, 98)
//        setRightButtons([button], withButtonWidth: 80)
        
        musicIndicator = ESTMusicIndicatorView(frame: CGRect())
        contentView.addSubview(musicIndicator)
        
        
        numberLabel = UILabel()
        numberLabel.font = Font(14)
        numberLabel.textAlignment = .center
        numberLabel.textColor = ColorWhite(146)
        contentView.addSubview(numberLabel)
        
        artworkImageView = UIImageView()
        artworkImageView.clipsToBounds = true
        artworkImageView.contentMode = .scaleAspectFit
        contentView.addSubview(artworkImageView)
        
        songLabel = UILabel()
        songLabel.font = Font(16)
        songLabel.textAlignment = .left
        songLabel.textColor = ColorWhite(86)
        contentView.addSubview(songLabel)
        
        singerLabel = UILabel()
        singerLabel.font = Font(11)
        singerLabel.textAlignment = .left
        singerLabel.textColor = ColorWhite(146)
        contentView.addSubview(singerLabel)
        
        albumNameLabel = UILabel()
        albumNameLabel.font = Font(11)
        albumNameLabel.textAlignment = .left
        albumNameLabel.textColor = ColorWhite(146)
        contentView.addSubview(albumNameLabel)
        
        durationLabel = UILabel()
        durationLabel.font = Font(13)
        durationLabel.textAlignment = .right
        durationLabel.textColor = ColorWhite(146)
        contentView.addSubview(durationLabel)
        
        
        musicIndicator.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        numberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
        artworkImageView.snp.makeConstraints { (make) in
            make.left.equalTo(numberLabel.snp.right)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.8)
            make.width.equalTo(artworkImageView.snp.height)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        songLabel.snp.makeConstraints { (make) in
            make.left.equalTo(artworkImageView.snp.right).offset(10)
            make.right.equalTo(durationLabel.snp.left)
            make.height.equalTo(songLabel.font.lineHeight)
            make.bottom.equalTo(contentView.snp.centerY).offset(-3)
        }
        singerLabel.snp.makeConstraints { (make) in
            make.left.equalTo(songLabel)
            make.right.equalTo(songLabel)
            make.height.equalTo(singerLabel.font.lineHeight)
            make.top.equalTo(contentView.snp.centerY).offset(0)
        }
        albumNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(songLabel)
            make.right.equalTo(songLabel)
            make.height.equalTo(albumNameLabel.font.lineHeight)
            make.top.equalTo(singerLabel.snp.bottom).offset(0)
        }
        
        durationLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.width.equalTo(40)
            make.height.equalTo(durationLabel.font.lineHeight)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
