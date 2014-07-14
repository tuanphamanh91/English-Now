//
//  TappedWordObject.m
//  English Now
//
//  Created by Tuan Pham Anh on 7/8/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import "TappedWordObject.h"

@implementation TappedWordObject


- (id)initWithWord:(NSString *)word andNumberTouch:(NSInteger )number {
    self = [super init];
    if (self) {
        _word = word;
        _numberTouch = number;
    }
    return self;
}
@end
