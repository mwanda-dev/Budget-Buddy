//
//  AddExpenseViewController.m
//  Budget-Buddy
//
//  Created by Mwanda Chipongo on 28/05/2024.
//

#import "Foundation/Foundation.h"
#import "AddExpenseViewController.h"
#import "CoreDataManager.h"
#import "MainViewController.h"

@implementation AddExpenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)saveExpense:(id)sender {
    double amount = [self.amountTextField.text doubleValue];
    NSString *category = self.categoryTextField.text;
    NSDate *date = self.datePicker.date;
    NSString *notes = self.notesTextView.text;
    
    [[CoreDataManager sharedManager] addExpenseWithAmount:amount category:category date:date notes:notes];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
