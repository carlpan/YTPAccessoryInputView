//
//  YTPViewController.m
//  YTPAccessoryInputView
//
//  Created by carlpan on 01/03/2017.
//  Copyright (c) 2017 carlpan. All rights reserved.
//

#import "YTPViewController.h"
@import YTPAccessoryInputView;


@interface YTPViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *commentInputToolBar;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UIButton *inputToolBarButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *data;

@end

@implementation YTPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // tableview
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.data = @[@"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test1", @"test5"];
    
    // connect button
    [self.inputToolBarButton addTarget:self action:@selector(inputToolBarTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setUpAccessoryInputView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpAccessoryInputView {
    // Create accessory view
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 200.0f)];
    [view setBackgroundColor:[UIColor blueColor]];
    self.accessoryInputView = view;
    
    // set input tool bar
    self.inputToolBar = self.commentInputToolBar;
    self.inputToolBarBottomSpace = self.bottomConstraint;
    
    [self ytp_configureAccessoryInputView];
}


#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = [self.data objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - ScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self ytp_dismissKeyboardOrAccessoryInputView];
}

#pragma mark - IBAction

- (void)inputToolBarTapped:(id)sender {
    [self ytp_toggleAccessoryInputViewWithButton:self.inputToolBarButton];
}

@end
