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
 *  It must be provided in the beginning.
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

/**
 *  This method is used to setup necessary internal parameters.
 *  It must be called after providing custom accessory input view.
 */
- (void)ytp_configureAccessoryInputView;

/**
 *  This method should be placed in the IBAction method associated with the desired
 *  button inside input tool bar to trigger toggle between keyboard and provided accessory input view.
 *
 *  @param button  The button that was pressed by the user to toggle between keyboard and accessory input view.
 */
- (void)ytp_toggleAccessoryInputViewWithButton:(UIButton *)button;

/**
 *  This method should be called when you want to dismiss keyboard or your custom accessory input view.
 *  An example location is to put it inside scrollViewWillBeginDragging: method.
 */
- (void)ytp_dismissKeyboardOrAccessoryInputView;

@end

NS_ASSUME_NONNULL_END
