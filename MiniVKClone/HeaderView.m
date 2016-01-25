//
//  HeaderView.m
//  MiniVKClone
//
//  Created by Антон Дитятив on 24.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import "HeaderView.h"
#import "WebImageView.h"
@interface HeaderView ()

@property(strong, nonatomic)WebImageView *avatarImage;
@property(strong, nonatomic)UILabel *nameLabel;

@end

@implementation HeaderView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if(self) {
        [self addSubview:self.avatarImage];
        [self addSubview:self.nameLabel];
    }    
    return self;
}

-(WebImageView *)avatarImage {
    if(!_avatarImage) {
        _avatarImage = [[WebImageView alloc] init];
        [_avatarImage setClipsToBounds:YES];
        [_avatarImage setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _avatarImage;
}

-(UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel sizeToFit];
        [_nameLabel setBackgroundColor:[UIColor redColor]];
        [_nameLabel setFrame:CGRectMake(CGRectGetMaxX(_avatarImage.frame), 10, _nameLabel.frame.size.width, _nameLabel.frame.size.height)];
    }
    
    return _nameLabel;
}

-(void)setupHeaderFrom:(NewsModel *)model {
    [_avatarImage setImageWithURL:model.profileAvatar];
    [_nameLabel setText:model.profileName];
    NSLog(@"%@", _nameLabel.text);
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [_avatarImage setFrame:CGRectMake(5, 0, 40, 40)];
    _avatarImage.layer.cornerRadius = 20;
    [_nameLabel sizeToFit];
    [_nameLabel setFrame:CGRectMake(CGRectGetMaxX(_avatarImage.frame), 10, _nameLabel.frame.size.width, _nameLabel.frame.size.height)];
}

@end
