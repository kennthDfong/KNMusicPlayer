//
//  KNMusicGroup.h
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/5.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import <UIKit/UIKit.h>


@class KNMusicSearchControl;
@class KNMusicOnBaiDuIcon;

@protocol KNMusicSearchControlDelegate <NSObject>

-(void)clickMusicSearchofRow:(KNMusicSearchControl *)search andMusic:(KNMusicOnBaiDuIcon *)musisc;

@end




@interface KNMusicSearchControl : UIViewController
@property (nonatomic,weak)id<KNMusicSearchControlDelegate> delegate;

@property (nonatomic,strong) NSString *searchString;

//+(KNMusicOnBaiDuIcon *)getCurrentMusic;
//+(void)setPlayingMusci:(KNMusicOnBaiDuIcon *)musci;
//+(KNMusicOnBaiDuIcon *)nextMusic:(KNMusicOnBaiDuIcon *)music;
//+(KNMusicOnBaiDuIcon *)forworadMusic:(KNMusicOnBaiDuIcon *)music;

@end
