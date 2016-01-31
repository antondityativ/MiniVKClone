//
//  PlayerViewController.h
//  MiniVKClone
//
//  Created by Антон Дитятив on 30.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioObject.h"
#import "ControllView.h"
#import "WebImageView.h"

@interface PlayerViewController : UIViewController <SoundManagerDelegate, ControllViewDelegate>

@property (nonatomic) NSInteger currentMusicIndex;
@property (nonatomic, strong) NSMutableArray *musicArray;

@end
