//
//  KNBoradListManager.h
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/17.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KNBoradListManager : NSObject

+(instancetype)listManager;
-(void )getListCompleteHandle:(void (^)(NSArray *array))complete andHaveReload:(void(^)(NSArray *haveData))haveDataHandle;
+(void)removeAllMusicList;

@end
