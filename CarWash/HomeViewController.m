//
//  ViewController.m
//  CarWash
//
//  Created by Payal Patel on 29/08/16.
//  Copyright © 2016 Payal Patel. All rights reserved.
//

#import "HomeViewController.h"
#import "SingUpVController.h"

#import "MBProgressHUD.h"


@interface HomeViewController ()
{
    
    IBOutlet UIButton *btnLocation;
}
- (IBAction)btnLocationClick:(id)sender;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
   /* UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    SingUpVController *signUPContr = (SingUpVController *)[storyboard instantiateViewControllerWithIdentifier:@"SingUpVController"];
    //menu is only an example
    signUPContr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:signUPContr animated:YES completion:nil];*/
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [APIFunctions checkSessionApi:_registerUser.response.data.session_key success:^(id resObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",[resObject description]);
    } failure:^(NSDictionary *error){
        NSLog(@"error %@",[error description]);
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnLocationClick:(id)sender {
}
@end
