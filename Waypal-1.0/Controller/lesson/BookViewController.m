

//
//  BookViewController.m
//  Waypal-1.0
//
//  Created by waypal on 2018/6/12.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "BookViewController.h"
#import "Config.h"
#import "LessonViewModel.h"
#import "BookCollectionViewCell.h"
#import "HorizontalPageFlowlayout.h"
#import "BookDetailViewController.h"
#define bookItemH
#define bookItemW   103

@interface BookViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *bookCollectionView;
@property (nonatomic,assign)NSInteger currentPage;
@property (nonatomic,assign)NSInteger  totalPages;
@property (nonatomic,assign)CGFloat itemSpacing;//之间的距离
@property (nonatomic,strong)NSMutableArray *itemArrary;
@property(nonatomic,assign) CGFloat lastContentOffset;
@property (weak, nonatomic) IBOutlet UIView *collectionBgView;
@property(nonatomic,strong) LessonViewModel *lessVModel;


@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage=0;
    self.lessVModel=[[LessonViewModel alloc] init];
//    self.itemArrary=[NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
    self.itemArrary=[NSMutableArray array];
    

    [self resquestBookData];
    
    [self configCollectionView];
}
#pragma mark 请求泛读数据
-(void)resquestBookData
{
//    [self resquestNavCourses];
    [self resquestGreatCourses];

}

-(void)resquestNavCourses{
    WeakSelf(self);
    [self.lessVModel getGreatcourses];
    [self.lessVModel setBlockWithReturnBlock:^(id returnValue) {
        [weakself.itemArrary addObjectsFromArray:returnValue];
        weakself. totalPages=ceil(self.itemArrary.count/8.0);
        [weakself.bookCollectionView reloadData];
    } WithErrorBlock:^(id errorCode) {
        [LoadingView tipViewWithTipString:errorCode];
    } WithFailureBlock:^{
        [LoadingView tipViewWithTipString:@"网络请求失败"];
    }];
}
-(void)resquestGreatCourses{
            WeakSelf(self);
    [self.lessVModel getGetCourseWithCourseID:@"11" page:[NSString stringWithFormat:@"%ld",(long)self.currentPage] ];
            [self.lessVModel setBlockWithReturnBlock:^(id returnValue) {
                [weakself.itemArrary addObjectsFromArray:returnValue];
                weakself. totalPages=ceil(self.itemArrary.count/8.0);
                [weakself.bookCollectionView reloadData];
            } WithErrorBlock:^(id errorCode) {
                [LoadingView tipViewWithTipString:errorCode];
            } WithFailureBlock:^{
                [LoadingView tipViewWithTipString:@"网络请求失败"];
            }];
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)configCollectionView{
    CGFloat spacing  =(self.bookCollectionView.frame.size.width - bookItemW*4)/5;
    HorizontalPageFlowlayout *layout = [[HorizontalPageFlowlayout alloc] initWithRowCount:2 itemCountPerRow:4];
    [layout setColumnSpacing:spacing rowSpacing:40 edgeInsets:UIEdgeInsetsMake(0, spacing, 10, spacing)];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = spacing;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.bookCollectionView setCollectionViewLayout:layout];
    self.bookCollectionView.delegate = self;
    self.bookCollectionView.dataSource = self;
    self.bookCollectionView.alwaysBounceHorizontal =YES;
    self.bookCollectionView.pagingEnabled=YES;
    [self.bookCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"BookCollectionViewCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemArrary.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *ID=@"BookCollectionViewCell";
        BookCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        cell.book_imageView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        [cell setCellDataDict:self.itemArrary[indexPath.row]];
         return cell;

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BookModel *bookModel= self.itemArrary[indexPath.row];
    BookDetailViewController * bookDetail =lStoryboard(@"Main", @"bookDetail");
    bookDetail.bookModel=bookModel;
    [self presentViewController:bookDetail animated:YES completion:nil];
    
}

- (IBAction)prevPageAction:(id)sender {
    [[animationTool shareInstance] shakeToShow:sender];
    if (self.currentPage==0) {
        return;
    }
    self.currentPage--;
       [self.bookCollectionView setContentOffset:CGPointMake((self.bookCollectionView.frame.size.width-66)*self.currentPage, 0) animated:YES];
}
- (IBAction)nextPageAction:(id)sender {
    [[animationTool shareInstance] shakeToShow:sender];
    if (self.currentPage==self.totalPages-1) {
        return;
    }
    self.currentPage++;
    [self.bookCollectionView setContentOffset:CGPointMake((self.bookCollectionView.frame.size.width-66)*self.currentPage, 0) animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
