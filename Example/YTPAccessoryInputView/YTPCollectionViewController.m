//
//  YTPCollectionViewController.m
//  YTPAccessoryInputView
//
//  Created by Carl Pan on 1/9/17.
//  Copyright © 2017 carlpan. All rights reserved.
//

#import "YTPCollectionViewController.h"
#import "InputScrollView.h"
@import YTPAccessoryInputView;

@interface YTPCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *chatInputToolBar;
@property (weak, nonatomic) IBOutlet UITextField *chatTextField;
@property (weak, nonatomic) IBOutlet UIButton *chatToolBarButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatBottomConstraint;

@property (strong, nonatomic) NSArray *data;

@end

@implementation YTPCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.data = @[@"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test5"];
    
    // connect button
    [self.chatToolBarButton addTarget:self action:@selector(inputToolBarTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setUpAccessoryInputView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // clean up
    [self ytp_resetViewControllerStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Accessory Input View

- (void)setUpAccessoryInputView {
    // Test with scrollview
    InputScrollView *inputScrollView = [[[NSBundle mainBundle] loadNibNamed:@"InputScrollView" owner:self options:nil] firstObject];
    [self configureScrollView:inputScrollView];
    self.accessoryInputView = inputScrollView;
    
    // set input tool bar
    self.inputToolBar = self.chatInputToolBar;
    self.inputToolBarBottomSpace = self.chatBottomConstraint;

    [self ytp_configureAccessoryInputView];
}

- (void)configureScrollView:(InputScrollView *)inputView {
    CGFloat x = 16.0f, y = 15.0f, stickerX = 65.0f, stickerY = 65.0f, xDiff = 28.0f;
    
    __block CGFloat cx = x;
    for (int i = 0; i < 8; i++) {
        NSString *stickerName = [NSString stringWithFormat:@"sticker%d", i+1];
        UIImageView *stickerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:stickerName]];
        stickerImageView.contentMode = UIViewContentModeScaleAspectFill;
        stickerImageView.frame = CGRectMake(cx, y, stickerX, stickerY);
        stickerImageView.clipsToBounds = YES;
        
        // Add gesture to image
        stickerImageView.tag = i;
        stickerImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stickerTapped:)];
        [stickerImageView addGestureRecognizer:tap];
        
        // Add image to scrollview
        [inputView.stickerScrollView addSubview:stickerImageView];
        
        // update x
        cx += stickerX + xDiff;
    }
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    //CGFloat stickerScrollWidth = (stickerX + xDiff) * 8 + 20;
    inputView.stickerScrollView.contentSize = CGSizeMake(viewWidth*2, inputView.stickerScrollView.frame.size.height);
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YTPChatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.centerLabel.text = [self.data objectAtIndex:indexPath.item];
    return cell;
}

#pragma mark - <UICollectionViewFlowLayoutDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    int numCellsInRow = 2;
    CGFloat cellWidth = self.view.frame.size.width / numCellsInRow;
    return CGSizeMake(cellWidth-15, 220);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
}

#pragma mark - ScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self ytp_dismissKeyboardOrAccessoryInputView];
}


#pragma mark - IBAction

- (void)inputToolBarTapped:(id)sender {
    [self ytp_toggleAccessoryInputViewWithButton:self.chatToolBarButton];
}

- (void)stickerTapped:(UITapGestureRecognizer *)recognizer {
    NSLog(@"Tapped: %ld", recognizer.view.tag);
}


@end
