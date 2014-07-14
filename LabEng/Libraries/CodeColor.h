//
//  CodeColor.h
//  MFSideMenuDemoBasic
//
//  Created by MAC on 7/2/13.
//  Copyright (c) 2013 University of Wisconsin - Madison. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CodeColor : NSObject

+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIImage *) imageFromColor:(UIColor *)color;

@end
