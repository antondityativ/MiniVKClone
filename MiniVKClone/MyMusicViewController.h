//
//  MyMusicViewController.h
//  razuvaevMusic
//
//  Created by Pavel Razuvaev on 15.11.15.
//  Copyright © 2015 Pavel Razuvaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SlideNavigationMainController.h"

@interface MyMusicViewController : CenterViewController <UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate>

@end