//
//  HSAddStudentViewController.m
//  HelpShift
//
//  Created by Ankit Gohel on 01/06/16.
//  Copyright © 2016 Ankit Gohel. All rights reserved.
//

#import "HSAddStudentViewController.h"
#import "HSStudentDetailsModel.h"
#import "HSPersonalDetailsModel.h"
#import "HSAcademicDetailsModel.h"
#import "HSDBManager.h"

#define kOFFSET_FOR_KEYBOARD 80.0

typedef enum
{
    kTypePersonal = 0,
    kTypeAcademic
} Weekday;

@interface HSAddStudentViewController ()
{
    BOOL isGenderMale;
    
    BOOL keyboardIsShown;
}
@end

@implementation HSAddStudentViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    isGenderMale = YES;
    
    [self addSaveButton];
    
    [self switchGender];
    
    [self changeSegment];
    
    [self loadTextFields];
    
    [self preloadStudentDataIfPresent];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.contentView addGestureRecognizer:tap];

}


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scrlVw.contentSize = self.contentView.frame.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Helpers


-(void)addSaveButton
{
    UIImage* image3 = [UIImage imageNamed:@"ic_Save"];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *btnSave = [[UIButton alloc] initWithFrame:frameimg];
    [btnSave setBackgroundImage:image3 forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(btnSaveTapped:) forControlEvents:UIControlEventTouchUpInside];
    [btnSave setShowsTouchWhenHighlighted:YES];
    [btnSave setTintColor:[UIColor orangeColor]];
    
    UIBarButtonItem *btnSaveStudent =[[UIBarButtonItem alloc] initWithCustomView:btnSave];
    self.navigationItem.rightBarButtonItem=btnSaveStudent;
}

-(void)changeSegment
{
    [self.vwPersonalDetails setHidden:!(self.scStudentDetails.selectedSegmentIndex == kTypePersonal)];
    [self.vwAcademicDetails setHidden:(self.scStudentDetails.selectedSegmentIndex == kTypePersonal)];
}

-(void)switchGender
{
    [self.btnMale setSelected:isGenderMale];
    [self.btnFemale setSelected:!isGenderMale];
}

-(void)preloadStudentDataIfPresent
{
    self.title = @"Add Student";
    
    if (self.objStudentSelected)
    {
        self.title = [NSString stringWithFormat:@"%@",self.objStudentSelected.objPersonalDetails.strName];
        
        /// Set Personal Details
        self.txtName.text        = [NSString stringWithFormat:@"%@",self.objStudentSelected.objPersonalDetails.strName];
        self.txtEmail.text       = [NSString stringWithFormat:@"%@",self.objStudentSelected.objPersonalDetails.strEmail];
        self.txtPhoneNumber.text = [NSString stringWithFormat:@"%@",self.objStudentSelected.objPersonalDetails.strPhoneNumber];
        self.txtViewAddress.text = [NSString stringWithFormat:@"%@",self.objStudentSelected.objPersonalDetails.strAddress];
        self.btnMale.selected    = self.objStudentSelected.objPersonalDetails.isMale;
        self.btnFemale.selected  = !self.objStudentSelected.objPersonalDetails.isMale;
        
        /// Set Academics Details
        self.txtDepartment.text     = [NSString stringWithFormat:@"%@",self.objStudentSelected.objAcademicDetails.strDepartment];
        self.txtSemester.text       = [NSString stringWithFormat:@"%@",self.objStudentSelected.objAcademicDetails.strSemester];
        self.txtHSCPercentage.text  = [NSString stringWithFormat:@"%@",self.objStudentSelected.objAcademicDetails.strHSCPercentage];
        self.txtSSCPercentage.text  = [NSString stringWithFormat:@"%@",self.objStudentSelected.objAcademicDetails.strSSCPercentage];
    }

}

