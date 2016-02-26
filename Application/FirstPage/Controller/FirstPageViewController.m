
#import "UIImageView+WebCache.h"
#import "FirstPageCollectionViewCell.h"
#import "FirstPageCellModel.h"
#import "FirstPageViewController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "ScrollBannerModel.h"
#import "DetailViewController.h"
#define kURLString  @"http://www.codingke.com:82/?r=course/firstcourse&page=%d&timestamp=1452873108&sign=48ee1b4fee091311c7f89c8a714a9dbee50b7c75"
@interface FirstPageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,MJRefreshBaseViewDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)UICollectionView *collection;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UICollectionViewFlowLayout *flowOut;
@property(nonatomic,strong)UIScrollView *scroll;
@property(nonatomic,strong)NSMutableArray *bannerImageArray;
@property(nonatomic,strong)UICollectionView *bannerCollocation;
@property(nonatomic,strong)UIActivityIndicatorView *actionView;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)MJRefreshHeaderView *refreshHeader;
@property(nonatomic,strong)MJRefreshFooterView *refreshFooter;
@property(nonatomic,assign)int page;





@end
static int offsetpage = 0;
@implementation FirstPageViewController
{
    NSTimer *_timer;
    
}

-(void)dealloc{
    _timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    _page = 1;
    
    [self createNavigation];
    [self createCollection];
    [self senderGetForBanner];
    [self loadData];
    
    _dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    _bannerImageArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    _refreshHeader = [MJRefreshHeaderView header];
    _refreshFooter = [MJRefreshFooterView footer];
    _refreshHeader.scrollView = _collection;
    _refreshFooter.scrollView = _collection;
    _refreshFooter.delegate = self;
    _refreshHeader.delegate = self;
    
    UILabel *finishLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-250)/2, 580, 250, 30)];
    finishLabel.text = @"亲~已经是全部数据啦!";
    finishLabel.font = [UIFont boldSystemFontOfSize:20];
    finishLabel.textAlignment = NSTextAlignmentCenter;
    finishLabel.layer.cornerRadius = 15;
    finishLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    finishLabel.clipsToBounds = YES;
    finishLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:finishLabel];
    self.finishLabel = finishLabel;
    self.finishLabel.hidden = YES;
}

#pragma mark - 创建collecton 包括banner 和 下面的数据
-(void)createCollection{
    _flowOut = [[UICollectionViewFlowLayout alloc]init];
    
    _flowOut.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height-50) collectionViewLayout:_flowOut];
    _flowOut.itemSize = CGSizeMake((self.view.frame.size.width-30)/2, (self.view.frame.size.width-30)/2);
    _flowOut.minimumLineSpacing = 10;
    _flowOut.minimumInteritemSpacing = 10;
    _flowOut.sectionInset = UIEdgeInsetsMake(110, 10, 0, 10);
    
    
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collection];
    [_collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
     UICollectionViewFlowLayout *bannerFlowOut = [[UICollectionViewFlowLayout alloc]init];
    _bannerCollocation = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100) collectionViewLayout:bannerFlowOut];
    [_collection addSubview:_bannerCollocation];
    bannerFlowOut.itemSize = CGSizeMake(self.view.frame.size.width, 100);
    bannerFlowOut.minimumInteritemSpacing = 0;
    bannerFlowOut.minimumLineSpacing = 0;
    _bannerCollocation.backgroundColor = [UIColor redColor];
    bannerFlowOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [_collection registerClass:[FirstPageCollectionViewCell class] forCellWithReuseIdentifier:@"FirstPageCollectionViewCell"];
    [_bannerCollocation registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    _bannerCollocation.delegate = self;
    _bannerCollocation.dataSource = self;
    _bannerCollocation.pagingEnabled = YES;
    
    
    _actionView = [[UIActivityIndicatorView alloc]initWithFrame:_bannerCollocation.bounds];
    _bannerCollocation.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.3];
    _bannerCollocation.pagingEnabled = YES;
    _bannerCollocation.showsHorizontalScrollIndicator = NO;
    [_bannerCollocation addSubview:_actionView];
    [_actionView startAnimating];
}


