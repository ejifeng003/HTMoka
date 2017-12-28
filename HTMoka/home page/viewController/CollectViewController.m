//
//  CollectViewController.m
//  HTMoka
//
//  Created by SZHuaTo on 2017/11/29.
//  Copyright © 2017年 深圳华图测控. All rights reserved.
//
#import "CollectViewController.h"
#import "CollectHeaderView.h"
#import "CollectTableViewCell.h"
#import "GoodsTableModel.h"
#import "GoodsDetailModel.h"

@interface CollectViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate,HXAlbumListViewControllerDelegate>
{
    BOOL _isDropDown;
    UITapGestureRecognizer *resignTap;
    NSMutableArray *goodsTableArr;//货物列表
    NSMutableArray *collectArr;//货物详情列表
    NSMutableArray *imageArr;//图片数组
    NSString *purchaseCode;//货物单号
    NSString *ListImageStr;
}

@property (weak, nonatomic) IBOutlet UIImageView *projectImg;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) UIView *goodsTableBackView;
@property (nonatomic,strong) UITableView *goodsTableView;//
@property (nonatomic,strong) UIView *RecognizerBackView;
@property (nonatomic,strong) CollectHeaderView *collectHeaderView;
@property (strong, nonatomic) HXPhotoView *photoView;

@property (strong, nonatomic) HXPhotoManager *manager;

@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;

@property (weak, nonatomic) IBOutlet UIButton *goodsBtn;

@property (weak, nonatomic) IBOutlet UIButton *SubmitBtn;//提交的按钮点击事件

@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"签收";
    _isDropDown = YES;
    
    //数据的初始化
    collectArr = [NSMutableArray array];
    goodsTableArr = [NSMutableArray array];
    imageArr = [NSMutableArray array];
    
    _SubmitBtn.layer.cornerRadius = 5;
    _goodsBtn.backgroundColor = [UIColor whiteColor];
    _goodsBtn.layer.cornerRadius = 5;
    _goodsBtn.layer.borderColor = [UIColor grayColor].CGColor;

    _goodsBtn.layer.borderWidth = .7;
    
//    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
//    photoView.frame = CGRectMake(0, 0, 0, 0);
//    photoView.delegate = self;
//    photoView.outerCamera = YES;
//    photoView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:photoView];
//
//    self.photoView = photoView;
    [self goodsTable];
    [self tableView];
    [self goodsTableNetWork];
}

#pragma mark - 视图创建
-(void)goodsTable
{
    //下拉列表的创建
//    _goodsTableBackView =  [[UIView alloc]initWithFrame:CGRectMake(15, self.goodsBtn.frame.size.height+self.goodsBtn.frame.origin.y+3, screen_width-30,0)];
//    _goodsTableBackView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:self.goodsTableBackView];
    
    //_goodsTableView.frame = self.goodsTableBackView.frame;
    
    self.goodsTableView.frame = CGRectMake(15, self.goodsBtn.frame.size.height+self.goodsBtn.frame.origin.y+3, screen_width-30,0);
    _goodsTableView = [[UITableView alloc]initWithFrame:CGRectMake(15, self.goodsBtn.frame.size.height+self.goodsBtn.frame.origin.y+3, screen_width-30, 0) style:UITableViewStylePlain];
    _goodsTableView.backgroundColor = [UIColor whiteColor];
    _goodsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _goodsTableView.dataSource = self;
    _goodsTableView.delegate = self;
    _goodsTableView.separatorStyle = YES;
    _goodsTableView.layer.cornerRadius = 8;
    _goodsTableView.layer.borderWidth = 1;
    _goodsTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:_goodsTableView];

//    _goodsTableView.layer.shadowColor = [UIColor blackColor].CGColor;
//    _goodsTableView.layer.shadowOpacity = 0.8f;
//    _goodsTableView.layer.shadowRadius = 4.f;
//    _goodsTableView.layer.shadowOffset = CGSizeMake(0,0);

}

