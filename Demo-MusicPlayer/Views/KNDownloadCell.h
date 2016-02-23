//
//  KNDownloadCell.h
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/23.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KNDownloadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *currentDownloadMusic;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIProgressView *preogress;

@end
