//
//  ProcessAPI.h
//  English Now
//
//  Created by Tuan Pham Anh on 6/13/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "SentenceObject.h"

@interface ProcessAPI : NSObject

+ (ProcessAPI *)sharedInstance;

- (void)getTodayWords;
- (void)getAllWords;
- (NSInteger )getNumberTodayWords;
- (void)getSentencesContainWordInArray:(NSArray *)arrayWords;

- (NSString *)searchDictionary:(NSString *)word;
- (void)wordTapped:(NSString *)wordTapped;
- (void)deleteWord:(NSString *)word;

- (void)addWord:(NSString *)text andRank:(NSInteger )rank;
- (void)addSentence:(SentenceObject *)sentenceObject;

- (void)updatePropertyOfWords: (NSMutableArray *)words;
@end
