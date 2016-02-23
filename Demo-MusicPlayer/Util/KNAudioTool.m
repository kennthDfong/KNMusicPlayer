//
//  KNAudioTool.m
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/4.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import "KNAudioTool.h"
#import "KNMuiscTool.h"
#import "KNMusic.h"
#import "KNMusicSearch.h"
#import <MediaPlayer/MediaPlayer.h>


@interface KNAudioTool()<FSPCMAudioStreamDelegate>
@property (nonatomic,assign) BOOL change;
@property (nonatomic,strong) AVAudioSession *session;
@property (nonatomic,strong) FSAudioStream *onlinePlay;
@property (nonatomic,assign) int num;

@end

static NSMutableDictionary *_musicDic;
static KNAudioTool *_audioTool= nil;
static NSMutableDictionary *_onleMusicDic;

@implementation KNAudioTool

+(instancetype)sharedAudiManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        _audioTool=[[KNAudioTool alloc] init];

    
    });
    
    return _audioTool;
}

-(instancetype)init{
    
    if (self=[super init]) {
        
        _musicDic=[NSMutableDictionary dictionary];
        _onleMusicDic=[NSMutableDictionary dictionary];
        self.session=[AVAudioSession sharedInstance];
        NSError *error=nil;
        [self.session setCategory:AVAudioSessionCategoryPlayback error:&error];
        [self.session setActive:YES error:&error];
    }
    
    return self;
    
}

//-(AVAudioPlayer *)playAudioWithFileName:(NSString *)fileName{
//    
//    if (fileName==nil||fileName.length==0) {
//        return nil;
//    }
//  _player=_musicDic[fileName];
//    
//    if (!_player) {
//        NSURL *url=[[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
//        if (!url) {
//            return nil;
//        }
//        _player =[[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
//        
//        if (![_player prepareToPlay]) {
//            return nil;
//        }
//        _musicDic[fileName]=_player;;
//    }
//    
//    if (![_player isPlaying]) {
//        [_player play];
//    }
//    
//    _player.delegate=self;
//    return _player;
//    
//}
//
//-(void)pauseAudioWithFileName:(NSString *)fileName{
//    
//    AVAudioPlayer *player=_musicDic[fileName];
//    if (!player) {
//        return;
//       
//    }
//    
//    if ([player isPlaying]) {
//        [player pause];
//    }
//    
//    
//}
//
//-(void)stopAudioWithFileName:(NSString *)fileName{
//    
//    
//    AVAudioPlayer *player=_musicDic[fileName];
//    if (!player) {
//        return;
//    }
//    [player pause];
//    [player stop];
//    //从字典中移除->每次从头开始播放
//    [_musicDic removeObjectForKey:fileName];
//    
//}



#pragma mark online play music
-(FSAudioStream *)playAudioWithOnlineString:(NSString *)fileName{
    
    if (fileName==nil||fileName.length==0) {
        return nil;
    }
   self.onlinePlay=_onleMusicDic[fileName];
    
    KNMusicOnBaiDuIcon *music ;
    if (_onlinePlay==nil) {
        
         music = [KNMuiscTool getOnlineCurrentMusic];
        
        if (!music) {

           music = [KNMuiscTool getCurrentMusic];
            
        }
        if ([[KNMuiscTool musicManager] searchMusicFromLocal:music]) {
            
            if (music.isSearchMusic) {
                
                _onlinePlay = [[FSAudioStream alloc] initWithUrl:[NSURL fileURLWithPath:music.songLink]];
                
            } else {
                
                 _onlinePlay  =[[FSAudioStream alloc] initWithUrl:[NSURL fileURLWithPath:[KNMuiscTool getLocatPath:music]]];
               
            }
           
            
        } else {
            
            
            FSStreamConfiguration *configuration = [FSStreamConfiguration new];
            configuration.cacheEnabled=NO;

            _onlinePlay = [[FSAudioStream alloc] initWithConfiguration:configuration];
            
            [_onlinePlay playFromURL:[NSURL URLWithString:fileName]];
            
        }
        
        
    }
    
    _onleMusicDic[fileName]=_onlinePlay;
    
        
//       onliePlayer.onCompletion=^(){
        
//       KNMusicOnBaiDuIcon *music = [KNMuiscTool getOnlineCurrentMusic];
//    
//       [self stopAudioWithOnlineString:music.songLink];
//       [[self playAudioWithOnlineString:[KNMuiscTool nextOnlineMusic:music].songLink] play];
        
        
//    };
    //onliePlayer.onFailure=^(kFsAudioStreamErrorNone,@"fee"){
        
        
        
    //};
    
    [self setBackLrc:music];
    return _onlinePlay;

}
//** 播放时候调用 暂停歌曲 反之亦然 */
-(void)pauseAudioWithOnlineString:(NSString *)fileName{
    
    
    FSAudioStream *onlinePlayer=_onleMusicDic[fileName];
    
    if (onlinePlayer==nil) {
        
        return;
    }
    
    
        [onlinePlayer pause];
 
    
    
}

