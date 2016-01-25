//
//  NewsTableViewCell.m
//  MiniVKClone
//
//  Created by Антон Дитятив on 23.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import "NewsTableViewCell.h"


@interface NewsTableViewCell()

@property(strong, nonatomic)HeaderView *headerView;
@property(strong, nonatomic)WebImageView *avatarImage;
@property(strong, nonatomic)UILabel *nameLabel;
@property(strong, nonatomic)UILabel *datePostPublicate;
@property(strong, nonatomic)UILabel *postNameLabel;
@property(strong, nonatomic)UILabel *likesLabel;
@property(strong, nonatomic)UILabel *repostsLabel;

@end

@implementation NewsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self.contentView addSubview:self.avatarImage];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.datePostPublicate];
        [self.contentView addSubview:self.postNameLabel];
        [self.contentView addSubview:self.likesLabel];
        [self.contentView addSubview:self.repostsLabel];
        [self.contentView addSubview:self.imageViewq];
    }
    
    return self;
}

//-(HeaderView *)headerView {
//    if(!_headerView) {
//        _headerView = [[HeaderView alloc] init];
//        [_headerView setFrame:CGRectMake(0, 0, screenWidth, 40)];
//    }
//    return _headerView;
//}

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
    }
    
    return _nameLabel;
}

-(UILabel *)datePostPublicate {
    if(!_datePostPublicate) {
        _datePostPublicate = [[UILabel alloc] init];
        [_datePostPublicate sizeToFit];
    }
    return _datePostPublicate;
}

-(UILabel *)postNameLabel {
    if(!_postNameLabel) {
        _postNameLabel = [[UILabel alloc] init];
        [_postNameLabel setNumberOfLines:0];
        [_postNameLabel sizeToFit];
    }
    return _postNameLabel;
}

-(WebImageView *)imageViewq {
    if(!_imageViewq) {
        _imageViewq = [[WebImageView alloc] init];
        [_imageViewq setClipsToBounds:YES];
        [_imageViewq setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _imageViewq;
}

-(UILabel *)likesLabel {
    if(!_likesLabel) {
        _likesLabel = [[UILabel alloc] init];
        [_likesLabel sizeToFit];
    }
    return _likesLabel;
}

-(UILabel *)repostsLabel {
    if(!_repostsLabel) {
        _repostsLabel = [[UILabel alloc] init];
        [_repostsLabel sizeToFit];
    }
    return _repostsLabel;
}


-(void)setupCellFromNews:(NewsModel *)model {
//    [_headerView setupHeaderFrom:model];
    [_avatarImage setImageWithURL:model.profileAvatar];
    [_nameLabel setText:model.profileName];
    [_postNameLabel setText:model.text];
    if(model.likes) {
        [_likesLabel setText:[NSString stringWithFormat:@"Likes: %@",model.likes]];
    }
    if(model.reposts) {
        [_repostsLabel setText:[NSString stringWithFormat:@"Reposts: %@",model.reposts]];
    }
    if(model.date) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.date.doubleValue];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *stringFromDate = [dateFormatter stringFromDate:date];

        [_datePostPublicate setText:stringFromDate];
    }
    if(self.imageViewq == nil) {
        [_imageViewq setImageWithURL:model.image];
    }
    else {
        [_imageViewq setImageWithURL:model.image];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [_headerView setFrame:CGRectMake(0, 0, screenWidth, 40)];
    [_avatarImage setFrame:CGRectMake(5, 0, 40, 40)];
    _avatarImage.layer.cornerRadius = 20;
    [_nameLabel sizeToFit];
    [_nameLabel setFrame:CGRectMake(CGRectGetMaxX(_avatarImage.frame), 10, screenWidth - CGRectGetMaxX(_avatarImage.frame) - 20, _nameLabel.frame.size.height)];
    [_datePostPublicate sizeToFit];
    [_datePostPublicate setFrame:CGRectMake(5, CGRectGetMaxY(_avatarImage.frame), _datePostPublicate.frame.size.width, _datePostPublicate.frame.size.height)];
    [_postNameLabel sizeToFit];
    CGRect frame = _postNameLabel.frame;
    if(frame.size.height > 60) {
        frame.size.height = 60;
        _postNameLabel.frame = frame;
    }
    [_postNameLabel setFrame:CGRectMake(15, CGRectGetMaxY(_datePostPublicate.frame) + 10, screenWidth - 30, _postNameLabel.frame.size.height)];
    [_likesLabel sizeToFit];
    [_likesLabel setFrame:CGRectMake(15, self.frame.size.height - _likesLabel.frame.size.height, _likesLabel.frame.size.width, _likesLabel.frame.size.height)];
//    if(self.imageViewq.image) {
        [_imageViewq setFrame:CGRectMake(15, CGRectGetMaxY(_postNameLabel.frame), screenWidth - 30,self.frame.size.height - _postNameLabel.frame.size.height - _likesLabel.frame.size.height - 80)];
//    }
    [_repostsLabel sizeToFit];
    [_repostsLabel setFrame:CGRectMake(screenWidth - _repostsLabel.frame.size.width - 15, _likesLabel.frame.origin.y, _repostsLabel.frame.size.width, _repostsLabel.frame.size.height)];
}

@end
