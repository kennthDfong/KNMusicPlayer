//
//  KNMusicControl.h
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/4.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KNMusicControl;
@class KNMusicOnBaiDuIcon;
@protocol KNMusicControlDelegate <NSObject>

-(void)clickLocalMusiControl:(KNMusicControl *)localControl withSelectedMuisc:(KNMusicOnBaiDuIcon *)music;

@end

@interface KNMusicControl : UIViewController
@property (nonatomic,weak) id<KNMusicControlDelegate> delegate;

@end
