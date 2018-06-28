//
//  AdvancedBookViewController.m
//  Waypal-1.0
//
//  Created by waypal on 2018/6/26.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "AdvancedBookViewController.h"
#import "Config.h"

#import "BookCollectionViewCell.h"
#import "HorizontalPageFlowlayout.h"
#import "BookDetailViewController.h"
#import "CourseModel.h"
#import "BooksViewModel.h"
#define bookItemH
#define bookItemW   125
#define perPageCount 16

#define navCourseID @"11"
@interface AdvancedBookViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
//@property (weak, nonatomic) IBOutlet UICollectionView *bookCollectionView;

@property (nonatomic,assign)NSInteger currentPage;
@property (nonatomic,assign)NSInteger  totalPages;
@property (nonatomic,assign)CGFloat itemSpacing;//之间的距离

@property (nonatomic,strong)NSMutableArray * advanceStageArrary;


@property(nonatomic,assign) CGFloat lastContentOffset;
@property (weak, nonatomic) IBOutlet UIView *collectionBgView;

@property(nonatomic,assign) BOOL isLoadMore;//是否加载更多
@property (weak, nonatomic) IBOutlet UIImageView *bookShelfImageView;


@property (weak, nonatomic) IBOutlet UIButton *advanceStageButton;
@property (weak, nonatomic) IBOutlet UIButton *starStageButton;
@property (nonatomic,strong)UIButton *selectedBtn;


@property (nonatomic,strong)NSMutableArray *anserQuestionArr;//回答问题的正确
@property(nonatomic,assign) CGFloat offset;

@end

@implementation AdvancedBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage=0;
    [self.advanceStageButton setTitle:[NSString stringWithFormat:@"%@",[self.navCourseArr[0]name_chinese]] forState:UIControlStateNormal];
     [self.starStageButton setTitle:[NSString stringWithFormat:@"%@",[self.navCourseArr[1]name_chinese]] forState:UIControlStateNormal];
    [self AdvanceStageChange:self.advanceStageButton];
    self.advanceStageArrary=[NSMutableArray array];
    [self resquestBookData];
    [self.advanceStageButton sizeToFit];
    [self.starStageButton sizeToFit];
    [self configCollectionView];
}

#pragma mark 请求泛读数据
-(void)resquestBookData
{
    [self resquestGreatCourses];
    
}

-(void)resquestGreatCourses{
    
    WeakSelf(self);
    BooksViewModel *booksVM=[[BooksViewModel alloc] init];
    [booksVM getGetCourseWithCourseID:[NSString stringWithFormat:@"%@",[self.navCourseArr[1]NavCourseId]] page:[NSString stringWithFormat:@"%ld",(long)self.currentPage] ];
    [booksVM setBlockWithReturnBlock:^(id returnValue) {
        NSArray * perLoadDataArr =(NSArray *)returnValue;
        if (perLoadDataArr.count <perPageCount) {
            weakself.isLoadMore =NO;
        }else{
            weakself.isLoadMore =YES;
        }
        [weakself.advanceStageArrary addObjectsFromArray:returnValue];
        weakself. totalPages=ceil(self.advanceStageArrary.count/8.0);
        [weakself.bookCollectionView reloadData];
    } WithErrorBlock:^(id errorCode) {
        [LoadingView tipViewWithTipString:errorCode];
    } WithFailureBlock:^{
        [LoadingView tipViewWithTipString:@"网络请求失败"];
    }];
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.dismissDoingBlock) {
            self.dismissDoingBlock();
        }
    }];
    
    
    
}

