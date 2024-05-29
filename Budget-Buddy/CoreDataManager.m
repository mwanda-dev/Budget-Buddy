//
//  CoreDataManager.m
//  Budget-Buddy
//
//  Created by Mwanda Chipongo on 28/05/2024.
//

#import "CoreDataManager.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>

@implementation CoreDataManager

+ (instancetype)sharedManager {
    static CoreDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _persistentContainer = ((AppDelegate *)UIApplication.sharedApplication.delegate).persistentContainer;
    }
    return self;
}

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

- (void)addExpenseWithAmount:(double)amount category:(NSString *)category date:(NSDate *)date notes:(NSString *)notes {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSManagedObject *newExpense = [NSEntityDescription insertNewObjectForEntityForName:@"Expense" inManagedObjectContext:context];
    
    [newExpense setValue:@(amount) forKey:@"amount"];
    [newExpense setValue:category forKey:@"category"];
    [newExpense setValue:date forKey:@"date"]; // Defaults to current date
    [newExpense setValue:notes forKey:@"notes"];
    
    [self saveContext];
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Failed to save expense: %@", error);
    } else {
        [self updateRemainingAmount:-amount];
    }
}

- (NSArray *)fetchExpenses {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Expense"];
    NSError *error = nil;
    NSArray *result = [self.persistentContainer.viewContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Error fetching expenses: %@", error.localizedDescription);
    }
    return result;
}

- (void)deleteExpense:(NSManagedObject *)expense {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    double amount = [[expense valueForKey:@"amount"] doubleValue];
    [context deleteObject:expense];
        
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Failed to delete expense: %@", error);
    } else {
        [self updateRemainingAmount:amount];
    }
}

- (void)createBudgetWithAmount:(double)amount {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Budget"];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Failed to fetch budget: %@", error);
        return;
    }
    
    NSManagedObject *budget;
    if (results.count > 0) {
        budget = results.firstObject;
        [budget setValue:@(amount) forKey:@"totalAmount"];
        [budget setValue:@(amount) forKey:@"remainingAmount"];
    } else {
        budget = [NSEntityDescription insertNewObjectForEntityForName:@"Budget" inManagedObjectContext:context];
        [budget setValue:@(amount) forKey:@"totalAmount"];
        [budget setValue:@(amount) forKey:@"remainingAmount"];
    }
    
    if (![context save:&error]) {
        NSLog(@"Failed to save budget: %@", error);
    }
}

- (NSManagedObject *)fetchBudget {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Budget"];
    NSError *error = nil;
    NSArray *results = [self.persistentContainer.viewContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Failed to fetch budget: %@", error);
        return nil;
    }
    
    return results.firstObject;
}

- (void)updateRemainingAmount:(double)amount {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Budget"];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Failed to fetch budget: %@", error);
        return;
    }
    
    if (results.count >= 0) {
        NSManagedObject *budget = results.firstObject;
        double remainingAmount = [[budget valueForKey:@"remainingAmount"] doubleValue];
        remainingAmount += amount;
        [budget setValue:@(remainingAmount) forKey:@"remainingAmount"];
        
        if (![context save:&error]) {
            NSLog(@"Failed to update remaining amount: %@", error);
        }
    }
}

@end
