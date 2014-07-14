//
//  DatabaseManager.m
//  EngLishNow
//
//  Created by Tuan Pham Anh on 4/8/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import "DatabaseManager.h"
#import "FMDatabase.h"
#import "AFHTTPRequestOperationManager.h"
#import "OpenUDID.h"

#import "SentenceHasWord.h"
#import "Test.h"
#import "WordObject.h"

//random function
#include <stdlib.h>

@implementation DatabaseManager
@synthesize databaseDelegate, numberDaylySentence, wordsToday;

- (id)init {
    self = [super init];
    if (self) {
        backgroundQueue = dispatch_queue_create("haki.englishnow", NULL);
        
    }
    return self;
}


#pragma mark - Create

//- (void )requestSentences: (NSString *)word {
//    
//    NSString *strURL = [NSString stringWithFormat:@"http://linh.onjumpstarter.io/sentences/view/%@.json", word];
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    [manager GET:strURL parameters:nil success:
//     ^(AFHTTPRequestOperation *operation, id responseObject) {
//         
//         
//         dispatch_async(backgroundQueue, ^{
//             NSArray *dict = [responseObject valueForKeyPath:@"data.array_sentence"];
//             [self addSentences:dict ofWord:word];
//             
//         });
//         
//         
//         
//     }
//         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//             NSLog(@"Error: %@", error);
//         }];
//    
//}

- (void )requestSentences: (NSString *)word {
    
    NSString *strURL = [NSString stringWithFormat:@"http://linh.onjumpstarter.io/apis/translated_sentences/passed.json", word];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:strURL parameters:nil success:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
         
         NSString *word = [responseObject valueForKeyPath:@"data.word"];
         NSInteger rank = [responseObject valueForKeyPath:@"data.rank"];
         NSArray *array_sentence = [responseObject valueForKeyPath:@"data.array_sentence"];
         
         NSArray *fisrtArray = [array_sentence objectAtIndex:0];
         NSString *secondSentence = [fisrtArray objectAtIndex:1];
         
         NSLog(@"utf8: %@", secondSentence);
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
    
}





- (void)addSentences: (NSArray *)arraySentence ofWord: (NSString *)newWord {
    
    FMDatabase *database = [FMDatabase databaseWithPath:[self pathForDB]];
    [database open];
    
    if (arraySentence.count > 0) {
        for (NSString *sentence in arraySentence) {
            
            // get unique string 36 characters
            NSString *uuid = [OpenUDID uuid];
            
            // get new string replace " ' " by " '' "
            NSString *sentenceReplaced = [sentence stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            NSString *addSentence = [NSString stringWithFormat:@"INSERT INTO Sentences(sentence, sentenceID) values('%@', '%@')", sentenceReplaced, uuid];
            [database executeUpdate:addSentence];
            
            NSString *addReference = [NSString stringWithFormat:@"INSERT INTO SentenceHasWords( word, sentenceID, isDisplay) values('%@', '%@', 0)", newWord, uuid];
            [database executeUpdate:addReference];
        }
        
        NSLog(@"---- ADD SENTENCES DONE! ---");
        
    }
    [database close];
    
}

// Path: /Users/dell/Library/Application Support/iPhone Simulator/7.0.3/Applications/F74D289A-20B1-4F7F-A6F2-21C64E976601/Documents/
- (NSString *)pathForDB{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *str = [documentsDir stringByAppendingPathComponent:@"englishnow.sqlite3"];
//      NSString *str = [[NSBundle mainBundle] pathForResource:@"englishnow" ofType:@"sqlite3"];
    return str;
}


/*
 Words(id, word, EF, I, nextDay, popularRank)
 PopularWords(id, word, rank)
 Sentences(id, sentence, sentenceID)
 SentenceHasWords( word, sentenceID, isDisplay)
 
 */

- (void)createDatabase {
    
    NSString *pathDB = [self pathForDB];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"englishnow" ofType:@"sqlite3"];
    if (![fileManager fileExistsAtPath:pathDB]) {
        
        
        FMDatabase *database = [FMDatabase databaseWithPath:pathDB];
        [database open];
        
        // Create table
        NSString *createWordsTable = @"CREATE TABLE Words(id INTEGER PRIMARY KEY AUTOINCREMENT, word VARCHAR(30) UNIQUE, EF float, I INTEGER, nextDay DATE, popularRank INTEGER)";
        
        NSString *createPopularWordsTable = @"CREATE TABLE PopularWords(id INTEGER PRIMARY KEY AUTOINCREMENT, word VARCHAR(30), rank INTEGER)";
        
        NSString *createSentencesTable = @"CREATE TABLE Sentences(id INTEGER PRIMARY KEY AUTOINCREMENT, sentence text, sentenceID VARCHAR(36) UNIQUE)";
        
        NSString *createSentenceHasWords = @"CREATE TABLE SentenceHasWords( word VARCHAR(30), sentenceID VARCHAR(30), isDisplay BOOLEAN, PRIMARY KEY (word, sentenceID), FOREIGN KEY (word) REFERENCES Words(word), FOREIGN KEY (sentenceID) REFERENCES Sentences(sentenceID))";
        
        
        BOOL is1 =  [database executeUpdate:createWordsTable];
        BOOL is2 =  [database executeUpdate:createPopularWordsTable];
        BOOL is3 =  [database executeUpdate:createSentencesTable];
        BOOL is4 =  [database executeUpdate:createSentenceHasWords];
        
        NSLog(@"%d - %d - %d - %d", is1, is2, is3, is4);

        [database close];
        
//        dispatch_async(backgroundQueue, ^{
//            [self createPopularWordsTable];
//        });
        NSLog(@"--Create Database done--");
    }
}

// Ham tao ra bang rank of word
- (void)createPopularWordsTable {

    NSString *path = [[NSBundle mainBundle] pathForResource:@"google-10000-english" ofType:@"txt"];
    
    if (![path isEqualToString:@""]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSArray *arrayContent = [content componentsSeparatedByString:@"\n"];
        
        
        FMDatabase *database = [FMDatabase databaseWithPath:[self pathForDB]];
        [database open];
        
        NSLog(@"--Create Rank--");
        int i = 0;
        while (i < [arrayContent count] -1) {
            
            NSString *insertRankWord = [NSString stringWithFormat:@"INSERT INTO PopularWords(word, rank) values('%@', %d)",arrayContent[i], i];
            [database executeUpdate:insertRankWord];
            i++;
            
        }
        
        [database close];
        
    }
    
    NSLog(@"---------------UPDATED POPULAR WORD-------------------");
}




#pragma mark - Get

/*
 Words(id, word, EF, I, nextDay, popularRank)
 PopularWords(id, word, rank)
 Sentences(id, sentence, sentenceID)
 SentenceHasWords( word, sentenceID, isDisplay)
 
 */

// Lay tat ca cac cau trong ngay

/*
 - Lay idWord cac tu co nextDay = today
 - Voi moi idWord lay ra 1 cau o bang Sentences
 where mydate >= Datetime('2009-11-13 00:00:00')
 */

- (void)getNumberWordsToday {
    
    // Luu lai ngay hom nay
    NSDateFormatter *DateFormatter = [[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *sToday =  [DateFormatter stringFromDate:[NSDate date]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:sToday forKey:@"recent"];
    [defaults synchronize];
    
    dispatch_async(backgroundQueue, ^{
        wordsToday = [self getAllWordsToday];
    });
}


- (void)getSentenceToday {

    // lay cau
    dispatch_async(backgroundQueue, ^{
        [self acceptDBGetSentenceToday];
    });
    
}


- (void)acceptDBGetSentenceToday {
    
    NSLog(@"--- GET ALL SENTENCES TODAY----");
    
    NSMutableArray *sentenceAndWordToday = [[NSMutableArray alloc] init];
    
    FMDatabase *database = [FMDatabase databaseWithPath:[self pathForDB]];
    [database open];
    
    for (WordObject *word in wordsToday) {
        
        NSMutableArray *arraySentenceOfWord = [[NSMutableArray alloc] init];

        NSString *queryGetSentence = [NSString stringWithFormat:@"SELECT Sentences.* FROM Sentences, SentenceHasWords WHERE Sentences.sentenceID = SentenceHasWords.sentenceID AND SentenceHasWords.word = \'%@\' AND isDisplay = 0", word.text];
        FMResultSet *sentences = [database executeQuery:queryGetSentence];


        while ([sentences next] && arraySentenceOfWord.count < 2) {
            
            NSString *sentence = [sentences stringForColumn:@"sentence"];
            [arraySentenceOfWord addObject:sentence];
            
            [self isDisplayChangeWithDatabase:database senteceID:[sentences stringForColumn:@"sentenceID"]];
        }
        
        if (arraySentenceOfWord.count < 2) {

            NSString *queryGetSentence1 = [NSString stringWithFormat:@"SELECT Sentences.* FROM Sentences, SentenceHasWords WHERE Sentences.sentenceID = SentenceHasWords.sentenceID AND SentenceHasWords.word = \'%@\' AND isDisplay = 1 ORDER BY RANDOM() ", word.text];
            FMResultSet *sentences1 = [database executeQuery:queryGetSentence1];
            
            while ([sentences1 next] && arraySentenceOfWord.count < 2) {
                
                NSString *sentence = [sentences1 stringForColumn:@"sentence"];
                [arraySentenceOfWord addObject:sentence];
                
//                [self isDisplayChangeWithDatabase:database senteceID:[sentences1 stringForColumn:@"sentenceID"]];
            }
        }
        
        
        SentenceHasWord *senHasWord = [[SentenceHasWord alloc] init];
        senHasWord.word = word;
        senHasWord.arraySentences = arraySentenceOfWord;
        
        [sentenceAndWordToday addObject:senHasWord];
    }
    
    [database close];

    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"haki.englishnow.sentenceToday" object:sentenceAndWordToday userInfo:nil];
    });
}


