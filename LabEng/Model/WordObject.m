//
//  WordObject.m
//  English Now
//
//  Created by Tuan Pham Anh on 7/1/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import "WordObject.h"

@implementation WordObject

- (id)initWithText:(NSString*)text nextDay:(NSString*)nextDay rank:(NSInteger)rank withI:(NSInteger )i withEF:(float)ef{
    
    self = [super init];
    if (self) {
        _text = text;
        _nextDay = nextDay;
        _rank = rank;
        _EF = ef;
        _I = i;
    }
    return self;
}

@end
