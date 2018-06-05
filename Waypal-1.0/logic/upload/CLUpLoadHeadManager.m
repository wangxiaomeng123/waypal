
//
//  CLUpLoadHeadManager.m
//  xiaojingyu
//
//  Created by Charlie.W on 2017/10/21.
//  Copyright © 2017年 kekejl. All rights reserved.
//

#import "CLUpLoadHeadManager.h"
//#import "General.h"
//#import "NetworkManager.h"
//#import "UserInfo.h"
//#import "NewCutViewController.h"


@interface CLUpLoadHeadManager()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UIImagePickerController * imgPicker;

@end

@implementation CLUpLoadHeadManager

static CLUpLoadHeadManager * cManager = nil;

+(CLUpLoadHeadManager *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cManager = [[CLUpLoadHeadManager alloc]init];
        
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
        [[self appRootViewController] presentViewController:imgPicker animated:YES completion:nil];
    }
    else if (method == 2)
    {
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [[self appRootViewController] presentViewController:imgPicker animated:YES completion:nil];
    }
    self.successBlock = ^(UIImage *obj,NSString * imagePath) {
        if (successBlock) {
            successBlock(obj,imagePath);
        }
    };
    
    
}
//相册的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    UIImage * selecteImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    __weak typeof(self)weakSelf = self;
//    NewCutViewController * newCut = [[NewCutViewController alloc]init];
//    [newCut cutImageWithImage:selecteImg Handler:^(UIImage *image) {
//        [weakSelf getBackCutPhotos:image];
//    }];
//    [picker pushViewController:newCut animated:YES];
    
}

-(void)getBackCutPhotos:(UIImage *)photoImage{
  
//    self.successBlock(photoImage, nil);
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    //    oss/kk/user/用户id/photo/时间戳.jpg
    //    门店评论图片   oss/kk/user/用户id/comment/时间戳.jpg
//    NSString * path = [NSString stringWithFormat:@"%@/user/%@_%f.png",[APPSettingInfo sharedInstance].ossFilePrefixPathString,[UserState sharedInstance].userIDString,interval];
//
//    //  把image变成Data
//    CGSize size = photoImage.size;
//    if (photoImage.size.height > 2000)
//    {
//        double temp = 2000/photoImage.size.height;
//        size = CGSizeMake(photoImage.size.width * temp, 2000);
//    }
//    UIImage * newImg = [self scaleToSize:photoImage size:size];
//    NSData * imgData = UIImageJPEGRepresentation(newImg,0.6);
//
//    __weak typeof(self)weakSelf = self;
//    [[NetworkManager sharedInstance]upLoadFileToAliyunOSSWithFile:imgData fileName:path showProgressHUDToWindow:YES success:^{
//        if (weakSelf.successBlock) {
//            weakSelf.successBlock(photoImage,path);
//        }
//    } failure:^{
//    }];
    
//    [[self appRootViewController] dismissViewControllerAnimated:YES completion:nil];
    
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
@end

