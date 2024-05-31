//
//  ExpenseDetailsViewController.m
//  Budget-Buddy
//
//  Created by Mwanda Chipongo on 29/05/2024.
//

#import "ExpenseDetailsViewController.h"

@interface ExpenseDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *notesLabel;

@end

@implementation ExpenseDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self displayExpenseDetails];
}

- (void)displayExpenseDetails {
    if (self.expense) {
        self.categoryLabel.text = [self.expense valueForKey:@"category"];
        self.amountLabel.text = [NSString stringWithFormat:@"K%.2f", [[self.expense valueForKey:@"amount"] doubleValue]];

        NSDate *date = [self.expense valueForKey:@"date"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        self.dateLabel.text = [dateFormatter stringFromDate:date];

        self.notesLabel.text = [self.expense valueForKey:@"notes"];
    }
}



@end
