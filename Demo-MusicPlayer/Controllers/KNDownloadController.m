//
//  KNDownloadController.m
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/23.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import "KNDownloadController.h"
#import "KNMusicSearch.h"
#import "KNDownloadCell.h"
#import "KNMuiscTool.h"

static NSString *identifer = @"cell";
@interface KNDownloadController ()<KNMusicSearchDelegate>
@property (nonatomic,strong) NSArray *downloadArray;
@property (nonatomic,strong) NSMutableDictionary *downloadDic;


@end

@implementation KNDownloadController
-(NSMutableDictionary *)downloadDic{
    
    if (!_downloadDic) {
        
        _downloadDic = [NSMutableDictionary dictionary];
    }
    
    
    return _downloadDic;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"KNDownloadCell" bundle:nil] forCellReuseIdentifier:identifer];
    self.downloadArray = [[KNMuiscTool musicManager] getAllDownloadMusic];
    [KNMusicSearch searchManager].delegate = self;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.downloadArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KNDownloadCell *cell  =[tableView dequeueReusableCellWithIdentifier:identifer];
    KNMusicOnBaiDuIcon *music = self.downloadArray[indexPath.row];
    cell.currentDownloadMusic.text = [NSString stringWithFormat:@"%@:%@",music.artistName,music.songName];
    self.downloadDic[music.songLink] = cell ;
    cell.downloadButton.tag =indexPath.row;
    [cell.downloadButton addTarget:self action:@selector(pauseOrStart:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
    
}

-(void)pauseOrStart:(UIButton *)sender{
    
    sender.selected=!sender.selected;
    
    if (sender.selected) {
       
        [[KNMusicSearch searchManager] recvResumClick:self.downloadArray[sender.tag]];
       } else {
                
            [[KNMusicSearch searchManager] recvStartClick:self.downloadArray[sender.tag]];
    }


}
 
#pragma mark --tablview-delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *headerString = [NSString stringWithFormat:@"正在下载:%ld首",self.downloadArray.count];
    return headerString;
    
}


#pragma mark  -- musicsearch -delegate
-(void)downloadTaskProgress:(KNMusicSearch *)search andEd:(int64_t)downloadedLength andKeyString:(NSString *)keyString andAll:(int64_t)expectedLength withDownTask:(NSURLSessionDownloadTask *)task{
    
   
    KNDownloadCell *cell = self.downloadDic[keyString];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        cell.preogress.progress = 1.0*downloadedLength/expectedLength;
    });
    
    
    
}

-(void)havedownloadedMusic:(KNMusicSearch *)search andlocaPath:(NSString *)string andKeyString:(NSString *)keyString{
    
        [self.downloadDic removeObjectForKey:keyString];

    
}

-(void)downloadFailer:(KNMusicSearch *)seach withKeyString:(NSString *)keyString andDownTask:(NSURLSessionTask *)task andError:(NSError *)error{


    [self.downloadDic removeObjectForKey:keyString];

    
}






@end
