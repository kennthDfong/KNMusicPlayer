//
//  KNListControl.h
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/17.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNBoardList.h"
@class KNMusicOnBaiDuIcon;
@class KNListControl;
@class KNArtist;
@protocol KNListControlDelegate  <NSObject>

-(void)clickListControlDelegate:(KNListControl *)control andMusic:(KNMusicOnBaiDuIcon *)muisc;

@end

@interface KNListControl : UITableViewController
@property (nonatomic,strong) KNBoardList *list;
@property (nonatomic,strong) KNArtist *artist;
@property (nonatomic,weak) id<KNListControlDelegate> delegate;

@end
