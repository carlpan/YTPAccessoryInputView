//
//  UIViewController+YTPAccessoryInputView.h
//  Pods
//
//  Created by Carl Pan on 1/3/17.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (YTPAccessoryInputView)

/**
 *  This property is required. It is the main view for the accessory input view.
 */
@property (strong, nonatomic) UIView *accessoryInputView;

/**
 *  This property holds the reference to the input tool bar used for chat/comment etc.
 */
@property (strong, nonatomic) UIView *inputToolBar;

/**
 *  Specifies the bottom layout constraint of the custom input tool bar. It is needed for
 *  move input tool bar up and down to leave space for keyboard and accessory input view.
 *
 *  @discussion Setting this property is optional, but will remove the need to
 *  manually looping tool bar's constraints to find the bottom layout constraint.
 */
@property (strong, nonatomic) NSLayoutConstraint *inputToolBarBottomSpace;

- (void)ytp_configureAccessoryInputView;

- (void)ytp_toggleAccessoryInputViewWithButton:(UIButton *)button;

- (void)ytp_dismissKeyboardOrAccessoryInputView;

@end

NS_ASSUME_NONNULL_END
