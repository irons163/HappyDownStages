//
//  DatabaseManager.m
//  Try_downStage
//
//  Created by irons on 2015/8/30.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "DatabaseManager.h"

static DatabaseManager* instance;

@implementation DatabaseManager

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

-(NSManagedObjectContext *)managedObjectContext{
    NSManagedObjectContext* context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)insertWithName:(NSString*)name withScore:(int)score{
    NSManagedObjectContext* context = [self managedObjectContext];
    NSManagedObject* entity = [NSEntityDescription insertNewObjectForEntityForName:@"Entity" inManagedObjectContext:context];
    [entity setValue:name forKey:@"name"];
    [entity setValue:[NSNumber numberWithInt:score] forKey:@"score"];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

-(NSArray*)load{
    NSManagedObjectContext* context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Entity" inManagedObjectContext:context];
    NSSortDescriptor *sortByScore = [NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:@[sortByScore]];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

@end
