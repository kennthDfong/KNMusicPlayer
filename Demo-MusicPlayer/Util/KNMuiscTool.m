//
//  KNMuiscTool.m
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/4.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import "KNMuiscTool.h"

#import "KNMusicSearch.h"
#import "KNArtist.h"
#import "KNCachDataTool.h"
#import "KNBoardList.h"
#import "KNMusicGroupTool.h"

const static NSString *baseUrlArtist=@"http://geci.me/api/artist/";
const static NSString *baseUrlCover=@"http://geci.me/api/cover/";
const static NSString *baseMusicDetail=@"http://ting.baidu.com/data/music/links?songIds=";
const static NSString *baiDuPlayUrl=@"http://tingapi.ting.baidu.com/v1/restserver/ting?from=webapp_music&method=baidu.ting.song.play&format=json&songid=";

const static NSString *baseMusicRecoUrl=@"http://tingapi.ting.baidu.com/v1/restserver/ting?from=webapp_music&method=baidu.ting.artist.getSongList&tinguid=";



 NSMutableArray *_muicArrayFromFile = nil;
static KNMusicOnBaiDuIcon *_playingMusic;



static NSMutableDictionary *_downloadMusicDic;



static NSMutableArray *_searchMuiscArray;
static KNMusicOnBaiDuIcon *_currentMusic;

static KNMuiscTool *_manger;



@interface KNMuiscTool ()
@property (nonatomic,strong) NSString *musicPath;


@end

@implementation KNMuiscTool
-(NSString *)musicPath {
    
    if (!_musicPath) {
        
        _musicPath = @"/Users/cll";
    }
    return _musicPath;
}

#pragma mark ---在线音乐
//+(NSArray *)onlineMusci:(NSArray *)array{
//    
//    
//    NSMutableArray *ary=[NSMutableArray array];
//    for (NSDictionary *dic in array) {
//        KNMusicOnlie *onlie=[[KNMusicOnlie alloc] init];
//        onlie.aid=dic[@"aid"];
//        onlie.sid=dic[@"sid"];
//        onlie.lrc=dic[@"lrc"];
//        onlie.song=dic[@"song"];
//        onlie.artist_id=dic[@"artist_id"];
//        onlie.cover=[NSString stringWithFormat:@"%@%ld",baseUrlCover,(long)[onlie.aid integerValue]];
//        onlie.cover=[KNMusicSearch searchCover:onlie.cover andIndex:0];
//        onlie.thumb=[NSString stringWithFormat:@"%@%ld",baseUrlCover,(long)[onlie.aid integerValue]];
//        onlie.thumb=[KNMusicSearch searchCover:onlie.thumb andIndex:1];
//        
//        onlie.name=[NSString stringWithFormat:@"%@%ld",baseUrlArtist,(long)[onlie.artist_id integerValue]];
//        onlie.name=[KNMusicSearch searchArtist:onlie.name andIndex:1];
//        
//        [ary addObject:onlie];
//    }
//    
//    return [ary copy];
//}

+(instancetype)musicManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        _manger=[[self alloc] init];
        
    });
    
    return _manger;
}

-(instancetype)init{
    
    if (self=[super init]) {
        
        _searchMuiscArray  = [NSMutableArray array];
        _downloadMusicDic  = [NSMutableDictionary dictionary];
        _muicArrayFromFile = [NSMutableArray array];
     
        
        
    }
    
    return self;
}


#pragma mark local music
-(NSArray *)musicArray{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _muicArrayFromFile=[[self getMusicFromPlist:@"music.plist"] mutableCopy];
        NSMutableArray *musics=[NSMutableArray array];
        for (NSDictionary *dic in _muicArrayFromFile) {
            KNMusicOnBaiDuIcon *music=[[KNMusicOnBaiDuIcon alloc] init];
            [music setValuesForKeysWithDictionary:dic];
            [musics addObject:music];
        }
        
        _muicArrayFromFile=musics;
               
        
    });
    
        
    
    return _muicArrayFromFile;
}

-(NSArray *)getMusicFromPlist:(NSString *)filename{
    
    NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [basePath stringByAppendingPathComponent:filename];
    //NSString *filePath=[[NSBundle mainBundle] pathForResource:filename ofType:nil];
    NSArray *musicArray=[NSArray arrayWithContentsOfFile:filePath];
    return musicArray;
    
}

