//
//  SuperMemo.m
//  English Now
//
//  Created by Tuan Pham Anh on 7/1/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import "SuperMemo.h"

@implementation SuperMemo

+ (float )calculatorEFwithOldEF: (float)oldEF response: (NSInteger)q {
    
    float newEF;
    if (oldEF == 0 && q == 0) {
        return 2.5;
    }
    
    newEF = oldEF + (0.1-(5-q)*(0.08+(5-q)*0.02));
    if (newEF < 1.3) {
        newEF = 1.3;
    }
    return newEF;
}

+ (NSInteger )calculatorNewIwithOldI: (NSInteger )oldI newEF: (float)newEF {
    if (oldI == 0) {
        return 1;
    }
    if (oldI == 1) {
        return 4;
    }
    
    return oldI*newEF;
}

/*
 
 I(1) = 1;
 I(2) = 6;
 EF(1) = 2.5;
 EF(2) = 2.5;
 
 EF = EF + (0.1-(5-q)*(0.08+(5-q)*0.02));
 I = I*EF;
 nextDay = now + I;
 
 */

@end
