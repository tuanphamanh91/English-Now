//
//  CustomCell.m
//  LabEng
//
//  Created by Tuan Pham Anh on 6/8/14.
//  Copyright (c) 2014 Tuan Pham Anh. All rights reserved.
//

#import "CustomCell.h"
#import "CodeColor.h"
#import "Constants.h"

@implementation CustomCell

@synthesize labelRank;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        labelRank = [[UILabel alloc] initWithFrame:CGRectMake(180, 5, 70, 40)];
        labelRank.font = [UIFont fontWithName:fontTitle size:20];
        labelRank.textAlignment = NSTextAlignmentCenter;
        [self addSubview:labelRank];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