+(KNMusicOnBaiDuIcon *)getCurrentMusic{
    
    return _playingMusic;
    
}
+(void)setPlayingMusci:(KNMusicOnBaiDuIcon *)musci{
//    if (![_muicArrayFromFile containsObject:musci]||!musci) {
//        
//        return;
//    }
    
    _playingMusic=musci;
    
    
}

+(KNMusicOnBaiDuIcon *)nextMusic:(KNMusicOnBaiDuIcon *)music{
    
    if (![_muicArrayFromFile containsObject:music]||!music) {
        return nil;
    }
    
        NSInteger index=[_muicArrayFromFile indexOfObject:music];
        if (index==_muicArrayFromFile.count-1) {
            index=0;
        } else {
            
            index=index+1;
        }
        [self setPlayingMusci:_muicArrayFromFile[index]];
    
        return _muicArrayFromFile[index];
    
    
    
}

+(KNMusicOnBaiDuIcon *)forworadMusic:(KNMusicOnBaiDuIcon *)music{
    
    
    
    if (![_muicArrayFromFile containsObject:music]||!music) {
        return nil;
    }
        NSInteger index=[_muicArrayFromFile indexOfObject:music];
        if (index==0) {
            index=_muicArrayFromFile.count-1;
        } else {
            
            index=index-1;
        }
        [self setPlayingMusci:_muicArrayFromFile[index]];
        return _muicArrayFromFile[index];
    

    
}


#pragma mark ---onlie muisc tool

+(KNMusicOnBaiDuIcon *)getOnlineCurrentMusic{
    
    return _currentMusic;
    
}
+(void)setOnlinePlayingMusci:(KNMusicOnBaiDuIcon *)music{
//    if (![_searchMuiscArray containsObject:music]||!music) {
//        
//        return;
//    }
    
    _currentMusic=music;
    
    
}

+(KNMusicOnBaiDuIcon *)nextOnlineMusic:(KNMusicOnBaiDuIcon *)music{
    
    if (![_searchMuiscArray containsObject:music]||!music) {
        
        return nil;
    }
    
    NSInteger index=[_searchMuiscArray indexOfObject:music];
    if (index==_searchMuiscArray.count-1) {
        index=0;
    } else {
        
        index=index+1;
    }
    [self setPlayingMusci:_searchMuiscArray[index]];
    return _searchMuiscArray[index];
    
    
}

+(KNMusicOnBaiDuIcon *)forworadOnlineMusic:(KNMusicOnBaiDuIcon *)music{
    
    
    
    if (![_searchMuiscArray containsObject:music]||!music) {
        
        return nil;
    }
    NSInteger index=[_searchMuiscArray indexOfObject:music];
    if (index==0) {
        index=_searchMuiscArray.count-1;
    } else {
        
        index=index-1;
    }
    [self setPlayingMusci:_searchMuiscArray[index]];
    return _searchMuiscArray[index];
    
}

-(void)removeMusicFromLocal:(KNMusicOnBaiDuIcon *)music{
    
    
    NSArray *array = [self getMusicFromPlist:@"music.plist"];
    NSMutableArray *muta = [NSMutableArray arrayWithArray:array];
    for (NSDictionary *dic in array) {
        
        if ([dic[@"songId"] intValue] == [music.songId intValue]) {
            
            [muta removeObject:dic];
            break;
        }
    }
    
     NSString *MUISCPlist = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"music.plist"];
    [muta writeToFile:MUISCPlist atomically:YES];
    [_muicArrayFromFile removeObject:music];
}

#pragma mark ---添加本地列表

+(void)addMusicForPlit:(KNMusicOnBaiDuIcon *)music withlocation:(NSString *)location{
    
    
    
    NSString *MUISCPlist = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"music.plist"];
//    NSFileManager *manager = [NSFileManager defaultManager];
//    if (![manager fileExistsAtPath:MUISCPlist]) {
//        
//        [manager createFileAtPath:MUISCPlist contents:nil attributes:nil];
//    }
    
    NSArray *array = [NSArray arrayWithContentsOfFile:MUISCPlist];
    NSNumber *num;
    if (!music.isSearchMusic) {
        
      num=[NSNumber numberWithBool:music.download];
        
    } else {
        
        num = [NSNumber numberWithBool:YES];
        
        NSString *savePath =[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:@"music"];
        savePath = [NSString stringWithFormat:@"%@/%@",savePath,music.songId];
        music.songLink = savePath ;
    }
    NSDictionary *dic=@{
                        @"songPicSmall":music.songPicSmall,
                        @"songPicBig":music.songPicBig,
                        @"songName":music.songName,
                        @"songLink":music.songLink,
                        @"songId":music.songId,
                        @"artistName":music.artistName,
                        @"download":num
                        };
    
    NSMutableArray *marray;
    if (array==nil) {
        
        marray = [NSMutableArray array];
        
    } else {
        
         marray = [array mutableCopy];
    }
   
    [marray addObject:dic];
    [[marray copy] writeToFile:MUISCPlist atomically:YES];
    
    [_muicArrayFromFile addObject:music];
    
    

    
}