- (void)isDisplayChangeWithDatabase:(FMDatabase *)database senteceID: (NSString *)sentenceID {
    
    NSString *queryUpdateDisplay = [NSString stringWithFormat:@"UPDATE SentenceHasWords SET isDisplay = 1 WHERE sentenceID = \'%@\'",sentenceID];
    BOOL isUpdated = [database executeUpdate:queryUpdateDisplay];
    
    if (isUpdated) {
        NSLog(@"-- UPDATE isDiplay done --");
    } else {
        NSLog(@"-- UPDATE isDiplay ERROR!! --");
        
    }
}


- (NSMutableArray *)getAllWordsToday {
    
        NSLog(@"-- GET ALL WORDS TODAY --");
    
    NSMutableArray *words = [[NSMutableArray alloc] init];
    
    FMDatabase *database = [FMDatabase databaseWithPath:[self pathForDB]];
    [database open];
    
    NSDateFormatter *DateFormatter = [[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *sNow =  [DateFormatter stringFromDate:[NSDate date]];
    
    NSString *queryGetWordID = [NSString stringWithFormat:@"SELECT * FROM Words WHERE nextDay <= Date('%@') ORDER BY popularRank LIMIT %d", sNow, numberDaylySentence];
    FMResultSet *s = [database executeQuery:queryGetWordID];
    
    while ([s next]) {
        WordObject *w = [[WordObject alloc] init];
        w.text = [s stringForColumn:@"word"];
        w.rank = [s intForColumn:@"popularRank"];
        [words addObject:w];
    }
    
    [database close];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [databaseDelegate returnWordCount:words.count];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"haki.englishnow.wordsToday" object:words];

    });

    return words;
}

