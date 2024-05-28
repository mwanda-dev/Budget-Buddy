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

@end

#ifndef CoreDataManager_h
#define CoreDataManager_h


#endif /* CoreDataManager_h */
