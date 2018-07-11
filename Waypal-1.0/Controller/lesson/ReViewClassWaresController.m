//
//  ReViewClassWaresController.m
//  Waypal-1.0
//
//  Created by waypal on 2018/7/11.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "ReViewClassWaresController.h"
#import "LessonViewModel.h"
@interface ReViewClassWaresController ()
@property (nonatomic,strong)NSMutableArray * imagesArrary;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ReViewClassWaresController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imagesArrary =[NSMutableArray array];
    LessonViewModel * model=[[LessonViewModel alloc] init];
    [model classwaresWithLessonID:@"" sessionID:@""];
    [model setBlockWithReturnBlock:^(id returnValue) {
        [self scrollViewWithImages:returnValue];
        
    } WithErrorBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];
    // Do any additional setup after loading the view.
}
-(void)scrollViewWithImages:(NSMutableArray *)imagesArr{
    self.scrollView.contentSize=CGSizeMake(self.scrollView.size.height*imagesArr.count, self.scrollView.size.width);
    self.scrollView.pagingEnabled=YES;
    for (int i=0; i<imagesArr.count; i++) {
       NSString *imagePath= imagesArr[i][@"path"];
        UIImageView *imgV=[[UIImageView alloc] initWithFrame:CGRectMake(self.scrollView.size.width*i, 0, self.scrollView.size.width, self.scrollView.size.height)];
        [imgV sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@""]];
        [self.scrollView addSubview:imgV];
    }
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