+(void)addMusicForLoaction:(KNMusicOnBaiDuIcon *)music withlocation:(NSString *)location{
    
   
    
    NSString *filePath = location;
    NSFileHandle *write=[NSFileHandle fileHandleForReadingAtPath:filePath];
    NSData *data =[write readDataToEndOfFile];
    NSString *savePath =[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:@"music"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:savePath]) {
        
        [fileManager createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    savePath =[NSString stringWithFormat:@"%@/%@.mp3",savePath, music.songId];
    [data writeToFile:savePath atomically:YES];
    [write closeFile];
    data=nil;
    [_downloadMusicDic removeObjectForKey:music.songLink];
    
    
}

+(void)deleteMuiscForPlist:(KNMusicOnBaiDuIcon *)music{
    
    
    NSString *MUISCPlist = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"music.plist"];
    NSArray *array =[NSArray arrayWithContentsOfFile:MUISCPlist];
    
    NSMutableArray *deleArray=[array mutableCopy];
    [deleArray removeObjectAtIndex:array.count-1];
    array = [deleArray copy];
    
    [array writeToFile:MUISCPlist atomically:YES];
    [_muicArrayFromFile removeObject:music];
    
    
}


#pragma mark ---关键词搜索模型处理部分
+(NSArray *)onlineFirstMusci:(NSDictionary *)dic{
    [KNCachDataTool removeCachData];
    
    [_searchMuiscArray removeAllObjects];

    NSArray *array=dic[@"song"];
    
    
#pragma 当搜索的是歌手时候,保存歌手信息 artistID,供用户按歌手搜索
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        NSArray *tempArray = dic[@"artist"];
        if (tempArray) {
            
            NSDictionary *artistDic = [tempArray firstObject];
            KNArtist *artist = [KNArtist pareArtistData:artistDic];
            NSDictionary *dic=@{@"artistid":artist.artistid,
                                @"artistpic":artist.artistpic,
                                @"artistname":artist.artistname,
                                @"yyr_artist":artist.yyr_artist};
            
            tempArray = @[dic];
            
            
            NSFileManager *fileManger = [NSFileManager defaultManager];
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            path = [path stringByAppendingPathComponent:@"artist.plist"];
            if (![fileManger fileExistsAtPath:path]) {
                
                [tempArray writeToFile:path atomically:YES];
                
            } else {
                
                NSMutableArray *artistArray = [NSMutableArray  arrayWithContentsOfFile:path];
                int i=0;
                for (NSDictionary *dicsub in artistArray) {
                    
                    i++;
                    if ([dicsub[@"artistname"] isEqualToString:dic[@"artistname"]]) {
                        
                        break;
                        
                    }
                }
                
                if (i==artistArray.count) {
                    
                    [artistArray addObject:dic];
                   
                    [artistArray writeToFile:path atomically:YES];
                    
                }
                
                
            }
            
           
        
        }
        
        
        
    });
    
    NSMutableArray *musciArray=[NSMutableArray array];
    
    for (NSDictionary *dic in array) {
        
        KNMusicOnBaiDu *music=[[KNMusicOnBaiDu alloc ]init];
        [music setValuesForKeysWithDictionary:dic];
        [musciArray addObject:music];
        
    }
    
    return [musciArray copy];
    
}

//
-(NSArray *)onlineMusciByMusicID:(NSDictionary *)dic{
    
    if ([dic[@"errorCode"] intValue]==22012) {
        return [_searchMuiscArray copy];
    }

    NSDictionary *musicDic   = dic[@"data"][@"songList"][0];
    KNMusicOnBaiDuIcon *music=[[KNMusicOnBaiDuIcon alloc] init];
    music.songName           =musicDic[@"songName"];
    music.songPicSmall       =musicDic[@"songPicSmall"];
    music.songPicBig         =musicDic[@"songPicBig"];
    music.songLink           = [self swithcString: musicDic[@"songLink"]];
    music.artistName         =musicDic[@"artistName"];
    music.lrcLink            =[NSString stringWithFormat:
                               @"http://musicdata.baidu.com%@",
                               musicDic[@"lrcLink"]];
    music.songId             =musicDic[@"songId"];
    
    [_searchMuiscArray addObject:music];
    return [_searchMuiscArray copy];
    
}

