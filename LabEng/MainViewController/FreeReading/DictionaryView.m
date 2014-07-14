//
//  DictionaryView.m
//  EngLishNow
//
//  Created by Tuan Pham Anh on 3/14/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import "DictionaryView.h"

#define DICTBLACKVIEW_ALPHA 0.85
#define VIEW_WIDTH 320
#define VIEW_HEIGHT 150

@implementation DictionaryView

@synthesize textViewMean;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.layer.cornerRadius = 10;
        self.tintColor = [UIColor whiteColor];
        self.contentMode = UIViewContentModeTop;
        self.backgroundColor = [UIColor brownColor];
        
        textViewMean = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
        textViewMean.editable = NO;
        textViewMean.backgroundColor = [UIColor clearColor];
        textViewMean.font = [UIFont systemFontOfSize:15];
        textViewMean.textColor = [UIColor whiteColor];
    
        [self addSubview:textViewMean];
        
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

@end
