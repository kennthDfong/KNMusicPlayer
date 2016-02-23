//
//  KNMusicSearch.h
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/6.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KNMusicSearch;
@class KNMusicOnBaiDuIcon;

@protocol KNMusicSearchDelegate <NSObject>

-(void)downloadTaskProgress:(KNMusicSearch *)search andEd:(int64_t)downloadedLength
                     andKeyString:(NSString *)keyString
                     andAll:(int64_t)expectedLength withDownTask:(NSURLSessionDownloadTask *)task;
-(void)havedownloadedMusic:(KNMusicSearch *)search andlocaPath:(NSString *)string
                                                   andKeyString:(NSString *)keyString;

-(void)downloadFailer:(KNMusicSearch *)seach withKeyString:(NSString *)keyString andDownTask:(NSURLSessionTask *)task andError:(NSError *)error;

@end

@interface KNMusicSearch : NSObject<NSURLSessionDownloadDelegate>
@property (nonatomic,weak)id <KNMusicSearchDelegate> delegate;

+(instancetype)searchManager;

//+(void )searchMusicByQuery:(NSString *)fileName;
// 
//
//+(NSString *)searchCover:(NSString *)urlStr andIndex:(NSInteger )index;
//
//+(NSURL *)downloadMusic:(NSString *)muiscStr;
//
//+(void )getMusicContens:(NSString *)remotePath;

+(void)downloadLrc:(NSURL *)url  completionHandler:(void(^)(id objct, id erro))complete;


-(void)downloadMusic:(NSString *)string   successHandler:
                                (void (^)(NSString * location, id response,NSString *keyString))success
                                andFailHander:(void (^)(id response, id erro,NSString *keyString))failHander
                                andProgrees:(void(^)(int64_t writedData,int64_t totalData))preogress;


-(void)getMusicList:(NSString *)urlString successHandler:(void(^)(id data,id response ))success
                                          andFailHandle:(void(^)(id response ,NSError *error))failHander;


-(void )getMusicListByID:(NSString *)ID   successHandler:(void(^)(id data,id response))success
                                          andFailHanle:(void(^)(id response,NSError *error))faileHander;

-(void)sendHeadRequet:(NSString *)urlString successHandler:(void(^)(int64_t musicLeng))succsess
                                andFailurHandle:(void(^)(NSHTTPURLResponse *response, NSError *error))failure;



#pragma mark--取消暂停任务
-(void)recvResumClick:(KNMusicOnBaiDuIcon *)music;
-(void)recvStartClick:(KNMusicOnBaiDuIcon *)music;

/** 上传任务  */
-(void)POST:(NSString *)url parameters:(NSMutableDictionary *)parameters
                            andBodyData:(NSData *)data andFileName:(NSString *)fileName
                            withsuccess:(void(^)(NSURLResponse *response,id responseObj))success
                            orFailure:(void(^)(NSURLResponse *response,NSError *error))failure;

@end