#pragma mark ---音乐榜单
//获取音乐列表
+(NSArray *)muiscList:(NSArray *)array{
    
    [KNCachDataTool removeCachData];
    [_searchMuiscArray removeAllObjects];
    NSMutableArray *mutableArray=[NSMutableArray array];
    for (NSDictionary *dic in array) {
        
        KNMusicOnBaiDuIcon *music=[KNMusicOnBaiDuIcon new];
        music.songPicSmall=dic[@"pic_small"];
        music.songPicBig  =dic[@"pic_big"];
        music.songId      =dic[@"song_id"];
        music.songLink    =[NSString stringWithFormat:@"%@%@",baiDuPlayUrl,dic[@"song_id"]];
        music.artistName  =dic[@"author"];
        music.songName    =dic[@"title"];
        music.lrcLink     =dic[@"lrclink"];
        [mutableArray addObject:music];
    }
    
    
    return   [mutableArray copy];
    
   
    
}

-(NSArray *)muiscListForContens:(NSDictionary *)dic{
    
    if ([dic[@"errorCode"] intValue]==22012) {
        return [_searchMuiscArray copy];
    }
    
    
    NSDictionary *musicDic   = dic[@"data"][@"songList"][0];
    KNMusicOnBaiDuIcon *music=[[KNMusicOnBaiDuIcon alloc] init];
    music.songName           =musicDic[@"songName"];
    music.songPicSmall       =musicDic[@"songPicSmall"];
    music.songPicBig         =musicDic[@"songPicBig"];
    music.songLink           = [self swithcString: musicDic[@"songLink"]];
    music.artistName         =musicDic[@"artistName"];
    music.lrcLink            =[NSString stringWithFormat:
                               @"http://musicdata.baidu.com%@",
                               musicDic[@"lrcLink"]];
    music.songId             =musicDic[@"songId"];
    
    [_searchMuiscArray addObject:music];
    return [_searchMuiscArray copy];
    
//    
//    NSDictionary *sondInfoDic = dic[@"songinfo"];
//    
//    
//    
//    //NSDictionary *musicDic   = dic[@"data"][@"songList"][0];
//    KNMusicOnBaiDuIcon *music=[[KNMusicOnBaiDuIcon alloc] init];
//    
//    music.songName=sondInfoDic[@"title"];
//    music.songPicBig=sondInfoDic[@"pic_premium"];
//    music.songPicSmall=sondInfoDic[@"pic_big"];
//    music.lrcLink=sondInfoDic[@"lrclink"];
//    music.artistName=sondInfoDic[@"author"];
//    music.songLink=dic[@"bitrate"][@"file_link"];
//    music.songId=sondInfoDic[@"song_id"];
    
    
 //   music.songName           =musicDic[@"songName"];
 //   music.songPicSmall       =musicDic[@"songPicSmall"];
 //   music.songPicBig         =musicDic[@"songPicBig"];
 //  music.songLink           = [self swithcString: musicDic[@"songLink"]];
 //  music.artistName         =musicDic[@"artistName"];
 //  music.lrcLink            =[NSString stringWithFormat:
                               //@"http://musicdata.baidu.com%@",
                              // musicDic[@"lrcLink"]];
  //  music.songId             =musicDic[@"songId"];
    
//    [_searchMuiscArray addObject:music];
//    return [_searchMuiscArray copy];

}

-(NSString *)swithcString:(NSString *)str{
    
    NSMutableString *mustr =  [str mutableCopy];
    
    NSRange rang=[str rangeOfString:@"&src="];
    if (rang.length==0) {
        
        return str;
    } else {
        NSRange subRang={rang.location,str.length-rang.location};
        [mustr replaceCharactersInRange:subRang withString:@""];
        
    }
    
    return [mustr copy];
}


