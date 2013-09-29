//
//  CCCell.m
//  Communicaid
//
//  Created by Lee Yu Zhou on 29/9/13.
//  Copyright (c) 2013 Lee Yu Zhou. All rights reserved.
//

#import "CCCell.h"

@implementation CCCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
