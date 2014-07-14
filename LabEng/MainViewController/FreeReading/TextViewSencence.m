//
//  TextViewSencence.m
//  EngLishNow
//
//  Created by Tuan Pham Anh on 3/13/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import "TextViewSencence.h"
#import "Constants.h"
#import "CodeColor.h"


@implementation TextViewSencence 
@synthesize delegate;
@synthesize myTextView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        myTextView = [[TextView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        myTextView.textColor = [UIColor brownColor];
        myTextView.font = [UIFont fontWithName:@"GurmukhiMN" size:24];
        myTextView.editable = NO;
        myTextView.backgroundColor = [UIColor clearColor];

        [myTextView setShowsHorizontalScrollIndicator:NO];
        [myTextView setShowsVerticalScrollIndicator:NO];
        [self addSubview:myTextView];

        self.layer.cornerRadius = 10;
        self.tintColor = [UIColor colorWithRed:0 green:0.5 blue:0.5 alpha:1];

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(printWordSelected:)];
        [myTextView addGestureRecognizer:tapGesture];
    }
    return self;
}



#pragma mark - Gesture Method

- (void)resetColor {
    
    if (attributedString != nil) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor brownColor] range:offsetRange];
        myTextView.attributedText = attributedString;
        attributedString = nil;
    }
}

- (void)printWordSelected:(id)sender {
    
    if ([myTextView.attributedText isEqualToAttributedString:attributedString]) {
            [self resetColor];
    }

    CGPoint pos = [sender locationInView:self];
    
    //eliminate scroll offset
    pos.y += myTextView.contentOffset.y;
    //get location in text from textposition at point
    UITextPosition *tapPos = [myTextView closestPositionToPoint:pos];
    
    //fetch the word at this position (or nil, if not available)
    UITextRange * wr = [myTextView.tokenizer rangeEnclosingPosition:tapPos withGranularity:UITextGranularityWord inDirection:UITextLayoutDirectionRight];
    
    NSString *wordTapped = [myTextView textInRange:wr]; //iOS 7 chay duoc
    if (wordTapped) {
        NSLog(@"Word: %@", wordTapped);
        [delegate textView:self tappedAtWord:wordTapped];
    }
    
    NSInteger startOffset = [myTextView offsetFromPosition:myTextView.beginningOfDocument toPosition:wr.start];
    NSInteger endOffset = [myTextView offsetFromPosition:myTextView.beginningOfDocument toPosition:wr.end];
    offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
    
    attributedString = [myTextView.attributedText mutableCopy];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:offsetRange];
    
    [myTextView setScrollEnabled:NO];
    [myTextView setAttributedText:attributedString];
    [myTextView setScrollEnabled:YES];

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