-(void)configCollectionView{
    CGFloat spacing  =(self.bookCollectionView.frame.size.width - bookItemW*4)/5;
    self.offset=spacing;
    HorizontalPageFlowlayout *layout = [[HorizontalPageFlowlayout alloc] initWithRowCount:2 itemCountPerRow:4];
    [layout setColumnSpacing:spacing rowSpacing:40 edgeInsets:UIEdgeInsetsMake(0, spacing, 10, spacing)];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = spacing;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.bookCollectionView setCollectionViewLayout:layout];
    self.bookCollectionView.delegate = self;
    self.bookCollectionView.dataSource = self;
    self.bookCollectionView.alwaysBounceHorizontal =YES;
    self.bookCollectionView.scrollEnabled=NO;
    self.bookCollectionView.pagingEnabled=YES;
    [self.bookCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"BookCollectionViewCell"];
    
    UISwipeGestureRecognizer *left_swip=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwip:)];
    left_swip.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.bookCollectionView addGestureRecognizer:left_swip];
    UISwipeGestureRecognizer *right_swip=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwip:)];
    right_swip.direction=UISwipeGestureRecognizerDirectionRight;
    [self.bookCollectionView addGestureRecognizer:right_swip];
}
-(void)leftSwip:(UISwipeGestureRecognizer *)swip{
    if (swip.state ==UIGestureRecognizerStateEnded) {
        [self nextPageAction:nil];
    }
}
-(void)rightSwip:(UISwipeGestureRecognizer *)swip{
    if (swip.state ==UIGestureRecognizerStateEnded) {
        [self prevPageAction:nil];
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.advanceStageArrary.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"BookCollectionViewCell";
    BookCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    [cell setCellDataDict:self.advanceStageArrary[indexPath.row]];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    BookModel *bookModel= self.advanceStageArrary[indexPath.row];
    bookModel.is_readed =@"1";
    if (self.advanceStageArrary.count!=0) {
        [self.advanceStageArrary replaceObjectAtIndex:indexPath.row withObject:bookModel];
    }
    [self enterBookDetailVCWithBookModel:bookModel];
    
    [self.bookCollectionView reloadData];
    
}
-(void)enterBookDetailVCWithBookModel:(BookModel *)bookModel
{
    BookDetailViewController * bookDetail =lStoryboard(@"Main", @"bookDetail");
    bookDetail.bookModel=bookModel;
    [self presentViewController:bookDetail animated:YES completion:nil];
}

#pragma mark 阶段切换
- (IBAction)AdvanceStageChange:(UIButton *)optionBtn {
//    if (optionBtn!= self.selectedBtn) {
//        self.selectedBtn.selected = NO;
//        optionBtn.selected = YES;
//        self.selectedBtn = optionBtn;
//    }else{
//        self.selectedBtn.selected = YES;
//    }
    if (self.selectedBtn==self.advanceStageButton){
//        [self changeAnimationStartStageTranstionX:112 advanceStageTranstionX:-112 shelfImageName:@"book_shelfPink"];
//        [self.view bringSubviewToFront:self.starStageButton];
   
    }
//    else if (self.selectedBtn==self.advanceStageButton){
////        [self changeAnimationStartStageTranstionX:0 advanceStageTranstionX:0 shelfImageName:@"book_shelfYellow"];
////        [self.view bringSubviewToFront:self.advanceStageButton];
////
//    }
    //    [self.bookCollectionView reloadData];
}

- (IBAction)dismissStarStageAction:(id)sender {
    CATransition *animation = [CATransition animation];
    animation.duration = 0.4;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"pageCurl";
    animation.type = kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}




-(void)changeAnimationStartStageTranstionX:(CGFloat)star_x  advanceStageTranstionX:(CGFloat)advanced_x  shelfImageName:(NSString *)imageName{

    [UIView animateWithDuration:0.3 animations:^{
        CGAffineTransform transform1= CGAffineTransformMakeTranslation(advanced_x, 0);
        self.starStageButton.transform=transform1;
        CGAffineTransform transform= CGAffineTransformMakeTranslation(star_x, 0);
        self.advanceStageButton.transform=transform;
        self.bookShelfImageView.image=[UIImage imageNamed:imageName];
    } completion:^(BOOL finished) {
       
    }];
    
}



#pragma mark 上一页
- (IBAction)prevPageAction:(id)sender {
    [[animationTool shareInstance] shakeToShow:sender];
    if (self.currentPage==0) {
        return;
    }
    self.currentPage--;
    [self.bookCollectionView setContentOffset:CGPointMake((self.bookCollectionView.frame.size.width-self.offset)*self.currentPage, 0) animated:YES];
}
#pragma mark 下一页
- (IBAction)nextPageAction:(id)sender {
    if (self.isLoadMore ==YES) {
        [self resquestGreatCourses];
    }else
    {
        [LoadingView tipViewWithTipString:@"没有更多了哦"];
    }
    [self.bookCollectionView reloadData];
    
    [[animationTool shareInstance] shakeToShow:sender];
    if (self.currentPage==self.totalPages-1) {
        return;
    }
    self.currentPage++;
    [self.bookCollectionView setContentOffset:CGPointMake((self.bookCollectionView.frame.size.width-self.offset)*self.currentPage, 0) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