#pragma mark --搜索本地音乐
-(BOOL)searchMusicFromLocal:(KNMusicOnBaiDuIcon *)muisc{
    
    
    if (muisc.isSearchMusic ) {
        
        return YES;
    }
    NSString *MUISCPlist = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"music.plist"];
    NSArray *array =[NSArray arrayWithContentsOfFile:MUISCPlist];
    
    for (NSDictionary *dic in array) {
        
        if (dic[@"songId"]==muisc.songId) {
            
            return YES;
            
        }
    }

    
    return NO;
}

+(NSString *)getLocatPath:(KNMusicOnBaiDuIcon *)muisc{
    
    NSString *savePath =[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:@"music"];
    
    savePath =[NSString stringWithFormat:@"%@/%@.mp3",savePath, muisc.songId];
    
    return savePath;

    
}

#pragma mark --下载音乐管理

-(void)addDownloadMusic:(KNMusicOnBaiDuIcon *)music{
    
    
    _downloadMusicDic[music.songLink]=music;
    
    
}
-(KNMusicOnBaiDuIcon *)getDonloadMuisc:(NSString *)urlString{
    
    return _downloadMusicDic[urlString];

    
}
-(void)deleteFailureMusic:(NSString *)urlString{
    
    
    [_downloadMusicDic removeObjectForKey:urlString];
    
}

-(NSArray *)getAllDownloadMusic{
    
    
    return [_downloadMusicDic allValues];
}

-(void)downloadMuisc:(KNMusicOnBaiDuIcon *)music{
    
    
    if (_downloadMusicDic[music.songLink]) {
        
        return;
        
    }

    __weak typeof(self) mySelf = self;
    
        if (!music.download&&![self searchMusicFromLocal:music]) {
             
             music.download=YES;
            
                [self  addDownloadMusic:music];

                [[KNMusicSearch searchManager] downloadMusic:music.songLink successHandler:^(NSString * location, id response, NSString *keyString) {
                    
                
                    [KNMuiscTool addMusicForPlit:[[KNMuiscTool musicManager] getDonloadMuisc:keyString] withlocation:nil];
                    
                    [KNMuiscTool addMusicForLoaction:[[KNMuiscTool musicManager ] getDonloadMuisc:keyString] withlocation:location];
                    
                    ;

                    [mySelf deleteFailureMusic:keyString];
                    
                } andFailHander:^(id response, id erro, NSString *keyString) {
                    
                    [mySelf deleteFailureMusic:keyString];
                    
                } andProgrees:^(int64_t writedData, int64_t totalData) {
                   
                    
                }];
                
                
            }
          

    
    
}

#pragma mark --歌手音乐管理

-(NSArray *)getALLArtistMessage{
    
   
    NSMutableArray *artistArray = [NSMutableArray array];
     NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:@"artist.plist"];

    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    for (NSDictionary *dic in array) {
        KNArtist *artist = [KNArtist new];
        
        [artist setValuesForKeysWithDictionary:dic];
        
        [artistArray addObject:artist];
    }
    
    return [artistArray copy];
    
}



-(void)getMusicByArtistAndBoardList:(KNArtist *)artist
                       andBoardList:(KNBoardList *)list andLimits:(NSInteger)num
                       andResultBlock:(void(^)(KNMusicOnBaiDuIcon *))aritstBlock
                       andFirstFailer:(void(^)(id,NSError * ))firstFailer
                       andSecondError:(void(^)(id, NSError *))secondError {
    
    
    NSString *urlString ;
    if (artist) {
        
         urlString = [NSString stringWithFormat:@"%@%@&limits=%ld",baseMusicRecoUrl,artist.artistid,num];
        
    } else {
        
        
        urlString=[NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?from=webapp_music&method=baidu.ting.billboard.billList&format=json&size=%ld&type=%d",num,[list.billboard_type intValue]];
        
    }
    
    [[KNMusicSearch searchManager] getMusicList:urlString successHandler:^(id data, id response) {
        NSData *recvData = data;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:recvData options:0 error:nil];
        
        NSArray *array ;
        if (list) {
    
            array = dic[@"song_list"];
            
        } else {
            
         array = dic[@"songlist"];
            
        }
       
        NSInteger index = 0;
        
        for (NSDictionary *dic in array) {
            
            if (array.count<num) {
                
                aritstBlock(nil);
                return ;
            }
            
            index ++;
            NSString *musicPathByID=[NSString stringWithFormat:@"%@%@",baseMusicDetail,dic[@"song_id"]];
            [[KNMusicSearch searchManager] getMusicListByID:musicPathByID successHandler:^(id data, id response) {
                NSData *revData=data;
                NSDictionary *dic  = [NSJSONSerialization JSONObjectWithData:revData options:0 error:nil];
                
                
                if (index>num-5||num==10) {
        
                    aritstBlock([self getArtitsMuisc:dic]);
                }
                                
                
                
            } andFailHanle:^(id response, NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                      firstFailer(response,error);
                    
                });
              
                
            }];
        }
        
    } andFailHandle:^(id response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
             secondError(response,error);
        });
        
       
        
    }];
    
    
}

