//
//  AudioPlayer.m
//  file
//
//  Created by 翟泉 on 16/5/23.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "AudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

//#import <AVKit/AVKit.h>

//#import <AudioUnit/AudioUnit.h>


// AudioQueue
#import <AudioToolbox/AudioToolbox.h>

@interface AudioPlayer ()
<AVAudioPlayerDelegate>
{
    AVAudioPlayer *_audioPlayer;
}

@end

@implementation AudioPlayer

+ (AudioPlayer *)sharedInstance; {
    static AudioPlayer * sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init; {
    if (self = [super init]) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        NSURL *url = [NSURL URLWithString:@"/Users/cezr/Documents/2233.mp3"];
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
        [_audioPlayer prepareToPlay];
        [_audioPlayer setVolume:1];
        _audioPlayer.numberOfLoops = 1; //设置音乐播放次数  -1为一直循环
        [_audioPlayer play]; //播放
        
        
        [self AudioToolbox];
        
    }
    return self;
}


- (void)AudioToolbox; {
    OSStatus status;
    
//    // 初始化AudioFileStream
//    AudioFileStreamID streamID;
//    status = AudioFileStreamOpen(NULL, &__AudioFileStream_PropertyListenerProc, &__AudioFileStream_PacketsProc, kAudioFileMP3Type, &streamID);
//    if (status != noErr) {
//        return;
//    }
//    
//    // 解析数据
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    status = AudioFileStreamParseBytes(streamID, data.length, data.bytes, kAudioFileStreamParseFlag_Discontinuity);
//    if (status != noErr) {
//        return;
//    }
    
    
    NSURL *url = [NSURL URLWithString:@"/Users/cezr/Documents/2233.mp3"];
    // AudioFile
    AudioFileID fileID;
    status = AudioFileOpenURL((__bridge CFURLRef)url, kAudioFileReadPermission, kAudioFileMP3Type, &fileID);
    if (status != noErr) {
        return;
    }
    // 读取音频格式信息
    
    AudioStreamBasicDescription mDataFormat;
    UInt32 size = sizeof(mDataFormat);
    AudioFileGetProperty(fileID, kAudioFilePropertyDataFormat, &size, &mDataFormat);
    
    //获取码率
    UInt32 bitRate;
    UInt32 bitRateSize = sizeof(bitRate);
    status = AudioFileGetProperty(fileID, kAudioFilePropertyBitRate, &size, &bitRate);
    if (status != noErr) {
        //错误处理
    }
    
}


// 歌曲信息解析的回调，每解析出一个歌曲信息都会进行一次回调
void __AudioFileStream_PropertyListenerProc(void                            *inClientData,
                                            AudioFileStreamID               inAudioFileStream,
                                            AudioFileStreamPropertyID       inPropertyID, // 此次回调解析的信息ID
                                            AudioFileStreamPropertyFlags    *ioFlags) {
    OSStatus status;
    
    UInt32 bitRate;
    UInt32 bitRateSize = sizeof(bitRate);
    status = AudioFileStreamGetProperty(inAudioFileStream, kAudioFileStreamProperty_BitRate, &bitRateSize, &bitRate);
    if (status != noErr) {
        return;
    }
    
}

// 分离帧的回调，每解析出一部分帧就会进行一次回调
void __AudioFileStream_PacketsProc(void *							inClientData,
                                 UInt32							inNumberBytes,
                                 UInt32							inNumberPackets,
                                 const void *					inInputData,
                                 AudioStreamPacketDescription	*inPacketDescriptions) {
    
}


#pragma mark - AVAudioPlayerDelegate


@end