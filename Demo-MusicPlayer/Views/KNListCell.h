//
//  KNListCell.h
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/17.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNBoardList.h"
#import "KNArtist.h"

@interface KNListCell : UITableViewCell
@property (nonatomic,strong) KNBoardList *list;
@property (nonatomic,strong) KNArtist *artit;

@end
