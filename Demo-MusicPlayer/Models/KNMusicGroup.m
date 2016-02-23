//
//  KNMusicGroup.m
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/22.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import "KNMusicGroup.h"

@implementation KNMusicGroup
-(instancetype)init{
    
    if (self = [super init]) {
        
        self.musicsArray = [NSMutableArray array];
    }
    
    return self;
}

@end
