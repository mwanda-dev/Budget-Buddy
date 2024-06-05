//
//  ViewController.h
//  Budget-Buddy
//
//  Created by Mwanda Chipongo on 28/05/2024.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *remainingBudgetLabel;
// These properties are connected to the table view and remaining budget labels in the main view
// The segues performed by the buttons are defined and called by name when the performSegueWithIdentifier
// signal is sent
@end

