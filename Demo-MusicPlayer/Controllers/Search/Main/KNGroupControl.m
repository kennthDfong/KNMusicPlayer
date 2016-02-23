//
//  KNGroupControl.m
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/7.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import "KNGroupControl.h"
#import "KNMuiscStroeViewController.h"
#import "KNMusicSearchControl.h"
#import "KNMuiscTool.h"
#import "KNMusicControl.h"
#import "KNDownloadController.h"

@interface KNGroupControl ()<UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lcoalMusicNum;
@property (weak, nonatomic) IBOutlet UILabel *downloadingMusic;
@property (nonatomic,copy ) NSString *searchPath;



@end

@implementation KNGroupControl

/**   搜索路径获取 可以给用户一个交互 让用户选择搜索路径*/
-(NSString *)searchPath{
    
    if (!_searchPath) {
        
        _searchPath =@"Users/Apple";
    }
    
    return _searchPath;
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self getMusicFromUserDeviec];
    NSLog(@"%@",NSTemporaryDirectory());
    self.navigationItem.title = @"我的音乐";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_search"] style:UIBarButtonItemStyleDone target:self action:@selector(searchButton:)];
    
    self.tableView.tableHeaderView=[self createScorView];
 
    
}
-(void)getMusicFromUserDeviec{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL firstSearch = ![defaults boolForKey:@"isFirstSearch"];
    if (firstSearch) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [[KNMuiscTool musicManager] searchLocalMusicOnPc:self.searchPath];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.lcoalMusicNum.text = [NSString stringWithFormat:
                                           @"%ld首",[[KNMuiscTool musicManager] musicArray].count];
                [defaults setBool:YES forKey:@"isFirstSearch"];
                
            });
            
        });
        
        
    }

}

#pragma 首界面在出现时候刷新数据
-(void)viewWillAppear:(BOOL)animated{
    
    self.lcoalMusicNum.text = [NSString stringWithFormat:
                               @"%ld首",[[KNMuiscTool musicManager] musicArray].count];
    NSArray *array = [[KNMuiscTool musicManager] getAllDownloadMusic];
    self.downloadingMusic.text = [NSString stringWithFormat:@"%ld首音乐正在下载",array.count],
    self.tabBarController.tabBar.hidden=NO;
                                  
}



-(UIScrollView *)createScorView{
    
    UIScrollView *scorView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.tableView.frame.size.width, 120)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:
                              [UIImage imageNamed:@"img_history_play_default.jpg"]];
    
    [scorView addSubview:imageView];
    
    return scorView;
    
}

#pragma mark -click Buttion 

- (IBAction)clickLocalButton:(UIButton *)sender {
    
    KNMusicControl *localMusicControl = [KNMusicControl new];
    
    [self.navigationController pushViewController:localMusicControl animated:YES];
    
}

- (IBAction)clcikShowDownloadMusic:(id)sender {
    
    
    KNDownloadController *downloadControl = [KNDownloadController new];
    
    [self.navigationController pushViewController:downloadControl animated:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark--tableview-datasourece



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section==0&&indexPath.row==2) {
        
         KNMuiscStroeViewController *stroControl=[KNMuiscStroeViewController new];
        
        [self.navigationController pushViewController:stroControl animated:YES];
        
    }
    
  
}

-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

- (void)searchButton:(UIBarButtonItem *)sender {
   
    
    KNMusicSearchControl *search = [KNMusicSearchControl new];

    [self.navigationController pushViewController:search animated:YES];
    
}


@end
