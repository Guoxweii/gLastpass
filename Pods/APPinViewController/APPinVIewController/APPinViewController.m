//The MIT License (MIT)
//
//Copyright (c) 2013 Alterplay
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of
//this software and associated documentation files (the "Software"), to deal in
//the Software without restriction, including without limitation the rights to
//use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//the Software, and to permit persons to whom the Software is furnished to do so,
//subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "APPinViewController.h"

@interface APPinViewController () {
    //Used in change pin case
    BOOL _firstTimePinVerified;
}
@property (nonatomic, strong) NSString *firstTimeEnteredPin;
@end

@implementation APPinViewController

- (id)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _enterYourPinString = NSLocalizedString(@"输入密码", nil);
    _createYourPinString = NSLocalizedString(@"创建密码", nil);
    _enterOnceAgainString = NSLocalizedString(@"再次输入密码", nil);
    
    _pinsDontMatchTryOnceAgainString = NSLocalizedString(@"密码错误", nil);
    
    _pinCreatedString = NSLocalizedString(@"密码创建成功", nil);
    _pinVerifiedString = NSLocalizedString(@"密码验证成功", nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pinCodeView.delegate = self;
    
    NSAssert(self.pinCodeView != nil, @"APPinCodeView is not initialized");
    [self setupDefaultMessage];
    
    self.title = @"PIN";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([_pinState isEqualToString:@"new"]) {
        self.message.text = @"创建密码";
    } else if([_pinState isEqualToString:@"verity"]) {
        self.message.text = @"输入密码";
    } else {
        self.message.text = @"输入旧密码";
    }
    
    //Strange bug in iOS7. Keyboard do not shown after call directly
    double delayInSeconds = .0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.pinCodeView becomeFirstResponder];
    });
    
}

#pragma mark - Pin Code View Delegate
- (void)pinCodeView:(APPinView *)view didEnterPin:(NSString *)pinCode {
    view.pinCode = nil;
    
    //Verify case
    if (self.pinCodeToCheck != nil && !self.shouldResetPinCode) {
        [self verifyPinWithEntered:pinCode];
    } else if (self.pinCodeToCheck != nil && self.shouldResetPinCode) {
        [self changePinWithEntered:pinCode];
    } else {
        [self setEnteredPin:pinCode];
    }
}

#pragma mar - Pins Logic
- (void)verifyPinWithEntered:(NSString *)pinCode {
    //Pins matched
    if ([self.pinCodeToCheck isEqualToString:pinCode]) {
        
        if ([self.delegate respondsToSelector:@selector(pinCodeViewController:didVerifiedPincodeSuccessfully:)]) {
            [self.delegate pinCodeViewController:self didVerifiedPincodeSuccessfully:pinCode];
        }
        
        [self showPinVerifiedMessage];
    } else {
        _failedAttempts++;
        
        if ([self.delegate respondsToSelector:@selector(pinCodeViewController:didFailVerificationWithCount:)]) {
            [self.delegate pinCodeViewController:self didFailVerificationWithCount:self.failedAttempts];
        }
        [self showPinsDontMatchMessage];
    }
}

- (void)setEnteredPin:(NSString *)pinCode {
    
    //This is first attempt
    if (self.firstTimeEnteredPin == nil) {
        self.firstTimeEnteredPin = [pinCode copy];
        
        //Message
        [self showEnterOnceAgainMessage];
        
        //Here we should compare them
    } else {
        
        //They are equal
        if ([pinCode isEqualToString:self.firstTimeEnteredPin]) {
            if ([self.delegate respondsToSelector:@selector(pinCodeViewController:didCreatePinCode:)]) {
                [self.delegate pinCodeViewController:self didCreatePinCode:pinCode];
            }
            
            //Message
            [self showPinCreatedMessage];
            
            //Passwords don't match. Let's go over again
        } else {
            
            self.firstTimeEnteredPin = nil;
            _failedAttempts++;
            
            if ([self.delegate respondsToSelector:@selector(pinCodeViewController:didFailVerificationWithCount:)]) {
                [self.delegate pinCodeViewController:self didFailVerificationWithCount:self.failedAttempts];
            }
            
            //Message
            [self showPinsDontMatchMessage];
        }
    }
}

- (void)changePinWithEntered:(NSString *)pinCode {
    //User have not verified password yet
    if (!_firstTimePinVerified) {
        
        //user entered valid
        if ([self.pinCodeToCheck isEqualToString:pinCode]) {
            
            _firstTimePinVerified = YES;
            
            //Message
            [self showCreateThePinMessage];
        } else {
            
            //Notify about fail
            _failedAttempts++;
            if ([self.delegate respondsToSelector:@selector(pinCodeViewController:didFailVerificationWithCount:)]) {
                [self.delegate pinCodeViewController:self didFailVerificationWithCount:self.failedAttempts];
            }
            
            //Message
            [self showPinsDontMatchMessage];
        }
    } else {
        
        //Create new password
        if (self.firstTimeEnteredPin == nil) {
            self.firstTimeEnteredPin = [pinCode copy];
            
            [self showEnterOnceAgainMessage];
        } else {
            
            //Everything is good
            if ([self.firstTimeEnteredPin isEqualToString:pinCode]) {
                
                if ([self.delegate respondsToSelector:@selector(pinCodeViewController:didChangePinCode:)]) {
                    [self.delegate pinCodeViewController:self didChangePinCode:pinCode];
                }
                
                [self showPinCreatedMessage];
                
                //Password don't match. Let's go to step 2
            } else {
                
                self.firstTimeEnteredPin = nil;
                _failedAttempts++;
                
                if ([self.delegate respondsToSelector:@selector(pinCodeViewController:didFailVerificationWithCount:)]) {
                    [self.delegate pinCodeViewController:self didFailVerificationWithCount:self.failedAttempts];
                }
                //Message
                [self showPinsDontMatchMessage];
            }
        }
    }
}

#pragma mark - Messages
- (void)setupDefaultMessage {
    //Verify case
    if (self.pinCodeToCheck != nil && !self.shouldResetPinCode) {
        [self showEnterYourPinMessage];
    } else if (self.pinCodeToCheck != nil && self.shouldResetPinCode) {
        [self showEnterYourPinMessage];
    } else {
        [self showCreateThePinMessage];
    }
}

- (void)showCreateThePinMessage {
    NSString *message = self.createYourPinString;
    NSLog(@"%@", message);
    [_message setText:@"创建密码"];
}

- (void)showEnterYourPinMessage {
    NSString *message = self.enterYourPinString;
    NSLog(@"%@", message);
    [_message setText:@"输入密码"];
}

- (void)showPinsDontMatchMessage {
    NSString *message = self.pinsDontMatchTryOnceAgainString;
    NSLog(@"%@", message);
    [_message setText:@"密码不一致"];
}

- (void)showPinCreatedMessage {
    NSString *message = self.pinCreatedString;
    NSLog(@"%@", message);
    [_message setText:@"密码创建成功"];
}

- (void)showEnterOnceAgainMessage {
    NSString *message = self.enterOnceAgainString;
    NSLog(@"%@", message);
    
    [_message setText:@"请再次输入密码"];
}

- (void)showPinVerifiedMessage {
    NSString *message = self.pinVerifiedString;
    NSLog(@"%@", message);
    
    [_message setText:@"密码验证成功"];
}

@end
