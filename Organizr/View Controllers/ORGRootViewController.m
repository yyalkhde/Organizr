//
//  ORGRootViewController.m
//  Organizr
//
//  Created by Yasser Al-Khder on 2014-08-26.
//  Copyright (c) 2014 Yasser Al-Khder. All rights reserved.
//

#import "ORGRootViewController.h"
#import "Task.h"
#import "ORGTableViewDataSource.h"
#import "ORGTaskTableViewCell.h"
#import "ORGNewTaskTableViewCell.h"
#import "ORGNewTaskTableViewController.h"

@interface ORGRootViewController () <ORGTableViewDataSourceDelegate>

@property (strong, nonatomic) ORGTableViewDataSource *dataSource;

@end

@implementation ORGRootViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom Initialization.
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupFetchedResultsController];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    self.dataSource.paused = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.dataSource.paused = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupFetchedResultsController
{
    self.dataSource = [[ORGTableViewDataSource alloc] initWithTableView:self.tableView];
    self.dataSource.fetchedResultsController = self.parent.childrenFetchedResultsController;
    self.dataSource.cellIdentifier = @"Task Cell";
    self.dataSource.delegate = self;
    
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    if ([segue.identifier isEqualToString:@"Add New Task"]) {
        ORGNewTaskTableViewController *sourceViewController = [segue sourceViewController];
        [Task insertTaskWithTitle:sourceViewController.titleTextField.text reminderDate:nil additionalNotes:nil parent:self.parent inManagedObjectContext:self.parent.managedObjectContext];
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ORGNewTaskTableViewCell *cell = (ORGNewTaskTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.textField becomeFirstResponder];
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"will start editing");
}

#pragma mark - Table view data source delegate
- (void)configureCell:(id)cell withObject:(id)object
{
    ORGTaskTableViewCell *taskCell = cell;
    Task *task = object;
    taskCell.textField.text = task.title;
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

@end
