//
//  HSStudentDetails.h
//  HelpShift
//
//  Created by Ankit Gohel on 01/06/16.
//  Copyright © 2016 Ankit Gohel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HSPersonalDetailsModel;
@class HSAcademicDetailsModel;

@interface HSStudentDetailsModel : NSObject

/// Stores Personal Details
@property(strong,nonatomic)HSPersonalDetailsModel *objPersonalDetails;
/// Stores Academic Details
@property(strong,nonatomic)HSAcademicDetailsModel *objAcademicDetails;

-(instancetype)initWithPersonalDetails:(HSPersonalDetailsModel *)objPersonalDetails
                    andAcademicDetails:(HSAcademicDetailsModel *)objAcademicDetails;

@end
