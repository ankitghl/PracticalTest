//
//  HSDBManager.h
//  HelpShift
//
//  Created by Ankit Gohel on 01/06/16.
//  Copyright © 2016 Ankit Gohel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class HSStudentDetailsModel;

@interface HSDBManager : NSObject

@property (nonatomic, strong) NSString *documentsDirectory;

+(HSDBManager *)getSharedInstance;
-(instancetype)initWithDatabase;
-(BOOL)createStudentDetailsTable;
-(BOOL) saveStudent:(HSStudentDetailsModel *)objStudent;
-(NSArray *)getAllStudentDetails;
-(BOOL)updateStudentDetailsFor:(HSStudentDetailsModel *)objStudent;
-(BOOL)deleteStudent:(HSStudentDetailsModel *)objStudent;


@end
