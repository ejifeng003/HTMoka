//
//  JournalViewController.m
//  HTMoka
//
//  Created by SZHuaTo on 2017/11/28.
//  Copyright © 2017年 深圳华图测控. All rights reserved.
//

#import "JournalViewController.h"
#import "JournalViewCell.h"
#import "JournalHeaderView.h"
#import "ProjectSearchVC.h"

typedef NS_ENUM(NSInteger,ImgType) {
    ImgTypeBefore = 0,
    ImgTypeAfter
    
};
@interface JournalViewController ()<UITableViewDelegate,UITableViewDataSource,HXPhotoViewDelegate>
{
    __weak IBOutlet UIButton *submitBtn;
    __weak IBOutlet UIButton *typeBtn;
    
    NSMutableData *imageData;
    NSMutableArray *BeforeImgArr;
    NSMutableArray *AfterImgArr;
    NSMutableDictionary *imageDic;
    NSString *ListAfterImage;
    NSString *ListBeforeImage;
    NSInteger uplodNum;//当前上传的次数
    NSString *projectID;//项目ID
    UIImage *composeImg;//当前合成的图片
    NSString *constructionStr;//施工文本
    UIImageView *kkImgView;
    
}
@property (weak, nonatomic) IBOutlet UITableView *MyTableView;
@property (nonatomic,strong) JournalHeaderView *journalHeaderView;//日志的头视图

@end

@implementation JournalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"日志";
    
    
    constructionStr = @"";
    typeBtn.layer.cornerRadius = 3;
    typeBtn.layer.borderColor = [UIColor grayColor].CGColor;
    typeBtn.layer.borderWidth = 1;
    submitBtn.layer.cornerRadius = 4;
    
    //数据的初始化
    imageData = [NSMutableData data];
    BeforeImgArr = [NSMutableArray array];
    AfterImgArr = [NSMutableArray array];
    imageDic = [NSMutableDictionary dictionary];

    [self myTableView];
    // Do any additional setup after loading the view.
}


-(void)myTableView
{
    _MyTableView.separatorStyle = YES;
    _MyTableView.delegate = self;
    _MyTableView.dataSource = self;
    
    JournalHeaderView *headerView = [JournalHeaderView creatViewWithTargetView:self.view];
    
    @weakify(self)

    __block  UIButton *blockBtn = headerView.typeBtn;
    headerView.SearchBlock=^(NSString *item){
        @strongify(self)
        ProjectSearchVC *vc = [[ProjectSearchVC alloc]init];
        [vc didSelectedItem:^(NSString *item,NSString *probjectid) {
            [blockBtn setTitle:item forState:UIControlStateNormal];
            projectID = probjectid;
        }];

        [self.navigationController pushViewController:vc animated:YES];
    };
    self.journalHeaderView = headerView;
    _MyTableView.tableHeaderView = self.journalHeaderView;
}

#pragma mark -网络请求
-(void)UploadNetWork:(NSArray*)imgArr ImageType:(NSInteger)ImgType
{
    NSDictionary * params = @{};
    MyLog(@"imagedate is =======%ld",imgArr.count);
    uplodNum = 0;
    
    [SPSVProgressHUD showWithStatus:@"上传中..."];
    [[NetworkManager sharedNetworkManager]requestUploading:params image:imgArr imageParamKey:@"ImgFile" success:^(id result){
        if ([result isKindOfClass:[NSDictionary class]]&&result != nil){
//            if (ImgType == ImgTypeBefore) {
//                ListBeforeImage  = [NSString stringWithFormat:@"%@#%@",ListBeforeImage,result[@"FileUrl"]];
//            }else if (ImgType == ImgTypeAfter) {
//                ListAfterImage  = [NSString stringWithFormat:@"%@#%@",ListAfterImage,result[@"FileUrl"]];
//            }
            [SPSVProgressHUD dismiss];
            [SPSVProgressHUD showSuccessWithStatus:@"上传成功"];
            
        }else{

        }
        uplodNum ++;
//        if (ImgType == ImgTypeBefore) {
//            if (uplodNum == BeforeImgArr.count) {
//                [self UploadNetWork:AfterImgArr ImageType:ImgTypeAfter];
//            }
//
//        }else if (ImgType == ImgTypeAfter){
//            if (uplodNum == AfterImgArr.count) {
//                [self SubmitNetWork];
//            }
//        }
    } fail:^(NSString *errorMsg) {
        if (ImgType == ImgTypeBefore) {
            [self UploadNetWork:AfterImgArr ImageType:ImgTypeAfter];
        }else if (ImgType == ImgTypeAfter){
            [self SubmitNetWork];
        }
    }];
}

