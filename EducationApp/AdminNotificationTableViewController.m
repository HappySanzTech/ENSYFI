//
//  AdminNotificationTableViewController.m
//  EducationApp
//
//  Created by Happy Sanz Tech on 28/03/18.
//  Copyright © 2018 Palpro Tech. All rights reserved.
//

#import "AdminNotificationTableViewController.h"

@interface AdminNotificationTableViewController ()
{
    AppDelegate *appDel;
    NSMutableArray *group_title;
    NSMutableArray *group_title_id;
    NSMutableArray *notification_id;
    NSMutableArray *notes;
    
    NSMutableArray *groupView_title;
    NSMutableArray *gropuDetailView_id;
    NSMutableArray *created_at;

}
@end

@implementation AdminNotificationTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [self.navigationController.navigationBar setHidden:NO];
    group_title = [[NSMutableArray alloc]init];
    group_title_id = [[NSMutableArray alloc]init];
    notification_id = [[NSMutableArray alloc]init];
    notes = [[NSMutableArray alloc]init];
    created_at = [[NSMutableArray alloc]init];

    groupView_title = [[NSMutableArray alloc]init];
    gropuDetailView_id = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters setObject:appDel.user_type forKey:@"user_type"];
    [parameters setObject:appDel.user_id forKey:@"user_id"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    /* concordanate with baseurl */
    NSString *forEvent = @"/apimain/disp_Groupmessage/";
    NSArray *components = [NSArray arrayWithObjects:baseUrl,appDel.institute_code,forEvent, nil];
    NSString *api = [NSString pathWithComponents:components];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    [manager POST:api parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSLog(@"%@",responseObject);
         
         NSString *status = [responseObject objectForKey:@"status"];
         NSString *msg = [responseObject objectForKey:@"msg"];
         NSArray *groupmsgDetails = [responseObject objectForKey:@"groupmsgDetails"];
         
         if ([msg isEqualToString:@"View Group Messages"] && [status isEqualToString:@"success"])
         {
             [group_title removeAllObjects];
             [group_title_id removeAllObjects];
             [notification_id removeAllObjects];
             [notes removeAllObjects];
             [created_at removeAllObjects];
             
             for (int i = 0; i < [groupmsgDetails count]; i++)
             {
                 
                 NSDictionary *dict = [groupmsgDetails objectAtIndex:i];
                 NSString *strgroup_title = [dict objectForKey:@"group_title"];
                 NSString *strgroup_title_id = [dict objectForKey:@"group_title_id"];
                 NSString *strNotification_id = [dict objectForKey:@"id"];
                 NSString *strnotes = [dict objectForKey:@"notes"];
                 NSString *strCreated_at = [dict objectForKey:@"created_at"];
                 
                 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                 [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                 NSDate *date = [dateFormatter dateFromString:strCreated_at];
                 dateFormatter = [[NSDateFormatter alloc] init];
                 [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm a"];
                 NSString *convertedString = [dateFormatter stringFromDate:date];

                 [group_title addObject:strgroup_title];
                 [group_title_id addObject:strgroup_title_id];
                 [notification_id addObject:strNotification_id];
                 [notes addObject:strnotes];
                 [created_at addObject:convertedString];

             }
             
             [self.tableView reloadData];
             
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
         }
         else
         {
             UIAlertController *alert= [UIAlertController
                                        alertControllerWithTitle:@"ENSYFI"
                                        message:msg
                                        preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *ok = [UIAlertAction
                                  actionWithTitle:@"OK"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      
                                  }];
             
             [alert addAction:ok];
             [self presentViewController:alert animated:YES completion:nil];
             
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
         }
     }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error: %@", error);
     }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [group_title count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TeacherNotificationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeacherNotificationViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.titleLabel.text = [group_title objectAtIndex:indexPath.row];
    cell.decripLabel.text = [notes objectAtIndex:indexPath.row];
    cell.dateLabel.text = [created_at objectAtIndex:indexPath.row];

    cell.cellView.layer.borderWidth = 1.0f;
    cell.cellView.layer.borderColor = [UIColor clearColor].CGColor;
    cell.cellView.layer.cornerRadius = 6.0f;
    
    cell.titleView.layer.borderWidth = 1.0f;
    cell.titleView.layer.borderColor = [UIColor clearColor].CGColor;
    cell.titleView.layer.cornerRadius = 6.0f;
    
    return cell;
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
