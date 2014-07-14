//
//  DatabaseManager.h
//  EngLishNow
//
//  Created by Tuan Pham Anh on 4/8/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import <dispatch/dispatch.h>


@protocol DatabaseDelegate <NSObject>
- (void)returnWordCount: (int )count;
@end


@interface DatabaseManager : NSObject {

    dispatch_queue_t backgroundQueue;
    NSMutableArray *allWords;
}


@property (strong) id<DatabaseDelegate> databaseDelegate;
@property (nonatomic, assign) NSInteger numberDaylySentence;
@property (nonatomic, strong) NSMutableArray *wordsToday;


- (void)createDatabase;
- (void)getNumberWordsToday;
- (void)getSentenceToday;
- (void)addWord: (NSString *)newWord;
- (void )getAllWords;
- (NSMutableArray *)getAllWordsInDB;
- (void)createTestsWithNumberQuestion: (NSInteger )numberOfQuestions;

@end
