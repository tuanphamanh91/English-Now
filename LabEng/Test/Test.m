//
//  Test.m
//  EngLishNow
//
//  Created by Tuan Pham Anh on 5/18/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import "Test.h"

@implementation Test

- (id)initWithSentence: (NSString *)sentence correctAnswer: (NSString *)correct wrong1: (NSString *)answer1 wrong2: (NSString *)answer2 wrong3: (NSString *)answer3 {
    
    self = [super init];
    
    if (self) {
        
        self.sentence = sentence;
        self.correctAnswer = correct;
        self.wrongAnswer1 = answer1;
        self.wrongAnswer2 = answer2;
        self.wrongAnswer3 = answer3;
    }
    return self;
}
@end
