//
//  ProcessAPI.m
//  English Now
//
//  Created by Tuan Pham Anh on 6/13/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import "ProcessAPI.h"
#import "HTTPClient.h"
#import "PersistencyManager.h"
#import "ChiMuc.h"
#import "Constants.h"
#import <dispatch/dispatch.h>
#import "SuperMemo.h"

@interface ProcessAPI () {
    
    PersistencyManager *persistencyManager;
    HTTPClient *httpClient;
    ChiMuc *chiMuc;
    BOOL isOnline;
    
    dispatch_queue_t backgroundQueue;
    
    NSMutableArray *allWordsToday;
    NSMutableArray *allWords;
}
@end

@implementation ProcessAPI

+ (ProcessAPI *)sharedInstance {
    
    static ProcessAPI *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[ProcessAPI alloc] init];
    });
    return _sharedInstance;
}


- (id)init {
    self = [super init];
    if (self) {
        persistencyManager = [[PersistencyManager alloc] init];
        [persistencyManager createDatabase];
        
        httpClient = [[HTTPClient alloc] init];
        
        chiMuc = [[ChiMuc alloc] init];
        [chiMuc khoiTaoChiMucTuDien:@"anhviet109K"];
        backgroundQueue = dispatch_queue_create("haki.englishnow", NULL);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTodayWords) name:UIApplicationWillEnterForegroundNotification object:nil];
        
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Work with word

- (void)getTodayWords {
    
    dispatch_async(backgroundQueue, ^{
        allWordsToday = [persistencyManager getTodayWordsWithNumber:[self numberWordsDaily] + 50];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSInteger number = [self getNumberTodayWords];
            NSDictionary *dict = [NSDictionary dictionaryWithObject:
                                  [NSNumber numberWithInt:number]                                                            forKey:@"number"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationNameNumberWords object:self userInfo:dict];
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationNameTodayWords object:allWordsToday userInfo:nil];
        });
    });
    
    
}

- (void)getAllWords {
    dispatch_async(backgroundQueue, ^{
        allWords = [persistencyManager getAllWords];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationNameAllWords object:allWords userInfo:nil];
        });
    });
}


- (NSInteger )getNumberTodayWords {
    if ([self numberWordsDaily] < allWordsToday.count) {
        return [self numberWordsDaily];
    }
    else {
        
        return allWordsToday.count;
    }
}

- (void)getSentencesContainWordInArray:(NSArray *)arrayWords {
    NSMutableArray *arraySentence = [[NSMutableArray alloc] init];
    
    dispatch_async(backgroundQueue, ^{
        
        [arrayWords enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            WordObject *wobj = obj;
            NSMutableArray *sobjs = [persistencyManager getSentencesContainWord:wobj.text numberSentence:2];
            [arraySentence addObjectsFromArray:sobjs];
        }];
        
       dispatch_async(dispatch_get_main_queue(), ^{
           [[NSNotificationCenter defaultCenter] postNotificationName:notificationNameTodaySentences object:arraySentence userInfo:nil];
       });
        
    });
}


- (void)deleteWord:(NSString *)word {
    dispatch_async(backgroundQueue, ^{
        [persistencyManager deleteWordAndItsSentences:word];
    });
}

- (NSInteger )numberWordsDaily {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger numberWordsDaily = [defaults integerForKey:userDefaultNumberWords];
    return numberWordsDaily;
}


- (void)addWord:(NSString *)text andRank:(NSInteger )rank {
    
    float EF = [SuperMemo calculatorEFwithOldEF:0 response:0];
    NSInteger I = [SuperMemo calculatorNewIwithOldI:0 newEF:EF];
    if (I == 4) EF = 2.5;

    NSDate *nextDay = [NSDate dateWithTimeIntervalSinceNow:60*60*24*I];
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *sNextDay =  [DateFormatter stringFromDate:nextDay];
    WordObject *wobj = [[WordObject alloc] initWithText:text nextDay:sNextDay rank:rank withI:I withEF:EF];
    
    [persistencyManager addWord:wobj];
}


- (void)addSentence:(SentenceObject *)sentenceObject {
    [persistencyManager addSentence:sentenceObject];
}


- (void)wordTapped:(NSString *)wordTapped {
    dispatch_async(backgroundQueue, ^{
        if (![persistencyManager isExistWords:wordTapped]) {
            [self httpRequestGetSentencesContainWord:wordTapped];
        }
    });
    
}


- (void)updatePropertyOfWords: (NSMutableArray *)words {
    dispatch_async(backgroundQueue, ^{
        [words enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    //
        }];
        
    });
}


- (void)updatePropertyOfWord: (NSString *)word withResponse: (NSInteger )q {
    WordObject *wobj = [persistencyManager getObjectFromText:word];
    
    float newEF = [SuperMemo calculatorEFwithOldEF:wobj.EF response:q];
    NSInteger newI = [SuperMemo calculatorNewIwithOldI:wobj.I newEF:newEF];
    
    NSDate *nextDay = [NSDate dateWithTimeIntervalSinceNow:60*60*24*newI];
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *sNextDay =  [DateFormatter stringFromDate:nextDay];
    
    WordObject *newWobj = [[WordObject alloc] initWithText:wobj.text nextDay:sNextDay rank:wobj.rank withI:newI withEF:newEF];
    [persistencyManager updateWord:newWobj];
}

#pragma mark - Search Dictionary

- (NSString *)searchDictionary:(NSString *)word {
    
    // cai dat them tu dien stardict... Search 109k truoc, ko co thi search stardict, ko co nua moi tru di tung chu mot.
    NSString *mean = nil;
    while (!mean && word.length > 0) {
        mean = [chiMuc traTu:word];
        word  = [word substringToIndex:word.length-1];

    }
    if (!mean) {
        return @"Not found!";
    }
    return mean;
}


#pragma mark - Http client

- (void )httpRequestGetSentencesContainWord: (NSString *)word {
    
    NSString *strURL = [NSString stringWithFormat:@"http://157.238.142.16/englishnow/apis/translated_sentences/vie/%@.json", word];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:strURL parameters:nil success:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
         
         NSString *word = [responseObject valueForKeyPath:@"data.word"];
         NSString *sRank = [responseObject valueForKeyPath:@"data.rank"];
         if (word) {
             [[ProcessAPI sharedInstance] addWord:word andRank: [sRank integerValue]];
         }
         
         NSArray *array_sentence = [responseObject valueForKeyPath:@"data.array_sentence"];
         
         [array_sentence enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
             NSString *sentence = [obj objectForKey:@"sentence"];
             NSString *translate_sentence = [obj objectForKey:@"translate_sentence"];
             
             SentenceObject *sobj = [[SentenceObject alloc] initWithSentence:sentence translateSentence:translate_sentence containWord:word];
             [[ProcessAPI sharedInstance] addSentence:sobj];
             
         }];
         
         NSLog(@"add word and sentences done!");
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Save Cache...");
             [[ProcessAPI sharedInstance] cacheWord:word];
         }];
    
}


- (void)cacheWord: (NSString *)word {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *cacheWords = [defaults objectForKey:userDefaultCacheWords];
    if (![cacheWords containsObject:word]) {
        [cacheWords addObject:word];
        [defaults synchronize];
    }
}

- (void)httpRequestSentenceOfWordsInCache {
    // neu co mang thi...
    NSLog(@"Request cache...");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *cacheWords = [defaults objectForKey:userDefaultCacheWords];
    [cacheWords enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [[ProcessAPI sharedInstance] httpRequestGetSentencesContainWord:obj];
        [cacheWords removeObject:obj];
    }];
    
}
@end
