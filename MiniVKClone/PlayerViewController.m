//
//  PlayerViewController.m
//  MiniVKClone
//
//  Created by Антон Дитятив on 30.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import "PlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>

#import "UIImage+ColorArt.h"

@interface PlayerViewController ()

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *artistLabel;

@property (nonatomic, strong) WebImageView *imgToLoad;
@property (nonatomic, strong) UIImageView *blurCover;
@property (nonatomic, strong) WebImageView *cover;

@property (nonatomic, strong) ControllView *controlPanel;
@property (nonatomic, strong) SLColorArt *colorArt;

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [self.view addSubview:self.imgToLoad];
    [self.view addSubview:self.blurCover];
    [self.view addSubview:self.cover];
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.artistLabel];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.controlPanel];
    [self.view addSubview:self.moviePlayer.view];
    
//    [self setupCoverAndColors];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupCoverAndColors:) name:@"imageLoaded" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
//        [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
//        [self resignFirstResponder];
    
    [super viewWillDisappear:animated];
}

#pragma mark setupUI
- (MPMoviePlayerController *)moviePlayer {
    AudioObject *currentAudio = [_musicArray objectAtIndex:_currentMusicIndex];
    [[SoundManager sharedManager] setDelegate:self];
    [[SoundManager sharedManager] playAudio:currentAudio];
    [SoundManager sharedManager].playlist = _musicArray;
    [SoundManager sharedManager].currentIndex = _currentMusicIndex;
    _moviePlayer = [SoundManager sharedManager].player;
    [_moviePlayer.view setHidden:YES];
    
    return _moviePlayer;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setTitle:@"Закрыть" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateHighlighted];
        [_closeButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateSelected];
        [_closeButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton sizeToFit];
        [_closeButton setFrame:CGRectMake(screenWidth - 10 - _closeButton.frame.size.width, statusBarOffset, _closeButton.frame.size.width, _closeButton.frame.size.height)];
    }
    return _closeButton;
}

- (WebImageView *)imgToLoad {
    if (!_imgToLoad) {
        _imgToLoad = [[WebImageView alloc] init];
        [_imgToLoad setHidden:YES];
    }
    return _imgToLoad;
}

- (UIImageView *)blurCover {
    if (!_blurCover) {
        _blurCover = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        [_blurCover setContentMode:UIViewContentModeScaleAspectFill];
        [_blurCover setClipsToBounds:YES];
    }
    return _blurCover;
}

- (WebImageView *)cover {
    if (!_cover) {
        _cover = [[WebImageView alloc] initWithFrame:CGRectMake(20, screenHeight/2 - (screenWidth/2 - 10), screenWidth - 40, screenWidth - 40)];
        [_cover setContentMode:UIViewContentModeScaleToFill];
        [_cover setClipsToBounds:YES];
        [_cover.layer setCornerRadius:_cover.frame.size.width/2];
    }
    return _cover;
}


- (UILabel *)artistLabel {
    if (!_artistLabel) {
        _artistLabel = [[UILabel alloc] init];
        [_artistLabel setTextColor:[UIColor colorWithWhite:1.0 alpha:0.7]];
        [_artistLabel setFont:[UIFont systemFontOfSize:16]];
        [_artistLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _artistLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
        [_titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

- (ControllView *)controlPanel {
    if (!_controlPanel) {
        _controlPanel = [[ControllView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cover.frame) + 10, screenWidth, 40)];
        _controlPanel.isPlaying = YES;
        [_controlPanel setDelegate:self];
    }
    return _controlPanel;
}

#pragma mark Actions
- (void)closeAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupCoverAndColors:(NSNotification *)noti {
    UIImage *image = (UIImage *)noti.object;
    UIImage *bluredImage = [image blurredImage];
    _colorArt = [image colorArt];
    
    [_controlPanel.playButton setTintColor:_colorArt.secondaryColor];
    [_controlPanel.pauseButton setTintColor:_colorArt.secondaryColor];
    [_controlPanel.nextButton setTintColor:_colorArt.secondaryColor];
    [_controlPanel.previousButton setTintColor:_colorArt.secondaryColor];
    [_controlPanel.shuffleButton setTintColor:[_colorArt.secondaryColor colorWithAlphaComponent:[SoundManager sharedManager].shuffle ? 1.0 : 0.5]];
    
    [UIView transitionWithView:self.view duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [_cover.activityIndicator stopAnimating];
        [_artistLabel setTextColor:_colorArt.primaryColor];
        [_titleLabel setTextColor:_colorArt.secondaryColor];
        [_closeButton setTitleColor:_colorArt.detailColor forState:UIControlStateNormal];
        [_closeButton setTitleColor:[_colorArt.detailColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [_closeButton setTitleColor:[_colorArt.detailColor colorWithAlphaComponent:0.5] forState:UIControlStateSelected];
        [_cover setImage:image];
        [_blurCover setImage:bluredImage];
    } completion:nil];
}

#pragma mark ControlPanel Delegate
- (void)play {
    if ([[SoundManager sharedManager].player playbackState] == MPMoviePlaybackStatePaused || [[SoundManager sharedManager].player playbackState] == MPMoviePlaybackStateStopped) {
        [[SoundManager sharedManager] play];
    }
}

- (void)pause {
    if ([[SoundManager sharedManager].player playbackState] == MPMoviePlaybackStatePlaying) {
        [[SoundManager sharedManager] pause];
    }
}

- (void)nextTrack {
    [[SoundManager sharedManager] nextTrack];
}

- (void)previousTrack {
    [[SoundManager sharedManager] previousTrack];
}

- (void)shuffle {
    [SoundManager sharedManager].shuffle = ![SoundManager sharedManager].shuffle;
//    [_controlPanel.shuffleButton setTintColor:[_colorArt.secondaryColor colorWithAlphaComponent:[PRSoundManager sharedManager].shuffle ? 1.0 : 0.5]];
}

#pragma mark SoundManagerDelegate
- (void)newAudio:(AudioObject *)audio {
    [_artistLabel setText:audio.artist];
    [_artistLabel sizeToFit];
    [_artistLabel setFrame:CGRectMake(10, CGRectGetMinY(_cover.frame) - 10 - _artistLabel.frame.size.height, screenWidth - 20, _artistLabel.frame.size.height)];
    
    [_titleLabel setText:audio.title];
    [_titleLabel sizeToFit];
    [_titleLabel setFrame:CGRectMake(10, CGRectGetMinY(_artistLabel.frame) - 10 - _titleLabel.frame.size.height, screenWidth - 20, _titleLabel.frame.size.height)];
}

- (void)coverWasFound:(NSString *)url {
    [UIView transitionWithView:self.view duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [_blurCover setImage:nil];
        [_cover setImage:nil];
    } completion:nil];
    [_cover.activityIndicator startAnimating];
    [_imgToLoad setImageWithURL:url];
}

#pragma mark Others

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
