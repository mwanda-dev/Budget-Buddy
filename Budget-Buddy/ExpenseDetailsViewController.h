//
//  ExpenseDetailsViewController.h
//  Budget-Buddy
//
//  Created by Mwanda Chipongo on 29/05/2024.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ExpenseDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) NSManagedObject *expense;

@end
