
//
//  CLUpLoadHeadManager.m
//  xiaojingyu
//
//  Created by Charlie.W on 2017/10/21.
//  Copyright © 2017年 kekejl. All rights reserved.
//

#import "UpLoadHeadManager.h"
#import "CutImageViewController.h"
#import "Config.h"



@interface UpLoadHeadManager()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UIImagePickerController * imgPicker;

@end

@implementation UpLoadHeadManager

static UpLoadHeadManager * cManager = nil;

+(UpLoadHeadManager *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cManager = [[UpLoadHeadManager alloc]init];
        
    });
    return cManager;
}



- (void)clUploadHeadImageWithMethed:(NSUInteger)method withBlock:(void (^)(UIImage *, NSString *))successBlock{
    UIImagePickerController * imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    if (method == 1)
    {
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        else
        {
            imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    else if (method == 2)
    {
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  
    }
    [[self appRootViewController] presentViewController:imgPicker animated:YES completion:nil];
    WeakSelf(self);
    self.successBlock = ^(UIImage *obj,NSString * imagePath) {
        if (successBlock) {
            successBlock(obj,[weakself fileName]);
        }
    };
    
    
}
#pragma mark 相机的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
//    相机或者相册中获取的图片
    UIImage * selecteImg = [info objectForKey:UIImagePickerControllerOriginalImage];
//    __weak typeof(self)weakSelf = self;
    [self getBackCutPhotos:selecteImg];

 //    进行剪切
//    CutImageViewController * newCut = [[CutImageViewController alloc]init];
//    [newCut cutImageWithImage:selecteImg Handler:^(UIImage *image) {
//        [weakSelf getBackCutPhotos:image];
//    }];
//
    
//    [picker pushViewController:newCut animated:YES];
    
    
}

-(void)getBackCutPhotos:(UIImage *)photoImage{
  
    self.successBlock(photoImage, nil);
    NSString *path ;
    //  把image变成Data
    CGSize size = photoImage.size;
    if (photoImage.size.height > 2000)
    {
        double temp = 2000/photoImage.size.height;
        size = CGSizeMake(photoImage.size.width * temp, 2000);
    }
    UIImage * newImg = [self scaleToSize:photoImage size:size];
    NSData * imgData = UIImageJPEGRepresentation(newImg,0.6);
        if (self.successBlock) {
            self.successBlock(photoImage,path);
        }
    NSString *imagePath=[self fileName];
    [NetworkingTool  uploadWithfileData:imgData name:@"" fileName:imagePath mimeType:@"image/png" progress:^(NSProgress *progress) {
          DDLog(@"进度条:%@",progress);
    } success:^(NSString *fileName) {
                NSDictionary *param=@{@"imagePath":fileName};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadSuccess" object:nil userInfo:param];
    } failed:^(NSString *errorCode) {
        DDLog(@"上传失败头像:%@",errorCode);

    }];
    
    [[self appRootViewController] dismissViewControllerAnimated:YES completion:nil];
    
    
}


-(NSString * )fileName{
    // 设置上传图片的名字
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMM/dd";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString * timeStamp=[MInspectClass  timeStampWithTime:[NSDate date]];
    NSString * randomStr=[MInspectClass createUuid];
    NSString *imageName=[NSString stringWithFormat:@"%@%@.png",timeStamp,randomStr];
    NSString *fileName = [NSString stringWithFormat:@"images/%@/%@", str,imageName];
    return fileName;
}



#pragma mark 剪裁照片
-(UIImage *)scaleToSize:(UIImage *)image size:(CGSize)size
{
    //创建一个bitmap的context
    //并把他设置成当前的context
    UIGraphicsBeginImageContext(size);
    //绘制图片的大小
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    //从当前context中创建一个改变大小后的图片
    UIImage *endImage=UIGraphicsGetImageFromCurrentImageContext();
    //让当前的context出堆栈
    UIGraphicsEndImageContext();
    return endImage;
    
}
- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end

