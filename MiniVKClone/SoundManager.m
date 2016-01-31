//
//  SoundManager.m
//

#import "SoundManager.h"

@interface SoundManager ()

@end

@implementation SoundManager

#pragma mark Init

SoundManager *sharedManager = nil;

+ (SoundManager *)sharedManager {
    if (sharedManager == nil) {
        sharedManager = [[SoundManager alloc] init];
    }
    return sharedManager;
}

#pragma mark Actions
- (void)playAudio:(AudioObject *)audio {
    if (!_player) {
        _player = [[MPMoviePlayerController alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:nil];
        _shuffle = NO;
    }
    [_player setContentURL:[NSURL URLWithString:audio.url]];
    [self setRemoteInfo:audio];
    [self play];
    
    [self.delegate newAudio:audio];
    
//    [[API sharedAPI] getCoverWithCompletion:^(id response, NSError *error) {
//        [self.delegate coverWasFound:response];
//    } ByArtist:audio.artist andTitle:audio.title];
}

- (void)pause {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changePlayBackState" object:nil];
    [_player pause];
}

- (void)play {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changePlayBackState" object:nil];    
    [_player play];
}

- (void)previousTrack {
    if (_currentIndex > 0) {
        _currentIndex = _currentIndex - 1;
    }else {
        _currentIndex = _playlist.count-1;
    }
    
    AudioObject *audio = [_playlist objectAtIndex:_currentIndex];
    [self playAudio:audio];
}

- (void)nextTrack {
    if (!_shuffle) {
        if (_currentIndex < _playlist.count - 1) {
            _currentIndex = _currentIndex + 1;
        }else {
            _currentIndex = 0;
        }
    }else {
        _currentIndex = arc4random_uniform(_playlist.count);        
    }
    
    AudioObject *audio = [_playlist objectAtIndex:_currentIndex];
    [self playAudio:audio];
}

#pragma mark RemoteInfo
- (void)setRemoteInfo:(AudioObject *)audio {
    NSMutableDictionary *albumInfo = [[NSMutableDictionary alloc] init];
//    UIImage *artWork = [UIImage imageNamed:@"launch4"];
    [albumInfo setObject:audio.title forKey:MPMediaItemPropertyTitle];
    [albumInfo setObject:audio.artist forKey:MPMediaItemPropertyArtist];
    //    [albumInfo setObject:album.title forKey:MPMediaItemPropertyAlbumTitle];
//    [albumInfo setObject:artWork forKey:MPMediaItemPropertyArtwork];
    [albumInfo setObject:audio.duration forKey:MPMediaItemPropertyPlaybackDuration];
    //    [albumInfo setObject:album.elapsedTime forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime]
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:albumInfo];
}

#pragma mark Notifications
- (void)moviePlayBackDidFinish:(NSNotification *)noti {
    [self nextTrack];
}

@end
