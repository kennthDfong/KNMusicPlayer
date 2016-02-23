//
//  KNMusicGroupTool.m
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/22.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import "KNMusicGroupTool.h"
#import "KNMuiscTool.h"
#import "KNMusic.h"
#import "KNMusicGroup.h"
#import "NSString+KNStringTool.h"

static NSArray *_groupArray;
static KNMusicGroupTool *_manager;
@interface KNMusicGroupTool ()
@property (nonatomic,strong) NSArray *allTitleArray;
@end
@implementation KNMusicGroupTool

-(NSArray *)allTitleArray{
    
    
    NSMutableArray *array = [NSMutableArray array];
    if (!_allTitleArray) {
        
        for (int i=0; i<26; i++) {
            
            char ch = 97+i;
            [array addObject:[NSString stringWithFormat:@"%c",ch]];
        }
    }
    
    
    return [array copy];;
}

+(instancetype)managerGroup{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
       
        _manager = [[self alloc] init];
    });
    
    return _manager;
    
}

-(instancetype)init{
    
    if (self = [super init]) {
        
       
    }
    
    return self;
}

-(NSArray *)getALLMusicGroup{
    
    if (_groupArray==nil) {
        
        NSArray *array  =[[KNMuiscTool musicManager] musicArray];
        [self paresMusicToGroup:array];
        
    }
    
  
    return _groupArray;
}

-(void)paresMusicToGroup:(NSArray *)array{
    
    NSMutableArray *arrays = [[NSMutableArray alloc] init];
    for (NSString *string in self.allTitleArray) {
        KNMusicGroup *group = [KNMusicGroup new];
        group.titile = string;
        [arrays addObject:group];
    }
    _groupArray = [arrays copy];
  
    for (KNMusicOnBaiDuIcon *music in array) {
        
        NSLog(@"gggg");
        NSString *nameString = [NSString convertHanZiToPingYing:music.artistName];
        char c= [nameString characterAtIndex:0];
       
        if ('A'<=c&&c<'Z') {
            c = c +32;
        }
        
        if (c<'a'||c> 'z') {
            NSLog(@"delete");
            continue;
        }
        int index= c-97;
        KNMusicGroup *group = _groupArray[index];
        [group.musicsArray addObject:music];
        
    }
    
    
}

@end
