//
//  FSCaptureSessionStore.m
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/21/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import "FSCaptureSessionStore.h"
#import "FSRecording.h"
#import "FSCapturedMoments.h"

@interface FSCaptureSessionStore()

@property (nonatomic, strong) NSMutableArray<FSCapturedMoments *> *sessions;
@property (nonatomic, strong) NSMutableDictionary *sessionsById;

@end

@implementation FSCaptureSessionStore

@synthesize sessions;
@synthesize sessionsById;

+(FSCaptureSessionStore *)sharedInstance
{
    static FSCaptureSessionStore *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FSCaptureSessionStore alloc] init];
        [instance load];
    });
    return instance;
}

-(id)init {
    self = [super init];
    if (self) {
        self.sessions = [NSMutableArray array];
        self.sessionsById = [NSMutableDictionary dictionary];
    }
    return self;
}

-(FSCapturedMoments *)newMomentsForRecording:(FSRecording *)recording {
    FSCapturedMoments *moments = [[FSCapturedMoments alloc] initWithRecording:recording];
    NSString *imagesDir = moments.imagesFolder;
    
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:imagesDir
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    NSAssert(error == nil, @"Error creating images directory");
    return moments;
}

-(NSUInteger)count {
    return self.sessions.count;
}

-(FSCapturedMoments *)sessionAtIndex:(NSInteger)index {
    return [self.sessions objectAtIndex:index];
}

-(FSCapturedMoments *)sessionById:(NSString *)sessionId {
    return [self.sessionsById objectForKey:sessionsById];
}

-(void)load {
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"FSCaptureSessionStore.sessions"];
    if (dataRepresentingSavedArray != nil)
    {
        NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
        if (oldSavedArray == nil)
            self.sessions = [[NSMutableArray alloc] init];
        else {
            self.sessions = [oldSavedArray mutableCopy];
            [self.sessions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                FSCapturedMoments *session = obj;
                [self.sessionsById setObject:session forKey:session.sessionId];
            }];
        }
    }
}

-(void)save {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.sessions]
                                              forKey:@"FSCaptureSessionStore.sessions"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)add:(FSCapturedMoments *)session {
    if ([self.sessionsById objectForKey:session.sessionId]) {
        NSAssert(@"CapturedMoments with ID: %@ already exists", session.sessionId);
    }
    [self.sessionsById setObject:session forKey:session.sessionId];
    [self.sessions insertObject:session atIndex:0];
}

@end
