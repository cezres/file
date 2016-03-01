//
//  ESTextFieldAlertView.m
//  buyer
//
//  Created by 翟泉 on 16/2/18.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "ESTextFieldAlertView.h"
#import "AppDelegate.h"


@interface ESTextFieldAlertView ()

@property (strong, nonatomic) UITextField   *textField;
@property (strong, nonatomic) UILabel       *titleLabel;
@property (strong, nonatomic) UIButton      *cancelButton;
@property (strong, nonatomic) UIButton      *confirmButton;
@property (strong, nonatomic) UIView        *backgroundView;

@end

@implementation ESTextFieldAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (instancetype)init; {
    
    if (self = [super init]) {
        self.frame = CGRectMake(SSize.width*0.15, (SSize.height-100)/2, SSize.width*0.7, 150);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8;
        self.backgroundColor = [UIColor whiteColor];
        
        
        self.layer.shadowColor = ColorRGB(230, 230, 230).CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 3;
        
        
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        [self addSubview:effectView];
        
        [self addSubview:self.textField];
        [self addSubview:self.titleLabel];
        [self addSubview:self.cancelButton];
        [self addSubview:self.confirmButton];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, self.cancelButton.y, self.width, 1)];
        line1.backgroundColor = ColorRGB(230, 230, 230);
        [self addSubview:line1];
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(self.width/2, self.cancelButton.y, 1, self.cancelButton.height)];
        line2.backgroundColor = ColorRGB(230, 230, 230);
        [self addSubview:line2];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        // 30  10 10 50 50
        
        
    }
    return self;
}

- (void)dealloc; {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    NSLog(@"%s", __FUNCTION__);
}



- (void)keyBoardWillShow:(NSNotification *)note; {
    CGRect keyBoardBounds = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGFloat offset = SSize.height - keyBoardBounds.size.height - self.height - self.y - 20;
    
    if (offset < 0) {
        if (duration > 0) {
            NSInteger i = [[note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
            UIViewAnimationOptions options = i << 16;
            [UIView animateWithDuration:duration delay:0 options:options animations:^{
                self.transform = CGAffineTransformTranslate(self.transform, 0, offset);
            } completion:nil];
        }
        else {
            self.transform = CGAffineTransformTranslate(self.transform, 0, offset);
        }
    }
}
- (void)keyBoardWillHide:(NSNotification *)note; {
    CGFloat duration = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (duration > 0) {
        NSInteger i = [[note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
        UIViewAnimationOptions options = i << 16;
        [UIView animateWithDuration:duration delay:0 options:options animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }
    else {
        self.transform = CGAffineTransformIdentity;
    }
}


#pragma mark - Animations

- (void)show; {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app.window.rootViewController.view addSubview:self.backgroundView];
    [app.window.rootViewController.view addSubview:self];
    
    self.backgroundView.alpha = 0;
    self.transform = CGAffineTransformMakeScale(0.6, 0.6);
    [UIView animateWithDuration:0.15 animations:^{
        self.transform = CGAffineTransformMakeScale(1.05, 1.05);
        self.backgroundView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            [self.textField becomeFirstResponder];
        }];
    }];
}

- (void)hide; {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.backgroundView.alpha = 0;
        self.transform = CGAffineTransformMakeScale(0.2, 0.2);
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)confirm; {
    if (self.confirmBlock && [self.textField.text length]) {
        self.confirmBlock(self.textField.text);
        [self hide];
    }
}

+ (ESTextFieldAlertView *)show; {
    ESTextFieldAlertView *view = [[ESTextFieldAlertView alloc] init];
    [view show];
    return view;
}
+ (void)showAlertWithTitle:(NSString *)title confirmBlock:(void (^)(NSString *text))confirmBlock; {
    ESTextFieldAlertView *view = [[ESTextFieldAlertView alloc] init];
    view.titleLabel.text = title;
    view.confirmBlock = confirmBlock;
    [view show];
}

#pragma mark - Lazy
- (UITextField *)textField; {
    if (_textField == nil) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(self.width*0.1, (self.height - 30)/2, self.width*0.8, 30)];
        _textField.layer.borderColor = ColorRGB(230, 230, 230).CGColor;
        _textField.layer.borderWidth = 1;
        _textField.keyboardType = UIKeyboardTypeAlphabet;
//        _textField.secureTextEntry = YES;
    }
    return _textField;
}
- (UILabel *)titleLabel; {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.width, 20)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"输入支付密码";
    }
    return _titleLabel;
}
- (UIButton *)cancelButton; {
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancelButton.frame = CGRectMake(0, self.height-50, self.width/2, 50);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
- (UIButton *)confirmButton; {
    if (_confirmButton == nil) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _confirmButton.frame = CGRectMake(self.width/2, self.height-50, self.width/2, 50);
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UIView *)backgroundView; {
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_backgroundView addGestureRecognizer:tap];
    }
    return _backgroundView;
}

@end
