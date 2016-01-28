//
//  MenuTableViewCell.m
//  Triathlon
//
//  Created by Aleksandr on 07/12/15.
//  Copyright © 2015 LiveTyping. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell

- (void)awakeFromNib {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.25]];
    }else{
        [self setBackgroundColor:[UIColor clearColor]];
    }
    // Configure the view for the selected state
}

@end
