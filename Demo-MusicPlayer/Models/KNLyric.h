//
//  KNLyric.h
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/9.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KNLyric : NSObject
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *word;

+(NSMutableArray *)lrcLinesWithFileName:(NSURL *)fileName;

@end
