//
//  HSStudentDetails.m
//  HelpShift
//
//  Created by Ankit Gohel on 01/06/16.
//  Copyright © 2016 Ankit Gohel. All rights reserved.
//

#import "HSStudentDetailsModel.h"
#import "HSPersonalDetailsModel.h"
#import "HSAcademicDetailsModel.h"

@implementation HSStudentDetailsModel

-(instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.objPersonalDetails = [[HSPersonalDetailsModel alloc] init];
        
        self.objAcademicDetails = [[HSAcademicDetailsModel alloc] init];
    }
    return self;

}

-(instancetype)initWithPersonalDetails:(HSPersonalDetailsModel *)objPersonalDetails
                    andAcademicDetails:(HSAcademicDetailsModel *)objAcademicDetails
{
    self = [super init];
    
    if (self)
    {
        self.objPersonalDetails = [[HSPersonalDetailsModel alloc] initWithName:objPersonalDetails.strName andEmail:objPersonalDetails.strEmail andPhoneNumber:objPersonalDetails.strPhoneNumber andAddress:objPersonalDetails.strAddress andGenderIfMale:objPersonalDetails.isMale andRollNumber:objPersonalDetails.iRollNo];
        
        self.objAcademicDetails = [[HSAcademicDetailsModel alloc] initWithDepartment:objAcademicDetails.strDepartment andSemester:objAcademicDetails.strSemester andHSCPercentage:objAcademicDetails.strHSCPercentage andSSCPercentage:objAcademicDetails.strSSCPercentage];
    }
    return self;
 
}

@end
