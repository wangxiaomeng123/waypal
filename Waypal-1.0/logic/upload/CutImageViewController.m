//
//  NewCutViewController.m
//  CharlieDemo
//
//  Created by Charlie.W on 2017/12/22.
//  Copyright © 2017年 com.charlieW. All rights reserved.
//

#import "CutImageViewController.h"
#import "CCutRangeView.h"
#import "Config.h"


typedef void(^handler)(UIImage *image);

@interface CutImageViewController ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    CGFloat _captureWith;//裁切范围
    
    CGFloat _browser_width;//屏幕宽
    CGFloat _browser_height;//屏幕高
    
    CGFloat _horSpace;//水平扩展范围
    CGFloat _verSpace;//竖直扩展范围
    
    CGFloat _fitScale;//自适应缩放率
}

@property (nonatomic, strong) UIScrollView *scaleView;

@property (nonatomic, strong) UIImageView *pics;

@property (nonatomic, strong) UIImage *sourceImg;//原图片


@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, copy) handler block;

//剪切框
@property (nonatomic, strong) CCutRangeView *rangeView;


@end

@implementation CutImageViewController
#pragma mark - 初始化数据
- (void)initData {
    
    //剪切范围
    _captureWith =lSCREEN_WIDTH-0.2;
    
    //屏幕宽
    _browser_width = self.view.frame.size.width;
    //屏幕高
    _browser_height = self.view.frame.size.height;
    //水平扩展范围
    _horSpace = (_browser_width - _captureWith);
    //竖直扩展范围
    _verSpace = (_browser_height - _captureWith);
    
    [self changeFrameWithImage:self.sourceImg];
    //宽的图片
    if (_pics.frame.size.width >_pics.frame.size.height) {
        _fitScale = _captureWith/_pics.frame.size.height;
        
    }else {
        //长的图片
        _fitScale = _captureWith/_pics.frame.size.width;
        
    }

    //设置最小缩放率
    _scaleView.minimumZoomScale = _fitScale;
    [_scaleView setZoomScale:_fitScale];
    
}

-(void)changeFrameWithImage:(UIImage *)image
{
    CGFloat height = image.size.height / image.size.width * _browser_width;
//  设置pic frame
    self.pics.frame = CGRectMake(0, 0, _browser_width,height);
    self.pics.image = image;
    [self changeContent];
    
    CGFloat width = _scaleView.contentSize.width;
    CGFloat heights = _scaleView.contentSize.height;
    CGPoint offset = CGPointMake((width - _browser_width), (heights - _captureWith));
    _scaleView.contentOffset = offset;
    
}
- (void)changeContent {
    
    CGSize size = CGSizeMake(_pics.frame.size.width +_horSpace/2-1, _pics.frame.size.height + _verSpace/2 -1);
    self.scaleView.contentSize = size;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden =YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"图片剪切";
    self.view.backgroundColor = [UIColor blackColor];
    [self initData];
    CGFloat  width;
    CGFloat height;
    if (lSCREEN_HEIGHT>lSCREEN_WIDTH) {
        width=lSCREEN_WIDTH;
        height=lSCREEN_HEIGHT;
    }
    else{
      
        width =lSCREEN_HEIGHT;
        height=lSCREEN_WIDTH;
    }
    
    UIView * view  = [[UIView alloc]initWithFrame:CGRectMake(0, height - 64, _browser_width , 64)];
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
    
    UIButton *sureBtn =[[UIButton alloc]initWithFrame:CGRectMake( width- 50 -20, 0, 50, 50)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sureBtn];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 50, 50)];
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [view addSubview:cancelBtn];
    
    CCutRangeView *range = [[CCutRangeView alloc]init];
    range.frame = CGRectMake(0, 0, _captureWith, _captureWith);
    range.center = self.scaleView.center;
    range.backgroundColor = [UIColor clearColor];
    self.rangeView = range;
    [self.view addSubview:range];
    [self.view bringSubviewToFront:range];
    
    
}