-(void)SubmitNetWork
{
    [SPSVProgressHUD showWithStatus:@"提交中..."];
    
    UITextView *textView = [_MyTableView viewWithTag:200];
    
    NSLog(@"image befor is %@=== %@++++++%@----%@",ListBeforeImage,ListAfterImage,textView.text,projectID);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setJsonValue:projectID key:@"Project"];
    [params setJsonValue:textView.text key:@"JobContent"];
    [params setJsonValue:ListBeforeImage key:@"ListAfter"];
    [params setJsonValue:ListAfterImage key:@"ListBefore"];

    [[NetworkManager sharedNetworkManager] requestConstructionLog:params success:^(id result){
        NSLog(@"货物列表 is %@",result);
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

- (IBAction)SubmitClick:(id)sender {
    //提交事件
    ListAfterImage = @"";
    ListBeforeImage = @"";
   // [self UploadNetWork:BeforeImgArr ImageType:ImgTypeBefore];
    [self composeImage];
}
-(void)composeImage
{
    //图片合成
    UIImage *beforeComposeImg;
    UIImage *afterComposeImg;
    
    if (BeforeImgArr.count >= 1) {
        UIImage *beforeImgs = [self mergedImageWithImageArray:BeforeImgArr];
        beforeComposeImg = [self imageAddText:beforeImgs text:@"施工前" fontHeight:60];
        composeImg = beforeComposeImg;
    }
    if (AfterImgArr.count >=1) {
        UIImage *afterImgs = [self mergedImageWithImageArray:AfterImgArr];
        afterComposeImg = [self imageAddText:afterImgs text:@"施工后" fontHeight:60];
    }
    
    UIImage *imgs;
    if (beforeComposeImg &&afterComposeImg) {
        imgs = [self mergedImageWithImageArray:[NSArray arrayWithObjects:beforeComposeImg,afterComposeImg, nil]];
          composeImg = [self imageAddText:imgs text:self.journalHeaderView.timeLabel.text fontHeight:60];
        [self imgAddUpload];
    }else if (beforeComposeImg &&!afterComposeImg){
          composeImg = [self imageAddText:beforeComposeImg text:self.journalHeaderView.timeLabel.text fontHeight:60];
        [self imgAddUpload];
    }else if (!beforeComposeImg &&afterComposeImg){
          composeImg = [self imageAddText:afterComposeImg text:self.journalHeaderView.timeLabel.text fontHeight:60];
        [self imgAddUpload];
    }else{
        [SPSVProgressHUD showSuccessWithStatus:@"请选择图片"];
    }
    
    NSArray *Imagearr = [NSArray arrayWithObjects:composeImg, nil];
    [self UploadNetWork:Imagearr ImageType:ImgTypeBefore];

}

-(void)imgAddUpload
{
    UIFont *contentfont =[UIFont systemFontOfSize:26];
    constructionStr = [NSString stringWithFormat:@"施工描述:%@",constructionStr];
    CGFloat textHeight = [self getSpaceLabelHeight:constructionStr withFont:contentfont withWidth:screen_width];
    //MyLog(@"当前的数据 %@ == %f",constructionStr,textHeight);
    
    composeImg = [self imageAddText:composeImg text:constructionStr fontHeight:textHeight+20];
    
    kkImgView.image = composeImg;

}
/**
 图片合成文字
 */
- (UIImage *)imageAddText:(UIImage *)img text:(NSString *)logoText fontHeight:(CGFloat)fontheight
{
    NSString* mark = logoText;
    int w = img.size.width;
    int h = img.size.height;

    
    UIGraphicsBeginImageContext(CGSizeMake(img.size.width, img.size.height+fontheight));

    
    if (fontheight != 60) {
        
        [img drawInRect:CGRectMake(0, 0, w, h)];

    }else{
        
        [img drawInRect:CGRectMake(0, fontheight, w, h)];
    }
   // NSLog(@"文字拼接的高度 %f",img.size.height);
    
    NSDictionary *attr = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:26], NSForegroundColorAttributeName : [UIColor redColor]};
    if (fontheight != 60) {
        [mark drawInRect:CGRectMake(10, 15+h, w-20, fontheight) withAttributes:attr];
    }else{
        [mark drawInRect:CGRectMake(10, 5, w-20,fontheight) withAttributes:attr];
    }
    
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return aimg;
}

