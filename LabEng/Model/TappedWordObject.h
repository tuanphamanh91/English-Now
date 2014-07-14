//
//  TappedWordObject.h
//  English Now
//
//  Created by Tuan Pham Anh on 7/8/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TappedWordObject : NSObject

@property (nonatomic, strong) NSString *word;
@property (nonatomic, assign) NSInteger numberTouch;

- (id)initWithWord:(NSString *)word andNumberTouch:(NSInteger )number;

@end