-(void)tableView
{
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    
    CollectHeaderView *headerView = [CollectHeaderView creatViewWithTargetView:self.view];
//    UITapGestureRecognizer *resignTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchImgTap:)];
//    resignTap.delegate = self;
//    [headerView.collectImage addGestureRecognizer:resignTap];
    
    
    @weakify(self)
    headerView.SearchBlock=^(UIImage *collectImage){
        @strongify(self)
        self.manager.configuration.saveSystemAblum = YES;
        [self hx_presentAlbumListViewControllerWithManager:self.manager delegate:self];
       // [self.photoView goPhotoViewController];

    };
    self.collectHeaderView = headerView;
    _myTableView.tableHeaderView = self.collectHeaderView;

}

-(void)recognizerBackView
{
    _RecognizerBackView = [[UIView alloc]initWithFrame:CGRectMake( 0, 150, screen_width, screen_height)];
    _RecognizerBackView.backgroundColor = [UIColor clearColor];
    _RecognizerBackView.alpha = 0;
    _RecognizerBackView.userInteractionEnabled = YES;
    [self.view addSubview:_RecognizerBackView];
    resignTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchImgTap:)];
    resignTap.delegate = self;
    [_RecognizerBackView addGestureRecognizer:resignTap];

    
    [self.view addSubview:_goodsTableView];
}


#pragma mark - 网络请求
-(void)goodsTableNetWork
{
    //货物列表
    [SPSVProgressHUD showWithStatus:@"加载中..."];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setJsonValue:LLBUserInfo.probjectID key:@"ProjectCode"];
    
    [[NetworkManager sharedNetworkManager] requestGoodsTable:params success:^(id result){
        NSLog(@"货物列表 is %@",result);
        [SPSVProgressHUD dismiss];
        
        if (![result isKindOfClass:[NSDictionary class]]) {
            NSArray * modelArr = [GoodsTableModel mj_objectArrayWithKeyValuesArray:result];
            
            for (int i=0; i<modelArr.count; i++) {
                [goodsTableArr addObject:modelArr[i]];
                GoodsTableModel *model = goodsTableArr[0];
                purchaseCode = model.PurchaseCode;
                [self.goodsBtn setTitle:model.PurchaseTitle forState:UIControlStateNormal];
            }
            [_goodsTableView reloadData];
            [self goodsDetailNetWork];
        }
    
    } fail:^(NSString *errorMsg) {
        //显示网络异常
        [SPSVProgressHUD dismiss];
        
    }];
    
}

-(void)goodsDetailNetWork
{
    [SPSVProgressHUD showWithStatus:@"加载中..."];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setJsonValue:purchaseCode key:@"purchaseCode"];
    
    [collectArr removeAllObjects];
    //货物详情事件
    [[NetworkManager sharedNetworkManager] requestGoodsDetailTable:params success:^(id result){
        NSLog(@"data is %@",result);
        [SPSVProgressHUD dismiss];
        if (![result isKindOfClass:[NSDictionary class]]) {
            [SPSVProgressHUD showSuccessWithStatus:@"加载完毕"];
            NSArray * modelArr = [GoodsDetailModel mj_objectArrayWithKeyValuesArray:result];
            
            for (int i=0; i<modelArr.count; i++) {
                [collectArr addObject:modelArr[i]];
                GoodsDetailModel *model = collectArr[i];
                NSLog(@"mode arr count is %ld   %@",modelArr.count,model.SlaveCode);
            }
        
            [_myTableView reloadData];
        }
    } fail:^(NSString *errorMsg) {
        //显示网络异常
        [SPSVProgressHUD dismiss];
        
    }];

}

