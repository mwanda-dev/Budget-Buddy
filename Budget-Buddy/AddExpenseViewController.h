//
//  AddExpenseViewController.h
//  Budget-Buddy
//
//  Created by Mwanda Chipongo on 28/05/2024.
//

#import <UIKit/UIKit.h>

@interface AddExpenseViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;

- (IBAction)saveExpense:(id)sender;

@end
