//
//  KNMuiscStroeViewController.m
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/17.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import "KNMuiscStroeViewController.h"
#import "KNListCell.h"
#import "KNMusicSearch.h"
#import "KNBoradListManager.h"
#import "KNBoardList.h"
#import "KNListControl.h"
#import "KNMuiscTool.h"
#import "KNArtist.h"
#import <UIImageView+WebCache.h>
#import "MBProgressHUD+KR.h"

#define SCREEN_BOUNDS  [UIScreen mainScreen].bounds
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define STATUES_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAV_HEINGT     [[UINavigationController alloc] init].navigationBar.frame.size.height

@interface KNMuiscStroeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSArray *boardListArray;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UISegmentedControl *segment;

@end

@implementation KNMuiscStroeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createTableView];
    self.view.backgroundColor = [UIColor whiteColor];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"排序榜",@"歌手"]];
    self.segment = segment;
    segment.frame = CGRectMake(0, NAV_HEINGT+STATUES_HEIGHT, SCREEN_WIDTH, NAV_HEINGT);
    segment.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:segment];
    [segment addTarget:self action:@selector(clickSegment:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.title = @"乐库";
    segment.userInteractionEnabled = YES;
    [segment setBackgroundImage:[UIImage imageNamed:@"segment"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"ic_iqiyi_return"] forState:UIControlStateNormal];
//Image:[UIImage imageNamed:@"ic_iqiyi_return"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];

    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self getData];
    
}
#pragma mark-clicksegement

-(void)clickSegment:(UISegmentedControl *)sender{
    
    
    if (sender.selectedSegmentIndex==1) {
        self.boardListArray = nil;
        [self.tableView reloadData];
        self.boardListArray = [[KNMuiscTool musicManager] getALLArtistMessage];
        [self.tableView reloadData];
        
    } else{
        
        [self getData];
    }
    
    
}


-(void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 2*NAV_HEINGT+STATUES_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_HEINGT-STATUES_HEIGHT-44)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
}
-(void)getData{
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"正在加载"];
    
    [[KNBoradListManager listManager] getListCompleteHandle:^(NSArray *array) {
        
        if (self.segment.selectedSegmentIndex==1) {
            return ;
        }
        self.boardListArray=array;
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
             [hud hide:YES];
             [self.tableView reloadData];
            
        });
       
        
    } andHaveReload:^(NSArray *haveData) {
        
        
        if (self.segment.selectedSegmentIndex==1) {
            return ;
        }
        self.boardListArray = haveData;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hide:YES];
            [self.tableView reloadData];
            
        });
        
    }];
    
}

-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden=NO;
    
}

#pragma mark --tableview -data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.boardListArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    static NSString *identifier = @"list";
    KNListCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[KNListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    
    
    if (self.segment.selectedSegmentIndex==1) {
        
        cell.list = nil;
        KNArtist *artist = self.boardListArray[indexPath.row];
        cell.artit = artist;
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:artist.artistpic] placeholderImage:[UIImage imageNamed:@"008"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//           
//            
//        }];
        
    } else {
        
        
          cell.list = self.boardListArray[indexPath.row];
    }
    
    
    return cell;
}

#pragma mark ---tableView delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.segment.selectedSegmentIndex==1) {
        
        return 30;
        
    } else {
        
         return 70;
    }
    
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (self.segment.selectedSegmentIndex==1) {
        
        return 40;
        
    } else {
        
        return 70;
    }

    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.segment.selectedSegmentIndex==1) {
    
        KNListControl *listContro = [KNListControl new];
        listContro.artist = self.boardListArray[indexPath.row];
        [[KNMuiscTool musicManager] removeAllSearchMuisc];
        [self.navigationController pushViewController:listContro animated:YES];
        
        
    } else {
        
        KNListControl *listContro = [KNListControl new];
        listContro.list=self.boardListArray[indexPath.row];
        
        [self.navigationController pushViewController:listContro animated:YES];

        
    }
    
    
    
}



@end
