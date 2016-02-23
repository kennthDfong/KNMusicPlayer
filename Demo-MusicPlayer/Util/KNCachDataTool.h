//
//  KNCachDataTool.h
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/11.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KNMusicOnBaiDuIcon;
#import "KNCachData.h"

@interface KNCachDataTool : NSObject

+(void)addLrcForCach:(NSArray *)lrc andURL:(NSURL *)url andID:(NSString *)ID;
+(NSArray *)getLrcForCachWith:(NSString *)ID;
+(void)transform;
+(void)removeCachData;

//+(void)addLrcForCach:()
@end
