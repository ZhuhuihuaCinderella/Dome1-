//
//  ViewController.m
//  Dome1 第一天的作业
//
//  Created by Qianfeng on 16/1/23.
//  Copyright © 2016年 ZZ. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "MyXIBTableViewCell.h"
@interface ViewController ()<NSURLSessionDataDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableData *resultData;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UIRefreshControl *refresh;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _dataSource = [[NSMutableArray alloc]init];
    [self loadDataSource];
    [self createTableView];
    
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"MyXIBTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    
}
static int page = 1;
-(void)loadDataSource {
    
/**********************异步请求************************/
    /*
    NSURL *url = [NSURL URLWithString:@"http://10.0.8.8/sns/my/user_list.php"];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dict);
    }];
    */
    
 /********************** 第一天的 NSURLSession ************************/
    /*
    NSURL * url = [NSURL URLWithString:@"http://10.0.8.8/sns/my/user_list.php"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
    }];
    [sessionDataTask resume];
    */
    
    /****************************** 第二天的 AFNetWorking ******************************/
    
    /*
     
     AFNetWorking   Get请求方法
     
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSDictionary *param = @{@"number":@10,@"page":@1};
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://10.0.8.8/sns/my/user_list.php" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@",responseObject);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ;
    }];
    */
    
    
    /*
      AFNetWorking   post请求方法
     
     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     
     NSDictionary *param = @{@"number":@10,@"page":@1};
     manager.responseSerializer = [AFHTTPResponseSerializer serializer];
     [manager POST:@"http://10.0.8.8/sns/my/user_list.php" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
     //NSLog(@"%@",responseObject);
     NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
     NSLog(@"%@",dict);
     
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     ;
     }];
     
     */
    
    
  /********************** 第四天的 NSURLSession ************************/
    
    /*
     
     NSURLSession  post请求  参数要写在请求体中 HTTPBody
     
     
    NSURL * url = [NSURL URLWithString:@"http://10.0.8.8/sns/my/user_list.php"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    request.HTTPMethod = @"post";
    request.HTTPBody = [@"number=10&&page=2" dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 60.0;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    [dataTask resume];
    */
    
    
     
    //NSURLSession  get请求  在url里可以直接写参数
    NSString *urlStr = [NSString stringWithFormat:@"http://10.0.8.8/sns/my/user_list.php?number=10&&page=%d",page];
    NSURL * url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    [dataTask resume];
    
}

#pragma mark - 创建tableView
-(void)createTableView {
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    
    //增加下拉刷新
    _refresh = [[UIRefreshControl alloc]init];
    [_refresh addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:_refresh];
    
    
    //增加加载更多button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"点击加载更多" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
    self.tableView.tableFooterView = button;
    
}
-(void)loadMore:(UIButton*)sender{
    page++;
    [self loadDataSource];
}
-(void)refreshData:(UIRefreshControl*)refresh {
    if (refresh.isRefreshing) {
        [self.dataSource removeAllObjects];
        page = 1;
        [self loadDataSource];
    }
}
#pragma mark - UITableViewDataSource 实现方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"cellID";
    MyXIBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    MyModel *model = self.dataSource[indexPath.row];
   // NSLog(@"%@",model);
    [cell configData:model];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}
#pragma mark - NSURLSessionDataDelegate 实现方法
//请求开始 收到了回应
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    //NSLog(@"%@",response);
    //在收到回应的时候初始化resultData 以便存放请求回来的data
    _resultData = [[NSMutableData alloc]init];
    completionHandler(NSURLSessionResponseAllow);//这个block一定要调用
}
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.resultData appendData:data];
}
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.resultData options:NSJSONReadingMutableContainers error:nil];
    NSArray *users = dict[@"users"];
    for (NSDictionary *dictItem in users) {
        MyModel *model = [[MyModel alloc]init];
        model.headimage = dictItem[@"headimage"];
        model.experience = dictItem[@"experience"];
        model.username = dictItem[@"username"];
        [_dataSource addObject:model];
       // NSLog(@"%ld",_dataSource.count);
    }
    [self.refresh endRefreshing];
    [self.tableView reloadData];
    
   // NSLog(@"%@",dict);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
