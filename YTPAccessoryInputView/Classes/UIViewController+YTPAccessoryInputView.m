//
//  UIViewController+YTPAccessoryInputView.m
//  Pods
//
//  Created by Carl Pan on 1/3/17.
//
//

#import "UIViewController+YTPAccessoryInputView.h"
#import <objc/runtime.h>

// Public
static char kYTPAccessoryInputViewKey;
static char kYTPInputToolBarKey;
static char kYTPInputToolBarBottomSpaceKey;

// Private
static char kYTPInputToolBarTextFieldKey;
static char kYTPAccessoryInputViewTriggerButtonKey;
static char kYTPInternalTableViewKey;
static char kYTPInternalCollectionViewKey;

@interface UIViewController (_YTPAccessoryInputView)

@property (strong, nonatomic, setter=ytp_setCustomButton:) UIButton *ytp_customButton;

@property (strong, nonatomic, setter=ytp_setInputTextField:) UITextField *ytp_inputTextField;

@property (strong, nonatomic, setter=ytp_setInternalTableView:) UITableView *ytp_internalTableView;

@property (strong, nonatomic, setter=ytp_setInternalCollectionView:) UICollectionView *ytp_internalCollectionView;

@end

@implementation UIViewController (YTPAccessoryInputView)


#pragma mark - Objc Runtime - Public - Accessory Input View

- (UIView *)ytp_accessoryInputView {
    return (UIView *)objc_getAssociatedObject(self, &kYTPAccessoryInputViewKey);
}

