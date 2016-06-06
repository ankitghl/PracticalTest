//
//  HSAcademicDetailsModel.m
//  HelpShift
//
//  Created by Ankit Gohel on 04/06/16.
//  Copyright © 2016 Ankit Gohel. All rights reserved.
//

#import "HSAcademicDetailsModel.h"

@implementation HSAcademicDetailsModel

-(instancetype)initWithDepartment:(NSString *)strDept
                      andSemester:(NSString *)strSem
                 andHSCPercentage:(NSString *)strHSCPer
                 andSSCPercentage:(NSString *)strSSCPer
{
    self = [super init];
    
    if (self)
    {
        self.strDepartment      = strDept;
        self.strSemester        = strSem;
        self.strHSCPercentage   = strHSCPer;
        self.strSSCPercentage   = strSSCPer;
        
    }
    return self;
}
@end
