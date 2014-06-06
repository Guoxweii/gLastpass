//
//  PinViewController.m
//  gLastpass
//
//  Created by gxw on 14/6/6.
//  Copyright (c) 2014年 bstar. All rights reserved.
//

#import "PinViewController.h"


@interface PinViewController ()

@end

@implementation PinViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createPin {
    APPinViewController *pinCtr = [[APPinViewController alloc] initWithNibName:@"APPinViewController" bundle:nil];
    pinCtr.delegate = self;
    [pinCtr setPinState:@"new"];
    _baseNaviCtr = [[UINavigationController alloc] initWithRootViewController:pinCtr];
    
    [self presentViewController:_baseNaviCtr animated:YES completion:nil];
}

- (void)verityPin {
    APPinViewController *pinCtr = [[APPinViewController alloc] initWithNibName:@"APPinViewController" bundle:nil];
    pinCtr.delegate = self;
    [pinCtr setPinState:@"verity"];
    pinCtr.pinCodeToCheck = [self current_pin];
    _baseNaviCtr = [[UINavigationController alloc] initWithRootViewController:pinCtr];
    
    [self presentViewController:_baseNaviCtr animated:YES completion:nil];
}

- (void)changePin {
    APPinViewController *pinCtr = [[APPinViewController alloc] initWithNibName:@"APPinViewController" bundle:nil];
    pinCtr.delegate = self;
    [pinCtr setPinState:@"reset"];
    pinCtr.pinCodeToCheck = [self current_pin];
    pinCtr.shouldResetPinCode = YES;
    _baseNaviCtr = [[UINavigationController alloc] initWithRootViewController:pinCtr];
    
    [self presentViewController:_baseNaviCtr animated:YES completion:nil];
}

#pragma mark - Delegates
//Create
- (void)pinCodeViewController:(APPinViewController *)controller didCreatePinCode:(NSString *)pinCode {
    [self store_pin:pinCode];
    [self store_valid:@"valid"];
    [_baseNaviCtr dismissViewControllerAnimated:YES completion:^{
        [self hidePinView];
    }];
}

//Verify
- (void)pinCodeViewController:(APPinViewController *)controller didVerifiedPincodeSuccessfully:(NSString *)pinCode {
    [self store_valid:@"valid"];
    [_baseNaviCtr dismissViewControllerAnimated:YES completion:^{
        [self hidePinView];
    }];
}

//Change
- (void)pinCodeViewController:(APPinViewController *)controller didChangePinCode:(NSString *)pinCode {
    [self store_pin:pinCode];
    [self store_valid:@"valid"];
    [self setIsEdit:NO];
    [_baseNaviCtr dismissViewControllerAnimated:YES completion:^{
        [self hidePinView];
    }];
}

- (void)hidePinView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[self current_valid] isEqualToString:@"valid"] && !_isEdit) { return; }
    
    if([self current_pin] && [[self current_valid] isEqualToString:@"unvalid"]) {
        [self verityPin];
    } else if ([self current_pin] && [[self current_valid] isEqualToString:@"valid"]){
        [self changePin];
    } else {
        [self createPin];
    }
}

- (NSString *)current_pin {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"pin"];
}

- (void)store_pin:(NSString *)pin {
    [[NSUserDefaults standardUserDefaults] setValue:pin forKey:@"pin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)current_valid {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"valid"];
}

- (void)store_valid:(NSString *)valid {
    [[NSUserDefaults standardUserDefaults] setValue:valid forKey:@"valid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
