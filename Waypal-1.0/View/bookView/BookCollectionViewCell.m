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
    [self.book_imageView sd_setImageWithURL:[NSURL URLWithString:bookModel.cover_path] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageAllowInvalidSSLCertificates];
    self.book_imageView.layer.cornerRadius=4;
    self.book_imageView.layer.masksToBounds =YES;
    


}

@end
