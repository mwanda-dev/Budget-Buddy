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

@end

