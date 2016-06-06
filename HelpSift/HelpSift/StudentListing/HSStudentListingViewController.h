//
//  HSStudentListingViewController.h
//  HelpShift
//
//  Created by Ankit Gohel on 01/06/16.
//  Copyright © 2016 Ankit Gohel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSStudentListingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *vwFooter;
@property (weak, nonatomic) IBOutlet UITableView *tblStudentListing;
@end
