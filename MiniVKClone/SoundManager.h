//
//  SoundManager.h

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AudioObject.h"

@protocol SoundManagerDelegate;

@interface SoundManager : NSObject

+ (SoundManager *)sharedManager;

@property (nonatomic, strong) MPMoviePlayerController *player;
@property (nonatomic, strong) NSMutableArray *playlist;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) BOOL shuffle;

@property (nonatomic, weak) NSObject<SoundManagerDelegate> *delegate;

- (void)playAudio:(AudioObject *)audio;

- (void)pause;
- (void)play;
- (void)previousTrack;
- (void)nextTrack;

@end

@protocol SoundManagerDelegate<NSObject>
@optional
- (void)coverWasFound:(NSString *)url;
- (void)newAudio:(AudioObject *)audio;
@end