//
//  KNArtist.h
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/17.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KNArtist : NSObject
@property (nonatomic,strong) NSString *yyr_artist;
@property (nonatomic,strong) NSString *artistid;
@property (nonatomic,strong) NSString *artistpic;
@property (nonatomic,strong) NSString *artistname;
//@property (nonatomic,strong) NSString *country;
//@property (nonatomic,strong) NSString *language;

+(instancetype)pareArtistData:(NSDictionary *)dic;

@end
