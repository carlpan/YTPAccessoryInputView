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
static char kYTPAccessoryInputContainerViewKey;
static char kYTPAccessoryInputViewTriggerButtonKey;
static char kYTPInternalTableViewKey;

@interface UIViewController (_YTPAccessoryInputView)

@property (strong, nonatomic, setter=ytp_setCustomButton:) UIButton *ytp_customButton;

@property (strong, nonatomic, setter=ytp_setInputTextField:) UITextField *ytp_inputTextField;

@property (strong, nonatomic, setter=ytp_setInternalTableView:) UITableView *ytp_internalTableView;

@end

@implementation UIViewController (YTPAccessoryInputView)


#pragma mark - Objc Runtime - Public - Accessory Input View

- (UIView *)accessoryInputView {
    return (UIView *)objc_getAssociatedObject(self, &kYTPAccessoryInputViewKey);
}

- (void)setAccessoryInputView:(UIView *)accessoryInputView {
    objc_setAssociatedObject(self, &kYTPAccessoryInputViewKey, accessoryInputView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Objc Runtime - Public - Input Tool Bar

- (UIView *)inputToolBar {
    return (UIView *)objc_getAssociatedObject(self, &kYTPInputToolBarKey);
}

- (void)setInputToolBar:(UIView *)inputToolBar {
    objc_setAssociatedObject(self, &kYTPInputToolBarKey, inputToolBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Objc Runtime - Public - Input Tool Bar Bottom Space

- (NSLayoutConstraint *)inputToolBarBottomSpace {
    return (NSLayoutConstraint *)objc_getAssociatedObject(self, &kYTPInputToolBarBottomSpaceKey);
}

- (void)setInputToolBarBottomSpace:(NSLayoutConstraint *)inputToolBarBottomSpace {
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


#pragma mark - Setup

- (void)ytp_configureAccessoryInputView {
    // Set bottom constraint
    if (!self.inputToolBarBottomSpace) {
        [self associateConstraint];
    }
    
    // Get textfield
    [self setInternalTextField];
    
    // Get TableView
    [self setInternalTableView];
    
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
                
                self.inputToolBarBottomSpace.constant = self.accessoryInputView.frame.size.height;
                
                // bring view up
                self.accessoryInputView.transform = CGAffineTransformMakeTranslation(0.0, -self.accessoryInputView.frame.size.height);
            }];
        } else {
            // bring keyboard up
            [UIView animateWithDuration:0.1 animations:^{
                self.inputToolBarBottomSpace.constant = 0.0f;
                
                // bring view down
                self.accessoryInputView.transform = CGAffineTransformMakeTranslation(0.0, self.accessoryInputView.frame.size.height);
                
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
            self.inputToolBarBottomSpace.constant = self.accessoryInputView.frame.size.height;
    
            // bring container view up
            self.accessoryInputView.transform = CGAffineTransformMakeTranslation(0.0, -self.accessoryInputView.frame.size.height);
        } completion:^(BOOL finished) {
            // scroll tableview
            [self scrollTableViewToBottom:NO];
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
            self.inputToolBarBottomSpace.constant = 0.0f;
            
            // bring container view down
            self.accessoryInputView.transform = CGAffineTransformMakeTranslation(0.0, self.accessoryInputView.frame.size.height);
        } completion:^(BOOL finished) {
            self.ytp_customButton.selected = NO;
        }];
    }
}


#pragma mark - Private Helpers - Setting Internal Setters

- (void)setInternalAccessoryInputView {
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
    CGFloat inputViewHeight = self.accessoryInputView.frame.size.height;
    
    [self.accessoryInputView setFrame:CGRectMake(0, viewHeight, viewWidth, inputViewHeight)];
    [self.view addSubview:self.accessoryInputView];
}

- (void)setInternalTextField {
    for (UIView *subView in self.inputToolBar.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            self.ytp_inputTextField = (UITextField *)subView;
            break;
        }
    }
}

- (void)setInternalTableView {
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UITableView class]]) {
            self.ytp_internalTableView = (UITableView *)subView;
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
            self.accessoryInputView.transform = CGAffineTransformMakeTranslation(0.0, self.accessoryInputView.frame.size.height);
            self.inputToolBarBottomSpace.constant = kbHeight;
        } completion:^(BOOL finished) {
            [self scrollTableViewToBottom:NO];
            self.ytp_customButton.selected = NO;
        }];
    } else {
        [UIView animateWithDuration:rate.floatValue animations:^{
            self.inputToolBarBottomSpace.constant = kbHeight;
        } completion:^(BOOL finished) {
            [self scrollTableViewToBottom:NO];
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    // Get keyboard animation rate
    NSNumber *rate = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    // move
    [UIView animateWithDuration:rate.floatValue animations:^{
        self.inputToolBarBottomSpace.constant = 0;
    }];
}


#pragma mark - Private Helpers - Bottom Constraint

- (void)associateConstraint {
    for (NSLayoutConstraint *constraint in self.view.constraints) {
        if ([self isBottomConstraint:constraint]) {
            NSLog(@"Found constriant: %f", constraint.constant);
            self.inputToolBarBottomSpace = constraint;
            break;
        }
    }
}

- (BOOL)firstItemMatchesBottomConstraint:(NSLayoutConstraint *)constraint {
    return constraint.firstItem == self.inputToolBar && constraint.firstAttribute == NSLayoutAttributeBottom;
}

- (BOOL)secondItemMatchesBottomConstraint:(NSLayoutConstraint *)constraint {
    return constraint.secondItem == self.inputToolBar && constraint.secondAttribute == NSLayoutAttributeBottom;
}

- (BOOL)isBottomConstraint:(NSLayoutConstraint *)constraint {
    return [self firstItemMatchesBottomConstraint:constraint] || [self secondItemMatchesBottomConstraint:constraint];
}


#pragma mark - Private Helper - TableView

- (void)scrollTableViewToBottom:(BOOL)animated {
    NSInteger sections = self.ytp_internalTableView.numberOfSections;
    NSInteger rowsInLastSection = [self.ytp_internalTableView numberOfRowsInSection:sections-1];
    
    [self.ytp_internalTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rowsInLastSection-1 inSection:sections-1] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}


@end
