//
//  ForgotPwdVController.m
//  CarWash
//
//  Created by Payal Patel on 02/09/16.
//  Copyright © 2016 Payal Patel. All rights reserved.
//

#import "ForgotPwdVController.h"

@interface ForgotPwdVController ()
{
    
    IBOutlet UITextField *txtMobileNo;
    IBOutlet UIButton *btnResetPwd;
    
    ViewStyle *style;
}
- (IBAction)btnResetPwdClick:(id)sender;
@end

@implementation ForgotPwdVController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //view style
    style = [[ViewStyle alloc] init];
    
    
}

-(void)viewWillLayoutSubviews
{
    [btnResetPwd setTitleColor:style.buttonTitleColor forState:UIControlStateNormal];
    btnResetPwd.backgroundColor = style.buttonBackgroundColor;
    btnResetPwd.layer.cornerRadius = 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnResetPwdClick:(id)sender {
}
@end
