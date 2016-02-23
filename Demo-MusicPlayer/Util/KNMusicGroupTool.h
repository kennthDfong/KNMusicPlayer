//
//  KNMusicGroupTool.h
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/22.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KNMusicOnBaiDuIcon;

@interface KNMusicGroupTool : NSObject

+(instancetype)managerGroup;
-(NSArray *)getALLMusicGroup;

/// 增加音乐的时候 为音乐组也增加
-(void)addMusicFromOnceGroup:(KNMusicOnBaiDuIcon *)music;
///删除音乐的时候相应删除组中的音乐
-(void)deleteMusicFromOnceGroup:(KNMusicOnBaiDuIcon *)music;

@end
