//
//  TeacherExamIntExtView.m
//  EducationApp
//
//  Created by HappySanz on 12/10/17.
//  Copyright © 2017 Palpro Tech. All rights reserved.
//

#import "TeacherExamIntExtView.h"

@interface TeacherExamIntExtView ()
{
    NSMutableArray *name;
    NSMutableArray *enroll_id;
    NSMutableArray *marksExt;
    NSMutableArray *marksInt;
    NSMutableArray *pref_language;
    NSString *isInternal;
    NSString *isExternal;
    NSArray *stat;
    
    NSArray *docPaths;
    NSString *documentsDir;
    NSString *dbPath;
    FMDatabase *database;
    FMResultSet *rs;
}
@end

@implementation TeacherExamIntExtView

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    name = [[NSMutableArray alloc]init];
    enroll_id = [[NSMutableArray alloc]init];
    marksExt = [[NSMutableArray alloc]init];
    marksInt = [[NSMutableArray alloc]init];
    pref_language = [[NSMutableArray alloc]init];
    stat = @[@"1"];
    NSString *class_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"class_id_key"];
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"ENSIFY.db"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    rs = [database executeQuery:@"Select distinct name,enroll_id,pref_language from table_create_teacher_student_details where class_id = ? order by name asc",class_id];
    [name insertObject:@"select" atIndex:0];
    [enroll_id insertObject:@"select" atIndex:0];
    [pref_language insertObject:@"select" atIndex:0];
    if(rs)
    {
        while ([rs next])
        {
            NSLog(@"name :%@",[rs stringForColumn:@"name"]);
            NSString *str_name = [rs stringForColumn:@"name"];
            NSString *str_enroll_id = [rs stringForColumn:@"enroll_id"];
            NSString *str_pref_language = [rs stringForColumn:@"pref_language"];
            [name addObject:str_name];
            [enroll_id addObject:str_enroll_id];
            [pref_language addObject:str_pref_language];
        }
        [self.tableView reloadData];
    }
    [database close];
    NSString *str_subject_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"exam_subject_id_key"];
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"ENSIFY.db"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    rs = [database executeQuery:@"Select distinct external_mark,internal_mark from table_create_exams_details where classmaster_id = ? and subject_id = ?",class_id,str_subject_id];
    if(rs)
    {
        while ([rs next])
        {
            NSLog(@"name :%@",[rs stringForColumn:@"name"]);
            isExternal = [rs stringForColumn:@"external_mark"];
            isInternal = [rs stringForColumn:@"internal_mark"];
        }
    }
    [database close];
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"marks_key"];

}
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
        TeacherMarkIntExtViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"static" forIndexPath:indexPath];
        NSString *str = [stat objectAtIndex:indexPath.row];
        NSLog(@"%@",str);
        return cell;
    }
    else
    {
        TeacherMarkIntExtViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dynamic" forIndexPath:indexPath];
        cell.externalMark.delegate = self;
        cell.internalMark.delegate = self;
        cell.externalMark.tag = 2;
        cell.internalMark.tag = 1;
        NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"marks_key"];
        if ([str isEqualToString:@"NO"])
        {
            cell.externalMark.text = [marksExt objectAtIndex:indexPath.row];
            cell.internalMark.text = [marksInt objectAtIndex:indexPath.row];
        }
        cell.rollNum.text = [NSString stringWithFormat:@"%li",indexPath.row+0];
        cell.studentName.text =[NSString stringWithFormat:@"%@ - %@",[name objectAtIndex:indexPath.row],[pref_language objectAtIndex:indexPath.row]];
        return cell;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    if (theTextField.tag == 1)
    {
        [theTextField resignFirstResponder];
    }
    else if (theTextField.tag == 2)
    {
        [theTextField resignFirstResponder];
    }
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGPoint pointInTable = [textField.superview convertPoint:textField.frame.origin toView:self.tableView];
    CGPoint contentOffset = self.tableView.contentOffset;
    contentOffset.y = (pointInTable.y - textField.inputAccessoryView.frame.size.height);
    NSLog(@"contentOffset is: %@", NSStringFromCGPoint(contentOffset));
    [self.tableView setContentOffset:contentOffset animated:YES];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"marks_key"];
    if (marksInt.count == 0 && marksExt.count == 0)
    {
        for (int i =0;i < [name count];i++)
        {
            [marksInt addObject:@""];
            [marksExt addObject:@""];
        }
    }
    NSInteger integer;
    NSString *str;
    if (textField.tag == 1)
    {
        str =  [textField text];
        NSLog(@"%@",str);
        BOOL valid;
        NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
        NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:str];
        valid = [alphaNums isSupersetOfSet:inStringSet];
        if (valid)
        {
             integer = [str intValue];
            
            if ([str intValue] > [isInternal intValue])
            {
                
                NSString *str = [NSString stringWithFormat:@"%@ %@",@"Enter valid internal marks for student between 0 to",isInternal];
                UIAlertController *alert= [UIAlertController
                                           alertControllerWithTitle:@"ENSYFI"
                                           message:str
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
                TeacherClasstestAddMarkCell *cell = (TeacherClasstestAddMarkCell*)textField.superview.superview;
                NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                NSInteger row = indexPath.row;
                [marksInt removeObjectAtIndex:row];
                [marksInt insertObject:[NSString stringWithFormat:@"%ld",(long)integer] atIndex:row];
            }
        }
        else
        {
            if ([str isEqualToString:@"AB"] || [str isEqualToString:@"NA"])
            {
                TeacherClasstestAddMarkCell *cell = (TeacherClasstestAddMarkCell*)textField.superview.superview;
                NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                NSInteger row = indexPath.row;
                [marksInt removeObjectAtIndex:row];
                [marksInt insertObject:[NSString stringWithFormat:@"%@",str] atIndex:row];
                
            }
            else
            {
                UIAlertController *alert= [UIAlertController
                                           alertControllerWithTitle:@"ENSYFI"
                                           message:@"Enter valid character as 'AB' for students"
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
    else if (textField.tag == 2)
    {
        NSString *str =  [textField text];
        BOOL valid;
        NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
        NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:str];
        valid = [alphaNums isSupersetOfSet:inStringSet];
        if (valid) 
        {
            integer = [str intValue];
            
            if ([str intValue] > [isExternal intValue])
            {
                NSString *str = [NSString stringWithFormat:@"%@ %@",@"Enter valid external marks for student between 0 to",isExternal];

                UIAlertController *alert= [UIAlertController
                                           alertControllerWithTitle:@"ENSYFI"
                                           message:str
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
                TeacherClasstestAddMarkCell *cell = (TeacherClasstestAddMarkCell*)textField.superview.superview;
                NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                NSInteger row = indexPath.row;
                [marksExt removeObjectAtIndex:row];
                [marksExt insertObject:[NSString stringWithFormat:@"%ld",(long)integer] atIndex:row];
            }
        }
        else
        {
            if ([str isEqualToString:@"AB"] || [str isEqualToString:@"NA"])
            {
                TeacherClasstestAddMarkCell *cell = (TeacherClasstestAddMarkCell*)textField.superview.superview;
                NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                NSInteger row = indexPath.row;
                [marksExt removeObjectAtIndex:row];
                [marksExt insertObject:[NSString stringWithFormat:@"%@",str] atIndex:row];
            }
            else
            {
                UIAlertController *alert= [UIAlertController
                                           alertControllerWithTitle:@"ENSYFI"
                                           message:@"Enter valid character as 'AB' for students"
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
    if ([textField.superview.superview isKindOfClass:[UITableViewCell class]])
    {
        TeacherMarkIntExtViewCell *cell = (TeacherMarkIntExtViewCell*)textField.superview.superview;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:TRUE];
    }
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
/*
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)saveBtn:(id)sender
{
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"marks_key"];
    if ([str isEqualToString:@"YES"])
    {
        UIAlertController *alert= [UIAlertController
                                   alertControllerWithTitle:@"ENSYFI"
                                   message:@"please enter marks for all students"
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
        [self.view endEditing:YES];
    }
    if(marksInt.count != 0 || marksExt.count != 0)
    {
        if (name.count == marksInt.count)
        {
            
            if ([marksInt containsObject:@""] || [marksExt containsObject:@""])
            {
                NSString *intStr = [marksInt firstObject];
                NSString *extStr = [marksExt firstObject];
                
                if ([intStr isEqualToString:@""] || [extStr isEqualToString:@""])
                {
                    [name removeObjectAtIndex:0];
                    [enroll_id removeObjectAtIndex:0];
                    [marksInt removeObjectAtIndex:0];
                    [marksExt removeObjectAtIndex:0];
                    
                    NSDate *todayDT = [NSDate date];
                    NSDateFormatter *dateFormatDT = [[NSDateFormatter alloc] init];
                    [dateFormatDT setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *dateTime = [dateFormatDT stringFromDate:todayDT];
                    BOOL isInserted;
                    BOOL isCreated;
                    NSString *strexam_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"exam_id_key"];
                    NSString *class_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"class_id_key"];
                    NSString *teacher_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"strteacher_id_key"];
                    NSString *subject_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"subject_id_exam_marks"];
                    
                    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    documentsDir = [docPaths objectAtIndex:0];
                    dbPath = [documentsDir stringByAppendingPathComponent:@"ENSIFY.db"];
                    database = [FMDatabase databaseWithPath:dbPath];
                    [database open];
                    isInserted = [database executeUpdate:@"UPDATE table_create_exams_of_the_class SET MarkStatus = ? WHERE exam_id = ?",@"1",strexam_id];
                    [database close];
                    if(isInserted)
                        NSLog(@"updated Successfully in table_create_exams_of_the_class ");
                    else
                        NSLog(@"Error occured while updateing");
                    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    documentsDir = [docPaths objectAtIndex:0];
                    dbPath = [documentsDir   stringByAppendingPathComponent:@"ENSIFY.db"];
                    database = [FMDatabase databaseWithPath:dbPath];
                    [database open];
                    isCreated = [database executeUpdate:@"CREATE TABLE table_create_academic_exam_marks (_id INTEGER  PRIMARY KEY DEFAULT NULL,exam_id TEXT DEFAULT NULL,teacher_id TEXT DEFAULT NULL,subject_id TEXT DEFAULT NULL,stu_id TEXT DEFAULT NULL,classmaster_id TEXT DEFAULT NULL,internal_mark TEXT DEFAULT NULL,internal_grade TEXT DEFAULT NULL,external_mark TEXT DEFAULT NULL,external_grade TEXT DEFAULT NULL,total_marks TEXT DEFAULT NULL,total_grade TEXT DEFAULT NULL,created_by TEXT DEFAULT NULL,created_at TEXT DEFAULT NULL,updated_by TEXT DEFAULT NULL,updated_at TEXT DEFAULT NULL,sync_status TEXT DEFAULT NULL)"];
                    if(isCreated)
                        NSLog(@"table_create_academic_exam_marks table Created Successfully");
                    else
                        NSLog(@"already exists");
                    [database close];
                    for (int i = 0;i < [name count];i++)
                    {
                        NSString *stud_id = [enroll_id objectAtIndex:i];
                        NSString *str_Marks_int = [marksInt objectAtIndex:i];
                        NSString *str_Marks_ext = [marksExt objectAtIndex:i];
                        
                        docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        documentsDir = [docPaths objectAtIndex:0];
                        dbPath = [documentsDir stringByAppendingPathComponent:@"ENSIFY.db"];
                        database = [FMDatabase databaseWithPath:dbPath];
                        [database open];
                        isInserted = [database executeUpdate:@"INSERT INTO table_create_academic_exam_marks (exam_id,teacher_id,subject_id,stu_id,classmaster_id,internal_mark,internal_grade,external_mark,external_grade,total_marks,total_grade,created_by,created_at,updated_by,updated_at,sync_status) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",strexam_id,teacher_id,subject_id,stud_id,class_id,str_Marks_int,@"AB",str_Marks_ext,@"AB",@"0",@"AB",teacher_id,dateTime,teacher_id,dateTime,@"NS"];
                    }
                    if(isInserted)
                    {
                        NSLog(@"Inserted Successfully in table_create_academic_exam_marks");
                        UIAlertController *alert= [UIAlertController
                                                   alertControllerWithTitle:@"ENSYFI"
                                                   message:@"Marks inserted successfully"
                                                   preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *ok = [UIAlertAction
                                             actionWithTitle:@"OK"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action)
                                             {
                                                 UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"teachers" bundle:nil];
                                                 TeacherExamViewController *teacherExamViewController = (TeacherExamViewController *)[storyboard instantiateViewControllerWithIdentifier:@"TeacherExamViewController"];
                                                 [self.navigationController pushViewController:teacherExamViewController animated:YES];
                                                 
                                             }];
                        
                        [alert addAction:ok];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    else
                    {
                        NSLog(@"Error occured while inserting");
                    }
                    [database close];
                    
                }
            }
                else
                {
                    UIAlertController *alert= [UIAlertController
                                               alertControllerWithTitle:@"ENSYFI"
                                               message:@"please enter marks for all students"
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
        else
        {
            UIAlertController *alert= [UIAlertController
                                       alertControllerWithTitle:@"ENSYFI"
                                       message:@"please enter marks for all students"
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
@end