-(void)stopAudioWithOnlineString:(NSString *)fileName{
    
    
    FSAudioStream *onlinePlayer=_onleMusicDic[fileName];
    
    if (onlinePlayer==nil) {
        
        return;
    }
    
    [onlinePlayer pause];
    [onlinePlayer stop];
    
    [_onleMusicDic removeObjectForKey:fileName];
}

#pragma mark stream delegate


#pragma  mark searchControl delegate
-(void)clickMusicSearchofRow:(KNMusicSearchControl *)search andMusic:(KNMusicOnBaiDuIcon *)musisc{
    
    
    KNMusicOnBaiDuIcon *localMusic = [KNMuiscTool getCurrentMusic];
    
    if (localMusic) {
        
        [self stopAudioWithOnlineString:localMusic.songLink];
        [KNMuiscTool setPlayingMusci:nil];
          _onlinePlay = nil;
        
    }
        
        
        KNMusicOnBaiDuIcon *tempMuisc=[KNMuiscTool getOnlineCurrentMusic];
        if (tempMuisc==nil) {
            
            [KNMuiscTool setOnlinePlayingMusci:musisc];
            [[self playAudioWithOnlineString:musisc.songLink] play];
            //[_onlinePlay play];
            
        } else {
            
            if (musisc!=tempMuisc) {
                
                [self stopAudioWithOnlineString:tempMuisc.songLink];
                [KNMuiscTool setOnlinePlayingMusci:musisc];
                [[self playAudioWithOnlineString:musisc.songLink] play];
                
            } else {
                
                
                [self pauseAudioWithOnlineString:musisc.songLink];
            }
            
        }
        
        self.num = 0;
        __weak KNAudioTool *mySelf=self;
    
       _onlinePlay.onCompletion = ^{
        
        [mySelf playModel:NO];
        
    };
        self.onlinePlay.onFailure=^(FSAudioStreamError error,NSString *description){
            
            if (mySelf.num==0) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"searchPlayError" object:mySelf userInfo:@{@"description":description}];
                mySelf.num = 1;
            }
            
            
        };

    
      

    
    
}

#pragma  mark musitStrore delegate

-(void)clickListControlDelegate:(KNListControl *)control andMusic:(KNMusicOnBaiDuIcon *)muisc{
    
    
    KNMusicOnBaiDuIcon *localMusic = [KNMuiscTool getCurrentMusic];
    
    if (localMusic) {
        
        [self stopAudioWithOnlineString:localMusic.songLink];
        [KNMuiscTool setPlayingMusci:nil];
          _onlinePlay = nil;
        
        
    }
    
        KNMusicOnBaiDuIcon *tempMuisc=[KNMuiscTool getOnlineCurrentMusic];
        if (tempMuisc==nil) {
            
            [KNMuiscTool setOnlinePlayingMusci:muisc];
            [[self playAudioWithOnlineString:muisc.songLink] play];
            
        } else {
            
            if (muisc!=tempMuisc) {
                
                [self stopAudioWithOnlineString:tempMuisc.songLink];
                [KNMuiscTool setOnlinePlayingMusci:muisc];
                [[self playAudioWithOnlineString:muisc.songLink] play];
                
            } else {
                
                
                [self pauseAudioWithOnlineString:muisc.songLink];
            }
            
        }
        
        __weak KNAudioTool *mySelf=self;
    
    _onlinePlay.onCompletion=^{
        
        [mySelf playModel:NO];
        
    };
        self.num=0;
        self.onlinePlay.onFailure=^(FSAudioStreamError error,NSString *description){
            
            if (mySelf.num==0) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"playError" object:mySelf userInfo:@{@"description":description}];
                mySelf.num=1;
                
            }
            
            
        };

        
        
        

    
    
}