- (void )getAllWords {
    
    dispatch_async(backgroundQueue, ^{
        NSMutableArray *words = [[NSMutableArray alloc] init];
        words = [self getAllWordsInDB];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"haki.englishnow.words" object:words];
            
        });
        
    });
}

- (NSMutableArray *)getAllWordsInDB {
    NSMutableArray *arrayAllWords = [NSMutableArray new];
    NSLog(@"------- GET ALL WORDS---------");
    FMDatabase *database = [FMDatabase databaseWithPath:[self pathForDB]];
    [database open];
    
    NSString *queryGetAllWords = @"SELECT * FROM Words ORDER BY popularRank";
    FMResultSet *s = [database executeQuery:queryGetAllWords];
    
    while ([s next]) {
        
        WordObject *wordObject = [WordObject new];
        wordObject.text = [s stringForColumn:@"word"];
        wordObject.nextDay = [s stringForColumn:@"nextDay"];
        wordObject.rank = [s intForColumn:@"popularRank"];
        
        [arrayAllWords addObject:wordObject];
    }
    
    return arrayAllWords;
}



/*
 
 I(1) = 1;
 I(2) = 6;
 EF(1) = 2.5;
 EF(2) = 2.5;
 
 EF = EF + (0.1-(5-q)*(0.08+(5-q)*0.02));
 I = I*EF;
 nextDay = now + I;
 
 */

