//
//  GroupNotificationAddmember.m
//  EducationApp
//
//  Created by Happy Sanz Tech on 10/05/18.
//  Copyright © 2018 Palpro Tech. All rights reserved.
//

#import "GroupNotificationAddmember.h"

@interface GroupNotificationAddmember ()
{
    AppDelegate *appDel;
    NSMutableArray *selectorList;
    NSMutableArray *name;
    NSMutableArray *user_id;
    NSMutableArray *class_sec_id;
    NSMutableArray *class_section;
    NSString *selectorFlag;
}
@end

@implementation GroupNotificationAddmember

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    name = [[NSMutableArray alloc]init];
    user_id = [[NSMutableArray alloc]init];
    class_sec_id = [[NSMutableArray alloc]init];
    class_section = [[NSMutableArray alloc]init];
    selectorList = [[NSMutableArray alloc]init];
    [selectorList addObject:@"Teaching"];
    [selectorList addObject:@"Non-Teaching"];
    [selectorList addObject:@"Student/Parent"];
    _teacherTxtField.layer.borderColor = [UIColor colorWithRed:102/255.0f green:51/255.0f blue:102/255.0f alpha:1.0].CGColor;
    _teacherTxtField.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    _teacherTxtField.layer.borderWidth = 1.0f;
    [_teacherTxtField.layer setCornerRadius:10.0f];
    _studentTxtField.layer.borderColor = [UIColor colorWithRed:102/255.0f green:51/255.0f blue:102/255.0f alpha:1.0].CGColor;
    _studentTxtField.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    _studentTxtField.layer.borderWidth = 1.0f;
    [_studentTxtField.layer setCornerRadius:10.0f];
    self.titleTxtField.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"GN_Group_title"];
    self.leadName.text =  [[NSUserDefaults standardUserDefaults]objectForKey:@"GN_lead_name"];
    self.studentTxtField.hidden = YES;
    self.studentArrowImage.hidden = YES;
    appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    pickerView = [[UIPickerView alloc]init];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    toolbar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolbar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *done=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(SelectedTeacherName)];
    UIBarButtonItem *cancel=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(CancelButton)];
    UIBarButtonItem *spacePicker=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolbar setItems:[NSArray arrayWithObjects:cancel,spacePicker,done, nil]];
    [self.teacherTxtField setInputView:pickerView];
    [self.studentTxtField setInputView:pickerView];
    [self.teacherTxtField setInputAccessoryView:toolbar];
    [self.studentTxtField setInputAccessoryView:toolbar];

}
-(void)selectedValue
{
    if ([self.teacherTxtField.text isEqualToString:@"Teaching"])
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
        [parameters setObject:@"1" forKey:@"user_id"];
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        /* concordanate with baseurl */
        NSString *get_allteachersuserid = @"apiadmin/get_allteachersuserid";
        NSArray *components = [NSArray arrayWithObjects:baseUrl,appDel.institute_code,get_allteachersuserid, nil];
        NSString *api = [NSString pathWithComponents:components];
        
        
        [manager POST:api parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             
             NSLog(@"%@",responseObject);
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             NSString *msg = [responseObject objectForKey:@"msg"];
             [name removeAllObjects];
             [user_id removeAllObjects];
             if ([msg isEqualToString:@"Teacher Details"])
             {
                 NSArray *dataArray = [responseObject valueForKey:@"teacherList"];
                 for (int i = 0;i < [dataArray count];i++)
                 {
                     NSArray *Data = [dataArray objectAtIndex:i];
                     NSString *strName = [Data valueForKey:@"name"];
                     NSString *strUser_id = [Data valueForKey:@"user_id"];
                     
                     [name addObject:strName];
                     [user_id addObject:strUser_id];
                 }
                    [self.tableView reloadData];
             }
         }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
         {
             NSLog(@"error: %@", error);
         }];
    }
    else if ([self.teacherTxtField.text isEqualToString:@"Non-Teaching"])
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
        [parameters setObject:@"1" forKey:@"user_id"];
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        /* concordanate with baseurl */
        NSString *get_allstaffsuserid = @"apiadmin/get_allstaffsuserid";
        NSArray *components = [NSArray arrayWithObjects:baseUrl,appDel.institute_code,get_allstaffsuserid, nil];
        NSString *api = [NSString pathWithComponents:components];
        
        
        [manager POST:api parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             
             NSLog(@"%@",responseObject);
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             NSString *msg = [responseObject objectForKey:@"msg"];
             [name removeAllObjects];
             [user_id removeAllObjects];
             if ([msg isEqualToString:@"Teacher Details"])
             {
                 NSArray *dataArray = [responseObject valueForKey:@"staffList"];
                 for (int i = 0;i < [dataArray count];i++)
                 {
                     NSArray *Data = [dataArray objectAtIndex:i];
                     NSString *strName = [Data valueForKey:@"name"];
                     NSString *strUser_id = [Data valueForKey:@"user_id"];
                     
                     [name addObject:strName];
                     [user_id addObject:strUser_id];
                 }
                     [self.tableView reloadData];
             }
         }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
         {
             NSLog(@"error: %@", error);
         }];
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
        [parameters setObject:@"1" forKey:@"user_id"];
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        /* concordanate with baseurl */
        NSString *get_allstudentuserid = @"apiadmin/list_class_section";
        NSArray *components = [NSArray arrayWithObjects:baseUrl,appDel.institute_code,get_allstudentuserid, nil];
        NSString *api = [NSString pathWithComponents:components];
        
        
        [manager POST:api parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             
             NSLog(@"%@",responseObject);
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             NSString *msg = [responseObject objectForKey:@"msg"];
             [name removeAllObjects];
             [user_id removeAllObjects];
             if ([msg isEqualToString:@"Class and Sections"])
             {
                 NSArray *dataArray = [responseObject valueForKey:@"listClasssection"];
                 for (int i = 0;i < [dataArray count];i++)
                 {
                     NSArray *Data = [dataArray objectAtIndex:i];
                     NSString *strClass_sec_id = [Data valueForKey:@"class_sec_id"];
                     NSString *strClass_section = [Data valueForKey:@"class_section"];
                     
                     [class_sec_id addObject:strClass_sec_id];
                     [class_section addObject:strClass_section];
                 }
                     [pickerView reloadAllComponents];
             }
         }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
         {
             NSLog(@"error: %@", error);
         }];
    }
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == self->pickerView)
    {
        return 1;
    }
    
    return 0;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self->pickerView)
    {
        if([self.teacherTxtField isFirstResponder])
        {
            return [selectorList count];
        }
        else if ([self.studentTxtField isFirstResponder])
        {
            return [class_section count];
        }
    }
       return 0;
}
#pragma mark - UIPickerViewDelegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self->pickerView)
    {
        if([self.teacherTxtField isFirstResponder])
        {
            return selectorList[row];
        }
        else if ([self.studentTxtField isFirstResponder])
        {
            return class_section[row];
        }
    }
    return nil;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self->pickerView)
    {
        if([self.teacherTxtField isFirstResponder])
        {
            selectorFlag = selectorList[row];
        }
        else if ([self.studentTxtField isFirstResponder])
        {
            selectorFlag = class_section[row];
        }
    }
}
-(void)SelectedTeacherName
{
    if([self.teacherTxtField isFirstResponder])
    {
        self.teacherTxtField.text = selectorFlag;
        if ([selectorFlag isEqualToString:@"Student/Parent"])
        {
            self.studentTxtField.hidden = NO;
            self.studentArrowImage.hidden = NO;
            [self selectedValue];
        }
        else
        {
            self.studentTxtField.hidden = YES;
            self.studentArrowImage.hidden = YES;

            [self selectedValue];
        }
        [self.teacherTxtField resignFirstResponder];
    }
    else if ([self.studentTxtField isFirstResponder])
    {
        self.studentTxtField.text = selectorFlag;
        [self selectedValue];
        [self.studentTxtField resignFirstResponder];
    }
}
-(void)CancelButton
{
    if([self.teacherTxtField isFirstResponder])
    {
        [self.teacherTxtField resignFirstResponder];
    }
    else if ([self.studentTxtField isFirstResponder])
    {
        [self.studentTxtField resignFirstResponder];
    }
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [name count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupNotificationAddMenberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.nameLabel.text = [name objectAtIndex:indexPath.row];
    cell.teacherId.text = [user_id objectAtIndex:indexPath.row];
    return cell;
}
- (IBAction)backButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
