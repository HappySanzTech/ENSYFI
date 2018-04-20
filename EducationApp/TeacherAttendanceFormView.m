 //
//  TeacherAttendanceFormView.m
//  EducationApp
//
//  Created by HappySanz on 03/10/17.
//  Copyright © 2017 Palpro Tech. All rights reserved.
//

#import "TeacherAttendanceFormView.h"

@interface TeacherAttendanceFormView ()
{
    NSArray *stat;
    NSArray *dynamic;
    NSMutableArray *classNameArr;
    NSMutableArray *name;
    NSString *textStr;
    NSMutableArray *result;
    NSMutableArray *tablearray;
    NSArray *attendanceType;
    NSString *str;
    AppDelegate *appDel;
    NSMutableArray *tableData;
    NSIndexPath *indexPath_stat;
    int count;
    NSMutableArray *presentArr;
    NSMutableArray *absentArr;
    NSMutableArray *leaveArr;
    NSMutableArray *odArr;
    NSString *class_id;
    NSInteger lastInserted_id;
    NSMutableArray *enroll_id;
    NSInteger lastInserted_id_AH;
    NSMutableArray *sub_result;
    
    NSArray *docPaths;
    NSString *documentsDir;
    NSString *dbPath;
    FMDatabase *database;
    FMResultSet *rs;
}
@end

@implementation TeacherAttendanceFormView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    stat = @[@"1"];
    classNameArr = [[NSMutableArray alloc]init];
    presentArr = [[NSMutableArray alloc]init];
    absentArr = [[NSMutableArray alloc]init];
    leaveArr = [[NSMutableArray alloc]init];
    odArr = [[NSMutableArray alloc]init];
    enroll_id = [[NSMutableArray alloc]init];
    name = [[NSMutableArray alloc]init];
    sub_result = [[NSMutableArray alloc]init];
    tablearray=[NSMutableArray new];
    attendanceType = @[@"",@"Present",@"Absent",@"Leave",@"OD"];
    result = [[NSMutableArray alloc]init];
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"ENSIFY.db"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    rs = [database executeQuery:@"SELECT DISTINCT (class_section) From table_create_teacher_student_details"];

    if(rs)
    {
        while ([rs next])
        {
            NSLog(@"Class_Section :%@",[rs stringForColumn:@"class_section"]);
            NSString *class_section = [rs stringForColumn:@"class_section"];
            [classNameArr addObject:class_section];
        }
    }
    [database close];
    _selectBtnOtlet.layer.borderColor = [UIColor colorWithRed:102/255.0f green:51/255.0f blue:102/255.0f alpha:1.0].CGColor;
    _selectBtnOtlet.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    _selectBtnOtlet.layer.borderWidth = 1.0f;
    [_selectBtnOtlet.layer setCornerRadius:10.0f];
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-YYYY"];
    NSString *dateString = [dateFormat stringFromDate:today];
    NSLog(@"date: %@", dateString);
    self.dateLabel.text = dateString;
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"dropdown"];
    tableData = [[NSMutableArray alloc] init];
    [[NSUserDefaults standardUserDefaults]setObject:@"No" forKey:@"atendencePicker_Key"];
    [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"pickercancel_Key"];

}

