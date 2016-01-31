//
//  ControllView.h
//  MiniVKClone
//
//  Created by Антон Дитятив on 30.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ControllViewDelegate;

@interface ControllView : UIView

@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *shuffleButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *previousButton;

@property (nonatomic) BOOL isPlaying;
@property (nonatomic, weak) NSObject<ControllViewDelegate> *delegate;

@end

@protocol ControllViewDelegate <NSObject>
@optional

- (void)play;
- (void)pause;
- (void)nextTrack;
- (void)previousTrack;
- (void)shuffle;

@end