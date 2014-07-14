//
//  ChiMuc.m
//  EngLishNow
//
//  Created by Tuan Pham Anh on 3/31/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import "ChiMuc.h"
#import "HeMaCeasar.h"
#import "AppDelegate.h"

@implementation ChiMuc
@synthesize arrayChiMuc, dictChiMuc, nameOfIndexFile;

- (id)init {
    
    self = [super init];
    if (self) {
        self.dictChiMuc = [[NSMutableDictionary alloc] init];
    }
    return self;
    
}

- (void)khoiTaoChiMucTuDien:(NSString *)fileName {
    
    arrayChiMuc = [[NSMutableArray alloc] init];
    self.nameOfIndexFile = fileName;
    
    self.HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:self.HUD];
    self.HUD.dimBackground = YES;
    [self.HUD setColor:[UIColor clearColor]];
    
	[self.HUD showWhileExecuting:@selector(khoiTaoChiMuc) onTarget:self withObject:nil animated:YES];
    
}


- (void)khoiTaoChiMuc {
    
    NSString *pathChiMuc = [[NSBundle mainBundle] pathForResource:nameOfIndexFile ofType:@"index"];
    
    if (![pathChiMuc isEqualToString:@""]) {
        if ([[self.dictChiMuc objectForKey:nameOfIndexFile] count] == 0) {
            
            NSData *dataChiMuc = [NSData dataWithContentsOfFile:pathChiMuc];
            NSString *content = [[NSString alloc] initWithData:dataChiMuc encoding:NSUTF8StringEncoding];
            [self.arrayChiMuc addObjectsFromArray:[content componentsSeparatedByString:@"\n"]];
            
            
            [self.dictChiMuc setObject:self.arrayChiMuc forKey:nameOfIndexFile];
            
        }else {
            
            [self.arrayChiMuc addObjectsFromArray:[self.dictChiMuc objectForKey:nameOfIndexFile]];
        }
    }
    else {
        
        NSLog(@"Không có file chỉ mục");
    }
    NSLog(@"Tong chi muc: %lu",(unsigned long)arrayChiMuc.count);
    
}


- (NSString *)docFileDictWithLocation: (NSInteger )locationDict length: (NSInteger )lengthDict {
    
    NSString *dictFilename = @"anhviet109K2";
    NSString *sDataFilePath = [[NSBundle mainBundle] pathForResource:dictFilename ofType:@"txt"];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:sDataFilePath];
    
    [fileHandle seekToFileOffset:locationDict];
    NSData *databuffer = [fileHandle readDataOfLength:lengthDict];
    
    NSString *sGiaiNghia = [[NSString alloc] initWithData:databuffer encoding:NSUTF8StringEncoding];
    [fileHandle closeFile];
    
    return sGiaiNghia;
    
}


- (NSInteger )chuyenCoSo: (NSString *)cosoGoc {
    
    NSString *CHUSO = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    NSInteger result = 0;
    
    for (int i = 0; i < [cosoGoc length]; i++) {
        
        NSString  *charString = [cosoGoc substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [CHUSO rangeOfString:charString];
        result = result*64 + range.location;
        
    }
    
    return result;
}


- (NSString *)traTu: (NSString *)sTuCanTra {
    
    NSString *chiMuc = [self layChiMucTuTraNhanh:sTuCanTra];
    
    if (![chiMuc isEqualToString:@"-1"]) {
        
        
        NSString *sLocation = [[chiMuc componentsSeparatedByString:@"\t"] objectAtIndex:1];
        NSString *sLength = [[chiMuc componentsSeparatedByString:@"\t"] objectAtIndex:2];
        
        NSString *result = [self docFileDictWithLocation:[self chuyenCoSo:sLocation] length:[self chuyenCoSo:sLength]];
        return result;
        
    }
    
    else
    {
        return nil;
    }
}

- (NSString*)layChiMucTuTraNhanh:(NSString*)sTuTraNhanh {
    
    NSInteger lower = 0;
    NSInteger upper = arrayChiMuc.count;
    NSInteger mid;
    while (lower <= upper) {
        mid = (lower + upper)/2;
        sTuTraNhanh = [sTuTraNhanh lowercaseString];
        NSString *midString = [[[arrayChiMuc objectAtIndex:mid] componentsSeparatedByString:@"\t"] objectAtIndex:0];
        midString = [midString lowercaseString];
        NSComparisonResult result = [self soSanhHaiString:midString and:sTuTraNhanh];
        
        if (result == 1) {
            upper = mid - 1;
        }
        else if (result == -1) {
            lower = mid + 1;
        }
        else {
            
            return [arrayChiMuc objectAtIndex:mid];
        }
    }
    return @"-1";
    
}


- (NSComparisonResult)soSanhHaiString:(NSString*)sChuoiMot and:(NSString*)sChuoiHai {
    
    NSComparisonResult comparisonResult = [sChuoiMot compare:sChuoiHai];
    return comparisonResult;
}


@end
