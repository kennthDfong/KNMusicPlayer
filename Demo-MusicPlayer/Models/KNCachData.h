//
//  KNCachData.h
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/11.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KNCachData : NSObject

@property (nonatomic,strong) NSMutableDictionary *lrcDic;
@property (nonatomic,strong) NSMutableDictionary *musicDic;

+(instancetype)sharedCachDataManager;
-(void)cleanCachData;

@end
