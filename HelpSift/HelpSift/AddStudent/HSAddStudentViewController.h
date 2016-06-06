//
//  HSAddStudentViewController.h
//  HelpShift
//
//  Created by Ankit Gohel on 01/06/16.
//  Copyright © 2016 Ankit Gohel. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "TPKeyboardAvoidingScrollView.h"

@class HSStudentDetailsModel;

@interface HSAddStudentViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>

#pragma mark - Outlets and Actions

/// Scroll view with all contents
@property (weak, nonatomic) IBOutlet UIScrollView *scrlVw;

/// Content View with Personal and Academic Details
@property (weak, nonatomic) IBOutlet UIView *contentView;

/// To switch between Personal/Academic Details
@property (weak, nonatomic) IBOutlet UISegmentedControl *scStudentDetails;
- (IBAction)segmentSwitched:(id)sender;

/// Personal Details View
@property (weak, nonatomic) IBOutlet UIView *vwPersonalDetails;

/// Textfield with Name as input
@property (weak, nonatomic) IBOutlet UITextField *txtName;
/// Textfield with Email as input
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
/// Textfield with Phone Number as input
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
/// Text View with Address as input
@property (weak, nonatomic) IBOutlet UITextView *txtViewAddress;
/// Button To mark Gender as MALE
@property (weak, nonatomic) IBOutlet UIButton *btnMale;
/// Button To mark Gender as FEMALE
@property (weak, nonatomic) IBOutlet UIButton *btnFemale;

/// Button event to switch Gender as MALE/FEMALE
- (IBAction)btnGenderClicked:(id)sender;

///Academic Details view
@property (weak, nonatomic) IBOutlet UIView *vwAcademicDetails;

/// Textfield with Engg Department as input
@property (weak, nonatomic) IBOutlet UITextField *txtDepartment;
/// Textfield with Semester as input
@property (weak, nonatomic) IBOutlet UITextField *txtSemester;
/// Textfield with HSC % as input
@property (weak, nonatomic) IBOutlet UITextField *txtHSCPercentage;
/// Textfield with SSC % as input
@property (weak, nonatomic) IBOutlet UITextField *txtSSCPercentage;

#pragma mark - Objects used

/// Student Object with Personal & Academic Details
@property(strong,nonatomic)HSStudentDetailsModel *objStudentSelected;

@end
