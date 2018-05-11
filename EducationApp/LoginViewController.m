//
//  LoginViewController.m
//  EducationApp
//
//  Created by HappySanz on 06/04/17.
//  Copyright © 2017 Palpro Tech. All rights reserved.
//



#import "LoginViewController.h"
@interface LoginViewController ()
{
    AppDelegate *appDel;
    NSMutableArray *admission_id;
    NSMutableArray *admission_no;
    NSMutableArray *class_id;
    NSMutableArray *class_name;
    NSMutableArray *studentname;
    NSMutableArray *registered_id;
    NSMutableArray *sec_name;
    
    NSArray *docPaths;
    NSString *documentsDir;
    NSString *dbPath;
    FMDatabase *database;
    FMResultSet *rs;
}
@property(strong) Reachability * googleReach;
@property(strong) Reachability * localWiFiReach;
@property(strong) Reachability * internetConnectionReach;
@end
@implementation LoginViewController
- (void)viewDidLoad
{
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"LoginViewController"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    admission_id = [[NSMutableArray alloc]init];
    admission_no = [[NSMutableArray alloc]init];
    class_id = [[NSMutableArray alloc]init];
    class_name = [[NSMutableArray alloc]init];
    studentname = [[NSMutableArray alloc]init];
    registered_id = [[NSMutableArray alloc]init];
    sec_name = [[NSMutableArray alloc]init];

    _username.layer.borderColor = [UIColor colorWithRed:102/255.0f green:51/255.0f blue:102/255.0f alpha:1.0].CGColor;
    _username.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    _username.layer.borderWidth = 1.0f;
    [_username.layer setCornerRadius:10.0f];
    
    _password.layer.borderColor = [UIColor colorWithRed:102/255.0f green:51/255.0f blue:102/255.0f alpha:1.0].CGColor;
    _password.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    _password.layer.borderWidth = 1.0f;
    [_password.layer setCornerRadius:10.0f];
    
    _signInOtlet.layer.cornerRadius = 20; // this value vary as per your desire
    _signInOtlet.clipsToBounds = YES;

    self.schoolname.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"institute_name_Key"];
    [self.schoolname.text uppercaseString];
    [self.navigationController setNavigationBarHidden:YES];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(hideKeyBoard)];
    
    [self.view addGestureRecognizer:tapGesture];
    NSString *institute_main_logo = [[NSUserDefaults standardUserDefaults]objectForKey:@"institute_logo_url"];
    NSURL *url = [NSURL URLWithString:institute_main_logo];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    dispatch_async(dispatch_get_main_queue(), ^{
        
            self.logoImageView.image = [UIImage imageWithData:imageData];
            self.logoImageView.layer.cornerRadius = 50.0;
            self.logoImageView.clipsToBounds = YES;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
    _username.delegate = self;
    _password.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    __weak typeof(self) weakSelf = self;
    self.googleReach = [Reachability reachabilityWithHostname:@"www.google.com"];
    self.googleReach.reachableBlock = ^(Reachability * reachability)
    {
        NSString * temp = [NSString stringWithFormat:@"GOOGLE Block Says Reachable(%@)", reachability.currentReachabilityString];
        NSLog(@"%@", temp);
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            
        }];
    };
    self.googleReach.unreachableBlock = ^(Reachability * reachability)
    {
        NSString * temp = [NSString stringWithFormat:@"GOOGLE Block Says Unreachable(%@)", reachability.currentReachabilityString];
        NSLog(@"%@",temp);
        
        dispatch_async(dispatch_get_main_queue(),
                       ^{
            UIAlertController *alert= [UIAlertController
                                       alertControllerWithTitle:@"ENSYFI"
                                       message:@"Please Check Your Internet connection"
                                       preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     
                                 }];
            
            [alert addAction:ok];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        });
    };
    [self.googleReach startNotifier];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)signInBtn:(id)sender
{
    if ([self.username.text isEqualToString:@""])
    {
        UIAlertController *alert= [UIAlertController
                                   alertControllerWithTitle:@"ENSYFI"
                                   message:@"please type your username"
                                   preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 
                             }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if ([self.password.text isEqualToString:@""])
    {
        UIAlertController *alert= [UIAlertController
                                   alertControllerWithTitle:@"ENSYFI"
                                   message:@"please type your password"
                                   preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 
                             }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if (self.password.text.length > 6)
    {
        UIAlertController *alert= [UIAlertController
                                   alertControllerWithTitle:@"ENSYFI"
                                   message:@"password should be 6 characters"
                                   preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 
                             }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        NSString *deviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken_Key"];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
        [parameters setObject:self.username.text forKey:@"username"];
        [parameters setObject:self.password.text forKey:@"password"];
        [parameters setObject:deviceToken forKey:@"gcm_key"];
        [parameters setObject:@"2" forKey:@"mobile_type"];

        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        NSString *institute_code = [[NSUserDefaults standardUserDefaults]objectForKey:@"institute_code_Key"];
        NSArray *components = [NSArray arrayWithObjects:baseUrl,institute_code,user_Login_Api, nil];
        NSString *api = [NSString pathWithComponents:components];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [manager POST:api parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             NSLog(@"%@",responseObject);
             
             NSString *msg = [responseObject objectForKey:@"msg"];
             NSString *status = [responseObject objectForKey:@"status"];
             NSArray *userData = [responseObject objectForKey:@"userData"];
             NSArray *parentProfile = [responseObject objectForKey:@"parentProfile"];
             NSArray *fatherProfile = [parentProfile valueForKey:@"fatherProfile"];
             NSArray *guardianProfile = [parentProfile valueForKey:@"guardianProfile"];
             
             NSArray *motherProfile = [parentProfile valueForKey:@"motherProfile"];
             NSArray *teacherProfile = [parentProfile valueForKey:@"teacherProfile"];
             NSArray *registeredDetails = [responseObject objectForKey:@"registeredDetails"];

             NSLog(@"%@%@%@",msg,status,teacherProfile);
             
             if ([msg isEqualToString:@"User loggedIn successfully"])
             {
                 NSString *name = [userData valueForKey:@"name"];
                 NSString *password_status = [userData valueForKey:@"password_status"];
                 NSString *user_id = [userData valueForKey:@"user_id"];
                 NSString *user_name = [userData valueForKey:@"user_name"];
                 NSString *user_pic = [userData valueForKey:@"user_pic"];
                 NSString *user_type = [userData valueForKey:@"user_type"];
                 NSString *user_type_name = [userData valueForKey:@"user_type_name"];
                 
                 if ([user_type_name isEqualToString:@"Students"])
                 {
                     [[NSUserDefaults standardUserDefaults]setObject:@"Student_Login" forKey:@"Login_status"];
                     [[NSUserDefaults standardUserDefaults]setObject:name forKey:@"name_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:password_status forKey:@"password_status_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:user_name forKey:@"user_name_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:user_id forKey:@"user_id_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:user_pic forKey:@"user_pic_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:user_type forKey:@"user_type_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:user_type_name forKey:@"user_type_name_key"];
                     appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                     appDel.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id_key"];
                     appDel.user_type = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_type_key"];
                     appDel.user_type_name = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_type_name_key"];
                     appDel.user_name = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_name_key"];
                     appDel.user_password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password_status_key"];
                     appDel.user_picture = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_pic_key"];
                     appDel.name = [[NSUserDefaults standardUserDefaults]objectForKey:@"name_key"];
                
                     NSString *fatherEmail = [fatherProfile valueForKey:@"email"];
                     NSString *fHome_address = [fatherProfile valueForKey:@"home_address"];
                     NSString *fHome_phone = [fatherProfile valueForKey:@"home_phone"];
                     NSString *fId = [fatherProfile valueForKey:@"id"];
                     NSString *fIncome = [fatherProfile valueForKey:@"income"];
                     NSString *fMobile = [fatherProfile valueForKey:@"mobile"];
                     NSString *fName = [fatherProfile valueForKey:@"name"];
                     NSString *fOcupation = [fatherProfile valueForKey:@"occupation"];
                     NSString *fOffice_phone = [fatherProfile valueForKey:@"office_phone"];
                     NSString *fRelationship = [fatherProfile valueForKey:@"relationship"];
                     NSString *fUser_pic = [fatherProfile valueForKey:@"user_pic"];
                     [[NSUserDefaults standardUserDefaults]setObject:fatherEmail forKey:@"femail_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:fHome_address forKey:@"fhome_address_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:fHome_phone forKey:@"fhome_phone_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:fId forKey:@"fid_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:fIncome forKey:@"fincome_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:fMobile forKey:@"fmobile_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:fName forKey:@"fName_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:fOcupation forKey:@"fOcupation_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:fOffice_phone forKey:@"fOffice_phone_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:fRelationship forKey:@"fRelationship_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:fUser_pic forKey:@"fUser_pic_key"];
                     
                     NSString *gEmail = [guardianProfile valueForKey:@"email"];
                     NSString *g_Home_address = [guardianProfile valueForKey:@"home_address"];
                     NSString *gHome_phone = [guardianProfile valueForKey:@"home_phone"];
                     NSString *gId = [guardianProfile valueForKey:@"id"];
                     NSString *gIncome = [guardianProfile valueForKey:@"income"];
                     NSString *gMobile = [guardianProfile valueForKey:@"mobile"];
                     NSString *gName = [guardianProfile valueForKey:@"name"];
                     NSString *gOccupation = [guardianProfile valueForKey:@"occupation"];
                     NSString *gOffice_phone = [guardianProfile valueForKey:@"office_phone"];
                     NSString *gRelationship = [guardianProfile valueForKey:@"Relationship"];
                     NSString *gUser_pic = [guardianProfile valueForKey:@"user_pic"];
                     [[NSUserDefaults standardUserDefaults]setObject:gEmail forKey:@"gEmail_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:g_Home_address forKey:@"g_Home_address_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:gHome_phone forKey:@"gHome_phone_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:gId forKey:@"gId_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:gIncome forKey:@"gIncome_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:gMobile forKey:@"gMobile_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:gName forKey:@"gName_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:gOccupation forKey:@"gOccupation_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:gOffice_phone forKey:@"gOffice_phone_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:gRelationship forKey:@"gRelationship_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:gUser_pic forKey:@"gUser_pic_key"];
                     
                     NSString *mEmail = [motherProfile valueForKey:@"email"];
                     NSString *m_Home_address = [motherProfile valueForKey:@"home_address"];
                     NSString *mHome_phone = [motherProfile valueForKey:@"home_phone"];
                     NSString *mId = [motherProfile valueForKey:@"id"];
                     NSString *mIncome = [motherProfile valueForKey:@"income"];
                     NSString *mMobile = [motherProfile valueForKey:@"mobile"];
                     NSString *mName = [motherProfile valueForKey:@"name"];
                     NSString *mOccupation = [motherProfile valueForKey:@"occupation"];
                     NSString *mOffice_phone = [motherProfile valueForKey:@"Office_phone"];
                     NSString *mRelationship = [motherProfile valueForKey:@"Relationship"];
                     NSString *mUser_pic = [motherProfile valueForKey:@"user_pic"];
                     [[NSUserDefaults standardUserDefaults]setObject:mEmail forKey:@"mEmail_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:m_Home_address forKey:@"m_Home_address_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:mHome_phone forKey:@"mHome_phone_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:mId forKey:@"mId_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:mIncome forKey:@"mIncome_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:mMobile forKey:@"mMobile_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:mName forKey:@"mName_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:mOccupation forKey:@"mOccupation_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:mOffice_phone forKey:@"mOffice_phone_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:mRelationship forKey:@"mRelationship_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:mUser_pic forKey:@"mUser_pic_key"];
                     
                     for (int i = 0; i < [registeredDetails count]; i++)
                     {
                         NSDictionary *dictionary_Enrollment = [registeredDetails objectAtIndex:i];
                         NSString *stradmission_id = [dictionary_Enrollment objectForKey:@"admission_id"];
                         NSString *stradmission_no = [dictionary_Enrollment objectForKey:@"admission_no"];
                         NSString *strclass_id = [dictionary_Enrollment objectForKey:@"class_id"];
                         NSString *strclass_name = [dictionary_Enrollment objectForKey:@"class_name"];
                         NSString *strstudentname = [dictionary_Enrollment objectForKey:@"name"];
                         NSString *strregistered_id = [dictionary_Enrollment objectForKey:@"registered_id"];
                         NSString *strsec_name = [dictionary_Enrollment objectForKey:@"sec_name"];
                         [admission_id addObject:stradmission_id];
                         [admission_no addObject:stradmission_no];
                         [class_id addObject:strclass_id];
                         [class_name addObject:strclass_name];
                         [studentname addObject:strstudentname];
                         [registered_id addObject:strregistered_id];
                         [sec_name addObject:strsec_name];
                         [[NSUserDefaults standardUserDefaults]setObject:admission_id forKey:@"admission_id_arr"];
                         [[NSUserDefaults standardUserDefaults]setObject:admission_no forKey:@"admission_no_arr"];
                         [[NSUserDefaults standardUserDefaults]setObject:class_id forKey:@"class_id_arr"];
                         [[NSUserDefaults standardUserDefaults]setObject:class_name forKey:@"classname_arr"];
                         [[NSUserDefaults standardUserDefaults]setObject:studentname forKey:@"studentname_arr"];
                         [[NSUserDefaults standardUserDefaults]setObject:registered_id forKey:@"registered_id_arr"];
                         [[NSUserDefaults standardUserDefaults]setObject:sec_name forKey:@"sec_name_arr"];
                     }
                         [self performSegueWithIdentifier:@"studentInfo" sender:self];
                 }
                 
                 else if ([user_type_name isEqualToString:@"Parents"])
                 {
                     [[NSUserDefaults standardUserDefaults]setObject:@"Parents_Login" forKey:@"Login_status"];
                     [[NSUserDefaults standardUserDefaults]setObject:name forKey:@"name_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:password_status forKey:@"password_status_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:user_name forKey:@"user_name_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:user_id forKey:@"user_id_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:user_pic forKey:@"user_pic_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:user_type forKey:@"user_type_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:user_type_name forKey:@"user_type_name_key"];
                     appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                     appDel.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id_key"];
                     appDel.user_type = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_type_key"];
                     appDel.user_type_name = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_type_name_key"];
                     appDel.user_name = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_name_key"];
                     appDel.user_password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password_status_key"];
                     appDel.user_picture = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_pic_key"];
                     appDel.name = [[NSUserDefaults standardUserDefaults]objectForKey:@"name_key"];
                     /*fatherProfile*/
                     NSString *fatherEmail = [fatherProfile valueForKey:@"email"];
                     NSString *fHome_address = [fatherProfile valueForKey:@"home_address"];
                     NSString *fHome_phone = [fatherProfile valueForKey:@"home_phone"];
                     NSString *fId = [fatherProfile valueForKey:@"id"];
                     NSString *fIncome = [fatherProfile valueForKey:@"income"];
                     NSString *fMobile = [fatherProfile valueForKey:@"mobile"];
                     NSString *fName = [fatherProfile valueForKey:@"name"];
                     NSString *fOcupation = [fatherProfile valueForKey:@"occupation"];
                     NSString *fOffice_phone = [fatherProfile valueForKey:@"office_phone"];
                     NSString *fRelationship = [fatherProfile valueForKey:@"relationship"];
                     NSString *fUser_pic = [fatherProfile valueForKey:@"user_pic"];
                     [[NSUserDefaults standardUserDefaults]setObject:fatherEmail forKey:@"femail_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:fHome_address forKey:@"fhome_address_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:fHome_phone forKey:@"fhome_phone_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:fId forKey:@"fid_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:fIncome forKey:@"fincome_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:fMobile forKey:@"fmobile_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:fName forKey:@"fName_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:fOcupation forKey:@"fOcupation_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:fOffice_phone forKey:@"fOffice_phone_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:fRelationship forKey:@"fRelationship_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:fUser_pic forKey:@"fUser_pic_key"];
                     
                     NSString *gEmail = [guardianProfile valueForKey:@"email"];
                     NSString *g_Home_address = [guardianProfile valueForKey:@"home_address"];
                     NSString *gHome_phone = [guardianProfile valueForKey:@"home_phone"];
                     NSString *gId = [guardianProfile valueForKey:@"id"];
                     NSString *gIncome = [guardianProfile valueForKey:@"income"];
                     NSString *gMobile = [guardianProfile valueForKey:@"mobile"];
                     NSString *gName = [guardianProfile valueForKey:@"name"];
                     NSString *gOccupation = [guardianProfile valueForKey:@"occupation"];
                     NSString *gOffice_phone = [guardianProfile valueForKey:@"office_phone"];
                     NSString *gRelationship = [guardianProfile valueForKey:@"Relationship"];
                     NSString *gUser_pic = [guardianProfile valueForKey:@"user_pic"];
                     [[NSUserDefaults standardUserDefaults]setObject:gEmail forKey:@"gEmail_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:g_Home_address forKey:@"g_Home_address_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:gHome_phone forKey:@"gHome_phone_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:gId forKey:@"gId_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:gIncome forKey:@"gIncome_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:gMobile forKey:@"gMobile_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:gName forKey:@"gName_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:gOccupation forKey:@"gOccupation_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:gOffice_phone forKey:@"gOffice_phone_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:gRelationship forKey:@"gRelationship_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:gUser_pic forKey:@"gUser_pic_key"];
                    
                     NSString *mEmail = [motherProfile valueForKey:@"email"];
                     NSString *m_Home_address = [motherProfile valueForKey:@"home_address"];
                     NSString *mHome_phone = [motherProfile valueForKey:@"home_phone"];
                     NSString *mId = [motherProfile valueForKey:@"id"];
                     NSString *mIncome = [motherProfile valueForKey:@"income"];
                     NSString *mMobile = [motherProfile valueForKey:@"mobile"];
                     NSString *mName = [motherProfile valueForKey:@"name"];
                     NSString *mOccupation = [motherProfile valueForKey:@"occupation"];
                     NSString *mOffice_phone = [motherProfile valueForKey:@"Office_phone"];
                     NSString *mRelationship = [motherProfile valueForKey:@"Relationship"];
                     NSString *mUser_pic = [motherProfile valueForKey:@"user_pic"];
                     
                     [[NSUserDefaults standardUserDefaults]setObject:mEmail forKey:@"mEmail_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:m_Home_address forKey:@"m_Home_address_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:mHome_phone forKey:@"mHome_phone_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:mId forKey:@"mId_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:mIncome forKey:@"mIncome_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:mMobile forKey:@"mMobile_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:mName forKey:@"mName_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:mOccupation forKey:@"mOccupation_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:mOffice_phone forKey:@"mOffice_phone_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:mRelationship forKey:@"mRelationship_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:mUser_pic forKey:@"mUser_pic_key"];
                     for (int i = 0; i < [registeredDetails count]; i++)
                     {
                         NSDictionary *dictionary_Enrollment = [registeredDetails objectAtIndex:i];
                         NSString *stradmission_id = [dictionary_Enrollment objectForKey:@"admission_id"];
                         NSString *stradmission_no = [dictionary_Enrollment objectForKey:@"admission_no"];
                         NSString *strclass_id = [dictionary_Enrollment objectForKey:@"class_id"];
                         NSString *strclass_name = [dictionary_Enrollment objectForKey:@"class_name"];
                         NSString *strstudentname = [dictionary_Enrollment objectForKey:@"name"];
                         NSString *strregistered_id = [dictionary_Enrollment objectForKey:@"registered_id"];
                         NSString *strsec_name = [dictionary_Enrollment objectForKey:@"sec_name"];
                         
                         [admission_id addObject:stradmission_id];
                         [admission_no addObject:stradmission_no];
                         [class_id addObject:strclass_id];
                         [class_name addObject:strclass_name];
                         [studentname addObject:strstudentname];
                         [registered_id addObject:strregistered_id];
                         [sec_name addObject:strsec_name];
                         
                         [[NSUserDefaults standardUserDefaults]setObject:admission_id forKey:@"admission_id_arr"];
                         [[NSUserDefaults standardUserDefaults]setObject:admission_no forKey:@"admission_no_arr"];
                         [[NSUserDefaults standardUserDefaults]setObject:class_id forKey:@"class_id_arr"];
                         [[NSUserDefaults standardUserDefaults]setObject:class_name forKey:@"classname_arr"];
                         [[NSUserDefaults standardUserDefaults]setObject:studentname forKey:@"studentname_arr"];
                         [[NSUserDefaults standardUserDefaults]setObject:registered_id forKey:@"registered_id_arr"];
                         [[NSUserDefaults standardUserDefaults]setObject:sec_name forKey:@"sec_name_arr"];
                     }
                     [self performSegueWithIdentifier:@"studentInfo" sender:self];
                 }
                 else if ([user_type_name isEqualToString:@"Admin"])
                 {
                     [[NSUserDefaults standardUserDefaults]setObject:@"Admin_Login" forKey:@"Login_status"];
                     NSString *name = [userData valueForKey:@"name"];
                     NSString *password_status = [userData valueForKey:@"password_status"];
                     NSString *user_id = [userData valueForKey:@"user_id"];
                     NSString *user_name = [userData valueForKey:@"user_name"];
                     NSString *user_pic = [userData valueForKey:@"user_pic"];
                     NSString *user_type = [userData valueForKey:@"user_type"];
                     NSString *user_type_name = [userData valueForKey:@"user_type_name"];
                 
                     [[NSUserDefaults standardUserDefaults]setObject:name forKey:@"name_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:password_status forKey:@"password_status_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:user_name forKey:@"user_name_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:user_id forKey:@"user_id_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:user_pic forKey:@"user_pic_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:user_type forKey:@"user_type_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:user_type_name forKey:@"user_type_name_key"];
                     
                     appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                     appDel.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id_key"];
                     appDel.user_type = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_type_key"];
                     appDel.user_type_name = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_type_name_key"];
                     appDel.user_name = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_name_key"];
                     appDel.user_password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password_status_key"];
                     appDel.user_picture = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_pic_key"];
                     appDel.name = [[NSUserDefaults standardUserDefaults]objectForKey:@"name_key"];
                     
                     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"admin" bundle:nil];
                     SWRevealViewController *exam = (SWRevealViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewControllerAdmin"];
                     [self.navigationController pushViewController:exam animated:YES];
                 }
                 else if ([user_type_name isEqualToString:@"Teachers"])
                 {
                     BOOL isInserted;
                     BOOL isdeleted;
                     docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                     documentsDir = [docPaths objectAtIndex:0];
                     dbPath = [documentsDir stringByAppendingPathComponent:@"ENSIFY.db"];
                     database = [FMDatabase databaseWithPath:dbPath];
                     [database open];
                     isInserted = [database executeUpdate:@"DELETE FROM table_create_attendence_history"];
                     if(isInserted)
                         NSLog(@"Deleted table_create_attendence_history");
                     else
                         NSLog(@"Error occured while Deleting");
                     [database close];
                     
                     docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                     documentsDir = [docPaths objectAtIndex:0];
                     dbPath = [documentsDir stringByAppendingPathComponent:@"ENSIFY.db"];
                     database = [FMDatabase databaseWithPath:dbPath];
                     [database open];
                     
                     isInserted = [database executeUpdate:@"DELETE FROM table_create_attendence"];
                     
                     if(isInserted)
                         NSLog(@"Deleted table_create_attendence");
                     else
                         NSLog(@"Error occured while Deleting");
                     
                     [database close];

                     [[NSUserDefaults standardUserDefaults]setObject:@"Teacher_Login" forKey:@"Login_status"];
                     NSString *name = [userData valueForKey:@"name"];
                     NSString *password_status = [userData valueForKey:@"password_status"];
                     NSString *user_id = [userData valueForKey:@"user_id"];
                     NSString *user_name = [userData valueForKey:@"user_name"];
                     NSString *user_pic = [userData valueForKey:@"user_pic"];
                     NSString *user_type = [userData valueForKey:@"user_type"];
                     NSString *user_type_name = [userData valueForKey:@"user_type_name"];
                     
                     [[NSUserDefaults standardUserDefaults]setObject:name forKey:@"name_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:password_status forKey:@"password_status_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:user_name forKey:@"user_name_key"];
                     
                     [[NSUserDefaults standardUserDefaults]setObject:user_id forKey:@"user_id_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:user_pic forKey:@"user_pic_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:user_type forKey:@"user_type_key"];
                     [[NSUserDefaults standardUserDefaults]setObject:user_type_name forKey:@"user_type_name_key"];
                     
                     appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                     appDel.user_name = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_name_key"];
                     appDel.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id_key"];
                     appDel.user_type = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_type_key"];
                     appDel.user_type_name = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_type_name_key"];
                     appDel.user_password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password_status_key"];
                     appDel.user_picture = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_pic_key"];
                     appDel.name = [[NSUserDefaults standardUserDefaults]objectForKey:@"name_key"];
                     
                     NSArray *exam = [responseObject objectForKey:@"Exams"];
                     NSArray *data = [exam valueForKey:@"data"];
                     NSArray *academic_marks = [responseObject objectForKey:@"academic_marks"];
                     NSArray *academic_month = [responseObject objectForKey:@"academic_month"];
                     NSArray *classSubject = [responseObject objectForKey:@"classSubject"];
                     NSArray *dataclassSubject = [classSubject valueForKey:@"data"];
                     NSArray *examDetails = [responseObject objectForKey:@"examDetails"];
                     NSArray *dataexamdetails = [examDetails valueForKey:@"data"];
                     NSArray *homeWork = [responseObject objectForKey:@"homeWork"];
                     NSArray *datahomework = [homeWork valueForKey:@"data"];
                     NSArray *studDetails = [responseObject objectForKey:@"studDetails"];
                     NSArray *datastudDetails = [studDetails valueForKey:@"data"];
                     NSArray *timeTable = [responseObject objectForKey:@"timeTable"];
                     NSArray *datatimeTable = [timeTable valueForKey:@"data"];
                     NSString *year_id = [responseObject objectForKey:@"year_id"];
                     [[NSUserDefaults standardUserDefaults]setObject:year_id forKey:@"Year_Id_key"];
                     NSLog(@"%@%@",exam,year_id);
                     
                     for (int i = 0; i < [data count]; i++)
                     {
                         NSDictionary *dict = [data objectAtIndex:i];
                         NSLog(@"%@",dict);
                         NSString *strFromdate = [dict objectForKey:@"Fromdate"];
                         NSString *strTodate = [dict objectForKey:@"Todate"];
                         NSString *strMarkStatus = [dict objectForKey:@"MarkStatus"];
                         NSString *strclass_name = [dict objectForKey:@"class_name"];
                         NSString *strclassmaster_id = [dict objectForKey:@"classmaster_id"];
                         NSString *strexam_id = [dict objectForKey:@"exam_id"];
                         NSString *strexam_name = [dict objectForKey:@"exam_name"];
                         NSString *stris_internal_external = [dict objectForKey:@"is_internal_external"];
                         NSString *strsec_name = [dict objectForKey:@"sec_name"];

                         docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                         documentsDir = [docPaths objectAtIndex:0];
                         dbPath = [documentsDir   stringByAppendingPathComponent:@"ENSIFY.db"];
                         database = [FMDatabase databaseWithPath:dbPath];
                         [database open];
                         
                         isInserted = [database executeUpdate:@"INSERT INTO table_create_exams_of_the_class (exam_id,exam_name,is_internal_external,Fromdate,Todate,class_name,classmaster_id,sec_name,MarkStatus) VALUES (?,?,?,?,?,?,?,?,?)",strexam_id,strexam_name,stris_internal_external,strFromdate,strTodate,strclass_name,strclassmaster_id,strsec_name,strMarkStatus];
                         
                         if(isInserted)
                             NSLog(@"Inserted Successfully in table_create_exams_of_the_class ");
                         else
                             NSLog(@"Error occured while inserting");
                         
                         [database close];

                       }
                       for (int i = 0; i < [academic_marks count]; i++)
                       {
                         NSArray *arr_academic_marks = [academic_month objectAtIndex:i];
                         NSLog(@"%@",arr_academic_marks);
                       }
                     
                     docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                     documentsDir = [docPaths objectAtIndex:0];
                     dbPath = [documentsDir stringByAppendingPathComponent:@"ENSIFY.db"];
                     database = [FMDatabase databaseWithPath:dbPath];
                     [database open];
                     isdeleted =[database executeUpdate:@"DELETE FROM table_create_academic_months"];
                     
                     if(isdeleted)
                         NSLog(@"Deleted Successfully");
                     else
                         NSLog(@"Error occured while deleting");
                     
                     [database close];
                     
                     for (int i = 0; i < [academic_month count]; i++)
                     {
                         NSString *str_month = [academic_month objectAtIndex:i];
                         NSLog(@"%@",str_month);
                         docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                         documentsDir = [docPaths objectAtIndex:0];
                         dbPath = [documentsDir   stringByAppendingPathComponent:@"ENSIFY.db"];
                         database = [FMDatabase databaseWithPath:dbPath];
                         [database open];
                         
                         isInserted = [database executeUpdate:@"INSERT INTO table_create_academic_months (academic_months) VALUES (?)",str_month];
                         
                         if(isInserted)
                             NSLog(@"Inserted Successfully in table_academic_months");
                         else
                             NSLog(@"Error occured while inserting");
                         
                         [database close];
                     }
                     
                     docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                     documentsDir = [docPaths objectAtIndex:0];
                     dbPath = [documentsDir stringByAppendingPathComponent:@"ENSIFY.db"];
                     database = [FMDatabase databaseWithPath:dbPath];
                     [database open];
                     isdeleted = [database executeUpdate:@"DELETE FROM table_create_teacher_handling_subjects"];
                     
                     if(isdeleted)
                         NSLog(@"Delete handling_subjects Successfully");
                     else
                         NSLog(@"Error occured while deleting");
                     
                     [database close];
                     
                     for (int i = 0; i < [dataclassSubject count]; i++)
                     {
                         NSDictionary *dict = [dataclassSubject objectAtIndex:i];
                         NSLog(@"%@",dict);

                         NSString *strclass_master_id = [dict objectForKey:@"class_master_id"];
                         NSString *strclass_name = [dict objectForKey:@"class_name"];
                         NSString *strsec_name = [dict objectForKey:@"sec_name"];
                         NSString *strsubject_id = [dict objectForKey:@"subject_id"];
                         NSString *strsubject_name = [dict objectForKey:@"subject_name"];
                         NSString *strteacher_id = [dict objectForKey:@"teacher_id"];
                         
                         [[NSUserDefaults standardUserDefaults]setObject:strteacher_id forKey:@"strteacher_id_key"];
                         NSLog(@"%@",strteacher_id);
                         [[NSUserDefaults standardUserDefaults]setObject:strteacher_id forKey:@"admin_teacherid"];
                         
                         docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                         documentsDir = [docPaths objectAtIndex:0];
                         dbPath = [documentsDir stringByAppendingPathComponent:@"ENSIFY.db"];
                         database = [FMDatabase databaseWithPath:dbPath];
                         [database open];
                         
                         isInserted=[database executeUpdate:@"INSERT INTO table_create_teacher_handling_subjects (class_master_id,class_name,sec_name,subject_id,subject_name,teacher_id) VALUES (?,?,?,?,?,?)",strclass_master_id,strclass_name,strsec_name,strsubject_id,strsubject_name,strteacher_id];
                         
                         if(isInserted)
                             NSLog(@"Inserted Successfully in table_create_teacher_handling_subjects");
                         else
                             NSLog(@"Error occured while inserting");
                         [database close];
                     }
                     
                     docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                     documentsDir = [docPaths objectAtIndex:0];
                     dbPath = [documentsDir stringByAppendingPathComponent:@"ENSIFY.db"];
                     database = [FMDatabase databaseWithPath:dbPath];
                     [database open];
                     isdeleted=[database executeUpdate:@"DELETE FROM table_create_exams_details"];
                     
                     if(isdeleted)
                         NSLog(@"Deleted table_create_exams_details Successfully");
                     else
                         NSLog(@"Error occured while deleting");
                     
                     [database close];

                     for (int i = 0; i < [dataexamdetails count]; i++)
                     {
                         NSDictionary *dict = [dataexamdetails objectAtIndex:i];
                         NSLog(@"%@",dict);
                         NSString *strclass_name = [dict objectForKey:@"class_name"];
                         NSString *strclassmaster_id = [dict objectForKey:@"classmaster_id"];
                         NSString *strexam_date = [dict objectForKey:@"exam_date"];
                         NSString *strexam_id = [dict objectForKey:@"exam_id"];
                         NSString *strexam_name = [dict objectForKey:@"exam_name"];
                         NSString *strsec_name = [dict objectForKey:@"sec_name"];
                         NSString *strsubject_name = [dict objectForKey:@"subject_name"];
                         NSString *strtimes = [dict objectForKey:@"times"];
                         NSString *strexternal_mark = [dict objectForKey:@"external_mark"];
                         NSString *strinternal_mark = [dict objectForKey:@"internal_mark"];
                         NSString *stris_internal_external = [dict objectForKey:@"is_internal_external"];
                         NSString *strSubject_total = [dict objectForKey:@"subject_total"];
                         NSString *strsubject_id = [dict objectForKey:@"subject_id"];
                         
                         docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                         documentsDir = [docPaths objectAtIndex:0];
                         dbPath = [documentsDir stringByAppendingPathComponent:@"ENSIFY.db"];
                         database = [FMDatabase databaseWithPath:dbPath];
                         [database open];
                         
                         isInserted=[database executeUpdate:@"INSERT INTO table_create_exams_details (class_name,classmaster_id,exam_date,exam_id,exam_name,sec_name,subject_name,times,external_mark,internal_mark,is_internal_external,subject_total,subject_id) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)",strclass_name,strclassmaster_id,strexam_date,strexam_id,strexam_name,strsec_name,strsubject_name,strtimes,strexternal_mark,strinternal_mark,stris_internal_external,strSubject_total,strsubject_id];
                         
                         if(isInserted)
                             NSLog(@"Inserted Successfully in table_create_exams_details");
                         else
                             NSLog(@"Error occured while inserting");

                         [database close];

                     }
                     
                     NSDate *today = [NSDate date];
                     NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                     [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                     NSString *dateString = [dateFormat stringFromDate:today];
                     
                     docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                     documentsDir = [docPaths objectAtIndex:0];
                     dbPath = [documentsDir stringByAppendingPathComponent:@"ENSIFY.db"];
                     database = [FMDatabase databaseWithPath:dbPath];
                     [database open];
                     
                     isdeleted = [database executeUpdate:@"DELETE FROM table_create_homework_class_test"];
                     
                     if(isdeleted)
                         NSLog(@"Deleted table_create_homework_class_test Successfully");
                     else
                         NSLog(@"Error occured while deleting");
                     
                     [database close];

                     for (int i = 0; i < [datahomework count]; i++)
                     {
                         NSDictionary *dict = [datahomework objectAtIndex:i];
                         NSArray *user_date = [responseObject objectForKey:@"userData"];
                         NSString *user_id = [user_date valueForKey:@"user_id"];
                         NSString *year_id = [responseObject valueForKey:@"year_id"];
                         [[NSUserDefaults standardUserDefaults]setObject:year_id forKey:@"Year_Id_key"];
                         NSString *strhw_id = [dict objectForKey:@"hw_id"];
                         NSString *strclass_id = [dict objectForKey:@"class_id"];
                         NSString *strclass_name = [dict objectForKey:@"class_name"];
                         NSLog(@"%@",strclass_name);
                         NSString *strdue_date = [dict objectForKey:@"due_date"];
                         NSString *strhw_details = [dict objectForKey:@"hw_details"];
                         NSString *strhw_type = [dict objectForKey:@"hw_type"];
                         NSString *strmark_status = [dict objectForKey:@"mark_status"];
                         NSString *strsec_name = [dict objectForKey:@"sec_name"];
                         NSLog(@"%@",strsec_name);
                         NSString *strsubject_id = [dict objectForKey:@"subject_id"];
                         NSString *strsubject_name = [dict objectForKey:@"subject_name"];
                         NSString *strteacher_id = [dict objectForKey:@"teacher_id"];
                         NSString *strtest_date = [dict objectForKey:@"test_date"];
                         NSString *strtitle = [dict objectForKey:@"title"];

                         docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                         documentsDir = [docPaths objectAtIndex:0];
                         dbPath = [documentsDir   stringByAppendingPathComponent:@"ENSIFY.db"];
                         database = [FMDatabase databaseWithPath:dbPath];
                         [database open];
                         
                         isInserted=[database executeUpdate:@"INSERT INTO table_create_homework_class_test (server_hw_id,year_id,class_id,teacher_id,hw_type,subject_id,subject_name,title,test_date,due_date,hw_details,status,mark_status,created_by,created_at,updated_by,updated_at,sync_status) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",strhw_id,year_id,strclass_id,strteacher_id,strhw_type,strsubject_id,strsubject_name,strtitle,strtest_date,strdue_date,strhw_details,@"",strmark_status,user_id,dateString,user_id,dateString,@"S"];
                         
                         if(isInserted)
                             NSLog(@"Inserted Successfully in table_create_homework_class_test");
                         else
                             NSLog(@"Error occured while inserting");
                         
                         [database close];

                     }
                     docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                     documentsDir = [docPaths objectAtIndex:0];
                     dbPath = [documentsDir stringByAppendingPathComponent:@"ENSIFY.db"];
                     database = [FMDatabase databaseWithPath:dbPath];
                     [database open];
                     
                     isdeleted = [database executeUpdate:@"DELETE FROM table_create_teacher_student_details"];
                     
                     if(isdeleted)
                         NSLog(@"Deleted teacher_student_details Successfully");
                     else
                         NSLog(@"Error occured while deleting");
                     
                     [database close];
                     
                     for (int i = 0 ; i < [datastudDetails count]; i++)
                     {
                         NSDictionary *dict = [datastudDetails objectAtIndex:i];
                         NSString *stradmission_id = [dict objectForKey:@"admission_id"];
                         NSString *strclass_id = [dict objectForKey:@"class_id"];
                         NSString *strclass_section = [dict objectForKey:@"class_section"];
                         NSString *strenroll_id = [dict objectForKey:@"enroll_id"];
                         NSString *strname = [dict objectForKey:@"name"];
                         NSString *strpref_language = [dict objectForKey:@"pref_language"];

                         docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                         documentsDir = [docPaths objectAtIndex:0];
                         dbPath = [documentsDir   stringByAppendingPathComponent:@"ENSIFY.db"];
                         database = [FMDatabase databaseWithPath:dbPath];
                         [database open];
                         
                         isInserted = [database executeUpdate:@"INSERT INTO table_create_teacher_student_details (enroll_id,admission_id,class_id,name,class_section,pref_language) VALUES (?,?,?,?,?,?)",strenroll_id,stradmission_id,strclass_id,strname,strclass_section,strpref_language];
                         
                         if(isInserted)
                             NSLog(@"Inserted Successfully in table_create_teacher_student_details");
                         else
                             NSLog(@"Error occured while inserting");
                         
                         [database close];
                     }
                     
                     docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                     documentsDir = [docPaths objectAtIndex:0];
                     dbPath = [documentsDir stringByAppendingPathComponent:@"ENSIFY.db"];
                     database = [FMDatabase databaseWithPath:dbPath];
                     [database open];
                     
                     isdeleted = [database executeUpdate:@"DELETE FROM table_create_teacher_timetable"];
                     
                     if(isdeleted)
                         NSLog(@"DELETED teacher_timetable Successfully");
                     else
                         NSLog(@"Error occured while deleting");
                     
                     [database close];

                     for (int i = 0 ; i < [datatimeTable count]; i++)
                     {
                         NSDictionary *dict = [datatimeTable objectAtIndex:i];
                         NSString *strtable_id = [dict objectForKey:@"table_id"];
                         NSString *strclass_id = [dict objectForKey:@"class_id"];
                         NSString *strsubject_id = [dict objectForKey:@"subject_id"];
                         NSString *strsubject_name = [dict objectForKey:@"subject_name"];
                         NSString *strteacher_id = [dict objectForKey:@"teacher_id"];
                         NSString *strname = [dict objectForKey:@"name"];
                         NSString *strday = [dict objectForKey:@"day"];
                         NSString *strperiod = [dict objectForKey:@"period"];
                         NSString *strsec_name = [dict objectForKey:@"sec_name"];
                         NSString *strclass_name = [dict objectForKey:@"class_name"];

                         docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                         documentsDir = [docPaths objectAtIndex:0];
                         dbPath = [documentsDir   stringByAppendingPathComponent:@"ENSIFY.db"];
                         database = [FMDatabase databaseWithPath:dbPath];
                         [database open];
                         
                         isInserted=[database executeUpdate:@"INSERT INTO table_create_teacher_timetable (table_id,class_id,subject_id,subject_name,teacher_id,name,day,period,sec_name,class_name) VALUES (?,?,?,?,?,?,?,?,?,?)",strtable_id,strclass_id,strsubject_id,strsubject_name,strteacher_id,strname,strday,strperiod,strsec_name,strclass_name];
                         
                         if(isInserted)
                             NSLog(@"Inserted Successfully in table_create_teacher_timetable");
                         else
                             NSLog(@"Error occured while inserting");
                         
                         [database close];

                     }
                     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"teachers" bundle:nil];
                     SWRevealViewController *teacher = (SWRevealViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewControllerTeacher"];
                     [self.navigationController pushViewController:teacher animated:YES];
                 }
                 NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"forgotPasswordKey"];
                 if ([str isEqualToString:@"Yes"])
                 {
                     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                     NewPasswordController *newPasswordController = (NewPasswordController *)[storyboard instantiateViewControllerWithIdentifier:@"newPasswordController"];
                     [self.navigationController pushViewController:newPasswordController animated:YES];
                 }
             }
             else
             {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 UIAlertController *alert= [UIAlertController
                                            alertControllerWithTitle:@"ENSYFI"
                                            message:@"username or password is incorrect"
                                            preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction *ok = [UIAlertAction
                                      actionWithTitle:@"OK"
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * action)
                                      {
                                          
                                      }];
                 
                 [alert addAction:ok];
                 [self presentViewController:alert animated:YES completion:nil];
                 self.username.text = @"";
                 self.password.text = @"";
             }
         }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
         {
             NSLog(@"error: %@", error);
         }];
    }
}
- (IBAction)forgotPaswrdBtn:(id)sender
{
    [self performSegueWithIdentifier:@"to_forgot" sender:self];
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    if (theTextField == self.username)
    {
        [_password becomeFirstResponder];
    }
    else if (theTextField == self.password)
    {
        [theTextField resignFirstResponder];
    }
    return YES;
}
- (void)keyboardWasShown:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    UIEdgeInsets contentInset = self.scrollview.contentInset;
    contentInset.bottom = keyboardRect.size.height;
    self.scrollview.contentInset = contentInset;
}
- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollview.contentInset = contentInsets;
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return NO;
}
-(void)hideKeyBoard
{
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
}
@end
