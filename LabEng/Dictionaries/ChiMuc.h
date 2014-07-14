//
//  ChiMuc.h
//  EngLishNow
//
//  Created by Tuan Pham Anh on 3/31/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface ChiMuc : NSObject

@property (nonatomic, strong) NSString *nameOfIndexFile;
@property (nonatomic, strong) NSMutableArray *arrayChiMuc;
@property (nonatomic, strong) NSMutableDictionary *dictChiMuc;
@property (nonatomic, strong) MBProgressHUD *HUD;

- (void)khoiTaoChiMucTuDien:(NSString *)indexFileName;

- (NSString *)traTu: (NSString *)sTuCanTra;

@end
