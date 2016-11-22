//
//  FSRecordingStore.m
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/21/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import "FSRecordingStore.h"
#import "FSRecording.h"

@interface FSRecordingStore()

@property (nonatomic, strong) NSMutableArray<FSRecording *> *recordings;
@property (nonatomic, strong) NSMutableDictionary *recordingsById;

@end

@implementation FSRecordingStore

@synthesize recordings;
@synthesize recordingsById;


+(FSRecordingStore *)sharedInstance
{
    static FSRecordingStore *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FSRecordingStore alloc] init];
        [instance load];
    });
    return instance;
}

-(id)init {
    self = [super init];
    if (self) {
        self.recordings = [NSMutableArray array];
        self.recordingsById = [NSMutableDictionary dictionary];
    }
    return self;
}

-(NSUInteger)count {
    return self.recordings.count;
}

-(FSRecording *)recordingAtIndex:(NSInteger)index {
    return [self.recordings objectAtIndex:index];
}

-(FSRecording *)recordingById:(NSString *)recordingId {
    return [self.recordingsById objectForKey:recordingsById];
}

-(void)load {
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"FSRecordingStore.recordings"];
    if (dataRepresentingSavedArray != nil)
    {
        NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
        if (oldSavedArray == nil)
            self.recordings = [[NSMutableArray alloc] init];
        else {
            self.recordings = [oldSavedArray mutableCopy];
            [self.recordings enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                FSRecording *recording = obj;
                [self.recordingsById setObject:recording forKey:recording.recordingId];
            }];
        }
    }
}

-(void)save {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.recordings]
                                              forKey:@"FSRecordingStore.recordings"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)add:(FSRecording *)recording {
    if ([self.recordingsById objectForKey:recording.recordingId]) {
        NSAssert(@"Recording with ID: %@ already exists", recording.recordingId);
    }
    [self.recordingsById setObject:recording forKey:recording.recordingId];
    [self.recordings insertObject:recording atIndex:0];
}

@end
