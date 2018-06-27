//
//  SubmitChooseOption.m
//  Waypal-1.0
//
//  Created by waypal on 2018/6/25.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "SubmitChooseOption.h"

@implementation SubmitChooseOption
-(void)setDataWithDict:(NSDictionary *)dataDict{
    if (dataDict) {
        self.dataDict=dataDict;
        self.totalQuestionLabel.text=[NSString stringWithFormat:@"总计测试题:%@",self.dataDict[@"total"]];
        self.rightcountLabel.text=[NSString stringWithFormat:@"正确测试题:%@",self.dataDict[@"rightcount"]];
        self.rightratioLabel.text=[NSString stringWithFormat:@"正确率:%@",self.dataDict[@"rightratio"]];
    }
 }
#pragma mark 再读一次
- (IBAction)readAgainAction:(id)sender {
    
    if (self.readAgainDoingBlock) {
        self.readAgainDoingBlock();
    }
}
- (void)layoutSubviews
{
  

    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
