//
//  ViewGroupMembersViewController.h
//  EducationApp
//
//  Created by Happy Sanz Tech on 17/05/18.
//  Copyright © 2018 Palpro Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewGroupMembersViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backButton:(id)sender;

@end
