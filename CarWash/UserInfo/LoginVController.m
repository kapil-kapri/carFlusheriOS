//
//  LoginVController.m
//  CarWash
//
//  Created by Payal Patel on 30/08/16.
//  Copyright © 2016 Payal Patel. All rights reserved.
//

#import "LoginVController.h"


#import "ForgotPwdVController.h"
#import "HomeViewController.h"


#import "UITableView+TextFieldAdditions.h"
#import "MBProgressHUD.h"

typedef NS_ENUM(NSInteger, SSInputFields)
{
    NONE,
    MOBILE_NO,
    PASS_WORD
};

@interface LoginVController ()<UITextFieldDelegate,MBProgressHUDDelegate>
{
    NSArray *arrPlaceHolder;
    
    ViewStyle *style;
    
    NSString *mobileno;
    NSString *password;
}
@end

@implementation LoginVController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //view style
    style = [[ViewStyle alloc] init];
    
    
    
    //call table kebord function
    [tblLogin beginWatchingForKeyboardStateChanges];
    tblLogin.tableFooterView = [[UIView alloc] init];
    tblLogin.backgroundColor = [UIColor clearColor];
    
    arrPlaceHolder = @[@"Mobile No",@"Password",@"Forgot Password",@"Continue"];
    
    mobileno = @"";
    password = @"";

    
}
-(void)viewWillLayoutSubviews
{
    self.view.backgroundColor = style.backgroundColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [tblLogin endWatchingForKeyboardStateChanges];
}

#pragma mark - UITableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrPlaceHolder count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier;
    CellIdentifier = [NSString stringWithFormat:@"cell %ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        CGRect cellRect = [tableView rectForRowAtIndexPath:indexPath];
        
        
        if (indexPath.row == [arrPlaceHolder count]-1 || indexPath.row == [arrPlaceHolder count]-2) {
            
            UIButton *buttonSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
            [cell.contentView addSubview:buttonSubmit];
            //[buttonSubmit setImage:[UIImage imageNamed:@"ic_action_accept.png"] forState:UIControlStateNormal];
            if (indexPath.row == [arrPlaceHolder count]-1) {
                [buttonSubmit setTitle:@"Continue" forState:UIControlStateNormal];
                [buttonSubmit setTitleColor:style.buttonTitleColor forState:UIControlStateNormal];
                buttonSubmit.backgroundColor = style.buttonBackgroundColor;
                
                buttonSubmit.frame = CGRectMake(5.0,
                                                50.0,
                                                CGRectGetWidth(cell.contentView.bounds)-10,
                                                CGRectGetHeight(cell.bounds));//CGRectMake((CGRectGetWidth(self.view.bounds)/2)- 80.0, 0.0, 160.0, 34.0);
                UIFont *font = [style regularFont:30];
                buttonSubmit.titleLabel.font = font;
                buttonSubmit.layer.cornerRadius = 5;
            }else{
                [buttonSubmit setTitle:@"Forgot Password" forState:UIControlStateNormal];
                [buttonSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                //buttonSubmit.backgroundColor = style.buttonBackgroundColor;
                
                buttonSubmit.frame = CGRectMake(CGRectGetWidth(cell.contentView.bounds)-205,
                                                40.0,
                                                200,
                                                CGRectGetHeight(cell.bounds));//CGRectMake((CGRectGetWidth(self.view.bounds)/2)- 80.0, 0.0, 160.0, 34.0);
                UIFont *font = [style regularFont:18];
                buttonSubmit.titleLabel.font = font;
            }
            
            //[UIFont boldSystemFontOfSize:15.0f];
            [buttonSubmit addTarget:self action:@selector(tblButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            buttonSubmit.tag = indexPath.row;
            
            buttonSubmit.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            cell.separatorInset = UIEdgeInsetsMake(0.f, 0, 0.f, cell.frame.size.width*300); //hide seprator
            
        }
        else{
            UITextField *textField = [self textFieldWithFrame:CGRectMake(5.0,
                                                                         cellRect.size.height-54,
                                                                         CGRectGetWidth(cell.contentView.bounds)-10,
                                                                         CGRectGetHeight(cell.bounds))];
            [cell.contentView addSubview:textField];
            
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:arrPlaceHolder[indexPath.row] attributes:@{ NSForegroundColorAttributeName : style.inputFieldPlaceholderColor }];
            textField.attributedPlaceholder = str;
            textField.delegate = self;
            
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
                UITextInputAssistantItem* item = [textField inputAssistantItem];
                item.leadingBarButtonGroups = @[];
                item.trailingBarButtonGroups = @[];
            }
        }
    }
    
    for (UIView *view in cell.contentView.subviews){
        
        if ([view isKindOfClass:[UITextField class]]) {
            if (indexPath.row == 0) {
                UITextField *textField = [cell.contentView.subviews objectAtIndex:0];
                textField.tag = MOBILE_NO;
                textField.text = mobileno;
                textField.returnKeyType = UIReturnKeyDone;
                textField.keyboardType = UIKeyboardTypePhonePad;
                
            }else if (indexPath.row == 1) {
                UITextField *textField = [cell.contentView.subviews objectAtIndex:0];
                textField.tag = PASS_WORD;
                textField.text = password;
                textField.returnKeyType = UIReturnKeyDone;
                textField.secureTextEntry = YES;
                textField.keyboardType = UIKeyboardTypeNamePhonePad;
            }
        }
    }
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [arrPlaceHolder count] -1) {
        return 90;
    }
    else
        return 70;
}

