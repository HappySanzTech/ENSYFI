//
//  AdminNotificationTableViewCell.h
//  EducationApp
//
//  Created by Happy Sanz Tech on 28/03/18.
//  Copyright © 2018 Palpro Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdminNotificationTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *cellView;
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *decripLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end