- (void)ytp_setAccessoryInputView:(UIView *)accessoryInputView {
    objc_setAssociatedObject(self, &kYTPAccessoryInputViewKey, accessoryInputView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Objc Runtime - Public - Input Tool Bar

- (UIView *)ytp_inputToolBar {
    return (UIView *)objc_getAssociatedObject(self, &kYTPInputToolBarKey);
}

- (void)ytp_setInputToolBar:(UIView *)inputToolBar {
    objc_setAssociatedObject(self, &kYTPInputToolBarKey, inputToolBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Objc Runtime - Public - Input Tool Bar Bottom Space

- (NSLayoutConstraint *)ytp_inputToolBarBottomSpace {
    return (NSLayoutConstraint *)objc_getAssociatedObject(self, &kYTPInputToolBarBottomSpaceKey);
}

- (void)ytp_setInputToolBarBottomSpace:(NSLayoutConstraint *)inputToolBarBottomSpace {
    objc_setAssociatedObject(self, &kYTPInputToolBarBottomSpaceKey, inputToolBarBottomSpace, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Objc Runtime - Private

- (UITextField *)ytp_inputTextField {
    return (UITextField *)objc_getAssociatedObject(self, &kYTPInputToolBarTextFieldKey);
}

- (void)ytp_setInputTextField:(UITextField *)inputTextField {
    objc_setAssociatedObject(self, &kYTPInputToolBarTextFieldKey, inputTextField, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIButton *)ytp_customButton {
    return (UIButton *)objc_getAssociatedObject(self, &kYTPAccessoryInputViewTriggerButtonKey);
}

- (void)ytp_setCustomButton:(UIButton *)customButton {
    objc_setAssociatedObject(self, &kYTPAccessoryInputViewTriggerButtonKey, customButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UITableView *)ytp_internalTableView {
    return (UITableView *)objc_getAssociatedObject(self, &kYTPInternalTableViewKey);
}

- (void)ytp_setInternalTableView:(UITableView *)internalTableView {
    objc_setAssociatedObject(self, &kYTPInternalTableViewKey, internalTableView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UICollectionView *)ytp_internalCollectionView {
    return (UICollectionView *)objc_getAssociatedObject(self, &kYTPInternalCollectionViewKey);
}

- (void)ytp_setInternalCollectionView:(UICollectionView *)internalCollectionView {
    objc_setAssociatedObject(self, &kYTPInternalCollectionViewKey, internalCollectionView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Public API

- (void)ytp_configureAccessoryInputView {
    // Set bottom constraint
    if (!self.ytp_inputToolBarBottomSpace) {
        [self associateConstraint];
    }
    
    // Get textfield
    [self setInternalTextField];
    
    // Get TableView/CollectionView
    [self setInternalScrollView];
    
    // Container view
    [self setInternalAccessoryInputView];

    // Register keyboard
    [self registerKeyboardNotifications];
}

- (void)ytp_toggleAccessoryInputViewWithButton:(UIButton *)button {
    // Set button
    self.ytp_customButton = button;
    
    if (self.ytp_customButton.selected) {
        // accessory view already up and about to be dismissed
        
        if (self.ytp_inputTextField.isFirstResponder) {
            // keyboard is up
            
            [UIView animateWithDuration:0.3 animations:^{
                [self.ytp_inputTextField resignFirstResponder];
                
                self.ytp_inputToolBarBottomSpace.constant = self.ytp_accessoryInputView.frame.size.height;
                
                // bring view up
                self.ytp_accessoryInputView.transform = CGAffineTransformMakeTranslation(0.0, -self.ytp_accessoryInputView.frame.size.height);
            }];
        } else {
            // bring keyboard up
            [UIView animateWithDuration:0.1 animations:^{
                self.ytp_inputToolBarBottomSpace.constant = 0.0f;
                
                // bring view down
                self.ytp_accessoryInputView.transform = CGAffineTransformMakeTranslation(0.0, self.ytp_accessoryInputView.frame.size.height);
                
                [self.ytp_inputTextField becomeFirstResponder];
            }];
        }
        
    } else {
        // accessory view not show yet
        NSTimeInterval rate = self.ytp_inputTextField.isFirstResponder ? 0.5 : 0.1;
        
        [UIView animateWithDuration:rate animations:^{
            if (self.ytp_inputTextField.isFirstResponder) {
                [self.ytp_inputTextField resignFirstResponder];
            }
            
            // update bottom constraint
            self.ytp_inputToolBarBottomSpace.constant = self.ytp_accessoryInputView.frame.size.height;
    
            // bring container view up
            self.ytp_accessoryInputView.transform = CGAffineTransformMakeTranslation(0.0, -self.ytp_accessoryInputView.frame.size.height);
        } completion:^(BOOL finished) {
            // scroll
            [self scrollScrollViewToBottom:NO];
        }];
    }
    
    // toggle button selection state
    self.ytp_customButton.selected = !self.ytp_customButton.selected;
}

- (void)ytp_dismissKeyboardOrAccessoryInputView {
    if (self.ytp_inputTextField.isFirstResponder) {
        // dismiss keyboard
        [self.ytp_inputTextField resignFirstResponder];
        self.ytp_customButton.selected = NO;
    } else {
        // dissmiss container view
        [UIView animateWithDuration:0.1 animations:^{
            self.ytp_inputToolBarBottomSpace.constant = 0.0f;
            
            // bring container view down
            self.ytp_accessoryInputView.transform = CGAffineTransformMakeTranslation(0.0, self.ytp_accessoryInputView.frame.size.height);
        } completion:^(BOOL finished) {
            self.ytp_customButton.selected = NO;
        }];
    }
}

- (void)ytp_resetViewControllerStatus {
    // remove associated objects
    objc_setAssociatedObject(self, &kYTPAccessoryInputViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &kYTPInputToolBarKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &kYTPInputToolBarBottomSpaceKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &kYTPInputToolBarTextFieldKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &kYTPAccessoryInputViewTriggerButtonKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &kYTPInternalTableViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &kYTPInternalCollectionViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // remove keyboard observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - Private Helpers - Setting Internal Setters

- (void)setInternalAccessoryInputView {
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
    CGFloat inputViewHeight = self.ytp_accessoryInputView.frame.size.height;
    
    [self.ytp_accessoryInputView setFrame:CGRectMake(0, viewHeight, viewWidth, inputViewHeight)];
    [self.view addSubview:self.ytp_accessoryInputView];
}

- (void)setInternalTextField {
    for (UIView *subView in self.ytp_inputToolBar.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            self.ytp_inputTextField = (UITextField *)subView;
            break;
        }
    }
}

- (void)setInternalScrollView {
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UITableView class]]) {
            self.ytp_internalTableView = (UITableView *)subView;
            break;
        }
        
        if ([subView isKindOfClass:[UICollectionView class]]) {
            self.ytp_internalCollectionView = (UICollectionView *)subView;
            break;
        }
    }
}


#pragma mark - Private Helpers - Keyboard Observers

- (void)registerKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    // Get keyboard parameters
    NSDictionary *info = [notification userInfo];
    CGFloat kbHeight = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    NSNumber *rate = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    // Check if button selected
    if (self.ytp_customButton.selected) {
        [UIView animateWithDuration:0.1 animations:^{
            self.ytp_accessoryInputView.transform = CGAffineTransformMakeTranslation(0.0, self.ytp_accessoryInputView.frame.size.height);
            self.ytp_inputToolBarBottomSpace.constant = kbHeight;
        } completion:^(BOOL finished) {
            [self scrollScrollViewToBottom:NO];
            self.ytp_customButton.selected = NO;
        }];
    } else {
        [UIView animateWithDuration:rate.floatValue animations:^{
            self.ytp_inputToolBarBottomSpace.constant = kbHeight;
        } completion:^(BOOL finished) {
            [self scrollScrollViewToBottom:NO];
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    // Get keyboard animation rate
    NSNumber *rate = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    // move
    [UIView animateWithDuration:rate.floatValue animations:^{
        self.ytp_inputToolBarBottomSpace.constant = 0;
    }];
}


#pragma mark - Private Helpers - Bottom Constraint

- (void)associateConstraint {
    for (NSLayoutConstraint *constraint in self.view.constraints) {
        if ([self isBottomConstraint:constraint]) {
            //NSLog(@"Found constriant: %f", constraint.constant);
            self.ytp_inputToolBarBottomSpace = constraint;
            break;
        }
    }
}

- (BOOL)firstItemMatchesBottomConstraint:(NSLayoutConstraint *)constraint {
    return constraint.firstItem == self.ytp_inputToolBar && constraint.firstAttribute == NSLayoutAttributeBottom;
}

- (BOOL)secondItemMatchesBottomConstraint:(NSLayoutConstraint *)constraint {
    return constraint.secondItem == self.ytp_inputToolBar && constraint.secondAttribute == NSLayoutAttributeBottom;
}

- (BOOL)isBottomConstraint:(NSLayoutConstraint *)constraint {
    return [self firstItemMatchesBottomConstraint:constraint] || [self secondItemMatchesBottomConstraint:constraint];
}


#pragma mark - Private Helper - ScrollView

- (void)scrollTableViewToBottom:(BOOL)animated {
    NSInteger sections = self.ytp_internalTableView.numberOfSections;
    
    if (sections == 0) {
        return;
    }
    
    NSInteger rowsInLastSection = [self.ytp_internalTableView numberOfRowsInSection:sections-1];
    [self.ytp_internalTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rowsInLastSection-1 inSection:sections-1] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

- (void)scrollCollectionViewToBottom:(BOOL)animated {
    NSInteger sections = self.ytp_internalCollectionView.numberOfSections;
    
    if (sections == 0) {
        return;
    }
    
    NSInteger itemsInLastSection = [self.ytp_internalCollectionView numberOfItemsInSection:sections-1];
    [self.ytp_internalCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:itemsInLastSection-1 inSection:sections-1] atScrollPosition:UICollectionViewScrollPositionBottom animated:animated];
}

- (void)scrollScrollViewToBottom:(BOOL)animated {
    if (self.ytp_internalTableView) {
        [self scrollTableViewToBottom:NO];
    } else {
        [self scrollCollectionViewToBottom:NO];
    }
}


@end
