//
//  CoreDataManager.h
//  Budget-Buddy
//
//  Created by Mwanda Chipongo on 28/05/2024.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

+ (instancetype)sharedManager;
- (void)saveContext;
- (void)addExpenseWithAmount:(double)amount category:(NSString *)category date:(NSDate *)date notes:(NSString *)notes;
- (NSArray *)fetchExpenses;
- (void)deleteExpense:(NSManagedObject *)expense;

- (void)createBudgetWithAmount:(double)amount;
- (NSManagedObject *)fetchBudget;
- (void)updateRemainingAmount:(double)amount;

- (void)saveUserWithUsername:(NSString *)username passwordHash:(NSString *)passwordHash useBiometrics:(BOOL)useBiometrics;
- (BOOL)validateUserWithUsername:(NSString *)username passwordHash:(NSString *)passwordHash;

@end
