//
//  BookCollectionViewCell.m
//  Waypal-1.0
//
//  Created by waypal on 2018/6/12.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "BookCollectionViewCell.h"
#import "Config.h"
@implementation BookCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCellDataDict:(BookModel *)bookModel{
    
    self.book_nameLabel.text =[NSString stringWithFormat:@"%@",bookModel.name];
    [self.book_nameLabel setAdjustsFontSizeToFitWidth:YES];
    self.lock_bgView.hidden =[bookModel.is_readed  boolValue ];
//     self.lock_bgView.hidden =YES;
    [self.book_imageView sd_setImageWithURL:[NSURL URLWithString:bookModel.cover_path] placeholderImage:[UIImage imageNamed:@"book_placeholder"] options:SDWebImageAllowInvalidSSLCertificates];
    
    self.book_imageView.layer.cornerRadius=5;
    self.book_imageView.layer.masksToBounds =YES;
    self.book_bgView.layer.cornerRadius=5;
    self.book_bgView.layer.masksToBounds =YES;
    self.lock_bgView.layer.cornerRadius =5;
    self.lock_bgView.layer.masksToBounds =YES;
}
-(void)drawRect:(CGRect)rect
{
    CALayer *top_layer=[CALayer layer];
    top_layer.frame= CGRectMake(3.0f, 0.0f,self.book_imageView.frame.size.width-3, 3.0);
    top_layer.backgroundColor =[[UIColor colorWithHexString:@"#9082F3"] CGColor];
    top_layer.shadowOffset =CGSizeMake(4, 4);
    CALayer *left_layer=[CALayer layer];
    left_layer.frame= CGRectMake(self.book_imageView.frame.size.width-5.0, 2.0f,5.0, self.book_imageView.frame.size.height);
    left_layer.backgroundColor =[[UIColor colorWithHexString:@"#9082F3"] CGColor];
    [self.book_bgView.layer addSublayer:top_layer];
    [self.book_bgView.layer addSublayer:left_layer];
    
    
    
    
}

@end
