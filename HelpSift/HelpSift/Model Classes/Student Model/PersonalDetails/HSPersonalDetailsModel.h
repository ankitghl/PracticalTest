//
//  HSPersonalDetailsModel.h
//  HelpShift
//
//  Created by Ankit Gohel on 04/06/16.
//  Copyright © 2016 Ankit Gohel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSPersonalDetailsModel : NSObject

/// Stores Roll Number
@property(nonatomic)int iRollNo;
/// Stores Name
@property(strong,nonatomic)NSString *strName;
/// Stores Email
@property(strong,nonatomic)NSString *strEmail;
/// Stores Phone Number
@property(strong,nonatomic)NSString *strPhoneNumber;
/// Stores Address
@property(strong,nonatomic)NSString *strAddress;
/// Stores Gender in Bool
@property(nonatomic)BOOL isMale;
/// Stores Gender
@property(strong,nonatomic)NSString *strGender;

-(instancetype)initWithName:(NSString *)fullname
                   andEmail:(NSString *)strEmailID
             andPhoneNumber:(NSString *)strPhn
                 andAddress:(NSString *)strAddr
            andGenderIfMale:(BOOL)gender
              andRollNumber:(int)iRN;

@end
