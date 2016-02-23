//
//  NSString+KNStringTool.m
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/22.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import "NSString+KNStringTool.h"

@implementation NSString (KNStringTool)
+(instancetype)convertHanZiToPingYing:(NSString *)string{
    
        if (![string length]) {
        
        return nil;
        
    }
    NSString *headString =[string substringToIndex:1];
    NSString *regex = @"^[a-zA-Z]*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([predicate evaluateWithObject:headString]) {
        
        return string;
    }

    
        
        NSMutableString *convert = [[NSMutableString alloc] initWithString:string];
        CFStringTransform((__bridge CFMutableStringRef)convert, 0, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)convert, 0, kCFStringTransformStripDiacritics, NO);
//        NSRange range = [convert rangeOfString:@" "];
//        
//        [convert replaceCharactersInRange:range withString:@""];
        return [convert copy];

    
    
}

@end
