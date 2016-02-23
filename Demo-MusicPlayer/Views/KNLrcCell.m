//
//  KNLrcCell.m
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/10.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import "KNLrcCell.h"

static NSString *ID=@"KNLrcCell";
@implementation KNLrcCell

+(instancetype)lrcCellWithTableView:(UITableView *)tableView{
    
    KNLrcCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell =[[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor=[UIColor clearColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.textLabel.textColor=[UIColor redColor];
        self.textLabel.textAlignment=NSTextAlignmentCenter;
        self.textLabel.font=[UIFont systemFontOfSize:13];
        self.textLabel.numberOfLines=0;
    }
    
    return self;
}

-(void)setLrcLine:(KNLyric *)lrcLine{
    
    _lrcLine=lrcLine;
    self.textLabel.text = lrcLine.word;
    
}

-(void)layoutSubviews{
    
    
    [super layoutSubviews];
    
    self.textLabel.bounds=self.bounds;
}


@end