-(void)UploadNetWork
{
    //上传图片
    [[NetworkManager sharedNetworkManager]requestUploading:nil image:imageArr imageParamKey:@"" success:^(id result){
        [SPSVProgressHUD showSuccessWithStatus:@"上传成功"];
        if ([result isKindOfClass:[NSDictionary class]]&&result != nil){
            ListImageStr  = [NSString stringWithFormat:@"%@",result[@"FileUrl"]];
            
        }else{
            //
        }
    } fail:^(NSString *errorMsg) {
        [SPSVProgressHUD showErrorWithStatus:@"上传失败"];
    }];

}
-(void)SubmitNetWork
{
    [SPSVProgressHUD showWithStatus:@"提交中..."];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableArray *classTableList = [NSMutableArray array];
    //
    for (int i =0; i<collectArr.count; i++) {
        GoodsDetailModel *model = collectArr[i];
        NSDictionary *classParams =  @{@"SlaveCode":model.SlaveCode,@"CommodityCode":model.PurchaseCode,
                                       @"Num":model.Num,
                                    @"CurrentEntryNumber":model.NumberStorage,
                                       @"CommodityName":model.CommodityName,
                                       };
        
        [classTableList addObject:classParams];
        
    }
    [params setJsonValue:purchaseCode key:@"PurchaseCode"];
    
    [params setJsonValue:self.goodsBtn.titleLabel.text key:@"PurchaseTitle"];
    
    [params setJsonArr:classTableList key:@"PurchaseTableVoList"];//货物表单
    
    [params setJsonValue:ListImageStr key:@"ImgFileUrl"];
    

    [[NetworkManager sharedNetworkManager] requestlGoodsSign:params success:^(id result){
        [SPSVProgressHUD dismiss];
        [SPSVProgressHUD showSuccessWithStatus:@"提交成功"];
        if (![result isKindOfClass:[NSDictionary class]]) {
        
        }
        
    } fail:^(NSString *errorMsg) {
        //显示网络异常
        [SPSVProgressHUD dismiss];
        [SPSVProgressHUD showErrorWithStatus:@"提交失败"];
    }];

}

#pragma mark - 点击事件
- (IBAction)goodsClick:(id)sender {
    if (_isDropDown) {
        [self recognizerBackView];
        
        [UIView animateWithDuration:0.2 animations:^{
            CGRect rect = _goodsTableView.frame;
            rect.origin.y = self.goodsBtn.frame.size.height+self.goodsBtn.frame.origin.y+3;
            rect.size.height = 260;
            _goodsTableView.frame = rect;
            self.RecognizerBackView.alpha =.5;
        }];
        
        [UIView animateWithDuration:0.32 animations:^{
            self.projectImg.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:^(BOOL finished) {
        }];
        _isDropDown = NO;
    }else{
        [UIView animateWithDuration:0.15 animations:^{
            CGRect rect = _goodsTableView.frame;
            rect.origin.y = self.goodsBtn.frame.size.height+self.goodsBtn.frame.origin.y+3;
            rect.size.height = 0;
            _goodsTableView.frame = rect;
            self.RecognizerBackView.alpha = 0;
            [self.RecognizerBackView removeFromSuperview];
            
        }];
        [UIView animateWithDuration:0.32 animations:^{
            self.projectImg.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        }];
        //
        _isDropDown = YES;
    }
}
-(void)searchImgTap:(UITapGestureRecognizer*)tap
{
    //交互点击事件
    [UIView animateWithDuration:0.15 animations:^{
        CGRect rect = _goodsTableView.frame;
        rect.origin.y = self.goodsBtn.frame.size.height+self.goodsBtn.frame.origin.y+3;
        rect.size.height = 0;
        _goodsTableView.frame = rect;
        self.RecognizerBackView.alpha = 0;
        [self.RecognizerBackView removeFromSuperview];
    }];
    
    [UIView animateWithDuration:0.32 animations:^{
        self.projectImg.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
    
    _isDropDown = YES;
}


#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _myTableView) {
        return collectArr.count;
    }else{
        return goodsTableArr.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _myTableView) {
        
        CollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollectTableViewCell"];

        if(cell == nil){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CollectTableViewCell" owner:self options:nil]lastObject];
        }
    
        GoodsDetailModel *model = collectArr[indexPath.row];

        cell.CommodityCodeLabel.text = model.CommodityCode;
        cell.numTextField.text = [NSString stringWithFormat:@"%@%@",model.Num,model.Unit];//当前填写的数量
        
        cell.orderNumLabel.text = [NSString stringWithFormat:@"%@%@",model.State,model.Unit];//当前订单的数量
        
        cell.signLabel.text = [NSString stringWithFormat:@"%@%@",model.NumberStorage,model.Unit];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"Cell" owner:self options:nil]lastObject];
        }
        
        GoodsTableModel *goodsModel = goodsTableArr[indexPath.row];
        cell.textLabel.text = goodsModel.PurchaseTitle;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _goodsTableView) {
        return 44;
    }else{
        return 86;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (tableView == _goodsTableView) {
        GoodsTableModel *m = goodsTableArr[indexPath.row];
        [self.goodsBtn setTitle:m.PurchaseTitle forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.15 animations:^{
            CGRect rect = _goodsTableView.frame;
            rect.origin.y = self.goodsBtn.frame.size.height+self.goodsBtn.frame.origin.y+3;
            rect.size.height = 0;
            _goodsTableView.frame = rect;
            self.RecognizerBackView.alpha = 0;
            [self.RecognizerBackView removeFromSuperview];
            //
            purchaseCode = m.PurchaseCode;
            [self goodsDetailNetWork];
        }];
        
        [UIView animateWithDuration:0.32 animations:^{
            self.projectImg.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        }];

        _isDropDown = YES;

    }

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = [[UILabel alloc]init];
    headerLabel.text = @"   货物签收列表:";
    headerLabel.textColor = [UIColor grayColor];
    headerLabel.font = [UIFont systemFontOfSize:15];
    headerLabel.backgroundColor = [UIColor whiteColor];
    
    return headerLabel;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _goodsTableView) {
        return 0;
    }else{
        return 44;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .1f;
}

