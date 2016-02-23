//
//  KNLrcCell.h
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/10.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNLyric.h"
@interface KNLrcCell : UITableViewCell

@property (nonatomic,strong) KNLyric *lrcLine;
+(instancetype)lrcCellWithTableView:(UITableView *)tableView;

@end
