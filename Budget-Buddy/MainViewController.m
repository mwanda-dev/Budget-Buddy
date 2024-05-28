//
//  ViewController.m
//  Budget-Buddy
//
//  Created by Mwanda Chipongo on 28/05/2024.
//

#import "MainViewController.h"
#import "CoreDataManager.h"
#import "AddExpenseViewController.h"

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *expenses;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self fetchExpenses];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(expenseAdded:) name:@"ExpenseAdded" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self fetchExpenses];
    [self.tableView reloadData];
}



- (void)fetchExpenses {
    self.expenses = [[CoreDataManager sharedManager] fetchExpenses];
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.expenses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpenseCell" forIndexPath:indexPath];
    
    NSManagedObject *expense = self.expenses[indexPath.row];
    
    UILabel *categoryLabel = [cell viewWithTag:1];
    categoryLabel.text = [expense valueForKey:@"category"];
        
    UILabel *amountLabel = [cell viewWithTag:2];
    amountLabel.text = [NSString stringWithFormat:@"$%.2f", [[expense valueForKey:@"amount"] doubleValue]];
    
    UILabel *dateLabel = [cell viewWithTag:3];
    NSDate *date = [expense valueForKey:@"date"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    dateLabel.text = [dateFormatter stringFromDate:date];
    
    return cell;
}

- (IBAction)addExpenseButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"addExpenseSegue" sender:self];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *expenseToDelete = self.expenses[indexPath.row];
        [[CoreDataManager sharedManager] deleteExpense:expenseToDelete];
        [self fetchExpenses];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Notification Handler

- (void)expenseAdded:(NSNotification *)notification {
    [self fetchExpenses];
    [self.tableView reloadData];
}

@end