- (void)didReceiveMemoryWarning {
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
    if(indexPath.row == 0)
    {
        TeacherAttendanceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"staticcell" forIndexPath:indexPath];
        NSString *str = [stat objectAtIndex:indexPath.row];
        NSLog(@"%@",str);
        return cell;
    }
    else
    {
        TeacherAttendanceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dynamiccell" forIndexPath:indexPath];
        cell.attendanceTxtfld.tag = 1;
        cell.attendanceTxtfld.delegate = self;
        cell.rollNumber.text = [NSString stringWithFormat:@"%li.", indexPath.row +0];
        cell.studeNameLabel.text = [name objectAtIndex:indexPath.row];
        cell.attendanceTxtfld.tag = indexPath.row;
        
        for (int i = 0; i < [result count]; i++)
        {
            cell.attendanceTxtfld.text = result[indexPath.row];
        }
        
        return cell;

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0)
    {
        return 57;

    }
    else
    {
        return 57;

    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [attendanceType count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [attendanceType objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [[NSUserDefaults standardUserDefaults]setObject:@"No" forKey:@"pickercancel_Key"];
    str = attendanceType[row];
    [[self view] endEditing:YES];
    [self.tableView reloadData];
}
- (IBAction)backBtn:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"teachers" bundle:nil];
    TeacherAttendanceView *myNewVC = (TeacherAttendanceView *)[storyboard instantiateViewControllerWithIdentifier:@"TeacherAttendanceView"];
    [self.navigationController pushViewController:myNewVC animated:YES];
}
- (IBAction)saveBtn:(id)sender
{
    NSString *attendence_Flagclass_id;
    NSString *attendence_Flagattendance_date;
    NSString *attendence_Flagattend_period;
    NSString *attendence_Flagstatus;
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"ENSIFY.db"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    rs = [database executeQuery:@"Select distinct class_id,attendance_date,attend_period,status from table_create_attendence_Flag where class_id = ?",class_id];
    if(rs)
    {
        while ([rs next])
        {
            attendence_Flagclass_id = [rs stringForColumn:@"class_id"];
            attendence_Flagattendance_date = [rs stringForColumn:@"attendance_date"];
            attendence_Flagattend_period = [rs stringForColumn:@"attend_period"];
            attendence_Flagstatus = [rs stringForColumn:@"status"];
        }
    }
    [database close];
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss a"];
    NSString *dateString = [dateFormat stringFromDate:today];
    NSDate *todayDT = [NSDate date];
    NSDateFormatter *dateFormatDT = [[NSDateFormatter alloc] init];
    [dateFormatDT setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [dateFormatDT stringFromDate:todayDT];
        
    NSArray *time = [dateString componentsSeparatedByString:@" "];
    NSString *attendance_period = [time objectAtIndex:2];
    attendance_period = @"0";
    NSLog(@"%@",attendance_period);
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"atendencePicker_Key"];
    [sub_result addObjectsFromArray:result];
    if ([str isEqualToString:@"YES"])
    {
        [sub_result removeObjectAtIndex:0];
        [sub_result removeLastObject];
    }
    else
    {
        [sub_result removeAllObjects];

        for (int i = 0; i < [name count]; i++)
        {
            [sub_result addObject:@"Present"];
        }
            [sub_result removeObjectAtIndex:0];
    }
    if (sub_result.count != 0)
        {
        NSLog(@"%@",sub_result);
        for (NSString *str in sub_result)
        {
            if ([str isEqualToString:@"Present"])
            {
                [presentArr addObject:str];
            }
            else if ([str isEqualToString:@"Absent"])
                {
                    [absentArr addObject:str];
                }
                else if ([str isEqualToString:@"Leave"])
                {
                    [leaveArr addObject:str];
                }
                else if ([str isEqualToString:@"OD"])
                {
                    [odArr addObject:str];
                }
            }
            NSMutableArray *totalpresent = [[NSMutableArray alloc]init];
            [totalpresent addObjectsFromArray:presentArr];
            [totalpresent addObjectsFromArray:odArr];
            [totalpresent removeObject:@""];
            NSInteger count_present = [totalpresent count];
            
            NSMutableArray *totalabsent = [[NSMutableArray alloc]init];
            [totalabsent addObjectsFromArray:absentArr];
            [totalabsent addObjectsFromArray:leaveArr];
            [totalabsent removeObject:@""];
            NSInteger count_absent = [totalabsent count];
            
            NSString *no_of_present_count = [NSString stringWithFormat:@"%lu", (unsigned long)count_present];
            NSString *no_of_absent_count = [NSString stringWithFormat:@" %lu", (unsigned long)count_absent];
            NSString *class_total = [NSString stringWithFormat:@"%lu", (unsigned long)sub_result.count];
            NSString *year_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"Year_Id_key"];
            NSLog(@"%@",year_id);
            
            if (![attendence_Flagclass_id isEqualToString:class_id] && ![attendence_Flagattendance_date isEqualToString:dateTime] && ![attendence_Flagattend_period isEqualToString:attendance_period] && ![attendence_Flagstatus isEqualToString:@"Active"])
                
            {
                BOOL isInserted;
                docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                documentsDir = [docPaths objectAtIndex:0];
                dbPath = [documentsDir   stringByAppendingPathComponent:@"ENSIFY.db"];
                database = [FMDatabase databaseWithPath:dbPath];
                [database open];
                isInserted = [database executeUpdate:@"CREATE TABLE table_create_attendence (_id INTEGER  PRIMARY KEY DEFAULT NULL,server_at_id TEXT DEFAULT NULL,ac_year TEXT DEFAULT NULL,class_id TEXT DEFAULT NULL,class_total TEXT DEFAULT NULL,no_of_present TEXT DEFAULT NULL,no_of_absent TEXT DEFAULT NULL,attendance_period TEXT DEFAULT NULL,created_by TEXT DEFAULT NULL,created_at TEXT DEFAULT NULL,updated_by TEXT DEFAULT NULL,updated_at TEXT DEFAULT NULL,status TEXT DEFAULT NULL,sync_status TEXT DEFAULT NULL)"];
                if(isInserted)
                    NSLog(@"Created Successfully in table_create_homework_class_test");
                else
                    NSLog(@"Error occured while Creating");
                [database close];
                docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                documentsDir = [docPaths objectAtIndex:0];
                dbPath = [documentsDir   stringByAppendingPathComponent:@"ENSIFY.db"];
                database = [FMDatabase databaseWithPath:dbPath];
                [database open];
                appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                NSLog(@"%@",appDel.user_id);
                isInserted=[database executeUpdate:@"INSERT INTO table_create_attendence (server_at_id,ac_year,class_id,class_total,no_of_present,no_of_absent,attendance_period,created_by,created_at,updated_by,updated_at,status,sync_status) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)",@"",year_id,class_id,class_total,no_of_present_count,no_of_absent_count,attendance_period,appDel.user_id,dateTime,appDel.user_id,dateTime,@"A",@"NS"];
                lastInserted_id = [database lastInsertRowId];
                NSLog(@"%ld",(long)lastInserted_id);
                [database close];
                
                if(isInserted)
                {
                    NSLog(@"Inserted Successfully in table_create_attendence");
                }
                else
                {
                    NSLog(@"Error occured while inserting");
                }
                [self AttendanceFlag];
                [self Attendence_History];
            }
            else
            {
            [sub_result removeAllObjects];
            UIAlertController *alert= [UIAlertController
                                       alertControllerWithTitle:@"ENSYFI"
                                       message:@"Attendance Already taken"
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
        }
}
-(void)AttendanceFlag
{
    BOOL isInserted;
    NSDate *todayDT = [NSDate date];
    NSDateFormatter *dateFormatDT = [[NSDateFormatter alloc] init];
    [dateFormatDT setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [dateFormatDT stringFromDate:todayDT];
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"ENSIFY.db"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    isInserted = [database executeUpdate:@"CREATE TABLE table_create_attendence_Flag (_id INTEGER  PRIMARY KEY DEFAULT NULL,class_id TEXT DEFAULT NULL,attendance_date TEXT DEFAULT NULL,attend_period TEXT DEFAULT NULL,status TEXT DEFAULT NULL)"];
    if(isInserted)
        NSLog(@"Created Successfully in table_create_attendence_Flag");
    else
        NSLog(@"Error occured while Creating");
    [database close];
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir stringByAppendingPathComponent:@"ENSIFY.db"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    isInserted = [database executeUpdate:@"INSERT INTO table_create_attendence_Flag (class_id,attendance_date,attend_period,status) VALUES (?,?,?,?)",class_id,dateTime,@"0",@"Active"];
    if(isInserted)
        NSLog(@"Inserted Successfully in table_create_attendence_Flag");
    else
        NSLog(@"Error occured while Inserting");
    [database close];
}
-(void)Attendence_History
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir stringByAppendingPathComponent:@"ENSIFY.db"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    BOOL Create = [database executeUpdate:@"CREATE TABLE table_create_attendence_history (_id INTEGER  PRIMARY KEY DEFAULT NULL,attend_id TEXT DEFAULT NULL,server_attend_id TEXT DEFAULT NULL,class_id TEXT DEFAULT NULL,student_id TEXT DEFAULT NULL,abs_date TEXT DEFAULT NULL,a_status TEXT DEFAULT NULL,attend_period TEXT DEFAULT NULL,a_val TEXT DEFAULT NULL,a_taken_by TEXT DEFAULT NULL,created_at TEXT DEFAULT NULL,updated_by TEXT DEFAULT NULL,updated_at TEXT DEFAULT NULL,status TEXT DEFAULT NULL,sync_status TEXT DEFAULT NULL)"];
    
    if(Create)
        NSLog(@"Created Successfully in table_create_attendance_history");
    else
        NSLog(@"Error occured while Creating");
    [database close];    
    [self Insert_attendenceHistory];
}
-(void)Insert_attendenceHistory
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss a"];
    NSString *dateString = [dateFormat stringFromDate:today];
    NSArray *time = [dateString componentsSeparatedByString:@" "];
    NSString *attendance_period = [time objectAtIndex:2];
    attendance_period = @"0";
    NSDate *todayDT = [NSDate date];
    NSDateFormatter *dateFormatDT = [[NSDateFormatter alloc] init];
    [dateFormatDT setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [dateFormatDT stringFromDate:todayDT];
    NSString *a_status;
    [name removeObjectAtIndex:0];
    for (int i = 0;i < [name count];i++)
    {
        if ([sub_result containsObject:@"Present"])
        {
            NSUInteger integer = [sub_result indexOfObject:@"Present"];
            NSString *str = enroll_id[integer];
            [enroll_id removeObject:str];
            [sub_result removeObjectAtIndex:integer];
        }
    }
    for (int i = 0;i < [enroll_id count];i++)
    {
            NSString *student_id = [enroll_id objectAtIndex:i];
        
            NSString *status = [sub_result objectAtIndex:i];
        
            if ([status isEqualToString:@"Present"])
            {
                a_status = @"P";
            }
             if ([status isEqualToString:@"Absent"])
            {
                a_status = @"A";
            }
            else if ([status isEqualToString:@"Leave"])
            {
                a_status = @"L";
            }
            else if ([status isEqualToString:@"OD"])
            {
                a_status = @"OD";
            }
            NSString *teacher_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"strteacher_id_key"];
            NSLog(@"%@",teacher_id);
            NSString *lastInsert_id = [NSString stringWithFormat:@"%ld",(long)lastInserted_id];
            [[NSUserDefaults standardUserDefaults]setObject:lastInsert_id forKey:@"create_attendance_table_lastInsertedKey"];
            docPaths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            documentsDir = [docPaths objectAtIndex:0];
            dbPath = [documentsDir stringByAppendingPathComponent:@"ENSIFY.db"];
            database = [FMDatabase databaseWithPath:dbPath];
            [database open];
            BOOL isInserted=[database executeUpdate:@"INSERT INTO table_create_attendence_history                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        (attend_id,server_attend_id,class_id,student_id,abs_date,a_status,attend_period,a_val,a_taken_by,created_at,updated_by,updated_at,status,sync_status) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,? )",lastInsert_id,@"",class_id,student_id,dateTime,a_status,attendance_period,@"0",teacher_id,dateTime,teacher_id,dateTime,@"Active",@"NS"];
            [database close];
            if(isInserted)
            {
                NSLog(@"Inserted Successfully in table_create_attendance_history");
                
                UIAlertController *alert= [UIAlertController
                                           alertControllerWithTitle:@"ENSYFI"
                                           message:@"Data inserted Successfully"
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
                NSLog(@"Error occured while inserting");
            }
        }
   }
- (IBAction)selectBtn:(id)sender
{
    if(dropDown == nil)
    {
        CGFloat f = 100;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :classNameArr :nil :@"down"];
        [[NSUserDefaults standardUserDefaults]setObject:@"teacher_attendance" forKey:@"teacher_attendanceKey"];
        _selectBtnOtlet.titleLabel.textColor = [UIColor colorWithRed:102/255.0f green:52/255.0f blue:102/255.0f alpha:1.0];
        dropDown.delegate = self;
    }
    else
    {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender
{
    [self rel];
}
-(void)rel
{
        dropDown = nil;
        NSString *db_class_name = [[NSUserDefaults standardUserDefaults]objectForKey:@"teacher_attendance_resultKey"];
        docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDir = [docPaths objectAtIndex:0];
        dbPath = [documentsDir   stringByAppendingPathComponent:@"ENSIFY.db"];
        database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        rs = [database executeQuery:@"Select distinct class_id from table_create_teacher_student_details where class_section= ? ",db_class_name];
        if(rs)
        {
            while ([rs next])
            {
                NSLog(@"Class_id :%@",[rs stringForColumn:@"class_id"]);
                class_id = [rs stringForColumn:@"class_id"];
            }
        }
        [[NSUserDefaults standardUserDefaults]setObject:class_id forKey:@"class_id_key"];;
        [database close];
        docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDir = [docPaths objectAtIndex:0];
        dbPath = [documentsDir   stringByAppendingPathComponent:@"ENSIFY.db"];
        database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        rs = [database executeQuery:@"Select distinct name from table_create_teacher_student_details where class_id = ? order by name asc ",class_id];
        if(rs)
        {
            [name removeAllObjects];
            [name insertObject:@"name" atIndex:0];
            while ([rs next])
            {
                NSLog(@"name :%@",[rs stringForColumn:@"name"]);
                NSString *strname = [rs stringForColumn:@"name"];
                NSString *strenroll_id = [rs stringForColumn:@"enroll_id"];
                NSLog(@"%@",strenroll_id);
                [name addObject:strname];
            }
        }
        [self getStudent_ID];
        [database close];
        [self.tableView reloadData];
}
-(void)getStudent_ID
{
    [enroll_id removeAllObjects];
    for (NSString *StudentName in name)
    {
        docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDir = [docPaths objectAtIndex:0];
        dbPath = [documentsDir   stringByAppendingPathComponent:@"ENSIFY.db"];
        database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        rs = [database executeQuery:@"Select distinct enroll_id from table_create_teacher_student_details where name = ?",StudentName];
        if(rs)
        {
            while ([rs next])
            {
                NSString *strenroll_id = [rs stringForColumn:@"enroll_id"];
                NSLog(@"%@",strenroll_id);
                [enroll_id addObject:strenroll_id];
            }
        }
        [database close];
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    datapickerView = [[UIPickerView alloc]init];
    datapickerView.dataSource = self;
    datapickerView.delegate = self;
    toolbar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [toolbar setTintColor:[UIColor whiteColor]];

    UIBarButtonItem *pickerCancelBtn=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(CancelBtn)];
    [pickerCancelBtn setTintColor:[UIColor blackColor]];
    UIBarButtonItem *pickerspace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [pickerspace setTintColor:[UIColor whiteColor]];
    [toolbar setItems:[NSArray arrayWithObjects:pickerCancelBtn,pickerspace, nil]];
    textField.inputView = datapickerView ;
    textField.inputAccessoryView = toolbar;
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    UITableViewCell *textFieldRowCell;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
    {
        textFieldRowCell = (UITableViewCell *) textField.superview.superview;
    }
    else
    {
        textFieldRowCell = (UITableViewCell *) textField.superview.superview.superview;
    }
    NSIndexPath *indexPath_stat = [self.tableView indexPathForCell:textFieldRowCell];
    count =(int)indexPath_stat.row;
    NSLog(@"%@",str);
    [self showSelected];
    return YES;
}
-(void)showSelected
{
    NSString *strPicker = [[NSUserDefaults standardUserDefaults]objectForKey:@"pickercancel_Key"];
    if (![strPicker isEqualToString:@"YES"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"atendencePicker_Key"];
        if (result.count==0)
        {
            [result removeAllObjects];
            for (int i=0; i <= [name count]; i++)
            {
                [result addObject:@"Present"];
            }
            [result removeObjectAtIndex:count];
            [result insertObject:str atIndex:count];
        }
        else
        {
            [result removeObjectAtIndex:count];
            [result insertObject:str atIndex:count];
        }
    }
}
-(void)CancelBtn
{
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"pickercancel_Key"];
    [[self view] endEditing:YES];
    [datapickerView removeFromSuperview];
    [toolbar removeFromSuperview];
}
@end
