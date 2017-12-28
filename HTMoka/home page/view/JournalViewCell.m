//
//  JournalViewCell.m
//  HTMoka
//
//  Created by SZHuaTo on 2017/11/28.
//  Copyright © 2017年 深圳华图测控. All rights reserved.
//

#import "JournalViewCell.h"
#import "HXPhotoModel.h"


@interface JournalViewCell()<HXPhotoViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate>
{
    UITextView *textview;
    NSMutableArray *imageArr;//图片数组
    NSData *imageData;//图片数据流
    NSInteger indexSection;
}
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;
@property (strong, nonatomic) HXPhotoModel *imageModel;

@end

@implementation JournalViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        imageArr = [NSMutableArray array];
        
        _imageModel = [[HXPhotoModel alloc]init];
        
        //self.userInteractionEnabled = NO;
        UIView *photoBack = [[UIView alloc]initWithFrame:CGRectMake(20, 15, screen_width-40, screen_width+20)];
        photoBack.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        photoBack.layer.cornerRadius = 9;
        [self addSubview:photoBack];
        
//        HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
//        photoView.frame = CGRectMake(25, 30, screen_width - 50, 0);
//        photoView.delegate = self;
//        photoView.backgroundColor = [UIColor clearColor];
//        [self addSubview:photoView];
//        self.photoView = photoView;
        
        HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
        photoView.frame = CGRectMake(27, 30, screen_width - 53, 0);
        photoView.delegate = self;
        photoView.outerCamera = YES;
        photoView.backgroundColor = [UIColor clearColor];
        [self addSubview:photoView];
        self.photoView = photoView;

    }
    return self;
}

