//
//  AppDelegate.h
//  EducationApp
//
//  Created by HappySanz on 03/04/17.
//  Copyright © 2017 Palpro Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Webservice.h"
#import <Google/Analytics.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>



@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (strong, nonatomic) NSString *institute_name;
@property (strong, nonatomic) NSString *institute_id;
@property (strong, nonatomic) NSString *institute_code;
@property (strong, nonatomic) NSString *institute_logo;
@property (strong, nonatomic) NSString *user_name;
@property (strong, nonatomic) NSString *user_picture;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *user_type;
@property (strong, nonatomic) NSString *user_type_name;
@property (strong, nonatomic) NSString *admissionID;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *fatherName;
@property (strong, nonatomic) NSString *user_password;
@property (strong, nonatomic) NSString *father_pic;
@property (strong, nonatomic) NSString *class_id;
@property (strong, nonatomic) NSString *exam_id;
@property (strong, nonatomic) NSString *student_id;
@property (strong, nonatomic) NSString *section_id;

@property (strong, nonatomic) NSString *msg;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *parentId;
@property (strong, nonatomic) NSString *attendance_id;
@property (strong, nonatomic) NSString *last_attendance_id;
@property (strong, nonatomic) NSString *last_attendance_history_id;
@property (strong, nonatomic) NSString *classtestHomework_last_id;
- (void)saveContext;

@end

