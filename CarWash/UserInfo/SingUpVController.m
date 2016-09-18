//
//  SingUpVController.m
//  CarWash
//
//  Created by Payal Patel on 29/08/16.
//  Copyright © 2016 Payal Patel. All rights reserved.
//

#import "SingUpVController.h"

#import "UITableView+TextFieldAdditions.h"
#import "MBProgressHUD.h"

#import "HomeViewController.h"

typedef NS_ENUM(NSInteger, SSInputFields)
{
    NONE,
    NAME,
    PSS_WORD,
    MOBILE_NO,
    EMAIL_ID,
    OTP
};

@interface SingUpVController ()<UITextFieldDelegate,MBProgressHUDDelegate>
{
    IBOutlet UITableView *tblSignUp;
    
    NSArray *arrPlaceHolder;
    
    ViewStyle *style;
    
    UILabel *lblNote;
    
    NSString *password;
    NSString *mobileno;
    NSString *emailid;
    NSString *userName;
    NSString *otp;
    NSString *getOTP;
    
    BOOL isOTPEnable;
    BOOL isResendEnable;
    NSTimer *timer;
    int currMinute;
    int currSeconds;
}


@end

@implementation SingUpVController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //view style
    style = [[ViewStyle alloc] init];
    
    //call table kebord function
    [tblSignUp beginWatchingForKeyboardStateChanges];
    tblSignUp.tableFooterView = [[UIView alloc] init];
    tblSignUp.backgroundColor = [UIColor clearColor];
    
    arrPlaceHolder = @[@"User Name",@"Email",@"Mobile No",@"Password",@"OTP",@"Note",@"Sing UP"];
    
    password = @"";
    mobileno = @"";
    emailid = @"";
    userName = @"";
    otp = @"";
    getOTP = @"";
    isOTPEnable = NO;
    isResendEnable = NO;
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
    [tblSignUp endWatchingForKeyboardStateChanges];
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
        
        
        if (indexPath.row == [arrPlaceHolder count]-1) {
            
            UIButton *buttonSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
            [cell.contentView addSubview:buttonSubmit];
            //[buttonSubmit setImage:[UIImage imageNamed:@"ic_action_accept.png"] forState:UIControlStateNormal];
            [buttonSubmit setTitle:@"Send OTP" forState:UIControlStateNormal];
            [buttonSubmit setTitleColor:style.buttonTitleColor forState:UIControlStateNormal];
            buttonSubmit.backgroundColor = style.buttonBackgroundColor;
            
            buttonSubmit.frame = CGRectMake(5.0,
                                            50.0,
                                            CGRectGetWidth(cell.contentView.bounds)-10,
                                            CGRectGetHeight(cell.bounds));//CGRectMake((CGRectGetWidth(self.view.bounds)/2)- 80.0, 0.0, 160.0, 34.0);
            UIFont *font = [style regularFont:30];
            buttonSubmit.titleLabel.font = font;
            buttonSubmit.layer.cornerRadius = 5;
            
            //[UIFont boldSystemFontOfSize:15.0f];
            [buttonSubmit addTarget:self action:@selector(tblButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            buttonSubmit.tag = indexPath.row;
            
            buttonSubmit.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            cell.separatorInset = UIEdgeInsetsMake(0.f, 0, 0.f, cell.frame.size.width*300); //hide seprator
            
        }else if (indexPath.row == [arrPlaceHolder count]-2) {
            lblNote = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, CGRectGetWidth(self.view.frame)-10, CGRectGetHeight(cell.bounds))];
            lblNote.text = @"OTP will be send to the above number";
            lblNote.textColor = [UIColor whiteColor];
            lblNote.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:lblNote];
            
        }
        else{
            UITextField *textField = [self textFieldWithFrame:CGRectMake(5.0,
                                                            cellRect.size.height-40,
                                                            CGRectGetWidth(cell.contentView.bounds)-10,
                                                            40)];
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
                textField.tag = NAME;
                textField.text = userName;
                textField.returnKeyType = UIReturnKeyDone;
                textField.keyboardType = UIKeyboardTypeAlphabet;
                if (isOTPEnable) {
                    [textField setEnabled:NO];
                }
            }else if (indexPath.row == 1) {
                UITextField *textField = [cell.contentView.subviews objectAtIndex:0];
                textField.tag = EMAIL_ID;
                textField.text = emailid;
                textField.returnKeyType = UIReturnKeyDone;
                textField.keyboardType = UIKeyboardTypeEmailAddress;
                if (isOTPEnable) {
                    [textField setEnabled:NO];
                }
            }else if (indexPath.row == 2) {
                UITextField *textField = [cell.contentView.subviews objectAtIndex:0];
                textField.tag = MOBILE_NO;
                textField.text = mobileno;
                textField.returnKeyType = UIReturnKeyDone;
                textField.keyboardType = UIKeyboardTypePhonePad;
                if (isOTPEnable) {
                    [textField setEnabled:NO];
                }
                
            }else if (indexPath.row == 3) {
                UITextField *textField = [cell.contentView.subviews objectAtIndex:0];
                textField.tag = PSS_WORD;
                textField.text = password;
                textField.secureTextEntry = YES;
                textField.returnKeyType = UIReturnKeyDone;
                textField.keyboardType = UIKeyboardTypeAlphabet;
                if (isOTPEnable) {
                    [textField setEnabled:NO];
                }
                
            }else if (indexPath.row == 4) {
                UITextField *textField = [cell.contentView.subviews objectAtIndex:0];
                textField.tag = OTP;
                textField.text = otp;
                textField.returnKeyType = UIReturnKeyDone;
                textField.keyboardType = UIKeyboardTypeAlphabet;
                if (isOTPEnable) {
                    textField.hidden = NO;
                }
                else
                    textField.hidden = YES;
                if (isResendEnable) {
                    [textField setEnabled:NO];
                }else
                    [textField setEnabled:YES];
            }
        }
        if ([view isKindOfClass:[UILabel class]]) {
            if (isOTPEnable && !isResendEnable) {
                lblNote.textAlignment = NSTextAlignmentRight;
                [lblNote setText:@"Time : 1:00"];
                currMinute=1;
                currSeconds=00;
                [self start];
            }
        }
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btnSend = [cell.contentView.subviews objectAtIndex:0];
            if (isOTPEnable) {
                [btnSend setTitle:@"Continue" forState:UIControlStateNormal];
            }if (isResendEnable) {
                [btnSend setTitle:@"Resend OTP" forState:UIControlStateNormal];
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
    return 50;
}
-(IBAction)tblButtonAction:(id)sender
{
    if (isOTPEnable) {
        if (isResendEnable) {
            isResendEnable = false;
            [tblSignUp reloadData];
        }else{
            if (![otp isEqualToString:getOTP])
            {
                NSString *msg = @"Invalid OTP";
                [self showMessage:AppName text:msg];
            }else{
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [APIFunctions registerUserApiMo:mobileno name:userName emailId:emailid password:password OTP:otp success:^(id resObject) {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UserRegister *registerU = [[UserRegister alloc] initWithDictionary:resObject error:nil];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if (registerU.response.code == 200) {
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
    else{
        if ([self inputVerification]) {
            [tblSignUp reloadData];
            [APIFunctions genrateOTP:mobileno success:^(id resObject) {
                /*{
                 response =     {
                 code = 200;
                 data =         {
                 otp = 1234;
                 };
                 msg = SUCCESS;
                 };
                 }*/
                NSDictionary *res = resObject[@"response"];
                if ([res[@"code"] intValue] == 200) {
                    NSDictionary *data = res[@"data"];
                    getOTP = data[@"otp"];
                }
            } failure:^(NSDictionary *error){
            }];
           
        }
    }
    
    
    
}

#pragma mark - Timer
-(void)start
{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    
}
-(void)timerFired
{
    if((currMinute>0 || currSeconds>=0) && currMinute>=0)
    {
        if(currSeconds==0)
        {
            currMinute-=1;
            currSeconds=59;
        }
        else if(currSeconds>0)
        {
            currSeconds-=1;
        }
        if(currMinute>-1)
            [lblNote setText:[NSString stringWithFormat:@"%@%d%@%02d",@"Time : ",currMinute,@":",currSeconds]];
    }
    else
    {
        [timer invalidate];
        isResendEnable = YES;
        [tblSignUp reloadData];
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
        
        case NAME:
            userName = textField.text;
            break;
        case PSS_WORD:
            password = textField.text;
            break;
        case MOBILE_NO:
            mobileno = textField.text;
            break;
        case EMAIL_ID:
            emailid = textField.text;
            break;
        case OTP:
            otp = textField.text;
            break;
        default:
            break;
            
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    switch (textField.tag) {
        case NAME:
            [textField resignFirstResponder];
            break;
        case PSS_WORD:
            [textField resignFirstResponder];
            break;
        case MOBILE_NO:
            [textField resignFirstResponder];
            break;
        case EMAIL_ID:
            [textField resignFirstResponder];
            break;
        case OTP:
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
    if(textField.tag == NAME) {
        maxLength = 40;
    }
    if(textField.tag == PSS_WORD) {
        maxLength = 40;
    }
    if(textField.tag == MOBILE_NO) {
        maxLength = 10;
    }
    if(textField.tag == EMAIL_ID) {
        maxLength = 40;
    }
    if(textField.tag == OTP) {
        maxLength = 10;
    }
    return maxLength;
}


#pragma mark - Database function
- (bool)inputVerification
{
    BOOL segueShouldOccur = YES|NO;
    NSString *msg = @"";
    if ([userName isEqualToString:@""]) {
        msg = [msg stringByAppendingString:@"User name is mandatory"];
        segueShouldOccur = NO;
    }
    else if ([mobileno isEqualToString:@""])
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
    else if ([emailid isEqualToString:@""])
    {
      msg = [msg stringByAppendingString:@"Email address is mandatory"];
      segueShouldOccur = NO;
    }
    else if (![emailid isEqualToString:@""])
    {
      if(![Functions validateEmailWithString:emailid]){
          msg = [msg stringByAppendingString:@"Invalid email address"];
          segueShouldOccur = NO;
      }
    }
    
    if (!segueShouldOccur)
    {
        msg = [msg stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
        msg = [msg stringByAppendingString:@"!"];
        
        [self showMessage:AppName text:msg];
        isOTPEnable = NO;
    }else{
        isOTPEnable = YES;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
