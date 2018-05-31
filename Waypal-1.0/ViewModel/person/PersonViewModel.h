//
//  PersonViewModel.h
//  iPad_wayPal
//
//  Created by waypal on 2018/5/18.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "ViewModelClass.h"

@interface PersonViewModel : ViewModelClass
-(void)editUserInfoWithName:(NSString *)name nick:(NSString *)nick password:(NSString *)password;
@end
