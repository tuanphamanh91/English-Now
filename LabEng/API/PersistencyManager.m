//
//  PersistencyManager.m
//  English Now
//
//  Created by Tuan Pham Anh on 6/13/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import "PersistencyManager.h"
#import "FMDatabase.h"
#import "WordObject.h"
#import <dispatch/dispatch.h>
#import "FMDatabase.h"
#import "Constants.h"
#import "OpenUDID.h"


@interface PersistencyManager () {
    
    dispatch_queue_t backgroundQueue;
    FMDatabase *database;
    
    NSMutableArray *todaySentences;
    NSMutableArray *allWords;
    
    NSInteger numberWordsOfDay;
}

@end

@implementation PersistencyManager

#pragma mark - CreateDB

- (id)init {
    self = [super init];
    if (self) {
        backgroundQueue = dispatch_queue_create("haki.englishnow", NULL);
    }
    return self;
}

- (NSString *)pathForDB{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *str = [documentsDir stringByAppendingPathComponent:@"englishnow.sqlite3"];
    return str;
}

#pragma mark - Public

- (void)createDatabase {
    
    NSString *pathDB = [self pathForDB];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    database = [FMDatabase databaseWithPath:pathDB];
    
    if (![fileManager fileExistsAtPath:pathDB]) {
        [database open];
        // Create query
        NSString *createWordsTable = @"CREATE TABLE Words(id INTEGER PRIMARY KEY AUTOINCREMENT, word VARCHAR(30) UNIQUE, EF float, I INTEGER, nextDay DATE, popularRank INTEGER)";
        
        NSString *createSentencesTable = @"CREATE TABLE Sentences(id INTEGER PRIMARY KEY AUTOINCREMENT, sentence text, translateSentence text, sentenceID VARCHAR(36) UNIQUE)";
        
        NSString *createSentenceHasWords = @"CREATE TABLE SentenceHasWords( word VARCHAR(30), sentenceID VARCHAR(30), isDisplay BOOLEAN, PRIMARY KEY (word, sentenceID), FOREIGN KEY (word) REFERENCES Words(word), FOREIGN KEY (sentenceID) REFERENCES Sentences(sentenceID))";
        
        // execute query
        [database executeUpdate:createWordsTable];
        [database executeUpdate:createSentencesTable];
        [database executeUpdate:createSentenceHasWords];
        [database close];
    }
}


- (NSMutableArray *)getTodayWordsWithNumber:(NSInteger )number {
    NSMutableArray *words = [[NSMutableArray alloc] init];
    [database open];
    NSString *queryGetWordID = [NSString stringWithFormat:@"SELECT * FROM Words WHERE nextDay <= Date('%@') ORDER BY popularRank LIMIT %d", [self strTimeToday], number];
    FMResultSet *s = [database executeQuery:queryGetWordID];
    
    while ([s next]) {
        WordObject *word = [[WordObject alloc] init];
        word.text = [s stringForColumn:@"word"];
        word.rank = [s intForColumn:@"popularRank"];
        [words addObject:word];
    }
    [database close];
    
    return words;
}

// return the number sentences contain a word
- (NSMutableArray *)getSentencesContainWord: (NSString *)word numberSentence:(NSInteger )numberSentence {
    
    NSMutableArray *sentenceObjects = [[NSMutableArray alloc] init];
    [database open];
    // get sentence is display = 0
    NSString *isDisplay0Query = [NSString stringWithFormat:@"SELECT Sentences.* FROM Sentences, SentenceHasWords WHERE Sentences.sentenceID = SentenceHasWords.sentenceID AND SentenceHasWords.word = \'%@\' AND isDisplay = 0", word];
    FMResultSet *result0 = [database executeQuery:isDisplay0Query];
    
    while ([result0 next] && sentenceObjects.count < numberSentence) {
        
        NSString *sentence = [result0 stringForColumn:@"sentence"];
        NSString *translateSentence = [result0 stringForColumn:@"translateSentence"];
        
        SentenceObject *sentObject = [[SentenceObject alloc] initWithSentence:sentence translateSentence:translateSentence containWord:word];
        [sentenceObjects addObject:sentObject];
        [self updateDisplayOfSenteceID:[result0 stringForColumn:@"sentenceID"]];
    }
    
    
    //if sentenceObjects < 2 get sentence is display = 1
    if (sentenceObjects.count < numberSentence) {
        
        NSString *isDisplay1Query = [NSString stringWithFormat:@"SELECT Sentences.* FROM Sentences, SentenceHasWords WHERE Sentences.sentenceID = SentenceHasWords.sentenceID AND SentenceHasWords.word = \'%@\' AND isDisplay = 1 ORDER BY RANDOM()", word];
        FMResultSet *result1 = [database executeQuery:isDisplay1Query];
        
        while ([result1 next] && sentenceObjects.count < 2) {
            NSString *sentence = [result1 stringForColumn:@"sentence"];
            NSString *translateSentence = [result1 stringForColumn:@"translateSentence"];
            SentenceObject *sentObject = [[SentenceObject alloc] initWithSentence:sentence translateSentence:translateSentence containWord:word];
            [sentenceObjects addObject:sentObject];
        }
    }
    [database close];
    
    return sentenceObjects;
    
}