- (IBAction)SubmitClick:(id)sender {
    //提交点击事件
    [self SubmitNetWork];
}

- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    if (photoList.count > 0) {
        HXPhotoModel *model = photoList.firstObject;
        self.collectHeaderView.collectImage.image = model.thumbPhoto;
                [imageArr removeAllObjects];
                [imageArr addObject:model.thumbPhoto];
                [self UploadNetWork];
        
        NSSLog(@"%ld张图片",photoList.count);
        
    }else if (videoList.count > 0) {
        __weak typeof(self) weakSelf = self;
        [self.toolManager getSelectedImageList:allList success:^(NSArray<UIImage *> *imageList) {
            self.collectHeaderView.collectImage.image = imageList.firstObject;
        } failed:^{

        }];
        [self.view showLoadingHUDText:@"视频写入中"];
        //
        [self.toolManager writeSelectModelListToTempPathWithList:videoList success:^(NSArray<NSURL *> *allURL, NSArray<NSURL *> *photoURL, NSArray<NSURL *> *videoURL) {
            NSSLog(@"%@",videoURL);
            [weakSelf.view handleLoading];
        } failed:^{
            [weakSelf.view handleLoading];
            [weakSelf.view showImageHUDText:@"写入失败"];
            NSSLog(@"写入失败");
        }];
        //
        NSSLog(@"%ld个视频",videoList.count);
    }
}
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.configuration.openCamera = YES;
        _manager.configuration.lookLivePhoto = YES;
        _manager.configuration.photoMaxNum = 1;
        _manager.configuration.videoMaxNum = 0;
        _manager.configuration.maxNum = 1;
        _manager.configuration.videoMaxDuration = 500.f;
        _manager.configuration.saveSystemAblum = NO;
        //        _manager.configuration.reverseDate = YES;
        _manager.configuration.showDateSectionHeader = NO;
        _manager.configuration.selectTogether = NO;
    }
    return _manager;
}

- (HXDatePhotoToolManager *)toolManager {
    if (!_toolManager) {
        _toolManager = [[HXDatePhotoToolManager alloc] init];
    }

    return _toolManager;
}


@end
