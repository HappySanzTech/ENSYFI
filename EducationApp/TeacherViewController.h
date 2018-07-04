//
//  TeacherViewController.h
//  EducationApp
//
//  Created by HappySanz on 02/08/17.
//  Copyright © 2017 Palpro Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeacherViewController : UIViewController<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *mainView;
- (IBAction)classAssignmentBtn:(id)sender;
- (IBAction)classAttendanceBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *segCenterView;
@property (weak, nonatomic) IBOutlet UIView *segView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebar;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end
