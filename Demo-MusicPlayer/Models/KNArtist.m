//
//  KNArtist.m
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/17.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import "KNArtist.h"

@implementation KNArtist

+(instancetype)pareArtistData:(NSDictionary *)dic{
    
    
    return [[self alloc] pareArtistDataWithDic:dic];
}

-(instancetype)pareArtistDataWithDic:(NSDictionary *)dic{
    
    
    [self setValuesForKeysWithDictionary:dic];
    return self;
    
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
    
}

@end
