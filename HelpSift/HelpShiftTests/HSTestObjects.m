//
//  HSTestObjects.m
//  HelpShift
//
//  Created by Ankit on 06/06/16.
//  Copyright © 2016 Ankit Gohel. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HSPersonalDetailsModel.h"
#import "HSAcademicDetailsModel.h"
#import "HSStudentDetailsModel.h"


@interface HSTestObjects : XCTestCase
{
    HSPersonalDetailsModel *objPersonal;
    HSAcademicDetailsModel *objAcademic;
}
@end

@implementation HSTestObjects

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testPersonalDetailsClassNil
{
    XCTAssertNil(objPersonal,@"HSPersonalDetailsModel object should be nil");
}


-(void)testPersonalDetailsClassTrue
{
    objPersonal = [[HSPersonalDetailsModel alloc] initWithName:@"ABC" andEmail:@"abc@gmail.com" andPhoneNumber:@"1234567890" andAddress:@"jehan Circle Nashik" andGenderIfMale:YES andRollNumber:1];
    
    XCTAssertNotNil(objPersonal,@"HSPersonalDetailsModel object should not be nil");
}

-(void)testAcademicDetailsNil
{
    XCTAssertNil(objAcademic,@"HSAcademicDetailsModel object should be nil");
}

-(void)testAcademicDetailsNotNil
{
    objAcademic = [[HSAcademicDetailsModel alloc] initWithDepartment:@"Information Technology" andSemester:@"5" andHSCPercentage:@"84.20" andSSCPercentage:@"88.52"];
    
    XCTAssertNotNil(objAcademic,@"HSAcademicDetailsModel object should not be nil");
}

-(void)testStudentDetailsNil
{
    HSStudentDetailsModel *objStudent;
    XCTAssertNil(objStudent,@"HSStudentDetailsModel object should be nil");
}

-(void)testStudentDetailsNotNil
{
    HSStudentDetailsModel *objStudent = [[HSStudentDetailsModel alloc] initWithPersonalDetails:objPersonal andAcademicDetails:objAcademic];
    XCTAssertNotNil(objStudent,@"HSStudentDetailsModel object should not be nil");
}


-(void)testEmailString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:@"ankit-gohel@gmail.com"];
    
    XCTAssertTrue(isValid,@"Email string should be valid");
}

@end
