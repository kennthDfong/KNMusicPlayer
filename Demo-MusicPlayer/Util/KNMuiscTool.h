//
//  KNMuiscTool.h
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/4.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "KNMusic.h"
@class KNArtist;
@class KNBoardList;


@interface KNMuiscTool : NSObject<AVAudioPlayerDelegate>


+(instancetype)musicManager;
-(NSMutableArray *)musicArray;

//本地音乐管理
+(KNMusicOnBaiDuIcon *)getCurrentMusic;
+(void)setPlayingMusci:(KNMusicOnBaiDuIcon *)musci;
+(KNMusicOnBaiDuIcon *)nextMusic:(KNMusicOnBaiDuIcon *)music;
+(KNMusicOnBaiDuIcon *)forworadMusic:(KNMusicOnBaiDuIcon *)music;
-(void)removeMusicFromLocal:(KNMusicOnBaiDuIcon *)music;



//在线音乐管理
+(KNMusicOnBaiDuIcon *)getOnlineCurrentMusic;
+(void)setOnlinePlayingMusci:(KNMusicOnBaiDuIcon *)music;
+(KNMusicOnBaiDuIcon *)nextOnlineMusic:(KNMusicOnBaiDuIcon *)music;
+(KNMusicOnBaiDuIcon *)forworadOnlineMusic:(KNMusicOnBaiDuIcon *)music;


//+(NSArray *)onlineFirstMusci:(NSArray *)arrar;
//+(NSArray *)onlineMusci:(NSArray *)array;
+(NSArray *)onlineFirstMusci:(NSDictionary *)dic;
-(NSArray *)onlineMusciByMusicID:(NSDictionary *)musicStr;

+(void)addMusicForPlit:(KNMusicOnBaiDuIcon *)music withlocation:(NSString *)location;
+(void)addMusicForLoaction:(KNMusicOnBaiDuIcon *)music withlocation:(NSString *)location;
+(void)deleteMuiscForPlist:(KNMusicOnBaiDuIcon *)music;


-(BOOL)searchMusicFromLocal:(KNMusicOnBaiDuIcon *)muisc;
+(NSString *)getLocatPath:(KNMusicOnBaiDuIcon *)muisc;

//根据传入的数组获得音乐列表
+(NSArray *)muiscList:(NSArray *)array;
-(NSArray *)muiscListForContens:(NSDictionary *)dic;

//正在下载音乐管理
-(void)addDownloadMusic:(KNMusicOnBaiDuIcon *)music;
-(KNMusicOnBaiDuIcon *)getDonloadMuisc:(NSString *)urlString;
-(void)deleteFailureMusic:(NSString *)urlString;
-(NSArray *)getAllDownloadMusic;
-(void)downloadMuisc:(KNMusicOnBaiDuIcon *)music;

//根据歌手得到其对应的歌曲

-(NSArray *)getALLArtistMessage;

-(void)getMusicByArtistAndBoardList:(KNArtist *)artist
                     andBoardList:(KNBoardList *)list andLimits:(NSInteger)num
                     andResultBlock:(void(^)(KNMusicOnBaiDuIcon *muisc))aritstBlock
                     andFirstFailer:(void(^)(id response,NSError *error ))firstFailer
                     andSecondError:(void(^)(id response, NSError *error))secondErrorr;



-(void)removeAllSearchMuisc;

///搜索本地音乐
-(void)searchLocalMusicOnPc:(NSString *)searchPath;







@end
