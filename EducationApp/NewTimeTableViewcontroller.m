//
//  NewTimeTableViewcontroller.m
//  EducationApp
//
//  Created by Happy Sanz Tech on 25/04/18.
//  Copyright © 2018 Palpro Tech. All rights reserved.
//

#import "NewTimeTableViewcontroller.h"

@interface NewTimeTableViewcontroller ()
{
    NSMutableArray *dayArray;
    NSMutableArray *valueArray;
}
@end

@implementation NewTimeTableViewcontroller

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarbutton setTarget: self.revealViewController];
        [self.sidebarbutton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    SWRevealViewController *revealController = [self revealViewController];
    UITapGestureRecognizer *tap = [revealController tapGestureRecognizer];
    tap.delegate = self;
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    dayArray = [[NSMutableArray alloc]init];
    valueArray = [[NSMutableArray alloc]init];
    [dayArray addObject:@"Monday"];
    [dayArray addObject:@"Tuesday"];
    [dayArray addObject:@"Wednesday"];
    [dayArray addObject:@"Thursday"];
    [dayArray addObject:@"friday"];
    
    [valueArray addObject:@"Monday"];
    [valueArray addObject:@"Tuesday"];
    [valueArray addObject:@"Wednesday"];
    [valueArray addObject:@"Thursday"];
    [valueArray addObject:@"friday"];
    
    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:dayArray];
    _segmentedControl.frame = CGRectMake(0,0,self.view.bounds.size.width,55);
    _segmentedControl.selectionIndicatorHeight = 2.0f;
    _segmentedControl.backgroundColor = [UIColor colorWithRed:62/255.0f green:142/255.0f blue:204/255.0f alpha:1.0];
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.selectionStyle  = HMSegmentedControlSelectionStyleBox;
    _segmentedControl.selectionIndicatorColor = [UIColor whiteColor];
    [self.view addSubview:_segmentedControl];
    [_segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(didSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
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
    return [valueArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewTimeTableTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [valueArray objectAtIndex:indexPath.row];
    return cell;
}
-(void)segmentAction:(UISegmentedControl *)sender
{
    if(_segmentedControl.selectedSegmentIndex == 0)
    {
        
    }
}
- (void)didSwipe:(UISwipeGestureRecognizer*)swipe
{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if (_segmentedControl.selectedSegmentIndex == 0)
        {
            _segmentedControl.selectedSegmentIndex = 1;
        }
    }
    else if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if (_segmentedControl.selectedSegmentIndex == 1)
        {
            _segmentedControl.selectedSegmentIndex = 0                                                       ;
        }
    }
}
@end
