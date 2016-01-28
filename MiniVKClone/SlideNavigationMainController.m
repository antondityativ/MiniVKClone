//
//  SlideNavigationMainController.m
//  Allure
//
//  Created by Evgeniy Orlov on 09.10.13.
//  Copyright (c) 2013 Personal. All rights reserved.
//

#define CENTER  1;
#define LEFT    2;
#define RIGHT   3;
#define SLIDE_TIMING .25
#define PANEL_WIDTH 100

#define coefficientForViewsToShow       0.33
#define velocityToSlide                 2000.0

#import "SlideNavigationMainController.h"
#import <QuartzCore/QuartzCore.h>

@interface SlideNavigationMainController () <UIGestureRecognizerDelegate, CenterViewDelegate>

@property (nonatomic, assign) CenterViewController *centerView;
@property (nonatomic, assign) LeftViewController *leftViewController;
@property (nonatomic, assign) RightViewController *rightViewController;

@property (nonatomic, assign) BOOL haveRightView;
@property (nonatomic, assign) BOOL haveLeftView;

@property (nonatomic, assign) CGPoint preVelocity;
@property (nonatomic, assign) BOOL showingRightPanel;
@property (nonatomic, assign) BOOL showingLeftPanel;
@property (nonatomic, assign) BOOL showPanel;

@property BOOL isSliding;

@property (strong, nonatomic) UIButton *blockClearButton;

@end

@implementation SlideNavigationMainController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    allowStopSliding = NO;
    [self.view setBackgroundColor:[UIColor blackColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideControllers:) name:@"hideControllers" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showControllerByAlpha) name:@"restoreAlpha" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lockSliding) name:@"lockSliding" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlockSliding) name:@"unlockSliding" object:nil];
    
    _isSliding = YES;
}

- (void)hideControllers:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"hideControllers"])
    {
        self.showingLeftPanel = NO;
        self.showingRightPanel = NO;
        [_blockClearButton setHidden:YES];
        [self movePanelToOriginalPosition];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isShowingRightPanel
{
    return self.showingRightPanel;
}

- (BOOL)isShowingLeftPanel
{
    return self.showingLeftPanel;
}

- (void)showRightPanel
{
    if (!self.showingRightPanel)
    {
        [self movePanelLeft];
    }
    else if (self.showingRightPanel)
    {
        self.showingRightPanel = NO;
        [self movePanelToOriginalPosition];
    }
}

- (void)showLeftPanel
{
    if (!self.showingLeftPanel)
    {
        [self movePanelRight];

        [_blockClearButton setHidden:NO];
        [self.centerView.view bringSubviewToFront:_blockClearButton];
    }
    else if (self.showingLeftPanel)
    {
        self.showingLeftPanel = NO;
        [self movePanelToOriginalPosition];

        [_blockClearButton setHidden:YES];
        [self.centerView.view bringSubviewToFront:self.centerView.view];
    }
}

- (void)movePanelLeft
{
    if (_haveRightView)
    {
        UIView *childView = [self getRightView];
        [self.view sendSubviewToBack:childView];
    }
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.centerView.view.frame = CGRectMake(-self.view.frame.size.width + PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                         }
                     }];
}

- (void)movePanelToOriginalPosition
{
    allowStopSliding = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"decreaseSlideArea" object:nil];
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.centerView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             [self resetMainView];
                         }
                     }];
}

- (void)resetMainView
{
    allowStopSliding = NO;
    if (self.showingRightPanel) {
        [self.rightViewController.view removeFromSuperview];
        
        self.showingRightPanel = NO;
    }
    if (self.showingLeftPanel) {
        [self.leftViewController.view removeFromSuperview];
        
        self.showingLeftPanel = NO;
    }
}

- (void)movePanelRight
{
    if (_haveLeftView)
    {
        UIView *childView = [self getLeftView];
        [self.view sendSubviewToBack:childView];
    }
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.centerView.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                         }
                     }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.rightViewController.view setAlpha:0];
}

- (void)showControllerByAlpha
{
    [self.rightViewController.view setAlpha:1.0];
}

- (void)returnToDefaultPosition
{
    [self movePanelToOriginalPosition];
    [_blockClearButton setHidden:YES];
}

