//
//  BudgetViewController.h
//  Budget-Buddy
//
//  Created by Mwanda Chipongo on 29/05/2024.
//

#import <UIKit/UIKit.h>

@interface BudgetViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *budgetAmountTextField;
- (IBAction)saveBudgetButtonTapped:(id)sender;

@end
