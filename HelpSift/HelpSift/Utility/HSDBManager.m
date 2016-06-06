//
//  HSDBManager.m
//  HelpShift
//
//  Created by Ankit Gohel on 01/06/16.
//  Copyright © 2016 Ankit Gohel. All rights reserved.
//

#import "HSDBManager.h"
#import "HSStudentDetailsModel.h"
#import "HSPersonalDetailsModel.h"
#import "HSAcademicDetailsModel.h"

#define kTableName @"studentDetails"

#define kCol1   @"rollNo"
#define kCol2   @"name"
#define kCol3   @"email"
#define kCol4   @"phoneNumber"
#define kCol5   @"address"
#define kCol6   @"gender"
#define kCol7   @"department"
#define kCol8   @"semester"
#define kCol9   @"HSCPercentage"
#define kCol10  @"SSCPercentage"


static HSDBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

static NSString *studentTable = @"studentDetails.sqlite";

@implementation HSDBManager

+(HSDBManager *)getSharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        sharedInstance = [[self alloc] initWithDatabase];
    });
    return sharedInstance;
}


-(instancetype)initWithDatabase
{
    self = [super init];
    if (self)
    {
        if (![self createDatabase])
        {
            return nil;
        }
    }
    return self;
}

-(BOOL) createDatabase
{
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: studentTable ] == NO)
    {
        return [self createStudentDetailsTable];
    }
    return NO;
}


-(NSString *)getDatabasePath
{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    return [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: studentTable]];

}
#pragma mark - Private method implementation


-(BOOL)createStudentDetailsTable
{
    BOOL isSuccess = NO;
    if (sqlite3_open([[self getDatabasePath] UTF8String], &database) == SQLITE_OK)
    {
        char *errMsg;

        NSString *strSQLStmt = [NSString stringWithFormat:@"create table if not exists %@ (%@ integer primary key, %@ text, %@ text, %@ text, %@ text, %@ text, %@ text, %@ integer, %@ integer, %@ integer )",kTableName,kCol1,kCol2,kCol3,kCol4,kCol5,kCol6,kCol7,kCol8,kCol9,kCol10];

        const char *sql_stmt = [strSQLStmt UTF8String];
        
        if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            NSLog(@"Failed to create table");
            isSuccess = NO;
            
        }
        else
        {
            isSuccess = YES;
            NSLog(@"Created table for student details at path:- %@",[self getDatabasePath]);
        }

        sqlite3_close(database);
        
    }
    else
    {
        isSuccess = NO;

        NSLog(@"Failed to open/create database");
        
    }
    return isSuccess;
}



