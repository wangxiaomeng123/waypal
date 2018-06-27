//
//  SubmitChooseOption.h
//  Waypal-1.0
//
//  Created by waypal on 2018/6/25.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^readAgainBlock)(void);
@interface SubmitChooseOption : UIView
@property(nonatomic,strong)NSDictionary * dataDict;
@property (weak, nonatomic) IBOutlet UILabel *totalQuestionLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightratioLabel;
@property(nonatomic,strong) readAgainBlock readAgainDoingBlock;
-(void)setDataWithDict:(NSDictionary *)dataDict;

@end
