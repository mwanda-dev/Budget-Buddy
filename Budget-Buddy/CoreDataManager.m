//
//  CoreDataManager.m
//  Budget-Buddy
//
//  Created by Mwanda Chipongo on 28/05/2024.
//

#import <Foundation/Foundation.h>
#import "CoreDataManager.h"
#import "AppDelegate.h"

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

@end