-(KNMusicOnBaiDuIcon *)getArtitsMuisc:(NSDictionary *)dic{
    
    
    
    if ([dic[@"errorCode"] intValue]==22012) {
        return nil;
    }
    
    NSDictionary *musicDic   = dic[@"data"][@"songList"][0];
    KNMusicOnBaiDuIcon *music=[[KNMusicOnBaiDuIcon alloc] init];
    music.songName           =musicDic[@"songName"];
    music.songPicSmall       =musicDic[@"songPicSmall"];
    music.songPicBig         =musicDic[@"songPicBig"];
    music.songLink           = [self swithcString: musicDic[@"songLink"]];
    music.artistName         =musicDic[@"artistName"];
    music.lrcLink            =[NSString stringWithFormat:
                               @"http://musicdata.baidu.com%@",
                               musicDic[@"lrcLink"]];
    music.songId             =musicDic[@"songId"];
    
    [_searchMuiscArray addObject:music];
    return  music;
    
}

-(void)removeAllSearchMuisc{
    
    
    [_searchMuiscArray removeAllObjects];
    
}

#pragma mark -搜索设备中有的音乐
-(void)getid3Message:(NSString *)filePath{
    
    NSMutableDictionary *retDic = [[NSMutableDictionary alloc] init];
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    AVURLAsset *mp3 =[AVURLAsset URLAssetWithURL:url options:nil];
    
    for (NSString *format in [mp3 availableMetadataFormats]) {
       
        
        for (AVMetadataItem *meta in [mp3 metadataForFormat:format]) {
            
            if (meta.commonKey) {
                
                [retDic setObject:meta.value forKey:meta.commonKey];
            }
        
    }
        
        KNMusicOnBaiDuIcon *music = [KNMusicOnBaiDuIcon new];
        music.songId      = [NSString stringWithFormat:@"%04d",arc4random()];
        if (!retDic[@"artist"]||!retDic[@"title"]) {
            
            NSArray *array   = [filePath.lastPathComponent componentsSeparatedByString:@"-"];
            if (array.count==0) {
                
                music.artistName = @"errorArtistName";
                music.songName   = @"errorSongName";
                
            } else {
                
                music.artistName = array[0];
                music.songName   = array[0];

            }
            
        } else {
            
            music.artistName  = retDic[@"artist"];
            music.songName    = retDic[@"title"];
        }
   
        //NSLog(@"%@",music.artistName);
        
        music.songLink     = filePath;
        music.searchMusic  = YES;
        music.songPicBig   = @"music";
        music.songPicSmall = @"music";
        music.lrcLink      = @"music";
        [_muicArrayFromFile addObject:music];
        [retDic removeAllObjects];
        retDic = nil;
        mp3    = nil;
        //[KNMuiscTool addMusicForLoaction:music withlocation:music.songLink];
       // [KNMuiscTool addMusicForPlit:music withlocation:music.songLink];
      
        
}


}

-(void)searchLocalMusicOnPc:(NSString *)searchPath{
    
    if ([searchPath.lastPathComponent hasPrefix:@"."]) {
        
        return ;
    }
    NSRange range = [searchPath rangeOfString:@"com."];
    if (range.length>0) {
        
        return ;
    }
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSArray *array = [manager contentsOfDirectoryAtPath:searchPath error:nil];
    if (array.count==0) {
        
        return ;
        
    }
    for (NSString *mp3String in array) {
        
        
        if ([mp3String.pathExtension isEqualToString:@"mp3"]||[mp3String.pathExtension isEqualToString:@"m4a"] ) {
            
            NSLog(@"%@", [searchPath stringByAppendingString:mp3String]);
            
          // [self getid3Message:[searchPath stringByAppendingPathComponent:mp3String]];
        }
    }

    for (int i=0; i<array.count; i++) {
        
       NSString *str = [searchPath stringByAppendingPathComponent:array[i]];
        
        [self searchLocalMusicOnPc:str];
    }
    
}



@end