-(void)createNavigation{
    UIImageView *navView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    navView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:navView];
    navView.image = [UIImage imageNamed:@"navigationBar"];
}

-(void)pressSearch{
    
}

#pragma mark - 获取数据
//发送请求获取滚动横幅数据
-(void)senderGetForBanner{
   
    NSString *urlString = @"http://www.codingke.com:82/?r=comm/banner&timestamp=1452873108&sign=84563c6a57deda0e4b8507f30b91391d321f580b";
    [self requestWithUrlString:urlString WithPrama:nil];
 }
//发送请求获取数据主页面数据
-(void)loadData{
    NSString *urlString = [NSString stringWithFormat:@"http://www.codingke.com:82/?r=course/firstcourse&page=%d&timestamp=1452873108&sign=48ee1b4fee091311c7f89c8a714a9dbee50b7c75",_page];
    
    [self requestWithUrlString:urlString WithPrama:nil];
}
//数据请求成功后舒心页面
-(void)requestSuccessWithInfo:(NSDictionary *)info{
    if ([info[@"data"] count] == 5) {
        for (NSDictionary *dic in info[@"data"]) {
            ScrollBannerModel *model = [[ScrollBannerModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_bannerImageArray addObject:model];
        }
        [_bannerCollocation reloadData];
        [self createTimer];
     }else {
        if (_page == 1) {
            [_dataArray removeAllObjects];
            
        }
        for (NSDictionary *dic in info[@"data"]) {
            
            FirstPageCellModel *model = [[FirstPageCellModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        [self stopRefresh];
        [_collection reloadData];

    }


}
         


//TODU:collectionView代理方法 返回行数
-(NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView == _collection){
        return _dataArray.count;
    }
    
    return _bannerImageArray.count;
    
}

//TODU:collectionView代理方法 返回列数
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(collectionView == _collection){
        FirstPageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FirstPageCollectionViewCell" forIndexPath:indexPath];
        
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
    
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:_bannerCollocation.bounds];
    ScrollBannerModel *model = _bannerImageArray[indexPath.row];
    NSURL *url = [NSURL URLWithString:model.banner];
    [imageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        _actionView.hidden = YES;
    }];
    cell.backgroundView = imageView;
    
    return cell;
    
}

#pragma mark - MJRefreshDelegte 方法
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if (refreshView == _refreshHeader) {
         _page = 1;
        [self loadData];
    }
    if (refreshView == _refreshFooter) {
        _page++;
        
        if (_page > 2) {
            self.finishLabel.alpha = 1.0;
            self.finishLabel.hidden = NO;
            [self performSelector:@selector(hideLable) withObject:nil afterDelay:2.0];
           }
         [self loadData];
    }
}

//隐藏数据完成label
-(void)hideLable{
    [UIView animateWithDuration:0.5 animations:^{
        
        self.finishLabel.alpha = 0.5;
    } completion:^(BOOL finished) {
        self.finishLabel.hidden = YES;
        
    }];
    
}

//停止刷新
-(void)stopRefresh{
    
    if ([_refreshHeader isRefreshing]) {
        [_refreshHeader endRefreshing];
    }
    if ([_refreshFooter isRefreshing]) {
        [_refreshFooter endRefreshing];
    }
    
    
}


-(void)createTimer{
    _timer  = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(changBannerImage) userInfo:nil repeats:YES];
    
}

-(void)changBannerImage{
    
    if (offsetpage == 0) {
        _bannerCollocation.contentOffset = CGPointMake(0, 0);
    }
    
    offsetpage++;
    [_bannerCollocation setContentOffset:CGPointMake(self.view.frame.size.width*offsetpage, 0) animated:YES];
    
}

#pragma mark - scrollViewDelegate方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == _bannerCollocation) {
        if (scrollView.contentOffset.x == 4*self.view.frame.size.width) {
            offsetpage = 0;
        }
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FirstPageCellModel *model = _dataArray[indexPath.row];
    if (collectionView == _collection) {
        DetailViewController *detail = [[DetailViewController alloc]init];
        
        detail.courseid = model.ID;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        return;
    }
    
    
    
    
    
    
}




@end