-(void)cellSection:(CGFloat)section
{
    //获取当前的cell的section
    if (section == 1) {
        textview = [[UITextView alloc] initWithFrame:CGRectMake(20, screen_width+60, screen_width-40, 150)];
        textview.backgroundColor= [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];//背景色
        textview.scrollEnabled = YES;    //当文字超过视图的边框时是否允许滑动，默认为“YES"
        textview.editable = YES;        //是否允许编辑内容，默认为“YES”
        textview.delegate = self;       //设置代理方法的实现类
        textview.tag = 200;
        textview.font=[UIFont fontWithName:@"Arial" size:15.0]; //设置字体名字和字体大小;
        //textview.returnKeyType = UIReturnKeyDefault;//return键的类型
        //textview.keyboardType = UIKeyboardTypeDefault;//键盘类型
        textview.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
        textview.dataDetectorTypes = UIDataDetectorTypeAll; //显示数据类型的连接模式（如电话号码、网址、地址等）
        textview.textColor = [UIColor grayColor];
    
        if (self.textStr) {
            textview.text = self.textStr;
        }else{
            textview.text = @"✎ 施工描述";
        }
        textview.layer.cornerRadius = 8;
        textview.layer.masksToBounds = YES;
        [self addSubview:textview];
    }
    indexSection = section;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (HXDatePhotoToolManager *)toolManager {
    if (!_toolManager) {
        _toolManager = [[HXDatePhotoToolManager alloc] init];
    }
    return _toolManager;
}

#pragma  mark - 图片回调处理
- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    NSSLog(@"所有:%ld - 照片:%ld - 视频:%ld",allList.count,photos.count,videos.count);
    NSSLog(@"所有:%@ - 照片:%@ - 视频:%@",allList,photos,videos);
    [imageArr removeAllObjects];
    for (int i = 0; i<photos.count; i++) {
        _imageModel = photos[i];
        NSData *imageData = UIImageJPEGRepresentation(_imageModel.thumbPhoto, 0.5);
        UIImage *imgs = [UIImage imageWithData: imageData];
         [imageArr addObject:imgs];
        
        if (i == photos.count -1) {
            //当时最后一张的时候
            if(self.SearchBlock){
                self.SearchBlock(indexSection, imageArr);
            }
        }
    }
    [HXPhotoTools selectListWriteToTempPath:allList requestList:^(  NSArray *imageRequestIds, NSArray *videoSessions) {
        NSSLog(@"requestIds - image : %@ \nsessions - video : %@",imageRequestIds,videoSessions);

    } completion:^(NSArray<NSURL *> *allUrl, NSArray<NSURL *> *imageUrls, NSArray<NSURL *> *videoUrls) {
        NSSLog(@"allUrl - %@\nimageUrls - %@\nvideoUrls - %@",allUrl,imageUrls,videoUrls);
    } error:^{
        NSSLog(@"失败");
    }];
}

    - (HXPhotoManager *)manager {
        if (!_manager) {
            _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
            _manager.configuration.openCamera = YES;
            _manager.configuration.lookLivePhoto = YES;
            _manager.configuration.photoMaxNum = 9;
            _manager.configuration.videoMaxNum = 0;
            _manager.configuration.maxNum = 9;
            _manager.configuration.videoMaxDuration = 500.f;
            _manager.configuration.saveSystemAblum = NO;
            //        _manager.configuration.reverseDate = YES;
            //
            _manager.configuration.showDateSectionHeader = NO;
            _manager.configuration.selectTogether = NO;
            //        _manager.configuration.rowCount = 3;
            //        _manager.configuration.themeColor = [UIColor orangeColor];
            //        _manager.configuration.navigationTitleSynchColor = YES;
            _manager.configuration.navigationBar = ^(UINavigationBar *navigationBar) {
                //            navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor orangeColor]};
            };
            
            //        _manager.configuration.movableCropBox = YES;
            //        _manager.configuration.movableCropBoxEditSize = YES;
            //        _manager.configuration.movableCropBoxCustomRatio = CGPointMake(1, 1);
            
            __weak typeof(self) weakSelf = self;
            //        _manager.configuration.useCustomCamera = YES;
            _manager.configuration.shouldUseCamera = ^(UIViewController *viewController, HXPhotoConfigurationCameraType cameraType, HXPhotoManager *manager) {
                
                // 这里拿使用系统相机做例子
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = (id)weakSelf;
                imagePickerController.allowsEditing = NO;
                NSString *requiredMediaTypeImage = ( NSString *)kUTTypeImage;
                NSString *requiredMediaTypeMovie = ( NSString *)kUTTypeMovie;
                NSArray *arrMediaTypes;
                if (cameraType == HXPhotoConfigurationCameraTypePhoto) {
                    arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeImage,nil];
                }else if (cameraType == HXPhotoConfigurationCameraTypeVideo) {
                    arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeMovie,nil];
                }else {
                    arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeImage, requiredMediaTypeMovie,nil];
                }
                [imagePickerController setMediaTypes:arrMediaTypes];
                // 设置录制视频的质量
                [imagePickerController setVideoQuality:UIImagePickerControllerQualityTypeHigh];
                //设置最长摄像时间
                [imagePickerController setVideoMaximumDuration:60.f];
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
                imagePickerController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                [viewController presentViewController:imagePickerController animated:YES completion:nil];
            };
        }
        return _manager;
    }

- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    NSSLog(@"%@",networkPhotoUrl);
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    NSSLog(@"%@",NSStringFromCGRect(frame));
   // self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin);

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    HXPhotoModel *model;
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        model = [HXPhotoModel photoModelWithImage:image];
        if (self.manager.configuration.saveSystemAblum) {
            [HXPhotoTools savePhotoToCustomAlbumWithName:self.manager.configuration.customAlbumName photo:model.thumbPhoto];
        }
        //
    }else  if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *url = info[UIImagePickerControllerMediaURL];
        NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                         forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
        float second = 0;
        second = urlAsset.duration.value/urlAsset.duration.timescale;
        model = [HXPhotoModel photoModelWithVideoURL:url videoTime:second];
        if (self.manager.configuration.saveSystemAblum) {
            [HXPhotoTools saveVideoToCustomAlbumWithName:self.manager.configuration.customAlbumName videoURL:url];
        }
    }
    
    if (self.manager.configuration.useCameraComplete) {
        self.manager.configuration.useCameraComplete(model);
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma textViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    NSString *str = textView.text;
    
    if ([str isEqualToString:@"✎ 施工描述"]) {
        textView.text = @"";
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSString *str = textView.text;
    //
    if (str.length == 0) {
        textView.text = @"✎ 施工描述";
    }
    if(self.textViewBlock){
        _textStr = textView.text;
        self.textViewBlock(self.textStr);
    }
    
}

- (void)textViewDidChange:(UITextView *)textView{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