-(IBAction)tblButtonAction:(id)sender
{
    if([sender tag] == 2){
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        ForgotPwdVController *forgotPwdContr = (ForgotPwdVController *)[storyboard instantiateViewControllerWithIdentifier:@"ForgotPwdVController"];
        [self.navigationController pushViewController:forgotPwdContr animated:YES];
    }else if ([sender tag] == 3){
        if ([self inputVerification]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [APIFunctions loginUserAPIMo:mobileno pwd:password success:^(id resObject) {
                
                UserRegister *registerU = [[UserRegister alloc] initWithDictionary:resObject error:nil];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (registerU.response.code == 200) {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    
                    HomeViewController *userProfileContr = (HomeViewController *)[storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                    //[self.navigationController pushViewController:userProfileContr animated:YES];
                    userProfileContr.registerUser = registerU;
                    [[SlideNavigationController sharedInstance] setViewControllers:@[userProfileContr] animated:YES];
                }
                
            } failure:^(NSDictionary *error){
            }];
            
            
        }
    }
    
}

#pragma mark - TextField
- (UITextField*)textFieldWithFrame:(CGRect)frame
{
    UITextField* textField = [[UITextField alloc] initWithFrame:frame];
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    textField.textAlignment            = NSTextAlignmentCenter;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.autocapitalizationType = UITextAutocapitalizationTypeSentences; // no auto capitalization support
    textField.keyboardType = UIKeyboardTypeAlphabet;
    textField.adjustsFontSizeToFitWidth = YES;
    textField.textColor = style.inputFieldTextColor;
    
    if(style.inputFieldBackgroundColor)
    textField.backgroundColor = style.inputFieldBackgroundColor;
    
    
    
    /*if(style.inputFieldBorderColor) {
     textField.layer.borderColor = style.inputFieldBorderColor.CGColor;
     textField.layer.masksToBounds=YES;
     textField.layer.cornerRadius=8.0f;
     textField.layer.borderWidth= 2.0f;
     }*/
    
    UIFont *font;
    if ([Functions IsiPhoneDevice]) {
        font = [style regularFont:15];
    }else
    font = [style regularFont:19];
    
    textField.font = font;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    
    
    textField.autocorrectionType     = UITextAutocorrectionTypeNo; // no auto correction support
    textField.clearButtonMode        = UITextFieldViewModeNever;
    
    return textField;
}

#pragma mark - TextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    switch (textField.tag) {
            case MOBILE_NO:
            mobileno = textField.text;
            break;
            case PASS_WORD:
            password = textField.text;
            break;
        default:
            break;
            
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    switch (textField.tag) {
            case MOBILE_NO:
            [textField resignFirstResponder];
            break;
            case PASS_WORD:
            [textField resignFirstResponder];
            break;
        default:
            break;
    }
    return YES;
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range1 replacementString:(NSString *)string
{
    int maxLength = 0;

    if(textField.tag == MOBILE_NO) {
        maxLength = 10;
    }
    if(textField.tag == PASS_WORD) {
        maxLength = 40;
    }
    return maxLength;
}


#pragma mark - Database function
- (bool)inputVerification
{
    BOOL segueShouldOccur = YES|NO;
    NSString *msg = @"";
    if ([mobileno isEqualToString:@""])
    {
        msg = [msg stringByAppendingString:@"Mobile number is mandatory"];
        segueShouldOccur = NO;
    }else if (![mobileno isEqualToString:@""] && [mobileno length]<10)
    {
        msg = [msg stringByAppendingString:@"Invalid mobile number"];
        segueShouldOccur = NO;
    }else if ([password isEqualToString:@""]) {
        msg = [msg stringByAppendingString:@"Password is mandatory"];
        segueShouldOccur = NO;
    }
    
    
    if (!segueShouldOccur)
    {
        msg = [msg stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
        msg = [msg stringByAppendingString:@"!"];
        
        [self showMessage:AppName text:msg];
    }else{
    }
    return segueShouldOccur;
}
#pragma mark - Alert.
-(void)showMessage:(NSString *)title text:(NSString *)text
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:title
                          message:text
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    
    
}


@end