#pragma mark - Set

- (void)addWord: (NSString *)newWord {
    
    dispatch_async(backgroundQueue, ^{
         [self acceptDBAddWordsTable:newWord];
    });
}

// TODO Viet lai ham addWord cho de nhin hon
- (void)acceptDBAddWordsTable: (NSString *)tapedWord {
    
    FMDatabase *database = [FMDatabase databaseWithPath:[self pathForDB]];
    [database open];
    
    NSString *queryGetWord = [NSString stringWithFormat:@"SELECT * FROM Words WHERE word = \'%@\'",tapedWord];
    FMResultSet *s = [database executeQuery:queryGetWord];

// Truong hop da ton tai tapedWord trong Words table
    if ([s next]) {

        NSDateFormatter *DateFormatter = [[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *sNow =  [DateFormatter stringFromDate:[NSDate date]];
        // update lai cac gia tri.
        if ([self isExistInWordsToday:tapedWord] && [[s stringForColumn:@"nextDay"] isEqualToString:sNow]) {
          
            float oldEF = [s doubleForColumn:@"EF"];
            NSInteger oldI = [s intForColumn:@"I"];
            
            NSString * queryUpdateWord = [self getQueryUpdateParameterOfWord:tapedWord andOldEF:oldEF oldI:oldI];
            
            BOOL isUpdated = [database executeUpdate:queryUpdateWord];
            
            if (isUpdated) {
                NSLog(@"-- THE WORD HAS BEEN UPDATED --");
            } else {
                NSLog(@"-- UPDATE WORD ERROR!! --");

            }
        }
        

    }
    
    else {
        
        //truong hop newWord chua ton lai trong Words table: add vao bang word

        NSInteger rank = [self getRankPopularOfWord:tapedWord];
        
        float EF = 2.5;
        NSInteger I = 1;

        NSDate *nextDay = [NSDate dateWithTimeIntervalSinceNow:60*60*24*I];
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *sNextDay =  [DateFormatter stringFromDate:nextDay];
        
        
        //create
        NSString *addNewWord = [NSString stringWithFormat:@"INSERT INTO Words(word, EF, I, nextDay, popularRank) values('%@', %f, %ld, '%@', %d)", tapedWord, EF, (long)I, sNextDay, rank];
        
        BOOL isDone = [database executeUpdate:addNewWord];
        
        if (isDone) {
            
            NSLog(@"-- THE WORD HAS BEEN ADDED --");
            [self requestSentences:tapedWord];
            
        } else {
            
            NSLog(@"-- ADD WORD ERROR!! --");
        }

        
    }
    
    [database close];
}


// PopularWords(id, word, rank)

- (NSInteger )getRankPopularOfWord: (NSString *)word {
    
    NSInteger rank = 100000;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"englishnow" ofType:@"sqlite3"];
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    NSString *getPopularRank = [NSString stringWithFormat:@"SELECT * FROM PopularWords WHERE word = '%@'", word];
    FMResultSet *s = [database executeQuery:getPopularRank];

    if ([s next]) {
        rank = [s intForColumn:@"rank"];
    }
    [database close];

    return rank;
}

- (BOOL)isExistInWordsToday: (NSString *)word {
    
    for (WordObject *w in wordsToday) {
        if ([w.text isEqualToString:word]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - SuperMemo

- (NSString *)getQueryUpdateParameterOfWord: (NSString *)word andOldEF: (float )oldEF oldI: (NSInteger )oldI {
    
    NSInteger newI;
    float newEF;
    
    if (oldI == 1) {   //neu I = 1 thi day la lan lap lai dau tien
        newI = 6;
        newEF = 2.5;
        
    } else {
        newEF = [self calculatorEF:oldEF andResponse:3];
        newI = [self calculatorNewI:oldI newEF:oldEF];
    }
    
    NSDate *nextDay = [NSDate dateWithTimeIntervalSinceNow:60*60*24*newI];
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *sNextDay =  [DateFormatter stringFromDate:nextDay];
    
    NSString *queryUpdate = [NSString stringWithFormat:@"UPDATE Words SET EF = %f, I = %ld, nextDay = '%@' where word = \'%@\'", newEF, (long)newI, sNextDay, word];

    return queryUpdate;
}


- (float )calculatorEF: (float)oldEF andResponse: (NSInteger)q {
    
    float newEF;
    newEF = oldEF + (0.1-(5-q)*(0.08+(5-q)*0.02));
    return newEF;
}

- (NSInteger )calculatorNewI: (NSInteger )oldI newEF: (float)newEF {
    
    return oldI*newEF;
}

#pragma mark - Tao Test

- (void)createTestsWithNumberQuestion: (NSInteger) numberQuestions; {
    
    dispatch_async(backgroundQueue, ^{
        [self taoTest:numberQuestions];
    });
    
}

- (void)taoTest: (NSInteger )soCauHoi {
    
    NSMutableArray *arrayQuestions = [[NSMutableArray alloc] init];
    
    
    FMDatabase *database = [FMDatabase databaseWithPath:[self pathForDB]];
    [database open];

    //TODO: Gioi han lai random theo popular rank
    NSString *queryGetWord = [NSString stringWithFormat:@"SELECT * FROM  (SELECT * FROM Words ORDER BY popularRank LIMIT 50) ORDER BY RANDOM() LIMIT %d", soCauHoi+20];
    
    FMResultSet *s = [database executeQuery:queryGetWord];
    
    allWords = [self getAllWordsInDB];
    
    while ([s next]) {
        
        NSString *word = [s stringForColumn:@"word"];
        
        NSString *queryGetSentence = [NSString stringWithFormat:@"SELECT * FROM Sentences, SentenceHasWords WHERE Sentences.sentenceID = SentenceHasWords.sentenceID AND SentenceHasWords.word = \'%@\' AND isDisplay = 1", word];
        
        FMResultSet *sentencesResult = [database executeQuery:queryGetSentence];
        
        if ([sentencesResult next]) {
            
            NSString *sentence = [sentencesResult stringForColumn:@"sentence"];
            
            sentence = [self questionFromSentence:sentence correctAnswer:word];
            
            if (sentence) {
                
                NSMutableArray *wrongAnwers = [self randomWrongAnswer:word];
                Test *test = [[Test alloc] initWithSentence:sentence correctAnswer:word wrong1:wrongAnwers[0] wrong2:wrongAnwers[1] wrong3:wrongAnwers[2]];
                [arrayQuestions addObject:test];
                
            }
            
        }
        else {
            
            NSString *queryGetSentence0 = [NSString stringWithFormat:@"SELECT * FROM Sentences, SentenceHasWords WHERE Sentences.sentenceID = SentenceHasWords.sentenceID AND SentenceHasWords.word = \'%@\'", word];
            
            FMResultSet *sentences0Result = [database executeQuery:queryGetSentence0];
            
            
            if ([sentences0Result next]) {
                
                NSString *sentence0 = [sentences0Result stringForColumn:@"sentence"];
                sentence0 = [self questionFromSentence:sentence0 correctAnswer:word];
                
                if (sentence0) {
                    
                    NSMutableArray *wrongAnwers = [self randomWrongAnswer:word];
                    Test *test = [[Test alloc] initWithSentence:sentence0 correctAnswer:word wrong1:wrongAnwers[0] wrong2:wrongAnwers[1] wrong3:wrongAnwers[2]];
                    [arrayQuestions addObject:test];
                
                }

            }
        }
        
        if (arrayQuestions.count == soCauHoi) {
            break;
        }
    }
    
    [database close];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"haki.englishnow.test" object:arrayQuestions];
    });
}


- (NSMutableArray *)randomWrongAnswer: (NSString *)correctAnswer {
    
    
    NSMutableArray *wrongAnswers = [[NSMutableArray alloc] init];
    
    int i = 0;
    do {
        int r = arc4random() % allWords.count;
        WordObject *word = [allWords objectAtIndex:r];
        
        if (![word.text isEqualToString:correctAnswer] && ![wrongAnswers containsObject:word.text]) {
            
            [wrongAnswers addObject:word.text];
            i++;
        }
        
    } while (i < 3);
    
    
    return wrongAnswers;
    
}

- (NSString *)questionFromSentence: (NSString *)sentence correctAnswer: (NSString *)correctAnswer {
    
    
    NSString *question = [[NSString alloc] init];
    
    NSString *replaceNomal = [NSString stringWithFormat:@" %@ ", correctAnswer];
    
    question = [sentence stringByReplacingOccurrencesOfString:replaceNomal withString:@" ____ "];
    
    // truong hop viet hoa
    if ([sentence isEqualToString:question]) {
        
        NSString *firstCapChar = [[correctAnswer substringToIndex:1] capitalizedString];
        NSString *cappedString = [correctAnswer stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
        
        NSString *replaceUpcase = [NSString stringWithFormat:@" %@ ", cappedString];
        question = [sentence stringByReplacingOccurrencesOfString:replaceUpcase withString:@" ____ "];
        
        // truong hop dung dau dong
        if ([question isEqualToString:sentence]) {
            
            NSString *replaceFirst = [NSString stringWithFormat:@"%@ ", cappedString];
            question = [sentence stringByReplacingOccurrencesOfString:replaceFirst withString:@" ____ "];
            
            //thuong hop them _s
            if ([question isEqualToString:sentence]) {
                
                NSString *stringAddS = [correctAnswer stringByAppendingString:@"s"];
                NSString *replaceNomal1 = [NSString stringWithFormat:@" %@ ", stringAddS];
                question = [sentence stringByReplacingOccurrencesOfString:replaceNomal1 withString:@" ____ "];
                
                // truong hop them _es
                if ([question isEqualToString:sentence]) {
                    
                    NSString *stringAddES = [correctAnswer stringByAppendingString:@"es"];
                    NSString *replaceNomal2 = [NSString stringWithFormat:@" %@ ", stringAddES];
                    question = [sentence stringByReplacingOccurrencesOfString:replaceNomal2 withString:@" ____ "];
                    
                    // truong hop them _ed
                    if ([question isEqualToString:sentence]) {
                        
                        NSString *stringAddED = [correctAnswer stringByAppendingString:@"ed"];
                        NSString *replaceNomal3 = [NSString stringWithFormat:@" %@ ", stringAddED];
                        question = [sentence stringByReplacingOccurrencesOfString:replaceNomal3 withString:@" ____ "];
                        
                        // truong hop them _ing
                        if ([question isEqualToString:sentence]) {
                            
                            NSString *stringAddING = [correctAnswer stringByAppendingString:@"ing"];
                            NSString *replaceNomal4 = [NSString stringWithFormat:@" %@ ", stringAddING];
                            question = [sentence stringByReplacingOccurrencesOfString:replaceNomal4 withString:@" ____ "];
                            
                            if ([question isEqualToString:sentence]) {
                                
                                // truong hop dung cuoi dong dau
                                NSString *replaceNomal5 = [NSString stringWithFormat:@" %@", correctAnswer];
                                question = [sentence stringByReplacingOccurrencesOfString:replaceNomal5 withString:@" ____ "];
                                // cac truong hop dung cuoi dong nhung lai them _ing/_s/_es
                                if ([question isEqualToString:sentence]) {
                                    return nil;
                                }
                            }
                        }
                        
                        
                    }
                }
            }
        }
    }
    
    
    return question;
}

@end
