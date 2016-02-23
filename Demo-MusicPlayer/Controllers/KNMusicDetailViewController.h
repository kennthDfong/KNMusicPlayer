//
//  KNMusicDetailViewController.h
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/4.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNMusic.h"

typedef void(^MyBlock)(BOOL);
@interface KNMusicDetailViewController : UIViewController
@property (nonatomic,strong)KNMusic *music;
@property (nonatomic,copy) MyBlock showViewWhenCallBack;
@property (nonatomic,strong) NSString *remoteRul;
@property (nonatomic,strong) NSString *imageUrl;


@end
