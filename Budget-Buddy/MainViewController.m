//
//  ViewController.m
//  Budget-Buddy
//
//  Created by Mwanda Chipongo on 28/05/2024.
//

#import "MainViewController.h"
#import "CoreDataManager.h"
#import "AddExpenseViewController.h"
#import "BudgetViewController.h"

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *expenses;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self fetchExpenses];
    [self fetchBudget];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(budgetUpdated:) name:@"BudgetUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(expenseAdded:) name:@"ExpenseAdded" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self fetchExpenses];
    [self fetchBudget];
    
    [self.tableView reloadData];
}

- (void)fetchExpenses {
    self.expenses = [[CoreDataManager sharedManager] fetchExpenses];
}

- (void)fetchBudget {
    NSManagedObject *budget = [[CoreDataManager sharedManager] fetchBudget];
    if (budget) {
        double remainingAmount = [[budget valueForKey:@"remainingAmount"] doubleValue];
        self.remainingBudgetLabel.text = [NSString stringWithFormat:@"Remaining Budget: K%.2f", remainingAmount];
    } else {
        self.remainingBudgetLabel.text = @"K0.00";
    }
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
    amountLabel.text = [NSString stringWithFormat:@"K%.2f", [[expense valueForKey:@"amount"] doubleValue]];
    
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

- (IBAction)setBudgetButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"setBudgetSegue" sender:self];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *expenseToDelete = self.expenses[indexPath.row];
        [[CoreDataManager sharedManager] deleteExpense:expenseToDelete];
        [self fetchExpenses];
        [self fetchBudget];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Notification Handler

- (void)budgetUpdated:(NSNotification *)notification {
    NSLog(@"Budget Updated");
    [self fetchBudget];
}

- (void)expenseAdded:(NSNotification *)notification {
    NSLog(@"Expense added");
    [self fetchExpenses];
    [self fetchBudget];
    [self.tableView reloadData];
}

@end
