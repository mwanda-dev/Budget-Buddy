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
    // This storage manager is responsible for all the reads and writes to the core data storage of the app
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _persistentContainer = ((AppDelegate *)UIApplication.sharedApplication.delegate).persistentContainer;
    }
    return self;
    // This container is the access point of the core data. It is similar to a database connection
}

- (NSManagedObjectContext *)managedObjectContext {
    return self.persistentContainer.viewContext;
}

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

- (void)saveUserWithUsername:(NSString *)username passwordHash:(NSString *)passwordHash useBiometrics:(BOOL)useBiometrics {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    [newUser setValue:username forKey:@"username"];
    [newUser setValue:passwordHash forKey:@"passwordHash"];
    [newUser setValue:@(useBiometrics) forKey:@"useBiometrics"];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Failed to save user: %@", error.localizedDescription);
    }
    // Creates a user account
}

- (BOOL)validateUserWithUsername:(NSString *)username passwordHash:(NSString *)passwordHash {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username == %@ AND passwordHash == %@", username, passwordHash];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Failed to fetch user: %@", error.localizedDescription);
        return NO;
    }
    
    return results.count > 0;
    // This method checks if the user signing in exists in the database
}

- (void)addExpenseWithAmount:(double)amount category:(NSString *)category date:(NSDate *)date notes:(NSString *)notes {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSManagedObject *newExpense = [NSEntityDescription insertNewObjectForEntityForName:@"Expense" inManagedObjectContext:context];
    
    [newExpense setValue:@(amount) forKey:@"amount"];
    [newExpense setValue:category forKey:@"category"];
    [newExpense setValue:date forKey:@"date"]; // Defaults to current date when no specific date is seleected
    [newExpense setValue:notes forKey:@"notes"];
    
    [self saveContext];
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Failed to save expense: %@", error);
    } else {
        [self updateRemainingAmount:-amount];
        // When an expense is added, it is subtracted from the budget
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
    // This handles the expense fetching on behalf of the main view controller
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
    // This deletes an expense
    // Upon deletion, the money subtracted from the budget is added back to the budget
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
    // This creates a budget
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
    // Fetches the budget on behalf of the main view controller which displays the budget
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
    // Updates the remaining amount of a budget
    // Is called when an expense is added or deleted
}

@end
