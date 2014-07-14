//
//  TextViewSencence.h
//  EngLishNow
//
//  Created by Tuan Pham Anh on 3/13/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TextView.h"
@protocol TextViewSencenceDelegate;

@interface TextViewSencence : UIView {
    NSMutableAttributedString *attributedString;
    NSRange offsetRange;
}

@property (strong) id<TextViewSencenceDelegate> delegate;
@property (strong, nonatomic) TextView *myTextView;

- (void)resetColor;

@end


@protocol TextViewSencenceDelegate <NSObject>

- (void)textView:(TextViewSencence *)textView tappedAtWord:(NSString *)wordTapped;

@end
