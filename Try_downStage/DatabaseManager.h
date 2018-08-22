//
//  DatabaseManager.h
//  Try_downStage
//
//  Created by irons on 2015/8/30.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DatabaseManager : NSObject

+(id)sharedInstance;
-(void)insertWithName:(NSString*)name withScore:(int)score;
-(NSArray*)load;

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