- (UIImage *)mergedImageWithImageArray:(NSArray *)imgArray {
    CGFloat image_width = (CGRectGetWidth(self.view.bounds));
    CGFloat bgImgHeight = 0;
    for (int i =0 ; i<imgArray.count; i++) {
        UIImage *currentImg = imgArray[i];
        bgImgHeight = bgImgHeight+currentImg.size.height*screen_width/currentImg.size.width;
    }
    UIGraphicsBeginImageContext(CGSizeMake(image_width, bgImgHeight));
    CGFloat y = 0;
    for (int i = 0; i < imgArray.count; i++)
    {
        id data = imgArray[i];
        UIImage *currentImg = imgArray[i];
        CGFloat image_height = currentImg.size.height*screen_width/currentImg.size.width;
        MyLog(@"当前图片的高度 is %f===%f====%f",currentImg.size.height,image_height,y);
        //横着画
        //        CGFloat x = edgeInsets.left + lie * (image_width + imageLie);
        //        CGFloat y = edgeInsets.top + lang * (image_width + imageHang);
        
        //竖着画
        if ([data isKindOfClass:[UIImage class]])
        {
            UIImage *image = imgArray[i];
            [image drawInRect:CGRectMake(0, y, image_width, image_height)];
            y = y+image_height+10;
        }
        else if ([data isKindOfClass:[NSString class]])
        {
            
            NSString *text = imgArray[i];
            CGFloat textSize = image_width/2;
            UIFont *font = [UIFont systemFontOfSize:textSize];
            NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.alignment = NSTextAlignmentCenter;//居中显示
            paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
            NSDictionary* attribute = @{
                                        NSForegroundColorAttributeName:[UIColor blackColor],//设置文字颜色
                                        NSFontAttributeName:font,//设置文字的字体
                                        NSParagraphStyleAttributeName:paragraphStyle,//设置文字的样式
                                        };
            CGFloat textY = y + (image_width-textSize)/2;
    
            //
            [text drawInRect:CGRectMake(10, textY, image_width, image_width) withAttributes:attribute];
        }
    }
    
    
    //获取上下文并将图片保存相册
    UIImage *newMergeImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newMergeImg;
    //    if (newMergeImg == nil) {
    //        return NO;
    //    }
    //    else {
    //        UIImageWriteToSavedPhotosAlbum(newMergeImg, self, nil, nil);
    //        return YES;
    //    }
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.dataArr.count;
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 2){
        JournalViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JournalViewCell"];
        
        if (!cell) {
            cell = [[JournalViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JournalViewCell"];
        }
        
        cell.SearchBlock=^(NSInteger section, NSArray*imageArray){
            if (section == 0) {
                [BeforeImgArr removeAllObjects];
                for (int i =0 ; i<imageArray.count; i++) {
                    [BeforeImgArr addObject:imageArray[i]];
                }
            }else{
                [AfterImgArr removeAllObjects];
                for (int i =0 ; i<imageArray.count; i++) {
                    [AfterImgArr addObject:imageArray[i]];
                }
            }
        };
        
        cell.textViewBlock=^(NSString *textStr){
            constructionStr = textStr;
        };
        
        [cell cellSection:indexPath.section];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;

    }else{
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        kkImgView = [[UIImageView alloc]init];
        kkImgView.frame = CGRectMake(0, 100, screen_width, screen_height*3);
        kkImgView.backgroundColor = [UIColor lightGrayColor];
        kkImgView.image = composeImg;
        kkImgView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:kkImgView];
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return  cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        return screen_width+46;
        }else if (indexPath.section == 1){
        return  screen_width+300;
    }else{
        return  screen_height*3.5;
    }
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = [[UILabel alloc]init];
    if (section == 0) {
        headerLabel.text = @"   施工前";
    }else{
        headerLabel.text = @"   施工后";
    }
    headerLabel.font = [UIFont systemFontOfSize:15];
    headerLabel.backgroundColor = [UIColor whiteColor];

    return headerLabel;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .1f;
}

-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    CGSize size = [str boundingRectWithSize:CGSizeMake(width-20, screen_height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;

}

@end

