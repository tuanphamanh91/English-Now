//
//  SentenceObject.m
//  English Now
//
//  Created by Tuan Pham Anh on 7/1/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import "SentenceObject.h"

@implementation SentenceObject

- (id)initWithSentence:(NSString*)text translateSentence:(NSString*)translateText containWord:(NSString*)containWord {
    
    self = [super init];
    if (self) {
        _text = text;
        _translateText = translateText;
        _containWord = containWord;
    }
    return self;
}
@end