-(BOOL) saveStudent:(HSStudentDetailsModel *)objStudent
{
    BOOL isSuccess = NO;
    
    const char *dbpath = [[self getDatabasePath] UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"Insert into %@ (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values (?,?,?,?,?,?,?,?,?,?)",kTableName,kCol1, kCol2, kCol3, kCol4, kCol5, kCol6, kCol7, kCol8, kCol9, kCol10];

        const char *sqlDB = [insertSQL UTF8String];
        
        if(sqlite3_prepare_v2(database, sqlDB, -1, &statement, NULL) != SQLITE_OK)
            isSuccess = NO;
        
//        sqlite3_bind_int(statement, 1 , objStudent.iRollNo);
        sqlite3_bind_text(statement, 2, [objStudent.objPersonalDetails.strName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [objStudent.objPersonalDetails.strEmail UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [objStudent.objPersonalDetails.strPhoneNumber UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 5, [objStudent.objPersonalDetails.strAddress UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 6, [objStudent.objPersonalDetails.strGender UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 7, [objStudent.objAcademicDetails.strDepartment UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 8 , [objStudent.objAcademicDetails.strSemester intValue]);
        sqlite3_bind_int(statement, 9 , [objStudent.objAcademicDetails.strHSCPercentage intValue]);
        sqlite3_bind_int(statement, 10 , [objStudent.objAcademicDetails.strSSCPercentage intValue]);

        if(SQLITE_DONE != sqlite3_step(statement))
            isSuccess = NO;
        
        sqlite3_reset(statement);
        
        sqlite3_close(database);
        isSuccess = YES;
    }
    return isSuccess;
}


-(NSArray *)getAllStudentDetails
{
    //Retrieve the values of database
    const char *dbpath = [[self getDatabasePath] UTF8String];

    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSMutableArray *arrmStudent = [[NSMutableArray alloc] init];

        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM %@",kTableName];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database ,query_stmt , -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                HSStudentDetailsModel *studentDetails = [[HSStudentDetailsModel alloc] init];
                
                // Get Personal Details
                studentDetails.objPersonalDetails.iRollNo           = sqlite3_column_int(statement, 0);
                studentDetails.objPersonalDetails.strName           = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                studentDetails.objPersonalDetails.strEmail          = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                studentDetails.objPersonalDetails.strPhoneNumber    = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                studentDetails.objPersonalDetails.strAddress        = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                studentDetails.objPersonalDetails.strGender         = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                studentDetails.objPersonalDetails.isMale            = [studentDetails.objPersonalDetails.strGender isEqualToString:@"M"];

                // Get Academic Details
                studentDetails.objAcademicDetails.strDepartment     = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                studentDetails.objAcademicDetails.strSemester       = [NSString stringWithFormat:@"%d",sqlite3_column_int(statement, 7)];
                studentDetails.objAcademicDetails.strHSCPercentage  = [NSString stringWithFormat:@"%d",sqlite3_column_int(statement, 8)];
                studentDetails.objAcademicDetails.strSSCPercentage  = [NSString stringWithFormat:@"%d",sqlite3_column_int(statement, 9)];

                [arrmStudent addObject:studentDetails];
            }
            
            sqlite3_finalize(statement);
        }

        sqlite3_close(database);
        
        return [arrmStudent mutableCopy];
    }
    return @[];
}


-(BOOL)updateStudentDetailsFor:(HSStudentDetailsModel *)objStudent
{
    BOOL isSuccess = NO;
    
    const char *utf8Dbpath = [[self getDatabasePath] UTF8String];
    
    if (sqlite3_open(utf8Dbpath, &database) == SQLITE_OK)
    {
        sqlite3_exec(database, "BEGIN", 0, 0, 0);

        NSString *updateQuery = [NSString stringWithFormat:@"update %@ Set %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@' Where %@=%d",kTableName,kCol2,objStudent.objPersonalDetails.strName,kCol3,objStudent.objPersonalDetails.strEmail,kCol4,objStudent.objPersonalDetails.strPhoneNumber,kCol5,objStudent.objPersonalDetails.strAddress,kCol6,objStudent.objPersonalDetails.strGender,kCol7,objStudent.objAcademicDetails.strDepartment,kCol8,objStudent.objAcademicDetails.strSemester,kCol9,objStudent.objAcademicDetails.strHSCPercentage,kCol10,objStudent.objAcademicDetails.strSSCPercentage,kCol1,objStudent.objPersonalDetails.iRollNo];

        const char *utf8UpdateQuery = [updateQuery UTF8String];
        
        sqlite3_prepare_v2(database, utf8UpdateQuery, -1, &statement, NULL);
        
        isSuccess = (sqlite3_step(statement) == SQLITE_DONE);
        
        sqlite3_reset(statement);
        
        sqlite3_finalize(statement);
        
        if (sqlite3_exec(database, "COMMIT", 0, 0, 0) != SQLITE_OK)
        {
            NSLog(@"SQL Error: %s",sqlite3_errmsg(database));
            isSuccess = NO;
        }
        sqlite3_close(database);

    }

    return isSuccess;
}


    
-(BOOL)deleteStudent:(HSStudentDetailsModel *)objStudent
{
    BOOL isSuccess = NO;
    
    const char *utf8Dbpath = [[self getDatabasePath] UTF8String];
    
    if (sqlite3_open(utf8Dbpath, &database) == SQLITE_OK)
    {
        isSuccess = YES;

        sqlite3_exec(database, "BEGIN", 0, 0, 0);

        NSString *querySQL = [NSString stringWithFormat: @"delete from %@ where %@='%d'",kTableName,kCol1,objStudent.objPersonalDetails.iRollNo];

        const char *updateStatement = [querySQL UTF8String];

        sqlite3_prepare_v2(database, updateStatement, -1, &statement, NULL);

        isSuccess = (sqlite3_step(statement) == SQLITE_DONE);

        sqlite3_reset(statement);
        
        sqlite3_finalize(statement);
        
        if (sqlite3_exec(database, "COMMIT", 0, 0, 0) != SQLITE_OK)
        {
            NSLog(@"SQL Error: %s",sqlite3_errmsg(database));
            isSuccess = NO;
        }
        sqlite3_close(database);

    }
    return isSuccess;
}


@end
