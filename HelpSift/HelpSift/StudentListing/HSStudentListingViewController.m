//
//  HSStudentListingViewController.m
//  HelpShift
//
//  Created by Ankit Gohel on 01/06/16.
//  Copyright © 2016 Ankit Gohel. All rights reserved.
//

#import "HSStudentListingViewController.h"
#import "HSAddStudentViewController.h"
#import "HSDBManager.h"
#import "HSStudentDetailsModel.h"
#import "HSPersonalDetailsModel.h"
#import "HSAcademicDetailsModel.h"

@interface HSStudentListingViewController ()
{
    NSMutableArray *arrStudentDetails;
}
@end

@implementation HSStudentListingViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Students";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStyleDone target:self action:@selector(btnAddStudent:)];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /// Get all records and display if present
    arrStudentDetails = [[[HSDBManager getSharedInstance] getAllStudentDetails] mutableCopy];
    [self setUpTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Helpers

-(void)setUpTable
{
    /// Change scrolling state on arraycount 0
    [self.tblStudentListing setScrollEnabled:[arrStudentDetails count] > 0];
    [self.tblStudentListing reloadData];

    /// Change footer view as per count
    if (arrStudentDetails.count > 0)
    {
        [self.tblStudentListing setTableFooterView:[[UIView alloc] init]];
    }
    else
    {
        [self.tblStudentListing setTableFooterView:self.vwFooter];
    }
    
}
#pragma mark - Table View Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrStudentDetails count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCellIdentifier = @"cellIdentifier";
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:strCellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCellIdentifier];
    }
    
    HSStudentDetailsModel *objStudent = (HSStudentDetailsModel *)[arrStudentDetails objectAtIndex:indexPath.row];
    cell.textLabel.text       = objStudent.objPersonalDetails.strName;
    cell.detailTextLabel.text = objStudent.objAcademicDetails.strDepartment;
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}


#pragma mark - Table View Delegates

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /// Navigate to Add Student Screen
    UIStoryboard *sbMain = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    HSAddStudentViewController *vcAddStudent = [sbMain instantiateViewControllerWithIdentifier:@"HSAddStudentViewController"];
    vcAddStudent.objStudentSelected = (HSStudentDetailsModel *)[arrStudentDetails objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vcAddStudent animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < arrStudentDetails.count)
    {
        return UITableViewCellEditingStyleDelete;
    }
    else
    {
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /// Check count before attempt to delete
    if (indexPath.row < arrStudentDetails.count)
    {
        /// Delete record
        if ([[HSDBManager getSharedInstance] deleteStudent:[arrStudentDetails objectAtIndex:indexPath.row]])
        {
            /// Remove from local array
            [arrStudentDetails removeObject:[arrStudentDetails objectAtIndex:indexPath.row]];
            [self setUpTable];

            NSLog(@"Saved success");
            [[[UIAlertView alloc] initWithTitle:@"Student Application" message:@"Student details deleted successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
        else
        {
            NSLog(@"Saved failed");
            [[[UIAlertView alloc] initWithTitle:@"Student Application" message:@"Student details failed to delete" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            
        }
    }
}



#pragma mark - Button Events

-(IBAction)btnAddStudent:(id)sender
{
    UIStoryboard *sbMain = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    HSAddStudentViewController *vcAddStudent = [sbMain instantiateViewControllerWithIdentifier:@"HSAddStudentViewController"];
    
    [self.navigationController pushViewController:vcAddStudent animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];

}
@end
