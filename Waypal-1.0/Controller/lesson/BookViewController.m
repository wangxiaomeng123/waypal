

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
#import "AdvancedBookViewController.h"
#import "CourseModel.h"
#import "StageButton.h"
#import "BooksViewModel.h"
#import "TipView.h"
#define bookItemH
#define bookItemW   125
#define perPageCount 16

#define navCourseID @"11"

@interface BookViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *bookCollectionView;
@property (nonatomic,assign)NSInteger currentPage;
@property (nonatomic,assign)NSInteger  totalPages;
@property (nonatomic,assign)CGFloat itemSpacing;//之间的距离

@property (nonatomic,strong)NSMutableArray * advanceStageArrary;


@property(nonatomic,assign) CGFloat lastContentOffset;
@property (weak, nonatomic) IBOutlet UIView *collectionBgView;
@property(nonatomic,strong) LessonViewModel *lessVModel;
@property(nonatomic,assign) BOOL isLoadMore;//是否加载更多
@property (weak, nonatomic) IBOutlet UIImageView *bookShelfImageView;
@property (weak, nonatomic) IBOutlet UIButton *advanceStageButton;
@property (weak, nonatomic) IBOutlet UIButton *starStageButton;
@property (nonatomic,strong)UIButton *selectedBtn;
@property (nonatomic,strong)NSMutableArray *anserQuestionArr;//回答问题的正确
@property(nonatomic,assign) CGFloat offset;
@property(nonatomic,strong)NSString * selectNavCourseId;

@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self addSwipGesture];
    [self operationQueues];
    
}

-(void)operationQueues{
//    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
//    NSBlockOperation * op1 = [NSBlockOperation blockOperationWithBlock:^{
//        [self resquestNavCoursesList];
//    }];
//    NSBlockOperation * op2 = [NSBlockOperation blockOperationWithBlock:^{
        [self resquestGreatBookList];
//    }];
//    [op2 addDependency:op1];
//    [queue addOperation:op1];
//    [queue addOperation:op2];
    
    
    
}

-(void)initData{
    self.currentPage=0;
    self.lessVModel=[[LessonViewModel alloc] init];
    self.advanceStageArrary=[NSMutableArray array];
//    self.NavCourseArray =[NSMutableArray array];
    [self configCollectionView];
    [self.advanceStageButton sizeToFit];
    [self.starStageButton sizeToFit];
    [self hanlerNavCourseWithNavCourseArr:self.NavCourseArray];
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 是否加载更多的书籍
-(BOOL)isLoadMoreBookDataWithData:(NSArray *)loadArr{
    if (loadArr.count==perPageCount)
    {
        return YES;
    }else{
        return NO;
    }
    
}

#pragma mark 初始化collectionView
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
    self.bookCollectionView.scrollEnabled=YES;
    self.bookCollectionView.pagingEnabled=YES;
    [self.bookCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"BookCollectionViewCell"];
}



#pragma mark  collectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
     return self.advanceStageArrary.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
              static NSString *ID=@"BookCollectionViewCell";
             BookCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
          DDLog(@"%@",self.advanceStageArrary);
           BookModel *bookModel= self.advanceStageArrary[indexPath.row];
           [cell setCellDataDict:bookModel];
    
          return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
        BookModel *bookModel= self.advanceStageArrary[indexPath.row];
    
    if ([bookModel.is_readed boolValue]==NO) {
        TipView *alert = [[[NSBundle mainBundle] loadNibNamed:@"TipView" owner:self options:0] lastObject];
        alert.frame=CGRectMake(0, 0, 372, 270);
        alert.okDoingBlock = ^{
            bookModel.is_readed =@"1";
            if (self.advanceStageArrary.count!=0)
            {
                [self.advanceStageArrary replaceObjectAtIndex:indexPath.row withObject:bookModel];
            }
            [self enterBookDetailVCWithBookModel:bookModel];
            [self.bookCollectionView reloadData];
            
        };
        [alert  jk_showInWindowWithMode:JKCustomAnimationModeAlert inView:nil bgAlpha:0.2 needEffectView:YES];
    }else{
        [self enterBookDetailVCWithBookModel:bookModel];
        [self.bookCollectionView reloadData];

    }
    


}





