//
//  MainStorage.m
//  MiniVKClone
//
//  Created by Антон Дитятив on 31.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import "MainStorage.h"

@interface MainStorage ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation MainStorage
@synthesize currentUser = _currentUser;
@synthesize currentNewsObj = _currentNewsObj;

MainStorage *sharedMainStorage = nil;

+ (MainStorage *)sharedMainStorage
{
    if (sharedMainStorage == nil) {
        sharedMainStorage = [[MainStorage alloc] init];
    }
    return sharedMainStorage;
}

#pragma mark core data initialisation

- (id)init {
    self = [super init];
    if (self) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MiniVKClone" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        NSURL *documentPath = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        
        NSURL *storeURL = [documentPath URLByAppendingPathComponent:@"MiniVKClone.sqlite"];
        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
        
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        }
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
    }
    return self;
}

- (void)mergeContext:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_managedObjectContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:) withObject:noti waitUntilDone:YES];
    });
}

-(void)saveContext {
    NSLog(@"saveContext");
    if ([self.managedObjectContext hasChanges]) {
        NSLog(@"hasChanges");
        NSError *error = nil;
        if(![self.managedObjectContext save:&error]) {
            NSLog(@"ERROR: %@", error);
        }
    } else {
        NSLog(@"doesn't have changes");
    }
}

#pragma mark User
- (void)createNewUser:(UserObject *)user {
    NSEntityDescription *userDescriptor = [NSEntityDescription entityForName:@"User" inManagedObjectContext:_managedObjectContext];
    UserManagedObject *userManagedObject = [[UserManagedObject alloc] initWithEntity:userDescriptor insertIntoManagedObjectContext:_managedObjectContext];
    userManagedObject.userId = user.userId;
    userManagedObject.firstName = user.firstName;
    userManagedObject.lastName = user.lastName;
    userManagedObject.avatarMediumUrl = user.avatarMediumUrl;
    
    [self saveContext];
}

-(void)createNews:(NewsModel *)model {
    NSEntityDescription *userDescriptor = [NSEntityDescription entityForName:@"News" inManagedObjectContext:_managedObjectContext];
    NewsModelObject *userManagedObject = [[NewsModelObject alloc] initWithEntity:userDescriptor insertIntoManagedObjectContext:_managedObjectContext];
    
    userManagedObject.postID = model.postID;
    userManagedObject.text = model.text;
    userManagedObject.likes = model.likes;
    userManagedObject.reposts = model.reposts;
    userManagedObject.image = model.image;
    userManagedObject.date = model.date;
    userManagedObject.profileName = model.profileName;
    userManagedObject.profileAvatar = model.profileAvatar;
    
    [self saveContext];
}

-(UserObject *)returnUser {
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"User" inManagedObjectContext:_managedObjectContext];
    
    [request setEntity:description];
    
    NSError *error = nil;
    NSArray *resultArray = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"error: %@", error);
    }
    
    if (resultArray.count > 0) {
        if (!_currentUser) {
            _currentUser = [[UserObject alloc] init];
        }
        UserManagedObject *userManagedObject = [resultArray firstObject];
        _currentUser.userId = userManagedObject.userId;
        _currentUser.firstName = userManagedObject.firstName;
        _currentUser.lastName = userManagedObject.lastName;
        _currentUser.avatarMediumUrl = userManagedObject.avatarMediumUrl;
        return _currentUser;
    }else {
        return nil;
    }
}

-(NewsModel *)returnCurrentNews:(NSString *)postID {
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"News" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postID == %@", postID];
    
    [request setEntity:description];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *resultArray = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"error: %@", error);
    }
    
    if (resultArray.count > 0) {
        if (!_currentNewsObj) {
            _currentNewsObj = [[NewsModel alloc] init];
        }
        NewsModelObject *userManagedObject = [resultArray firstObject];
        _currentNewsObj.postID = userManagedObject.postID;
        _currentNewsObj.text = userManagedObject.text;
        _currentNewsObj.likes = userManagedObject.likes;
        _currentNewsObj.reposts = userManagedObject.reposts;
        _currentNewsObj.image = userManagedObject.image;
        _currentNewsObj.date = userManagedObject.date;
        _currentNewsObj.profileName = userManagedObject.profileName;
        _currentNewsObj.profileAvatar = userManagedObject.profileAvatar;
        return _currentNewsObj;
    }else {
        return nil;
    }
}


-(NSArray *)returnNews {
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"News" inManagedObjectContext:_managedObjectContext];
    [request setEntity:description];
    
    NSError *error = nil;
    NSArray *resultArray = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"error: %@", error);
    }
    
    return resultArray;
    
}

-(NewsModel *)currentNewsObj:(NSString *)postID {
    return [self returnCurrentNews:postID];
}


- (UserObject *)currentUser {
    return [self returnUser];
}

-(void)deleteNews {
    NSFetchRequest* request = [[NSFetchRequest alloc]init];

    
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"News" inManagedObjectContext:_managedObjectContext];

    [request setEntity:entity];

    
    NSArray *objects = [_managedObjectContext executeFetchRequest:request error:nil];
    
    if(objects.count > 0) {
        for(NewsModelObject *news in objects) {
            [_managedObjectContext deleteObject:news];
            [self saveContext];
        }
    }

}

#pragma mark UserDefaults
- (NSString *)returnAccessToken {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"accessToken"];
}
@end