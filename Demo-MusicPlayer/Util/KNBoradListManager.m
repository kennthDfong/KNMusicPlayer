//
//  KNBoradListManager.m
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/17.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import "KNBoradListManager.h"
#include "KNBoardList.h"
#import "KNMusicSearch.h"

const static NSString *baiDuListUrl=@"http://tingapi.ting.baidu.com/v1/restserver/ting?from=webapp_music&method=baidu.ting.billboard.billList&format=json&size=10&type=";
static NSMutableArray *_musicListArray=nil;
static KNBoradListManager *_mananger;
@interface KNBoradListManager ()
@property (nonatomic,strong) NSArray *netArray;

@end
@implementation KNBoradListManager


-(NSArray *)netArray{
    
    
    if (!_netArray) {
        
        _netArray=@[@"http://tingapi.ting.baidu.com/v1/restserver/ting?       from=webapp_music&method=baidu.ting.billboard.billList&format=json&size=10&type=1",
                    @"http://tingapi.ting.baidu.com/v1/restserver/ting?from=webapp_music&method=baidu.ting.billboard.billList&format=json&size=10&type=2",
                    
                    @"http://tingapi.ting.baidu.com/v1/restserver/ting?from=webapp_music&method=baidu.ting.billboard.billList&format=json&size=10&type=11",
                    
                    @"http://tingapi.ting.baidu.com/v1/restserver/ting?from=webapp_music&method=baidu.ting.billboard.billList&format=json&size=10&type=12",
                    
                    @"http://tingapi.ting.baidu.com/v1/restserver/ting?from=webapp_music&method=baidu.ting.billboard.billList&format=json&size=10&type=16",
                    @"http://tingapi.ting.baidu.com/v1/restserver/ting?from=webapp_music&method=baidu.ting.billboard.billList&format=json&size=10&type=21",
                    @"http://tingapi.ting.baidu.com/v1/restserver/ting?from=webapp_music&method=baidu.ting.billboard.billList&format=json&size=10&type=22",
                    @"http://tingapi.ting.baidu.com/v1/restserver/ting?from=webapp_music&method=baidu.ting.billboard.billList&format=json&size=10&type=23",
                    @"http://tingapi.ting.baidu.com/v1/restserver/ting?from=webapp_music&method=baidu.ting.billboard.billList&format=json&size=10&type=24",
                    @"http://tingapi.ting.baidu.com/v1/restserver/ting?from=webapp_music&method=baidu.ting.billboard.billList&format=json&size=10&type=25"
                    ];
    }
    
    
    return _netArray;
}


+(instancetype)listManager{
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        _mananger = [[self alloc] init];
        
    });
    
    return _mananger;
}

-(instancetype)init{
    
    if (self=[super init]) {
        
       
    }
    
    
    return self;
}


-(void )getListCompleteHandle:(void (^)(NSArray *))complete andHaveReload:(void (^)(NSArray *))haveDataHandle{
    
    if (_musicListArray==nil) {
         _musicListArray=[NSMutableArray array];
        for (NSString *urlString in self.netArray) {
            
            [[KNMusicSearch searchManager] getMusicList:urlString successHandler:^(id data, id response) {
                NSData *recData = data;
                NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:recData options:0 error:nil];
                NSDictionary *boardDic=dic[@"billboard"];
                KNBoardList *list =[KNBoardList new];
                [list setValuesForKeysWithDictionary:boardDic];
                [_musicListArray addObject:list];
                complete([_musicListArray copy]);
               
                
            } andFailHandle:^(id response, NSError *error) {
               
                
                
            }];
           
            
        }

    }  else {
        
        haveDataHandle(_musicListArray);
        
    }
    
    
    
}
+(void)removeAllMusicList{
    
    [_musicListArray removeAllObjects];
    
}
-(void)dealloc{
    
    [_musicListArray removeAllObjects];
    
}



@end
