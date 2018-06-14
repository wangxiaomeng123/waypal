//
//  BookCollectionViewCell.h
//  Waypal-1.0
//
//  Created by waypal on 2018/6/12.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"
@interface BookCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *book_imageView;
@property (weak, nonatomic) IBOutlet UILabel *book_nameLabel;
@property (weak, nonatomic) IBOutlet UIView *lock_bgView;
@property (weak, nonatomic) IBOutlet UIView *book_bgView;

-(void)setCellDataDict:(BookModel *)bookModel;
@end
