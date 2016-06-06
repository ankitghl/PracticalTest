//
//  HSAcademicDetailsModel.h
//  HelpShift
//
//  Created by Ankit Gohel on 04/06/16.
//  Copyright © 2016 Ankit Gohel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSAcademicDetailsModel : NSObject

/// Stores Depatrment
@property(strong,nonatomic)NSString *strDepartment;
/// Stores Semester
@property(strong,nonatomic)NSString *strSemester;
/// Stores HSC Percentage
@property(strong,nonatomic)NSString *strHSCPercentage;
/// Stores SSC Percentage
@property(strong,nonatomic)NSString *strSSCPercentage;

-(instancetype)initWithDepartment:(NSString *)strDept
                      andSemester:(NSString *)strSem
                 andHSCPercentage:(NSString *)strHSCPer
                 andSSCPercentage:(NSString *)strSSCPer;

@end
