//
//  PersistencyManager.h
//  English Now
//
//  Created by Tuan Pham Anh on 6/13/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WordObject.h"
#import "SentenceObject.h"

@interface PersistencyManager : NSObject

- (void)createDatabase;

- (NSMutableArray *)getTodayWordsWithNumber:(NSInteger )number; //return Words
- (NSMutableArray *)getSentencesContainWord: (NSString *)word numberSentence:(NSInteger)numberSentence; // return Sentences
- (NSMutableArray *)getAllWords; //return Words
- (WordObject *)getObjectFromText:(NSString *)text;

- (void)addWord:(WordObject *)wordObject;
- (void)updateWord:(WordObject *)wordObject;

- (void)addSentence:(SentenceObject *)sentenceObject;

- (BOOL)isExistWords:(NSString *)word;

- (void)deleteWordAndItsSentences: (NSString *)word;

@end
