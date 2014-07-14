//
//  TextView.m
//  EngLishNow
//
//  Created by Tuan Pham Anh on 6/3/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import "TextView.h"

@implementation TextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.editable = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (BOOL)canBecomeFirstResponder {
    return NO;
}

@end
