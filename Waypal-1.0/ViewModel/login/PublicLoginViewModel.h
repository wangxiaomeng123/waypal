//
//  PublicLoginViewModel.h
//  PC_Waypal
//
//  Created by waypal on 2018/5/16.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "ViewModelClass.h"

@interface PublicLoginViewModel : ViewModelClass
-(void)loginWithUserName:(NSString *)userName password:(NSString *)password;
@end
