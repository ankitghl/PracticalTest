//
//  HSTestDatabase.m
//  HelpShift
//
//  Created by Ankit on 06/06/16.
//  Copyright © 2016 Ankit Gohel. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <sqlite3.h>

#import "HSStudentDetailsModel.h"
#import "HSPersonalDetailsModel.h"
#import "HSAcademicDetailsModel.h"

static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@interface HSTestDatabase : XCTestCase

@end

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

@implementation HSTestDatabase

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


-(NSString *)getDatabasePath
{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    XCTAssertTrue([[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"studentDetails.sqlite"]].length > 0, @"Database path must not be nil");
    
    // Build the path to the database file
    return [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"studentDetails.sqlite"]];
    
}

-(void)testCreateStudentDetailsTable
{
    int result = sqlite3_open([[self getDatabasePath] UTF8String], &database);
    
    XCTAssertEqual(SQLITE_OK, result, @"Failed to Open Database while creating table");
    
    if (result == SQLITE_OK)
    {
        char *errMsg;
        
        NSString *strSQLStmt = [NSString stringWithFormat:@"create table if not exists %@ (%@ integer primary key, %@ text, %@ text, %@ text, %@ text, %@ text, %@ text, %@ integer, %@ integer, %@ integer )",kTableName,kCol1,kCol2,kCol3,kCol4,kCol5,kCol6,kCol7,kCol8,kCol9,kCol10];
        
        const char *sql_stmt = [strSQLStmt UTF8String];
        
        result = sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg);
        
        XCTAssertEqual(SQLITE_OK, result, @"Failed to create Table :%s",errMsg);
    }
    result = sqlite3_close(database);

    XCTAssertEqual(SQLITE_OK, result, @"Failed to close db while creating table");

}

-(void)testCreatingDatabase
{
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    XCTAssertNotNil(filemgr, @"Filemanager should not be nil");
    
    if ([filemgr fileExistsAtPath: @"studentDetails.sqlite" ] == NO)
    {
         [self testCreateStudentDetailsTable];
    }
}

-(void)testSaveDetails
{
    const char *dbpath = [[self getDatabasePath] UTF8String];
    
    int result = sqlite3_open(dbpath, &database);
    
    XCTAssertEqual(SQLITE_OK, result, @"Failed to Open Database while saving student details");

    if (result == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"Insert into %@ (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values (?,?,?,?,?,?,?,?,?,?)",kTableName,kCol1, kCol2, kCol3, kCol4, kCol5, kCol6, kCol7, kCol8, kCol9, kCol10];
        
        const char *sqlDB = [insertSQL UTF8String];
        
        result = sqlite3_prepare_v2(database, sqlDB, -1, &statement, NULL);
        
        XCTAssertEqual(SQLITE_OK, result, @"Failed to execute prepare statement for saving record");
        
        XCTAssertEqual(SQLITE_OK, sqlite3_bind_text(statement, 2, [@"Ankit Gohel" UTF8String], -1, SQLITE_TRANSIENT), @"Binding failed for Name");
        sqlite3_bind_text(statement, 2, [@"Ankit Gohel" UTF8String], -1, SQLITE_TRANSIENT);
        
        sqlite3_bind_text(statement, 3, [@"ankit@gmail.com" UTF8String], -1, SQLITE_TRANSIENT);
        XCTAssertEqual(SQLITE_OK, sqlite3_bind_text(statement, 3, [@"ankit@gmail.com" UTF8String], -1, SQLITE_TRANSIENT), @"Binding failed for Email");

        sqlite3_bind_text(statement, 4, [@"9874563210" UTF8String], -1, SQLITE_TRANSIENT);
        XCTAssertEqual(SQLITE_OK, sqlite3_bind_text(statement, 4, [@"9874563210" UTF8String], -1, SQLITE_TRANSIENT), @"Binding failed for Phone Number");

        sqlite3_bind_text(statement, 5, [@"Jehan Circle, Nashik" UTF8String], -1, SQLITE_TRANSIENT);
        XCTAssertEqual(SQLITE_OK, sqlite3_bind_text(statement, 5, [@"Jehan Circle, Nashik" UTF8String], -1, SQLITE_TRANSIENT), @"Binding failed for Address");
        
        sqlite3_bind_text(statement, 6, [@"M" UTF8String], -1, SQLITE_TRANSIENT);
        XCTAssertEqual(SQLITE_OK, sqlite3_bind_text(statement, 6, [@"M" UTF8String], -1, SQLITE_TRANSIENT),
                       @"Binding failed for Gender");

        sqlite3_bind_text(statement, 7, [@"IT" UTF8String], -1, SQLITE_TRANSIENT);
        XCTAssertEqual(SQLITE_OK, sqlite3_bind_text(statement, 7, [@"IT" UTF8String], -1, SQLITE_TRANSIENT), @"Binding failed for Department");

        sqlite3_bind_int(statement, 8 , [@"7" intValue]);
        XCTAssertEqual(SQLITE_OK, sqlite3_bind_int(statement, 8 , [@"7" intValue]), @"Binding failed for Semester");

        sqlite3_bind_int(statement, 9 , [@"89.98" intValue]);
        XCTAssertEqual(SQLITE_OK, sqlite3_bind_int(statement, 9 , [@"89.98" intValue]), @"Binding failed for HSC Percentage");

        sqlite3_bind_int(statement, 10 , [@"91.56" intValue]);
        XCTAssertEqual(SQLITE_OK, sqlite3_bind_int(statement, 10 , [@"91.56" intValue]), @"Binding failed for SSC Percentage");

        result = sqlite3_step(statement);
        XCTAssertEqual(SQLITE_DONE, result, @"Failed to execute step for saving record");
        
        result = sqlite3_close(database);
    }
}