-(void)clickLocalMusiControl:(KNMusicControl *)localControl withSelectedMuisc:(KNMusicOnBaiDuIcon *)music{
    
    KNMusicOnBaiDuIcon *onlineMusic = [KNMuiscTool getOnlineCurrentMusic];
    if (onlineMusic) {
        
        [self stopAudioWithOnlineString:onlineMusic.songLink];
        [KNMuiscTool setOnlinePlayingMusci:nil];
        _onlinePlay = nil;
        
    }
        
        KNMusicOnBaiDuIcon *tempMuisc=[KNMuiscTool getCurrentMusic];
        if (tempMuisc==nil) {
            
            [KNMuiscTool setPlayingMusci:music];
            [[self playAudioWithOnlineString:music.songLink] play];
            
        } else {
            
            if (music!=tempMuisc) {
                
                [self stopAudioWithOnlineString:tempMuisc.songLink];
                [KNMuiscTool setPlayingMusci:music];
                [[self playAudioWithOnlineString:music.songLink] play];
                
            } else {
                
                [self pauseAudioWithOnlineString:music.songLink];
            }
            
        }
    
    __weak KNAudioTool *mySelf = self;
     _onlinePlay.onCompletion =^{
        
        
        [mySelf playModel:YES];
        
    };
    _onlinePlay.onFailure =^(FSAudioStreamError erro,NSString *description){
        
        [[KNMusicSearch searchManager] downloadMusic:[KNMuiscTool getCurrentMusic].songLink successHandler:^(id location, id response, NSString *keyString) {
            
            
            [KNMuiscTool addMusicForPlit:[[KNMuiscTool musicManager] getDonloadMuisc:keyString] withlocation:nil];
            
            [KNMuiscTool addMusicForLoaction:[[KNMuiscTool musicManager ] getDonloadMuisc:keyString] withlocation:location];
            
            ;

            
        } andFailHander:^(id response, id erro, NSString *keyString) {
            
            
        } andProgrees:^(int64_t writedData, int64_t totalData) {
            NSLog(@"---");
            
        }];
        
    };
    
}

-(void)playModel:(BOOL)isLocal{
    
    BOOL isCirc = YES;
    if (isLocal) {
        
        
            if (isCirc) {
                
                KNMusicOnBaiDuIcon *music = [KNMuiscTool nextMusic:[KNMuiscTool getCurrentMusic]];
                [[self playAudioWithOnlineString:music.songLink] play];
                
            } else {
                
                [KNMuiscTool setPlayingMusci:nil];
            }
            

        
        
    } else {
        
        
        if (isCirc) {
            
           KNMusicOnBaiDuIcon *music = [KNMuiscTool nextOnlineMusic:[KNMuiscTool getOnlineCurrentMusic]];
            [[self playAudioWithOnlineString:music.songLink] play];
            
        } else {
            
            [KNMuiscTool setOnlinePlayingMusci:nil];
        }
        
        
    }
   
    
}

#pragma mark --setbacklrc
-(void)setBackLrc:(KNMusicOnBaiDuIcon *)music{
    
//    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
//    NSMutableDictionary *info      = [NSMutableDictionary dictionary];
//    info[MPMediaItemPropertyAlbumTitle] = music.songName;
//    info[MPMediaItemPropertyArtist] = music.artistName;
//    //info[MPMediaItemPropertyPlaybackDuration] = @""
   
    
}


@end
