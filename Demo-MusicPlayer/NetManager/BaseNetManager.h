//
//  BaseNetManager.h
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/5.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseNetManager : NSObject

+(id)GET:(NSString *)path parameters:(NSDictionary *)params completionHandler:(void(^)(id responseObj,NSError *error))complete;
+(id)POST:(NSString *)path parameters:(NSDictionary *)params completionHandler:(void(^)(id responseObj,NSError *error))complete;


@end
