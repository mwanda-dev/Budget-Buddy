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
#import "ExpenseDetailsViewController.h"

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
        self.remainingBudgetLabel.text = [NSString stringWithFormat:@"K%.2f", remainingAmount];
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
    // These are the rows each expense will be displayed in
    
    NSManagedObject *expense = self.expenses[indexPath.row];
    
    UILabel *categoryLabel = [cell viewWithTag:1];
    // The view tag represents the column number in each row in the table
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
    // When the add expense button is tapped, it'll present the add expense interface as a pop up
}

- (IBAction)setBudgetButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"setBudgetSegue" sender:self];
    // When the set budget button is tapped, it'll present the set budget interface as a pop up
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
    // This is the editing style that is built in to enable deletion of cells or row in a table view
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *expenseToDelete = self.expenses[indexPath.row];
        [[CoreDataManager sharedManager] deleteExpense:expenseToDelete];
        [self fetchExpenses];
        [self fetchBudget];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    // This method enables the deletion of an expense by sliding the expense to the left
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showExpenseDetailsSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showExpenseDetailsSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *selectedExpense = self.expenses[indexPath.row];
        ExpenseDetailsViewController *destinationVC = segue.destinationViewController;
        destinationVC.expense = selectedExpense;
        // This method sends the selected expense to the Expense Details View Controller so that it can be displayed
    }
}

#pragma mark - Notification Handler
// These notification handlers listen for notifications from the AddExpense and Budget View Controllers so that the main view
// controller is immediately updated when an expense is added or a budget is set

- (void)budgetUpdated:(NSNotification *)notification {
    NSLog(@"Budget Updated");
    [self fetchBudget];
    [self.tableView reloadData];
}

- (void)expenseAdded:(NSNotification *)notification {
    NSLog(@"Expense added");
    [self fetchExpenses];
    [self fetchBudget];
    [self.tableView reloadData];
}

@end