-(void)loadTextFields
{
    [self outlineView:self.txtName ];
    [self outlineView:self.txtEmail ];
    [self outlineView:self.txtPhoneNumber ];

    [self.txtViewAddress.layer setCornerRadius:3.0];
    [self.txtViewAddress.layer setBorderWidth:1.0f];
    [self.txtViewAddress.layer setBorderColor:[UIColor orangeColor].CGColor];
    [self.txtViewAddress.layer setMasksToBounds:YES];

    [self outlineView:self.txtDepartment ];
    [self outlineView:self.txtSemester ];
    [self outlineView:self.txtHSCPercentage ];
    [self outlineView:self.txtSSCPercentage ];
}

-(void)outlineView:(UITextField *)vw
{
    [vw.layer setCornerRadius:3.0];
    [vw.layer setBorderWidth:1.0f];
    [vw.layer setBorderColor:[UIColor orangeColor].CGColor];
    [vw.layer setMasksToBounds:YES];
}



-(BOOL) validateEmailWithString:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


-(BOOL)validateStudentDetails
{
    /// Check for valid Personal details
    if ([self validatePersonalDetails].length == 0)
    {
        /// Check for valid academic details
        if ([self validateAcademicDetails].length == 0)
        {
            return YES;
        }
        else
        {
            [self.vwPersonalDetails setHidden:YES];
            [self.vwAcademicDetails setHidden:NO];
            
            [[[UIAlertView alloc] initWithTitle:@"Student Application" message:[self validateAcademicDetails] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            return NO;
        }

    }
    else
    {
        [self.vwPersonalDetails setHidden:NO];
        [self.vwAcademicDetails setHidden:YES];

        [[[UIAlertView alloc] initWithTitle:@"Student Application" message:[self validatePersonalDetails] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return NO;
    }
}

-(NSString *)validatePersonalDetails
{
    NSString *strErrorMsg;
    
    if (self.txtName.text.length == 0)
    {
        strErrorMsg = @"Please enter Name";
        [self.txtName becomeFirstResponder];
    }
    else if(![self validateEmailWithString:self.txtEmail.text])
    {
        strErrorMsg = @"Please enter valid Email Address";
        [self.txtEmail becomeFirstResponder];
    }
    else if ((self.txtPhoneNumber.text.length == 0) || (self.txtPhoneNumber.text.length != 10))
    {
        strErrorMsg = @"Please enter valid Phone Number";
        [self.txtPhoneNumber becomeFirstResponder];

    }
    else if (self.txtViewAddress.text == 0)
    {
        strErrorMsg = @"Please enter Address";
        [self.txtViewAddress becomeFirstResponder];

    }
    else
    {
        strErrorMsg = @"";
    }
    return  strErrorMsg;
}

-(NSString *)validateAcademicDetails
{
    NSString *strErrorMsg;

    if (self.txtDepartment.text.length == 0)
    {
        strErrorMsg = @"Please enter Department";
        [self.txtDepartment becomeFirstResponder];
    }
    else if(self.txtSemester.text.length == 0)
    {
        strErrorMsg = @"Please enter Semester";
        [self.txtSemester becomeFirstResponder];

    }
    else if (self.txtHSCPercentage.text.length == 0)
    {
        strErrorMsg = @"Please enter HSC Percentage";
        [self.txtHSCPercentage becomeFirstResponder];

    }
    else if (self.txtSSCPercentage.text == 0)
    {
        strErrorMsg = @"Please enter SSC Percentage";
        [self.txtSSCPercentage becomeFirstResponder];

    }
    else
    {
        strErrorMsg = @"";
    }
    return strErrorMsg;
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)clearAll
{
    self.txtName.text = @"";
    self.txtEmail.text = @"";
    self.txtPhoneNumber.text = @"";
    self.txtViewAddress.text = @"";
    
    self.txtDepartment.text = @"";
    self.txtSemester.text = @"";
    self.txtHSCPercentage.text = @"";
    self.txtSSCPercentage.text = @"";
    
}


#pragma mark - Textfield/ Textview Delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint cPoint = textField.frame.origin;
    [self.scrlVw setContentOffset:CGPointMake(0, cPoint.y - 100) animated:YES];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.txtName)
    {
        [self.txtEmail becomeFirstResponder];
    }
    else if (textField == self.txtEmail)
    {
        [self.txtPhoneNumber becomeFirstResponder];
    }
    else if (textField == self.txtPhoneNumber)
    {
        [self.txtViewAddress becomeFirstResponder];
    }
    
    if (textField == self.txtDepartment)
    {
        [self.txtSemester becomeFirstResponder];
    }
    else if (textField == self.txtSemester)
    {
        [self.txtHSCPercentage becomeFirstResponder];
    }
    else if (textField == self.txtHSCPercentage)
    {
        [self.txtSSCPercentage becomeFirstResponder];
    }
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.txtPhoneNumber)
    {
        NSString *resultText = [textField.text stringByReplacingCharactersInRange:range
                                                                       withString:string];
        return resultText.length <= 10;
    }
    return YES;
  
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    
    NSString *resultText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    return resultText.length <= 50;

    return YES;
}


-(void)textViewDidBeginEditing:(UITextView *)textView
{
    CGPoint cPoint = textView.frame.origin;
    [self.scrlVw setContentOffset:CGPointMake(0, cPoint.y - 100) animated:YES];

}


#pragma mark - Button Events

- (IBAction)btnSaveTapped:(id)sender
{
    [self.view endEditing:YES];
    
    HSPersonalDetailsModel *objPersonalDetails = [[HSPersonalDetailsModel alloc] initWithName:self.txtName.text
                                                                                     andEmail:self.txtEmail.text
                                                                               andPhoneNumber:self.txtPhoneNumber.text
                                                                                   andAddress:self.txtViewAddress.text
                                                                              andGenderIfMale:isGenderMale
                                                                                andRollNumber:self.objStudentSelected.objPersonalDetails.iRollNo];
    
    HSAcademicDetailsModel *objAcademicDetails = [[HSAcademicDetailsModel alloc]initWithDepartment:self.txtDepartment.text
                                                                                       andSemester:self.txtSemester.text
                                                                                  andHSCPercentage:self.txtHSCPercentage.text
                                                                                  andSSCPercentage:self.txtSSCPercentage.text];
    
    HSStudentDetailsModel *student = [[HSStudentDetailsModel alloc]initWithPersonalDetails:objPersonalDetails
                                                                        andAcademicDetails:objAcademicDetails];
/// If record is cached then go for Updating after validating
    if (self.objStudentSelected)
    {
        if ([self validateStudentDetails])
        {
            if ([[HSDBManager getSharedInstance] updateStudentDetailsFor:student])
            {
                NSLog(@"Saved success");
                [[[UIAlertView alloc] initWithTitle:@"Student Application" message:@"Student details updated successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                
                
            }
            else
            {
                NSLog(@"Saved failed");
                [[[UIAlertView alloc] initWithTitle:@"Student Application" message:@"Student details failed to update" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                
            }

        }
    }
    else    /// Not cached then add new record
    {
        if ([self validateStudentDetails])
        {
            if ([[HSDBManager getSharedInstance] saveStudent:student])
            {
                NSLog(@"Saved success");
                [[[UIAlertView alloc] initWithTitle:@"Student Application" message:@"Student details saved successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                [self clearAll];
            }
            else
            {
                NSLog(@"Saved failed");
                [[[UIAlertView alloc] initWithTitle:@"Student Application" message:@"Student details failed to save" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                
            }
        }
    }
}

- (IBAction)btnGenderClicked:(id)sender
{
    isGenderMale = !isGenderMale;
    [self switchGender];
}

- (IBAction)segmentSwitched:(id)sender
{
    [self changeSegment];
}

@end
