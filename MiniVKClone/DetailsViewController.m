//
//  DetailsViewController.m
//  MiniVKClone
//
//  Created by Антон Дитятив on 25.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@property(strong,nonatomic)UIScrollView *scrollView;
@property(strong,nonatomic)WebImageView *avatarImageView;
@property(strong,nonatomic)WebImageView *postImageView;
@property(strong,nonatomic)UILabel *nameLabel;
@property(strong,nonatomic)UILabel *postDescriptionLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupUI];
}

#pragma mark - SetupUI

-(void)setupUI {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.avatarImageView];
    [self.scrollView addSubview:self.nameLabel];
    [self.scrollView addSubview:self.postDescriptionLabel];
    [self.scrollView addSubview:self.postImageView];
}

-(UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = YES;
    }
    return _scrollView;
}

-(WebImageView *)avatarImageView {
    if(!_avatarImageView) {
        _avatarImageView = [[WebImageView alloc] init];
        [_avatarImageView setClipsToBounds:YES];
        [_avatarImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_avatarImageView setImageWithURL:_model.profileAvatar];
    }
    return _avatarImageView;
}

-(UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setText:_model.profileName];
        [_nameLabel sizeToFit];
        [_nameLabel setNumberOfLines:0];
    }
    return _nameLabel;
}

-(UILabel *)postDescriptionLabel {
    if(!_postDescriptionLabel) {
        _postDescriptionLabel = [[UILabel alloc] init];
        [_postDescriptionLabel setText:_model.text];
        [_postDescriptionLabel sizeToFit];
        [_postDescriptionLabel setNumberOfLines:0];
    }
    return _postDescriptionLabel;
}

-(WebImageView *)postImageView {
    if(!_postImageView) {
        _postImageView = [[WebImageView alloc] init];
        [_postImageView setClipsToBounds:YES];
        [_postImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_postImageView setImageWithURL:_model.image];
    }
    return _postImageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Other

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [_scrollView setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [_avatarImageView setFrame:CGRectMake(20, 20, 70, 70)];
    _avatarImageView.layer.cornerRadius = 35;
    [_nameLabel sizeToFit];
    [_nameLabel setFrame:CGRectMake(CGRectGetMaxX(_avatarImageView.frame) + 10, _avatarImageView.frame.origin.y + _avatarImageView.frame.size.height/2 -10, screenWidth - CGRectGetMaxX(_avatarImageView.frame) - 30, _nameLabel.frame.size.height)];
    [_postDescriptionLabel sizeToFit];
    [_postDescriptionLabel setFrame:CGRectMake(20, CGRectGetMaxY(_avatarImageView.frame) + 20, screenWidth - 20, _postDescriptionLabel.frame.size.height)];
    [_postImageView setFrame:CGRectMake(20, CGRectGetMaxY(_postDescriptionLabel.frame), screenWidth - 40, 180)];
    [_scrollView setContentSize:CGSizeMake(screenWidth,CGRectGetMaxY(_postImageView.frame)+ 90)];
}

@end
