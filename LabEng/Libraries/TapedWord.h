//
//  TapedWord.h
//  LabEng
//
//  Created by Tuan Pham Anh on 6/6/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TapedWord : NSObject

+(NSString*)getWordAtPosition:(CGPoint)pos inTextView:(UITextView*)_tv;


@end
