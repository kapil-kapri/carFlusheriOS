//
//  UserProfileVController.m
//  CarWash
//
//  Created by Payal Patel on 02/09/16.
//  Copyright © 2016 Payal Patel. All rights reserved.
//

#import "UserProfileVController.h"

#import "UITableView+TextFieldAdditions.h"
#import "UIAlertView+Blocks.h"

typedef NS_ENUM(NSInteger, SSInputFields)
{
    NONE,
    FIRST_NAME,
    LAST_NAME,
    EMAIL_ID,
    PASS_WORD
    
};

@interface UserProfileVController ()<UITextFieldDelegate>
{
    
    IBOutlet UITableView *tblUserProfile;
    
    NSArray *arrPlaceHolder;
    
    ViewStyle *style;
    
    NSString *firstname;
    NSString *lastname;
    NSString *emailid;
    NSString *password;
}
@end

@implementation UserProfileVController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //view style
    style = [[ViewStyle alloc] init];
    
    //call table kebord function
    [tblUserProfile beginWatchingForKeyboardStateChanges];
    tblUserProfile.tableFooterView = [[UIView alloc] init];
    tblUserProfile.backgroundColor = [UIColor clearColor];
    
    arrPlaceHolder = @[@"Profile Image",@"First Name",@"Last Name",@"Email Id",@"Password",@"Continue"];
    
    
}
-(void)viewWillLayoutSubviews
{
    self.view.backgroundColor = style.backgroundColor;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [tblUserProfile endWatchingForKeyboardStateChanges];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        //CGRect cellRect = [tableView rectForRowAtIndexPath:indexPath];
        
        
        if (indexPath.row == [arrPlaceHolder count]-1) {
            
            UIButton *buttonSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
            [cell.contentView addSubview:buttonSubmit];
            //[buttonSubmit setImage:[UIImage imageNamed:@"ic_action_accept.png"] forState:UIControlStateNormal];
            
            [buttonSubmit setTitle:@"Done" forState:UIControlStateNormal];
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
            
        }else if (indexPath.row == 0) {
            UIImageView *imgProfile = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200)];
            imgProfile.image = [UIImage imageNamed:@"user_icon.png"];
            imgProfile.contentMode = UIViewContentModeScaleToFill;
            imgProfile.clipsToBounds = YES;
            [cell.contentView setClipsToBounds:YES];
            [cell.contentView addSubview:imgProfile];
        }
        else{
            UITextField *textField = [self textFieldWithFrame:CGRectMake(5.0,
                                                                         10,
                                                                         CGRectGetWidth(cell.contentView.bounds)-10,
                                                                         CGRectGetHeight(cell.bounds))];
            [cell.contentView addSubview:textField];
            
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:arrPlaceHolder[indexPath.row] attributes:@{ NSForegroundColorAttributeName : style.inputFieldPlaceholderColor }];
            textField.attributedPlaceholder = str;
            textField.delegate = self;
            
            UIImageView *imgSepration = [[UIImageView alloc] initWithFrame:CGRectMake(5, 60, CGRectGetWidth(self.view.frame)-10, 1)];
            imgSepration.backgroundColor = [UIColor grayColor];
            [cell.contentView addSubview:imgSepration];
            
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
                UITextInputAssistantItem* item = [textField inputAssistantItem];
                item.leadingBarButtonGroups = @[];
                item.trailingBarButtonGroups = @[];
            }
        }
    }
    
    for (UIView *view in cell.contentView.subviews){
        
        if ([view isKindOfClass:[UITextField class]]) {
            if (indexPath.row == 1) {
                UITextField *textField = [cell.contentView.subviews objectAtIndex:0];
                textField.tag = FIRST_NAME;
                textField.returnKeyType = UIReturnKeyNext;
                textField.keyboardType = UIKeyboardTypeAlphabet;
                
            }else if (indexPath.row == 2) {
                UITextField *textField = [cell.contentView.subviews objectAtIndex:0];
                textField.tag = LAST_NAME;
                textField.returnKeyType = UIReturnKeyNext;
                textField.keyboardType = UIKeyboardTypeAlphabet;
                
            }else if (indexPath.row == 3) {
                UITextField *textField = [cell.contentView.subviews objectAtIndex:0];
                textField.tag = EMAIL_ID;
                textField.returnKeyType = UIReturnKeyNext;
                textField.keyboardType = UIKeyboardTypeEmailAddress;
                
            }else if (indexPath.row == 4) {
                UITextField *textField = [cell.contentView.subviews objectAtIndex:0];
                textField.tag = PASS_WORD;
                textField.returnKeyType = UIReturnKeyDone;
                textField.secureTextEntry = YES;
                textField.keyboardType = UIKeyboardTypeNamePhonePad;
            }
        }
    }
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 200;
    }else if ([arrPlaceHolder count] -1) {
        return 90;
    }
    else
        return 50;
}

-(IBAction)tblButtonAction:(id)sender
{
    if([sender tag] == 2){
        
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
            case FIRST_NAME:
            firstname = textField.text;
            break;
            case LAST_NAME:
            lastname = textField.text;
            break;
            case EMAIL_ID:
            emailid = textField.text;
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
            case FIRST_NAME:
            [tblUserProfile makeNextCellWithTextFieldFirstResponder];
            break;
            case LAST_NAME:
            [tblUserProfile makeNextCellWithTextFieldFirstResponder];
            break;
            case EMAIL_ID:
            [tblUserProfile makeNextCellWithTextFieldFirstResponder];
            break;
            case PASS_WORD:
            [textField resignFirstResponder];
            break;
        default:
            break;
    }
    return YES;
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return NO;
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
