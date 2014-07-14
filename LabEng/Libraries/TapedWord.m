//
//  TapedWord.m
//  LabEng
//
//  Created by Tuan Pham Anh on 6/6/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import "TapedWord.h"

@implementation TapedWord

+(NSString*)getWordAtPosition:(CGPoint)pos inTextView:(UITextView*)_tv
{
    //eliminate scroll offset
    pos.y += _tv.contentOffset.y;
    //get location in text from textposition at point
    UITextPosition *tapPos = [_tv closestPositionToPoint:pos];
    //fetch the word at this position (or nil, if not available)
    UITextRange * wr = [_tv.tokenizer rangeEnclosingPosition:tapPos withGranularity:UITextGranularityWord inDirection:UITextLayoutDirectionRight];
    return [_tv textInRange:wr];
}

@end
