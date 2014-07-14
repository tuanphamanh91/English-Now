//
//  WordObject.h
//  English Now
//
//  Created by Tuan Pham Anh on 7/1/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordObject : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *nextDay;
@property (nonatomic, assign) NSInteger rank;
@property (nonatomic, assign) NSInteger I;
@property (nonatomic, assign) float EF;


- (id)initWithText:(NSString*)text nextDay:(NSString*)nextDay rank:(NSInteger)rank withI:(NSInteger )i withEF:(float)ef;
@end