#pragma mark ad
-(void)enterAdvanceViewControllerWithNavCourseID:(NSArray *)navCourseArr
{
  AdvancedBookViewController *advanceVC=  lStoryboard(@"Main", @"advanced");
    advanceVC.navCourseArr =self.NavCourseArray;
    advanceVC.dismissDoingBlock = ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    };
    [self presentViewController:advanceVC animated:NO completion:nil];
}

#pragma mark 进入书的详情
-(void)enterBookDetailVCWithBookModel:(BookModel *)bookModel{
    
    BookDetailViewController * bookDetail =lStoryboard(@"Main", @"bookDetail");
    bookDetail.bookModel=bookModel;
    [self presentViewController:bookDetail animated:YES completion:nil];
}

#pragma mark 添加滑动手势
-(void)addSwipGesture{
    UISwipeGestureRecognizer *left_swip=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwip:)];
    left_swip.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.bookCollectionView addGestureRecognizer:left_swip];
    UISwipeGestureRecognizer *right_swip=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwip:)];
    right_swip.direction=UISwipeGestureRecognizerDirectionRight;
    [self.bookCollectionView addGestureRecognizer:right_swip];
}
#pragma mark 左滑
-(void)leftSwip:(UISwipeGestureRecognizer *)swip{
    if (swip.state ==UIGestureRecognizerStateEnded) {
        [self nextPageAction:nil];
    }
}
#pragma mark 右滑
-(void)rightSwip:(UISwipeGestureRecognizer *)swip{
    if (swip.state ==UIGestureRecognizerStateEnded) {
        [self prevPageAction:nil];
    }
}

- (IBAction)enterAdvanceStageAction:(id)sender {
    [self.advanceStageArrary removeAllObjects];
      CGRect frame=self.bookCollectionView.frame;
    [self.bookCollectionView removeFromSuperview];
    self.bookCollectionView.frame=frame;
    [self.collectionBgView addSubview:self.bookCollectionView];
    [self resquestGreatBookList];
    
//    [self.bookCollectionView reloadData];
    return;
    [self enterAdvanceViewControllerWithNavCourseID: self.NavCourseArray];

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
        [self resquestGreatBookList];
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



//==========================网络请求==============================


//#pragma mark 请求泛读导航数据
//-(void)resquestNavCoursesList{
//    WeakSelf(self);
//    [self.lessVModel getGreatcourses];
//    [self.lessVModel setBlockWithReturnBlock:^(id returnValue) {
//        [weakself.NavCourseArray addObjectsFromArray:returnValue];
//        [weakself hanlerNavCourseWithNavCourseArr:weakself.NavCourseArray];
//
//    } WithErrorBlock:^(id errorCode) {
//        [LoadingView tipViewWithTipString:errorCode];
//    } WithFailureBlock:^{
//        [LoadingView tipViewWithTipString:@"网络请求失败"];
//    }];
//    [self.bookCollectionView reloadData];
//}
-(void)hanlerNavCourseWithNavCourseArr:(NSArray *)navCourseArr{
    if (navCourseArr.count==0) {
        return;
    }
    CourseModel *model=navCourseArr[0];
    [self.starStageButton setTitle:model.name_chinese forState:UIControlStateNormal];
    if (navCourseArr.count==1) {
        self.advanceStageButton.hidden= YES;
        return;
    }
    CourseModel *model1=navCourseArr[1];
    [self.advanceStageButton setTitle:model1.name_chinese forState:UIControlStateNormal];
}


#pragma mark  booklist
-(void)resquestGreatBookList{
    WeakSelf(self);
    BooksViewModel *booksVM=[[BooksViewModel alloc] init];
    if (self.NavCourseArray.count==0) {
        return;
    }
    NSString *NavCourseID =[self.NavCourseArray[0]NavCourseId];
     [booksVM getGetCourseWithCourseID:NavCourseID  page:[NSString stringWithFormat:@"%ld",(long)self.currentPage] ];
      [booksVM setBlockWithReturnBlock:^(id returnValue) {
        weakself.isLoadMore=[weakself isLoadMoreBookDataWithData:returnValue];
        [weakself.advanceStageArrary addObjectsFromArray:returnValue];
        weakself. totalPages=ceil(self.advanceStageArrary.count/8.0);
       [weakself.bookCollectionView  reloadData];

      } WithErrorBlock:^(id errorCode) {
        
        [LoadingView tipViewWithTipString:errorCode];
        
    } WithFailureBlock:^{
        
        [LoadingView tipViewWithTipString:@"网络请求失败"];
        
    }];
          [self.bookCollectionView  reloadData];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
