//
//  KNCachDataTool.m
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/11.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import "KNCachDataTool.h"
#import <AVFoundation/AVFoundation.h>
#import "KNLyric.h"


@interface KNCachDataTool()


@end
@implementation KNCachDataTool

//缓存歌词和存到本地
+(void)addLrcForCach:(NSArray *)lrc andURL:(NSURL *)url andID:(NSString *)ID{
    
    [KNCachData sharedCachDataManager].lrcDic[ID] = lrc;
    NSString *strPath=url.path;
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:strPath];
    NSData *data=[readHandle readDataToEndOfFile];
    [data writeToFile:[self lrcPathwith:(NSString *)ID] atomically:YES];
    [readHandle closeFile];
    data = nil;

    
    
}
+(NSString *)lrcPathwith :(NSString *)ID{
    
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    
    NSString * lrcPath=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    lrcPath = [lrcPath stringByAppendingPathComponent:@"lrc"];
    if (![manager fileExistsAtPath:lrcPath]) {
        
        [manager createFileAtPath:lrcPath contents:nil attributes:nil];
    }
    
    lrcPath = [NSString stringWithFormat:@"/%@.lrc",ID];
    
    return lrcPath;
}


#pragma mark --歌词获取
+(NSArray *)getLrcForCachWith:(NSString *)ID{
    
    NSArray *array = [KNCachData sharedCachDataManager].lrcDic[ID];
    
    if (array.count==0) {
        
       NSString *lrcPath = [[self lrcPath] stringByAppendingFormat:@"/%@.lrc",ID];
        NSURL *url = [NSURL fileURLWithPath:lrcPath];
        array = [KNLyric lrcLinesWithFileName:url];
    }
  
    return array;
}

+(NSString *)lrcPath{
    
      NSString * lrcPath=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
        lrcPath=[lrcPath stringByAppendingPathComponent:@"lrc"];
    
       return lrcPath;
    
}



+(void)removeCachData{
    
    [[KNCachData sharedCachDataManager] cleanCachData];
    
}



+(void)transform{
    
    NSString *string=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *array = [manager contentsOfDirectoryAtPath:string error:nil];
    for (NSString *subString in array) {
        
        if (![[subString pathExtension] isEqualToString:@"metadata"]&&![subString  isEqualToString:@"DS_Store"]) {
            
            NSString *str=[NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject],subString];
            NSMutableDictionary *retDic = [[NSMutableDictionary alloc] init];
            
            NSURL *url = [NSURL fileURLWithPath:str];
            AVURLAsset *mp3 =[AVURLAsset URLAssetWithURL:url options:nil];
            NSLog(@"%@",mp3);
            
            for (NSString *format in [mp3 availableMetadataFormats]) {
                NSLog(@"format Type =%@",format);
                
                for (AVMetadataItem *meta in [mp3 metadataForFormat:format]) {
                    
                    if (meta.commonKey) {
                        
                        [retDic setObject:meta.value forKey:meta.commonKey];
                    }
                }
            }
            NSLog(@"%@",retDic);

        }
    }
    
}



@end
