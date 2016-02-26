//
//  LessonViewController.m
//  ITclassroom
//
//  Created by motion on 16/2/22.
//  Copyright (c) 2016年 duanchuanfen. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "LessonViewController.h"
#import "FirstPageViewController.h"
#import "FirstPageCollectionViewCell.h"
#import "MJRefresh.h"
#import "FirstPageCellModel.h"
#import "DetailViewController.h"

#define kIOSURLString @"http://www.codingke.com:82/?r=course/cate&cateid=2&page=%d&timestamp=1452873359&sign=20ef30694f3a7fc4a35d9e057fd9b9f4f43196c3"

#define kAndrionURLString @"http://www.codingke.com:82/?r=course/cate&cateid=1&page=1&timestamp=1452929263&sign=8a50c9da68dee966f7178af511d8e27ae80f2824"

#define kCOCOSURLString @"http://www.codingke.com:82/?r=course/cate&cateid=69&page=1&timestamp=1452929279&sign=07c9787661ab09fd6b597d0d789b9edc79e73e5a"
@interface LessonViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,MJRefreshBaseViewDelegate>
@property(nonatomic,strong)UISegmentedControl *segement;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong)UICollectionView *collection;
@property(nonatomic,strong)UICollectionView *androidCollection;
@property(nonatomic,strong)UICollectionView *cocosCollection;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSString *iosUrl;
@property(nonatomic,strong)NSString *androidUrl;
@property(nonatomic,strong)NSString *cocosUrl;
@property(nonatomic,assign)int pageIos;
@property(nonatomic,assign)int pageAndroid;
@property(nonatomic,assign)int pageCosos;


//@property(nonatomic,strong)MJRefreshHeaderView *headerView;
@property(nonatomic,strong)MJRefreshFooterView *footerView;


@end

@implementation LessonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    _pageIos = 1;
    _pageAndroid = 1;
    _pageCosos = 1;
    
    _iosUrl = [NSString stringWithFormat:kIOSURLString,_pageIos];
    _androidUrl = kAndrionURLString;
    _cocosUrl = kCOCOSURLString;
    
    //自定义导航视图
   UIImageView *barView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    barView.image = [UIImage imageNamed:@"navigationBarbackground"];
    [self.view addSubview:barView];
    
    _dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    //分段视图
    NSArray *array = @[@"iOS",@"Android",@"Cocos2d-X"];
    
    _segement = [[UISegmentedControl alloc]initWithItems:array];
    _segement.frame =CGRectMake(20, 20, self.view.frame.size.width-40,40);
    _segement.tintColor = [UIColor whiteColor];
    _segement.layer.borderWidth = 1;
    _segement.layer.borderColor = [UIColor whiteColor].CGColor;
    _segement.selectedSegmentIndex = 0;
    [self.view addSubview:_segement];
    [_segement addTarget:self action:@selector(sendRequest) forControlEvents:(UIControlEventValueChanged)];
    
    //实例化collection
    UICollectionViewFlowLayout *iosFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height-70) collectionViewLayout:iosFlowLayout];
    iosFlowLayout.itemSize = CGSizeMake((self.view.frame.size.width-30)/2, (self.view.frame.size.width-30)/2);
    iosFlowLayout.minimumLineSpacing = 10;
    iosFlowLayout.minimumInteritemSpacing = 10;
    iosFlowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
    _collection.showsVerticalScrollIndicator = NO;
    _collection.showsHorizontalScrollIndicator = NO;
    iosFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collection];
    
    
    //注册复用池
    [_collection registerClass:[FirstPageCollectionViewCell class] forCellWithReuseIdentifier:@"FirstPageCollectionViewCell"];
    _footerView = [MJRefreshFooterView footer];
    _footerView.scrollView = _collection;
    _footerView.delegate = self;
    
     [self showFinishLabel];
     [self sendGet:_iosUrl];
}

-(void)sendRequest{
    [_dataArray removeAllObjects];
    
    if (_segement.selectedSegmentIndex == 0) {
        _pageIos = 1;
        _iosUrl = [NSString stringWithFormat:kIOSURLString,_pageIos];
        [self sendGet:_iosUrl ];
    }
    
    if (_segement.selectedSegmentIndex == 1) {
        [self sendGet:_androidUrl ];
    }
    
    if (_segement.selectedSegmentIndex == 2) {
        [self sendGet:_cocosUrl ];
    }
    
}

-(void)sendGet:(NSString *)urlString {
    [self requestWithUrlString:urlString WithPrama:nil];
}

-(void)requestSuccessWithInfo:(NSDictionary *)info{
    
    NSArray *array = info[@"data"];
    if (_segement.selectedSegmentIndex != 0) {
        [_dataArray removeAllObjects];
    }
    
    for (NSDictionary *dic in array) {
        FirstPageCellModel *model = [[FirstPageCellModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [_dataArray addObject:model];
    }
    [self stopRefresh];
    [_collection reloadData];

}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FirstPageCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"FirstPageCollectionViewCell" forIndexPath:indexPath];
    
    FirstPageCellModel *model = _dataArray[indexPath.row];
    cell.title.text = model.title;
    cell.lessonNum.text = [NSString stringWithFormat:@"课时:%@",model.lessonNum];
    cell.hitNum.text = [NSString stringWithFormat:@"点击:%@",model.hitNum];
    NSURL *url = [NSURL URLWithString:model.largePicture];
    
    [cell.largePicture sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.coverView.hidden = YES;
    }];
    
    return cell;
}

-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    
    if (refreshView == _footerView && _segement.selectedSegmentIndex == 0) {
        _pageIos++;
        
        if (_pageIos > 2) {
            self.finishLabel.alpha = 1.0;
            self.finishLabel.hidden = NO;
            [self performSelector:@selector(hideLabel) withObject:nil afterDelay:2.0];
          }
         [self sendGet:[NSString stringWithFormat:kIOSURLString,_pageIos]];
      }
    
    
    if (_segement.selectedSegmentIndex == 1||_segement.selectedSegmentIndex == 2) {
        [self stopRefresh];
      }
}


-(void)stopRefresh{
    
    if ([_footerView isRefreshing]) {
        [_footerView endRefreshing];
    }
}


-(void)hideLabel{
    [UIView animateWithDuration:0.5 animations:^{
        self.finishLabel.alpha = 0.5;
    } completion:^(BOOL finished) {
        
        self.finishLabel.hidden = YES;
        
    }];
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FirstPageCellModel *model = _dataArray[indexPath.row];
    
    DetailViewController *detail = [[DetailViewController alloc]init];
    
    detail.courseid = model.ID;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];



}


@end
