//
//  KNListControl.m
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/17.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import "KNListControl.h"
#import "KNMusicSearch.h"
#import "KNMusic.h"
#import "KNMuiscTool.h"
#import <UIImageView+WebCache.h>
#import "KNAudioTool.h"
#import "TSMessage.h"
#import "KNMusicSearchControl.h"
#import "KNArtist.h"
#import "MJRefresh.h"
#import "KNCachDataTool.h"
#import "MBProgressHUD+KR.h"

const static NSString *baseMusicDetail=@"http://ting.baidu.com/data/music/links?songIds=";

@interface KNListControl ()
@property (nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic,strong) NSString *selcteMusicName;
@property (nonatomic,strong) UIBarButtonItem *item;
@property (nonatomic,getter=isFirstNotification) BOOL firstNotification;
@property (nonatomic,assign) int limits;

@end

@implementation KNListControl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listArray = [NSMutableArray array];
    self.limits = 10;
    self.tableView.bouncesZoom = YES;
    if (self.list!=nil) {
        
        self.navigationItem.title=self.list.name;
        MBProgressHUD *hud = [MBProgressHUD showMessage:@"正在加载"];
        [[KNMuiscTool musicManager] getMusicByArtistAndBoardList:nil andBoardList:self.list andLimits:self.limits andResultBlock:^(KNMusicOnBaiDuIcon *muisc) {
            
            [self.listArray addObject:muisc];
            dispatch_async(dispatch_get_main_queue(), ^{
               
                [hud hide:YES];
                [self.tableView reloadData];
            });
            
        } andFirstFailer:^(id response, NSError *error) {
            [hud hide:YES];
            
        } andSecondError:^(id response, NSError *error) {
            [hud hide:YES];
            
        }];
        
        
    } else {
        
        MBProgressHUD *hud = [MBProgressHUD showMessage:@"正在加载"];
       [[KNMuiscTool musicManager] getMusicByArtistAndBoardList:self.artist andBoardList:nil andLimits:self.limits andResultBlock:^(KNMusicOnBaiDuIcon *muisc) {
           
           self.navigationItem.title=self.artist.artistname;
           [self.listArray addObject:muisc];
           dispatch_async(dispatch_get_main_queue(), ^{
               [hud hide:YES];
               [self.tableView reloadData];
           });
           
       } andFirstFailer:^(id response, NSError *error) {
           
           [hud hide:YES];
           
       } andSecondError:^(id response, NSError *error) {
           
           [hud hide:YES];
           
       }];
    
    }
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playError:) name:@"playError" object:nil];
    
    self.delegate = [KNAudioTool sharedAudiManager];
    
    [TSMessage setDefaultViewController:self];
    [self setUpRefreshControl];
    

}

#pragma mark --下拉刷新

-(void)setUpRefreshControl{
    
   
    self.tableView.mj_footer =[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
    
    
}

-(void)getMoreData{
    
    
    if (self.artist) {
        
        self.limits = self.limits +5;
        
        [[KNMuiscTool musicManager] getMusicByArtistAndBoardList:self.artist andBoardList:nil andLimits:self.limits andResultBlock:^(KNMusicOnBaiDuIcon *muisc) {
            
            if (muisc == nil) {
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
            
            [self.listArray addObject:muisc];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
            });
            if (self.limits == self.listArray.count) {
                [self.tableView.mj_footer endRefreshing];
                
                
            }

            
        } andFirstFailer:^(id response, NSError *error) {
            
            
            
        } andSecondError:^(id response, NSError *error) {
            
            
            
        }];
        
    } else {
        
        
        self.limits = self.limits +5;
        
        [[KNMuiscTool musicManager] getMusicByArtistAndBoardList:nil andBoardList:self.list andLimits:self.limits andResultBlock:^(KNMusicOnBaiDuIcon *muisc) {
            
            if (muisc == nil) {
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
            
            [self.listArray addObject:muisc];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
            });
            if (self.limits == self.listArray.count) {
                [self.tableView.mj_footer endRefreshing];
                
                
            }
            
            
        } andFirstFailer:^(id response, NSError *error) {
            
            [self.tableView.mj_footer endRefreshing];
            NSHTTPURLResponse *res=response;
            NSLog(@"%ld error:%@",res.statusCode,error.userInfo);
            NSLog(@"榜单错误");

            
        } andSecondError:^(id response, NSError *error) {
            
             [self.tableView.mj_footer endRefreshing];
            NSHTTPURLResponse *res=response;
            NSLog(@"%ld error:%@",res.statusCode,error.userInfo);
            NSLog(@"榜单错误");

            
        }];

        
        
        
    }

    
    
}

-(void)playError:(NSNotification *)infor{
   
        NSDictionary *dic=infor.userInfo;
        [TSMessage showNotificationWithTitle:@"错误" subtitle:dic[@"description"] type:TSMessageNotificationTypeError];
        [self showAlert];
             
    
    
}

-(void)showAlert{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"资源错误" message:@"是否搜索更多歌曲" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *anctionNo=[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *anctionYes=[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //self.tableView.userInteractionEnabled=NO;
      
        
        KNMusicSearchControl *search=[KNMusicSearchControl new];
        
        search.searchString=self.selcteMusicName;
        
        [self.navigationController pushViewController:search animated:YES];
        self.firstNotification=YES;

    }];
    
    [alert addAction:anctionNo];
    [alert addAction:anctionYes];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"searchCell"] ;
    
    if (cell==nil) {
        
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"searchCell"];
    }
    if (self.listArray.count<=0) {
        return nil;
    }
    KNMusicOnBaiDuIcon *onelin=self.listArray[indexPath.row];
    cell.textLabel.text=onelin.songName;
    cell.detailTextLabel.text=onelin.artistName;
    BOOL showImage = YES;
    if (showImage) {
       
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:onelin.songPicSmall]
                          placeholderImage:[UIImage imageNamed:@"008"]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                              
                          }];
    } 
    
   
    
    return cell;

    
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 70;
}

#pragma mark-tableview-delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KNMusicOnBaiDuIcon *music=self.listArray[indexPath.row];
    self.selcteMusicName=music.songName;
    [[KNMuiscTool musicManager] downloadMuisc:music];
    [self.delegate clickListControlDelegate:self andMusic:music];
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    
    [super viewWillAppear:animated];
//    self.list = nil;
//    self.artist = nil;
//    self.listArray = nil;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [KNCachDataTool removeCachData];
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"playError" object:nil];
    
    
}




@end