//- (NSMutableArray *)getSentencesContainWords:(NSMutableArray *)words {
//
//    NSMutableArray *sentences = [[NSMutableArray alloc] init];
//    [database open];
//    for (Word *word in words) {
//        // get sentence is display = 0
//        NSMutableArray *arraySentenceOfWord = [[NSMutableArray alloc] init];
//        NSString *isDisplay0Query = [NSString stringWithFormat:@"SELECT Sentences.* FROM Sentences, SentenceHasWords WHERE Sentences.sentenceID = SentenceHasWords.sentenceID AND SentenceHasWords.word = \'%@\' AND isDisplay = 0", word.text];
//        FMResultSet *result0 = [database executeQuery:isDisplay0Query];
//
//        while ([result0 next] && arraySentenceOfWord.count < 2) {
//
//            NSString *sentence = [result0 stringForColumn:@"sentence"];
//            [arraySentenceOfWord addObject:sentence];
//            [self updateDisplayOfSenteceID:[result0 stringForColumn:@"sentenceID"]];
//        }
//
//        //if arraySentenceOfWord.count < 2 get sentence is display = 1
//        if (arraySentenceOfWord.count < 2) {
//
//            NSString *isDisplay1Query = [NSString stringWithFormat:@"SELECT Sentences.* FROM Sentences, SentenceHasWords WHERE Sentences.sentenceID = SentenceHasWords.sentenceID AND SentenceHasWords.word = \'%@\' AND isDisplay = 1 ORDER BY RANDOM()", word.text];
//            FMResultSet *result1 = [database executeQuery:isDisplay1Query];
//
//            while ([result1 next] && arraySentenceOfWord.count < 2) {
//
//                NSString *sentence = [result1 stringForColumn:@"sentence"];
//                [arraySentenceOfWord addObject:sentence];
//            }
//        }
//
//        [sentences addObjectsFromArray: arraySentenceOfWord];
//    }
//
//    [database close];
//
//    return sentences;
//}


- (NSMutableArray *)getAllWords {
    
    allWords = [NSMutableArray new];
    [database open];
    NSString *queryGetAllWords = @"SELECT * FROM Words ORDER BY popularRank";
    FMResultSet *s = [database executeQuery:queryGetAllWords];
    
    while ([s next]) {
        WordObject *wordObject = [[WordObject alloc] initWithText:[s stringForColumn:@"word"] nextDay:[s stringForColumn:@"nextDay"] rank:[s intForColumn:@"popularRank"] withI:0 withEF:0];
        [allWords addObject:wordObject];
    }
    [database close];
    
    return allWords;
}

- (WordObject *)getObjectFromText:(NSString *)text {
    NSString *queryGetWord = [NSString stringWithFormat:@"SELECT * FROM Words WHERE word = \'%@\'", text];
    FMResultSet *s = [database executeQuery:queryGetWord];
    
    WordObject *wordObject;
    if ([s next]) {
        wordObject = [[WordObject alloc] initWithText:[s stringForColumn:@"word"] nextDay:[s stringForColumn:@"nextDay"] rank:[s intForColumn:@"popularRank"] withI:[s intForColumn:@"I"] withEF:[s doubleForColumn:@"EF"]];
    }
    [database close];
    
    return wordObject;
}

