//
//  DetailViewController.m
//  ITclassroom
//
//  Created by motion on 16/2/24.
//  Copyright (c) 2016年 duanchuanfen. All rights reserved.
//
#import "MJRefresh.h"
#import "DetailViewController.h"
#import "LessonListModel.h"
#define kURLLessonInfo @"http://www.codingke.com:82/?r=lesson/lessonlist&courseid=%@&uid=11625&page=%d&timestamp=1456283902&sign=7e9e5355550ad79348686c3c8894e7f5092026a0"
@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArrSecTitle;
@property(nonatomic,strong)NSMutableArray *dataArraySecRow;
@property(nonatomic,assign)int page;

@property(nonatomic,strong)MJRefreshHeaderView *headView;
@property(nonatomic,strong)MJRefreshFooterView *footView;

@end

@implementation DetailViewController
-(void)dealloc{
    [_footView free];
    [_headView free];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    _dataArrSecTitle = [[NSMutableArray alloc]init];
    _dataArraySecRow = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self createUI];
    [self createTableView];
    [self requestWithUrlString:[NSString stringWithFormat:kURLLessonInfo,_courseid,_page] WithPrama:nil];
    
}

-(void)createUI{
    UIImageView *headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 130)];
    headView.image = [UIImage imageNamed:@"detail 2.jpg"];
    headView.userInteractionEnabled = YES;
    [self.view addSubview:headView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 30, 100, 100)];
    imageView.image = [UIImage imageNamed:@"shipinbofang"];
    [headView addSubview:imageView];
    
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,30)];
    backView.image = [UIImage imageNamed:@"detail.jpg"];
    backView.userInteractionEnabled = YES;
    [headView addSubview:backView];
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(0, 0, 30, 30);
    [backView addSubview:button];
    [button addTarget:self action:@selector(pressBack) forControlEvents:(UIControlEventTouchUpInside)];
}

-(void)pressBack{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createTableView{
    
   _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 150, self.view.frame.size.width,self.view.frame.size.height-150)  style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionFooterHeight = 0;
    _tableView.rowHeight = 30;
    [self.view addSubview:_tableView];
    
    
    _headView = [MJRefreshHeaderView header];
    _headView.delegate =self;
    _headView.scrollView = _tableView;
    
    _footView = [MJRefreshFooterView footer];
    _footView.delegate = self;
    _footView.scrollView = _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArrSecTitle.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataArraySecRow[section] count];
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifer = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cell"];
    }
       //刷新数据
    NSMutableArray *mrr = _dataArraySecRow[indexPath.section];
    LessonListModel *model = mrr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld.%@",indexPath.row+1,model.title];
    cell.detailTextLabel.text = model.length;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

-(void)requestSuccessWithInfo:(NSDictionary *)info{
    if (_page == 1) {
        [_dataArrSecTitle removeAllObjects];
        [_dataArraySecRow removeAllObjects];
    }
    
    NSArray *arr = info[@"data"];
    for (NSDictionary *dict in arr) {
        [_dataArrSecTitle addObject:dict[@"title"]];
       
        NSMutableArray *mrr = [NSMutableArray array];
        for (NSDictionary *lesson in dict[@"lesson"]) {
            LessonListModel *model = [[LessonListModel alloc]init];
            [model setValuesForKeysWithDictionary:lesson];
            [mrr addObject:model];
        
        }
        [_dataArraySecRow addObject:mrr];
    
    }

    [_tableView reloadData];
    [self stopRefresh];


}

-(void)requestFailedWithError:(NSString *)error{
    [self stopRefresh];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 12)];
    label.font = [UIFont systemFontOfSize:12];
    label.text = _dataArrSecTitle[section];
    return label;

}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if (refreshView == _headView) {
        //下拉刷新
        _page = 1;
        
    }
    if (refreshView == _footView) {
        //上拉加载
        _page++;
   }
    
    [self requestWithUrlString:[NSString stringWithFormat:kURLLessonInfo,_courseid,_page] WithPrama:nil];
}

-(void)stopRefresh{
    if ([_headView isRefreshing]) {
        [_headView endRefreshing];
    }
    if ([_footView isRefreshing]) {
        [_footView endRefreshing];
    }
}


@end
