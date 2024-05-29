//
//  BudgetViewController.m
//  Budget-Buddy
//
//  Created by Mwanda Chipongo on 29/05/2024.
//

#import <Foundation/Foundation.h>
#import "BudgetViewController.h"
#import "CoreDataManager.h"

@interface BudgetViewController ()

@end

@implementation BudgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)saveBudgetButtonTapped:(id)sender {
    double budgetAmount = [self.budgetAmountTextField.text doubleValue];
    [[CoreDataManager sharedManager] createBudgetWithAmount:budgetAmount];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BudgetUpdated" object:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