#pragma mark - Set method

- (void)addWord:(WordObject *)wordObject {
    
    [database open];
    NSString *addNewWord = [NSString stringWithFormat:@"INSERT INTO Words(word, EF, I, nextDay, popularRank) values('%@', %f, %ld, '%@', %d)", wordObject.text, wordObject.EF, (long)wordObject.I, wordObject.nextDay, wordObject.rank];
    [database executeUpdate:addNewWord];
    [database close];
    
}

- (void)updateWord: (WordObject *)wordObject {
    [database open];
    NSString *queryUpdate = [NSString stringWithFormat:@"UPDATE Words SET EF = %f, I = %ld, nextDay = '%@' where word = \'%@\'", wordObject.EF, (long)wordObject.I, wordObject.nextDay, wordObject.text];
    [database executeUpdate:queryUpdate];
    [database close];
}

- (void)addSentence:(SentenceObject *)sentenceObject {
    
    [database open];
    
    // get unique string 36 characters
    NSString *uuid = [OpenUDID uuid];
    
    // get new string replace " ' " by " '' "
    NSString *sentenceReplaced = [sentenceObject.text stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    NSString *translateReplaced = [sentenceObject.translateText stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    NSString *queryAddSentence = [NSString stringWithFormat:@"INSERT INTO Sentences(sentence, translateSentence, sentenceID) values('%@', '%@', '%@')", sentenceReplaced, translateReplaced, uuid];
    [database executeUpdate:queryAddSentence];
    
    NSString *queryAddReference = [NSString stringWithFormat:@"INSERT INTO SentenceHasWords( word, sentenceID, isDisplay) values('%@', '%@', 0)", sentenceObject.containWord, uuid];
    [database executeUpdate:queryAddReference];
    
    [database close];
    
}





- (void)updateDisplayOfSenteceID: (NSString *)sentenceID {
    NSString *queryUpdateDisplay = [NSString stringWithFormat:@"UPDATE SentenceHasWords SET isDisplay = 1 WHERE sentenceID = \'%@\'",sentenceID];
    [database executeUpdate:queryUpdateDisplay];
}


- (BOOL)isExistWords:(NSString *)word {
    
    [database open];
    NSString *queryGetWord = [NSString stringWithFormat:@"SELECT * FROM Words WHERE word = \'%@\'",word];
    FMResultSet *s = [database executeQuery:queryGetWord];
    
    if ([s next]) {
        
        [database close];
        NSLog(@"This word is exist!");
        return YES;
        
    } else {
        
        [database close];
        NSLog(@"Adding...");

        return NO;
    }
    
}

//- (BOOL)isExistWordsToday:(NSString *)word {
//    for (WordObject *w in wordsToday) {
//        if ([w.text isEqualToString:word]) {
//            return YES;
//        }
//    }
//    
//    return NO;
//}

- (void)deleteWordAndItsSentences: (NSString *)word {
    [database open];
    NSString *queryDelWord = [NSString stringWithFormat:@"DELETE FROM Words WHERE word = \'%@\'",word];
    [database executeUpdate:queryDelWord];
    
    NSString *queryGetSentenceID = [NSString stringWithFormat:@"SELECT * FROM SentenceHasWords WHERE word = \'%@\'",word];
    FMResultSet *s = [database executeQuery:queryGetSentenceID];
    
    while ([s next]) {
        // get ID of sentence contain word is deleted
        NSString *sentenceID = [s stringForColumn:@"sentenceID"];
        
        NSString *queryDelSentence = [NSString stringWithFormat:@"DELETE FROM Sentences WHERE sentenceID = \'%@\'",sentenceID];
        [database executeUpdate:queryDelSentence];
    }
    [database close];

}
/*
 Words(id, word, EF, I, nextDay, popularRank)
 Sentences(id, sentence, translateSentence, sentenceID)
 SentenceHasWords( word, sentenceID, isDisplay)
 
 */


#pragma mark - Utilities



- (NSString *)strTimeToday {
    NSDateFormatter *DateFormatter = [[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *sNow =  [DateFormatter stringFromDate:[NSDate date]];
    return sNow;
}



@end
