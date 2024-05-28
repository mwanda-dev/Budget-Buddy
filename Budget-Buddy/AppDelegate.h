//
//  AppDelegate.h
//  Budget-Buddy
//
//  Created by Mwanda Chipongo on 28/05/2024.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

