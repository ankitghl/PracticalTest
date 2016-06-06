//
//  HSPersonalDetailsModel.m
//  HelpShift
//
//  Created by Ankit Gohel on 04/06/16.
//  Copyright © 2016 Ankit Gohel. All rights reserved.
//

#import "HSPersonalDetailsModel.h"

@implementation HSPersonalDetailsModel

-(instancetype)initWithName:(NSString *)fullname
                   andEmail:(NSString *)strEmailID
             andPhoneNumber:(NSString *)strPhn
                 andAddress:(NSString *)strAddr
            andGenderIfMale:(BOOL)gender
              andRollNumber:(int)iRN
{
    self = [super init];
    
    if (self)
    {
        self.strName        = fullname;
        self.strEmail       = strEmailID;
        self.strPhoneNumber = strPhn;
        self.strAddress     = strAddr;
        
        self.isMale         = gender;
        
        self.iRollNo        = iRN;
        
        self.strGender = (self.isMale) ? @"M" : @"F";
    }
    return self;

}
@end