-(void)testUpdateStudentDetails
{
    const char *utf8Dbpath = [[self getDatabasePath] UTF8String];
    
    int result = sqlite3_open(utf8Dbpath, &database);
    
    XCTAssertEqual(SQLITE_OK, result, @"Failed to Open Database while updating student details");

    if (result == SQLITE_OK)
    {
        result = sqlite3_exec(database, "BEGIN", 0, 0, 0);
        
        XCTAssertEqual(SQLITE_OK, result, @"Failed to Open Transaction while updating student details");

        NSString *updateQuery = [NSString stringWithFormat:@"update %@ Set %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@' Where %@=%d",kTableName,kCol2,@"Ankit",kCol3,@"ankit@gmail.com",kCol4,@"9872827772",kCol5,@"Jehan Circle Nashik",kCol6,@"M",kCol7,@"IT",kCol8,@"7",kCol9,@"98.0",kCol10,@"99.98",kCol1,1];
        
        const char *utf8UpdateQuery = [updateQuery UTF8String];
        
        result = sqlite3_prepare_v2(database, utf8UpdateQuery, -1, &statement, NULL);
        XCTAssertEqual(SQLITE_OK, result, @"Failed to run prepare stmt while updating student details");

        result = sqlite3_step(statement);
        XCTAssertEqual(SQLITE_DONE, result, @"Failed to run step while updating student details");

        result = sqlite3_reset(statement);
        XCTAssertEqual(SQLITE_OK, result, @"Failed to reset while updating student details");

        result = sqlite3_finalize(statement);
        XCTAssertEqual(SQLITE_OK, result, @"Failed to finalise while updating student details");

        result = sqlite3_exec(database, "COMMIT", 0, 0, 0) ;
        XCTAssertEqual(SQLITE_OK, result, @"Failed to Commit Transaction while updating student details");

        result = sqlite3_close(database);
        XCTAssertEqual(SQLITE_OK, result, @"Failed to close DB while updating record");

    }
}



-(void)testDeleteStudent
{
    const char *utf8Dbpath = [[self getDatabasePath] UTF8String];
    
    int result = sqlite3_open(utf8Dbpath, &database);
    
    XCTAssertEqual(SQLITE_OK, result, @"Failed to Open Database while deleting student details");
    
    if (result == SQLITE_OK)
    {
        
        sqlite3_exec(database, "BEGIN", 0, 0, 0);
        XCTAssertEqual(SQLITE_OK, result, @"Failed to Open Transaction while deleting student details");

        NSString *querySQL = [NSString stringWithFormat: @"delete from %@ where %@='%d'",kTableName,kCol1,1];
        
        const char *updateStatement = [querySQL UTF8String];
        
        sqlite3_prepare_v2(database, updateStatement, -1, &statement, NULL);
        XCTAssertEqual(SQLITE_OK, result, @"Failed to run prepare stmt while deleting student details");

        result = sqlite3_step(statement);
        XCTAssertEqual(SQLITE_DONE, result, @"Failed to run step while deleting student details");

        result = sqlite3_reset(statement);
        XCTAssertEqual(SQLITE_OK, result, @"Failed to reset while deleting student details");
        
        result = sqlite3_finalize(statement);
        XCTAssertEqual(SQLITE_OK, result, @"Failed to finalise while deleting student details");
        
        result = sqlite3_exec(database, "COMMIT", 0, 0, 0) ;
        XCTAssertEqual(SQLITE_OK, result, @"Failed to Commit Transaction while deleting student details");
        
        sqlite3_close(database);
        XCTAssertEqual(SQLITE_OK, result, @"Failed to close DB while deleting record");

    }
}



@end
