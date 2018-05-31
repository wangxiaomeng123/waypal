//
//  PersonViewController.h
//  iPad_wayPal
//
//  Created by waypal on 2018/5/17.
//  Copyright © 2018年 waypal. All rights reserved.
//
typedef void(^loginOutComebackAction)(void);
#import <UIKit/UIKit.h>
typedef void(^editNickName)(NSString *nickName);

@interface PersonViewController : UIViewController
@property (nonatomic,strong)editNickName editNickNameBlock;
@property(nonatomic,strong) loginOutComebackAction comebackAction;
@end
