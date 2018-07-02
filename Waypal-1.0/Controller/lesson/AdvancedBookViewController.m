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
#import "TipView.h"
#import "NavCourseView.h"
#define bookItemH
#define bookItemW   125
#define perPageCount 16

@interface AdvancedBookViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, nonatomic)  UICollectionView *bookCollectionView;
@property (nonatomic,assign)NSInteger currentPage;
@property (nonatomic,assign)NSInteger  totalPages;
@property (nonatomic,assign)CGFloat itemSpacing;//之间的距离
@property (weak, nonatomic) IBOutlet UIScrollView *collection_BgView;
@property (nonatomic,strong)NSMutableArray * advanceStageArrary;
@property(nonatomic,assign) CGFloat lastContentOffset;
@property (weak, nonatomic) IBOutlet UIView *collectionBgView;
@property(nonatomic,assign) BOOL isLoadMore;//是否加载更多
@property (weak, nonatomic) IBOutlet UIImageView *bookShelfImageView;
@property (nonatomic,strong)NSMutableArray *anserQuestionArr;//回答问题的正确
@property(nonatomic,assign) CGFloat offset;
@property (weak, nonatomic) IBOutlet UIView *navCourseOptionBgView;
@property(nonatomic,strong) NSString *currentSelectNavCourseID;
@end
@implementation AdvancedBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage=0;
    self.advanceStageArrary=[NSMutableArray array];
    [self initNavCourseView];
    [self initCollectionView];

}

-(void)initNavCourseView
{
    WeakSelf(self);
    CGSize  size=self.navCourseOptionBgView.size;
    NavCourseView *navV=[[NavCourseView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) titileArr:self.navCourseArr];
    navV.chooseNavCourseDoingBlock = ^(NSString *nav_courseID, NSString *shelf_ImageName) {
        weakself.currentSelectNavCourseID=nav_courseID;
        [weakself ReloadCollectionViewDataWithNavCourseID:nav_courseID shelfImageName:shelf_ImageName];
    };
    [self.navCourseOptionBgView addSubview:navV];
}


-(void)ReloadCollectionViewDataWithNavCourseID:(NSString *)NavCourseID shelfImageName:(NSString *)shelfImageName{
    self.currentPage=0;
    self.bookShelfImageView.image=[UIImage imageNamed:shelfImageName];
    [self.bookCollectionView removeFromSuperview];
    [self.advanceStageArrary removeAllObjects];
    [self resquestGreatCoursesWithNavCourseID:NavCourseID];
    [self initCollectionView];
    [self.bookCollectionView reloadData];
}

#pragma mark 请求泛读数据
-(void)resquestGreatCoursesWithNavCourseID:(NSString *)NavCourseID{

    WeakSelf(self);
    BooksViewModel *booksVM=[[BooksViewModel alloc] init];
    [booksVM getGetCourseWithCourseID:[NSString stringWithFormat:@"%@", NavCourseID] page:[NSString stringWithFormat:@"%ld",(long)self.currentPage] ];
 
    [booksVM setBlockWithReturnBlock:^(id returnValue) {
        NSArray * perLoadDataArr =(NSArray *)returnValue;
        if (perLoadDataArr.count <perPageCount) {
            weakself.isLoadMore =NO;
        }else{
            weakself.isLoadMore =YES;
        }
        DDLog(@"%ld",weakself.advanceStageArrary.count);
        [weakself.advanceStageArrary addObjectsFromArray:returnValue];
        weakself. totalPages=ceil(self.advanceStageArrary.count/8.0);
        DDLog(@"perLoadDataArr:%ld-%ld-%ld",perLoadDataArr.count,weakself.advanceStageArrary.count,(long)self.currentPage);
        [weakself.bookCollectionView reloadData];
    } WithErrorBlock:^(id errorCode) {
        [LoadingView tipViewWithTipString:errorCode];
    } WithFailureBlock:^{
        [LoadingView tipViewWithTipString:@"网络请求失败"];
    }];
    [self.bookCollectionView reloadData];
    
    
}

- (IBAction)backAction:(id)sender {
    CATransition *animation = [CATransition animation];
    animation.duration = 0.4;
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"pageCurl";
    animation.type = kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void )initCollectionView{
        CGFloat spacing  =(self.collection_BgView.frame.size.width - bookItemW*4)/5;
        self.offset=spacing;
        HorizontalPageFlowlayout *layout = [[HorizontalPageFlowlayout alloc] initWithRowCount:2 itemCountPerRow:4];
        [layout setColumnSpacing:spacing rowSpacing:40 edgeInsets:UIEdgeInsetsMake(0, spacing, 10, spacing)];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = spacing;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
      self.bookCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.collection_BgView.frame.size.width, self.collection_BgView.frame.size.height) collectionViewLayout:layout];
        self.bookCollectionView.delegate = self;
        self.bookCollectionView.dataSource = self;
        self.bookCollectionView.alwaysBounceHorizontal =YES;
        self.bookCollectionView.scrollEnabled=NO;
        self.bookCollectionView.pagingEnabled=YES;
       self.bookCollectionView.backgroundColor=[UIColor clearColor];
        [self.bookCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"BookCollectionViewCell"];
        [self.collection_BgView addSubview:self.bookCollectionView];
       [self.bookCollectionView reloadData];
        [self addGesture];
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
-(void)enterBookDetailVCWithBookModel:(BookModel *)bookModel
{
    BookDetailViewController * bookDetail =lStoryboard(@"Main", @"bookDetail");
    bookDetail.bookModel=bookModel;
    [self presentViewController:bookDetail animated:YES completion:nil];
}

-(void)addGesture {
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
        if (   self.currentSelectNavCourseID.length!=0) {
           [self resquestGreatCoursesWithNavCourseID: self.currentSelectNavCourseID];
        }
  
    }else
    {
//        [LoadingView tipViewWithTipString:@"没有更多了哦"];
    }
    [self.bookCollectionView reloadData];
    
    [[animationTool shareInstance] shakeToShow:sender];
    if (self.currentPage==self.totalPages-1) {
        [LoadingView tipViewWithTipString:@"没有更多了哦"];
        return;
    }
    self.currentPage++;
    [self.bookCollectionView setContentOffset:CGPointMake((self.bookCollectionView.frame.size.width-self.offset)*self.currentPage, 0) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
