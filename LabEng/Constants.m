//
//  Constants.m
//  LabEng
//
//  Created by Tuan Pham Anh on 6/5/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import "Constants.h"

@implementation Constants

#ifdef DEBUG
NSString* const codeColor = @"34AADC";
#else
NSString* const codeColor = @"4CD964";
#endif

#ifdef DEBUG
NSString* const buttonColor = @"039E22";
#else
NSString* const buttonColor = @"069022";
#endif

NSString* const fontTitle = @"Palatino-Bold";
NSString* const fontTitleNav = @"EuphemiaUCAS";


NSString* const labelColor = @"CC6600";

NSString* const fontLabel = @"AlNile";

NSString* const colorScroll = @"FFFFD7";

NSString* const colorText = @"D6CEC3";

NSString* const userDefaultNumberWords = @"NumberWordsDaily";
NSString* const userDefaultCacheWords = @"CacheWordsWhenServerDie";

NSString* const notificationNameTodayWords = @"haki.englishnow.todayWords";
NSString* const notificationNameTodaySentences = @"haki.englishnow.todaySentences";
NSString* const notificationNameAllWords = @"haki.englishnow.allWords";
NSString* const notificationNameNumberWords = @"haki.englishnow.numberWords";


@end
