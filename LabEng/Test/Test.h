//
//  Test.h
//  EngLishNow
//
//  Created by Tuan Pham Anh on 5/18/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Test : NSObject

@property (nonatomic, strong) NSString *sentence;

@property (nonatomic, strong) NSString *correctAnswer;

@property (nonatomic, strong) NSString *wrongAnswer1;

@property (nonatomic, strong) NSString *wrongAnswer2;

@property (nonatomic, strong) NSString *wrongAnswer3;


- (id)initWithSentence: (NSString *)sentence correctAnswer: (NSString *)correct wrong1: (NSString *)answer1 wrong2: (NSString *)answer2 wrong3: (NSString *)answer3;

@end
