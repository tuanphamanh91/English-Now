//
//  SentenceObject.h
//  English Now
//
//  Created by Tuan Pham Anh on 7/1/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SentenceObject : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *translateText;
@property (nonatomic, strong) NSString *containWord;

- (id)initWithSentence:(NSString*)text translateSentence:(NSString*)translateText containWord:(NSString*)containWord ;

@end
