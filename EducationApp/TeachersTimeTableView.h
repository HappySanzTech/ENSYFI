//
//  TeachersTimeTableView.h
//  EducationApp
//
//  Created by HappySanz on 12/10/17.
//  Copyright © 2017 Palpro Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@interface TeachersTimeTableView : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
- (IBAction)viewNotes:(id)sender;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarbutton;
@end