-(void)setNeedsDisplay
{
    [_scaleView setZoomScale:1.0 animated:YES];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _pics;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    [self changeContent];

    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? (scrollView.contentSize.width)/2 : (xcenter);
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? (scrollView.contentSize.height)/2 : (ycenter);
    [_pics setCenter:CGPointMake(xcenter, ycenter)];
    

    
}
- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender
{
    
    if (sender.numberOfTapsRequired == 2){
        if (_scaleView.zoomScale > _fitScale) {
            [_scaleView setZoomScale:_fitScale animated:YES];
        } else {
            CGFloat maxScale = _scaleView.maximumZoomScale;
            [_scaleView setZoomScale:maxScale animated:YES];
        }
    }
    
}

#pragma mark - 确定和取消
- (void)cancel {
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)sure {
    
    if (_block) {
        self.rangeView.hidden = YES;
        CGRect rect = CGRectMake(self.rangeView.frame.origin.x, self.rangeView.frame.origin.y, self.rangeView.frame.size.width, self.rangeView.frame.size.height);
        UIImage *image = [self screenImageWithRect:rect];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
        UIImage *resultImg = [UIImage imageWithData:imageData];
        _block(resultImg);
    }
    [self cancel];
    
}

#pragma mark - 懒加载
- (UIScrollView *)scaleView {
    
    if (!_scaleView) {
        _scaleView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64, _browser_width, _browser_height-64-64)];
        _scaleView.delegate = self;
        _scaleView.maximumZoomScale = 4.0;
        _scaleView.minimumZoomScale = 1;
        _scaleView.bouncesZoom = YES;
        _scaleView.multipleTouchEnabled = YES;
        _scaleView.showsHorizontalScrollIndicator = NO;
        _scaleView.showsVerticalScrollIndicator = NO;
        _scaleView.center = self.view.center;
        [self.view addSubview:_scaleView];
    }
    return _scaleView;
    
}
- (UIImageView *)pics {
    
    if (!_pics) {
        _pics = [[UIImageView alloc]init];
        _pics.contentMode = UIViewContentModeScaleAspectFit;
        _pics.userInteractionEnabled = YES;
        [self.scaleView addSubview:_pics];
        
        UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
        singleFingerOne.delegate = self;
        singleFingerOne.numberOfTapsRequired = 1;
        [_pics addGestureRecognizer:singleFingerOne];
        
        UITapGestureRecognizer *singleFingerTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
        singleFingerTwo.delegate = self;
        singleFingerTwo.numberOfTapsRequired = 2;
        [_pics addGestureRecognizer:singleFingerTwo];
    }
    return _pics;
}

#pragma mark - 截取图片
-(UIImage *)screenImageWithRect:(CGRect)imgRect{
    //获得 截取框相对于imageView的坐标大小
    CGRect imageViewRect = [_pics convertRect:imgRect fromView:self.view];
    //获得结果不准确 需要进行缩放调整
   imageViewRect.origin = CGPointMake(imageViewRect.origin.x * _scaleView.zoomScale, imageViewRect.origin.y * _scaleView.zoomScale);
    imageViewRect.size = CGSizeMake(_captureWith, _captureWith);
    
    //获得imageView对于原图的缩放率
    CGFloat scale = self.sourceImg.size.width/_pics.frame.size.width;
    
    //获得截取框相对原图上的坐标大小
    CGRect newRect = CGRectMake(imageViewRect.origin.x *scale, imageViewRect.origin.y*scale, imageViewRect.size.width*scale, imageViewRect.size.height*scale);
    
    //创建CGImageRef并从一个上边坐标大小中截取源UIImage的一部分
    CGImageRef cgimg = CGImageCreateWithImageInRect(self.sourceImg.CGImage,newRect);
    
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    //注意释放CGImageRef，因为创建方法包含Create
    CGImageRelease(cgimg);
    
    return newImage;
    
}
- (UIImage *)normalizedImage:(UIImage *)normal{
    if (normal.imageOrientation == UIImageOrientationUp){
        return normal;
    }
    UIGraphicsBeginImageContextWithOptions(normal.size, NO, normal.scale);
    [normal drawInRect:(CGRect){0, 0, normal.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}
#pragma mark - 返回图片
- (void)cutImageWithImage:(UIImage *)image
                  Handler:(void(^)(UIImage *image))handler{
    UIImage * iamge = [self normalizedImage:image];
    self.sourceImg = iamge;
    self.block = handler;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

