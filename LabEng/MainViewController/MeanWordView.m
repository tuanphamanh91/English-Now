//
//  MeanWord.m
//  LabEng
//
//  Created by Tuan Pham Anh on 6/10/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import "MeanWordView.h"
#import "CodeColor.h"
#import "Constants.h"

@implementation MeanWordView
@synthesize textViewMean, labelWord;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
        labelWord = [[UILabel alloc] init];
        labelWord.frame = CGRectMake(10, 20, frame.size.width - 10*2, 40);
        labelWord.textAlignment = NSTextAlignmentCenter;
        labelWord.font = [UIFont fontWithName:fontTitle size:30];
        labelWord.textColor = [CodeColor colorFromHexString:codeColor];

        [self addSubview:labelWord];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 60, frame.size.width - 10*2, 1)];
        lineView.backgroundColor = [CodeColor colorFromHexString:buttonColor];
        [self addSubview:lineView];
        
        
        textViewMean = [[TextView alloc] initWithFrame:CGRectMake(10, 80, frame.size.width - 10*2, frame.size.height - 100)];
        textViewMean.editable = NO;
        textViewMean.backgroundColor = [UIColor clearColor];
//        textViewMean.textColor = [CodeColor colorFromHexString:codeColor];
        textViewMean.font = [UIFont fontWithName:fontLabel size:20];

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
