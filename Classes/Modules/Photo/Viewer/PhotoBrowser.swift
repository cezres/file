//
//  PhotoBrowser.swift
//  file
//
//  Created by 翟泉 on 2017/3/4.
//  Copyright © 2017年 云之彼端. All rights reserved.
//

import UIKit

class PhotoBrowser: UIViewController, UIScrollViewDelegate {
    
    fileprivate var _urls: [URL]!
    
    fileprivate var _index: Int = 0 {
        didSet {
            guard _index != oldValue else {
                return
            }
            title = "\(_index+1)/\(_urls.count)"
            
            
            print("\n\n")
            
            print(_index)
            
            if _index < oldValue {
                print("←")
                // left
                if _index > 0 {
                    let photoView = getPhotoView()
                    photoView.isHidden = false
                    photoView.tag = _index - 1
                    photoView.url = _urls[photoView.tag]
                    photoView.frame = CGRect(x: _scrollView.bounds.width * CGFloat(photoView.tag), y: 0, width: _scrollView.bounds.width, height: _scrollView.bounds.height)
                    photoViews.insert(photoView, at: 0)
                    print("添加\(photoView.tag)")
                }
                // remove
                if photoViews.count > 3 {
                    let photoView = photoViews.removeLast()
                    photoView.isHidden = true
                    cachePhotoViews.append(photoView)
                    print("删除\(photoView.tag)")
                }
            }
            else {
                print("→")
                // right
                if _index < _urls.count - 1 {
                    let photoView = getPhotoView()
                    photoView.isHidden = false
                    photoView.tag = _index + 1
                    photoView.url = _urls[photoView.tag]
                    photoView.frame = CGRect(x: _scrollView.bounds.width * CGFloat(photoView.tag), y: 0, width: _scrollView.bounds.width, height: _scrollView.bounds.height)
                    photoViews.append(photoView)
                    print("添加\(photoView.tag)")
                }
                // remove
                if photoViews.count > (_index == _urls.count - 1 ? 2 : 3) {
                    let photoView = photoViews.removeFirst()
                    photoView.isHidden = true
                    cachePhotoViews.append(photoView)
                    print("删除\(photoView.tag)")
                }
            }
        }
    }
    
    fileprivate var _scrollView: UIScrollView!
    
    init(urls: [URL], index: Int) {
        super.init(nibName: nil, bundle: nil)
        _urls = urls
        _index = index
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.white
        
        _scrollView = UIScrollView()
        _scrollView.isPagingEnabled = true
        _scrollView.delegate = self
        _scrollView.backgroundColor = UIColor.white
        view.addSubview(_scrollView)
        _scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        title = "\(_index+1)/\(_urls.count)"
        
        // left
        if _index > 0 {
            let leftPhoto = getPhotoView()
            leftPhoto.tag = _index - 1
            leftPhoto.url = _urls[_index - 1]
            photoViews.append(leftPhoto)
        }
        // center
        let centerPhoto = getPhotoView()
        centerPhoto.tag = _index
        centerPhoto.url = _urls[_index]
        photoViews.append(centerPhoto)
        // right
        if _index < _urls.count - 1 {
            let rightPhoto = getPhotoView()
            rightPhoto.tag = _index + 1
            rightPhoto.url = _urls[_index + 1]
            photoViews.append(rightPhoto)
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let topOffset = navigationController?.navigationBar.frame.maxY ?? 0
        _scrollView.snp.updateConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(topOffset)
        }
        _scrollView.layoutIfNeeded()
        _scrollView.contentSize = CGSize(width: _scrollView.bounds.width * CGFloat(_urls.count), height: _scrollView.bounds.height)
        _scrollView.contentOffset = CGPoint(x: _scrollView.bounds.width * CGFloat(_index), y: 0)
        
        for view in photoViews {
            view.frame = CGRect(x: _scrollView.bounds.width * CGFloat(view.tag), y: 0, width: _scrollView.bounds.width, height: _scrollView.bounds.height)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        PhotoMemoryCache.shared().removeAllObjects()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    fileprivate var photoViews = [PhotoView]()
    fileprivate var cachePhotoViews = [PhotoView]()
    
    func getPhotoView() -> PhotoView {
        guard cachePhotoViews.count == 0 else {
            let photoView = cachePhotoViews.removeFirst()
            return photoView
        }
        let photoView = PhotoView()
        _scrollView.addSubview(photoView)
        return photoView
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > CGFloat(_index+1) * scrollView.frame.width {
            _index += 1
        }
        else if scrollView.contentOffset.x < CGFloat(_index-1) * scrollView.frame.width {
            _index -= 1
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard _index != Int(scrollView.contentOffset.x / scrollView.frame.size.width) else {
            return
        }
        _index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }

}
