//
//  KNAudioTool.h
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/4.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <FSAudioStream.h>
#import "KNMusicSearchControl.h"
#import "KNListControl.h"
#import "KNMusicControl.h"

@interface KNAudioTool : NSObject<AVAudioPlayerDelegate,KNMusicSearchControlDelegate,KNListControlDelegate,KNMusicControlDelegate>

+(instancetype)sharedAudiManager;

////本地播放
//-(AVAudioPlayer *)playAudioWithFileName:(NSString *)fileName;
//
//-(void)pauseAudioWithFileName:(NSString *)fileName;
//
//-(void)stopAudioWithFileName:(NSString *)fileName;

//在线音乐播放

-(FSAudioStream *)playAudioWithOnlineString:(NSString *)fileName;
-(void)pauseAudioWithOnlineString:(NSString *)fileName;
-(void)stopAudioWithOnlineString:(NSString *)fileName;

@end