- (void)setCenteralView:(CenterViewController *)view
{
    if (_blockClearButton == nil)
    {
        _blockClearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_blockClearButton setFrame:view.view.frame];
        [_blockClearButton setBackgroundColor:[UIColor clearColor]];
        [_blockClearButton addTarget:self action:@selector(returnToDefaultPosition) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [_blockClearButton removeFromSuperview];
    }
    
    CGRect lastFrame = CGRectZero;
    if (self.centerView.view != nil) {
        lastFrame = self.centerView.view.frame;
    }
    else {
        lastFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [self.centerView.view removeFromSuperview];
    self.centerView.view = nil;
    [self.centerView removeFromParentViewController];
    self.centerView = nil;
    
    self.centerView = view;
    self.centerView.view.tag = CENTER;
    [self.centerView.view addSubview:_blockClearButton];
    [_blockClearButton setHidden:YES];
    
    [self.view addSubview:self.centerView.view];
    [self addChildViewController:self.centerView];
    
    self.centerView.view.frame = lastFrame;
    self.centerView.delegate = self;
    
    [view didMoveToParentViewController:self];
    [self setupGestures];
}

- (void)setLeftView:(LeftViewController *)viewController
{
    self.haveLeftView = YES;
    
    self.leftViewController = viewController;
    self.leftViewController.view.tag = LEFT;
    self.leftViewController.delegate = self.centerView;
    
    [self.leftViewController didMoveToParentViewController:self];
    
    [self addChildViewController:self.leftViewController];
    self.leftViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)setRightView:(RightViewController *)viewController
{
    self.haveRightView = YES;
    
    self.rightViewController = viewController;
    self.rightViewController.view.tag = RIGHT;
    self.rightViewController.delegate = self.centerView;
    
    [self.rightViewController didMoveToParentViewController:self];
    
    [self addChildViewController:self.rightViewController];
    self.rightViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (UIView *)getLeftView
{
    if (self.haveLeftView)
    {
        self.showingLeftPanel = YES;
        
        [self.view addSubview:self.leftViewController.view];
        
        return self.leftViewController.view;
    }
    return nil;
}

- (UIView *)getRightView
{
    if (self.haveRightView)
    {
        self.showingRightPanel = YES;
        
        [self.view addSubview:self.rightViewController.view];
        
        return self.rightViewController.view;
    }
    return nil;
}

- (void)setupGestures
{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    
    [self.centerView.view addGestureRecognizer:panRecognizer];
}

- (void)lockSliding {
    _isSliding = NO;
}

- (void)unlockSliding {
    _isSliding = YES;
}

-(void)movePanel:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];

    if (!_isSliding) {
        return;
    }
    
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer*)sender;
    
    if ([recognizer velocityInView:[sender view]].x > 0) {
        UIView *leftView = [self getLeftView];
        
        if (leftView != nil) {
            [self.view sendSubviewToBack:leftView];
            [[sender view] bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
        }
    }
    
    if ([recognizer state] == UIGestureRecognizerStateChanged) {
        CGFloat dx = [recognizer translationInView:self.view].x;
        CGRect newFrame = self.centerView.view.frame;
        newFrame.origin.x += dx;
        if (newFrame.origin.x > 0) {
            [self.centerView.view setFrame: newFrame];
        }
    }
    if ([recognizer state] == UIGestureRecognizerStateEnded || [recognizer state] == UIGestureRecognizerStateCancelled)
    {
        if ([self shouldShowLeftViewForX: self.centerView.view.frame.origin.x velocity: [recognizer velocityInView: self.view].x]) {
            [self movePanelRight];
        }
        else if ([self shouldShowRightViewForX: self.centerView.view.frame.origin.x velocity: [recognizer velocityInView: self.view].x]) {
            return;//[self showRightViewAnimated: YES];
        }
        else {
            [self movePanelToOriginalPosition];
        }
        
    }
    [recognizer setTranslation: CGPointZero inView: self.centerView.view];
}

- (void)updateMenuTransform:(UIViewController *)menu factor:(CGFloat)factor animated:(BOOL)animate {
    if (!menu) {
        return;
    }
    CALayer* layer = menu.view.layer;
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, -40 * (1 - factor));
    
    if (animate) {
        [layer removeAllAnimations];
        
        CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath: @"transform"];
        animation.fromValue = [NSValue valueWithCATransform3D: layer.transform];
        animation.toValue = [NSValue valueWithCATransform3D: transform];
        animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
        animation.duration = 0.3;
        [layer addAnimation: animation forKey: @"UpdateMenuTransformAnimation"];
        
    }
    layer.transform = transform;
}

- (BOOL)shouldShowRightViewForX:(CGFloat)x velocity:(CGFloat)velocity{
    return false;
}

- (BOOL)shouldShowLeftViewForX:(CGFloat)x velocity:(CGFloat)velocity {
    BOOL result = ((x > 220 * coefficientForViewsToShow && velocity > 0) || (x > 0 && velocity > velocityToSlide));
    
    if (result)
    {
        [_blockClearButton setHidden:NO];
        [self.centerView.view bringSubviewToFront:_blockClearButton];
    }
    else
    {
        [_blockClearButton setHidden:YES];
        [self.centerView.view bringSubviewToFront:self.centerView.view];
    }
    
    return result;
}


@end
