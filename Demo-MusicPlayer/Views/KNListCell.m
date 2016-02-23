//
//  KNListCell.m
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/17.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import "KNListCell.h"
#import <UIImageView+WebCache.h>

@implementation KNListCell


-(void)setList:(KNBoardList *)list{
    
    if (list==nil) {
        
        return;
    }
    
    _list = list;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:list.pic_s260] placeholderImage:[UIImage imageNamed:@"008"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    self.textLabel.text=list.name;
    self.textLabel.font=[UIFont systemFontOfSize:20];
    self.detailTextLabel.text=[NSString stringWithFormat:@"更新时间:%@",list.update_date];
    self.detailTextLabel.font=[UIFont systemFontOfSize:15];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

-(void)setArtit:(KNArtist *)artit{
    
    if (artit==nil) {
        
        return;
    }
    _artit = artit;
    self.textLabel.text = artit.artistname;
    self.imageView.image = nil;
    self.detailTextLabel.text = nil;
    
}



@end
