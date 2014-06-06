//
//  PinViewController.h
//  gLastpass
//
//  Created by gxw on 14/6/6.
//  Copyright (c) 2014年 bstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPinViewController.h"

@interface PinViewController : UIViewController<APPinViewControllerDelegate>
@property (retain, nonatomic) UINavigationController *baseNaviCtr;
@property (assign, nonatomic) BOOL isEdit;

- (void)createPin;
- (void)verityPin;
- (void)changePin;
@end
