//
//  SIAlertView.m
//  SIAlertView
//
//  Created by Kevin Cao on 13-4-29.
//  Copyright (c) 2013年 Sumi Interactive. All rights reserved.
//

#import "SIAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+BadgeValue.h"
//#import "MLPSpotlight.h"
//#import "THLabel.h"
#import "NSAttributedString+DDHTML.h"

NSString *const SIAlertViewWillShowNotification = @"SIAlertViewWillShowNotification";
NSString *const SIAlertViewDidShowNotification = @"SIAlertViewDidShowNotification";
NSString *const SIAlertViewWillDismissNotification = @"SIAlertViewWillDismissNotification";
NSString *const SIAlertViewDidDismissNotification = @"SIAlertViewDidDismissNotification";

#define DEBUG_LAYOUT 0

#define MESSAGE_MIN_LINE_COUNT 3
#define MESSAGE_MAX_LINE_COUNT 10
#define GAP 10
#define CANCEL_BUTTON_PADDING_TOP 5
#define CONTENT_PADDING_LEFT 20 //10
#define CONTENT_PADDING_TOP 20 //12
#define CONTENT_PADDING_BOTTOM 20 //10
#define BUTTON_HEIGHT 44
#define CONTAINER_WIDTH 300
#define FADE_DURATION 0.2f

#define CONTINUE_SECS 10

#define OLD_MAN_ENABLED NO

@class SIAlertBackgroundView;

static SIAlertBackgroundView *__si_alert_background_view;
static SIAlertView *__si_alert_current_view;

@interface SIAlertView ()

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, weak) UIWindow *oldKeyWindow;
@property (nonatomic, strong) UIWindow *alertWindow;
#ifdef __IPHONE_7_0
@property (nonatomic, assign) UIViewTintAdjustmentMode oldTintAdjustmentMode;
#endif
@property (nonatomic, assign, getter = isVisible) BOOL visible;
@property (nonatomic, assign) BOOL showCancel;
@property (nonatomic, assign) BOOL clicked;
@property (nonatomic, assign) BOOL flashFlag;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) ZCAnimatedLabel *messageLabel2;
@property (strong, nonatomic) UIButton *closeButton;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSTimer *timerWobble;
@property (nonatomic, strong) NSTimer *timerCountdown;
@property (nonatomic, strong) NSTimer *timerFlash;

@property (nonatomic, assign) int countdown;

@property (nonatomic, assign, getter = isLayoutDirty) BOOL layoutDirty;

+ (SIAlertView *)currentAlertView;
+ (void)showBackground;
+ (void)hideBackgroundAnimated:(BOOL)animated;

- (void)setup;
- (void)invalidateLayout;
- (void)resetTransition;

@end

#pragma mark - SIBackgroundWindow

@interface SIAlertBackgroundView : UIView

@end


@interface SIAlertBackgroundView ()

@property (nonatomic, assign) SIAlertViewBackgroundStyle style;

@end

@implementation SIAlertBackgroundView

- (id)initWithFrame:(CGRect)frame andStyle:(SIAlertViewBackgroundStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        self.style = style;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.opaque = NO;

        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    }
    return self;
}

@end


#pragma mark - SIAlertItem

@interface SIAlertItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) SIAlertViewButtonType type;
@property (nonatomic, copy) SIAlertViewHandler action;

@end

@implementation SIAlertItem

@end

#pragma mark - SIAlertViewController

@interface SIAlertViewController : UIViewController

@property (nonatomic, strong) SIAlertView *alertView;

@end

@implementation SIAlertViewController

#pragma mark - View life cycle

- (void)loadView
{
    self.view = self.alertView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [kHelpers loopInBackground];

    [self.alertView setup];
}

@end

#pragma mark - SIAlert

@implementation SIAlertView

+ (void)initialize
{
    if (self != [SIAlertView class])
        return;

    SIAlertView *appearance = [self appearance];
    appearance.viewBackgroundColor = [UIColor whiteColor];
    appearance.titleColor = [UIColor blackColor];
    appearance.messageColor = [UIColor darkGrayColor];
    appearance.titleFont = [UIFont boldSystemFontOfSize:20];
    appearance.messageFont = [UIFont systemFontOfSize:16];
    appearance.buttonFont = [UIFont systemFontOfSize:[UIFont buttonFontSize]];
    appearance.buttonColor = [UIColor colorWithWhite:0.4 alpha:1];
    appearance.buttonBackgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    appearance.cancelButtonColor = [UIColor colorWithWhite:0.3 alpha:1];
    appearance.destructiveButtonColor = [UIColor whiteColor];
    appearance.cornerRadius = 2;
    appearance.shadowRadius = 8;
}

- (id)init
{
	return [self initWithTitle:nil andMessage:nil];
}


- (id)initWithTitle:(NSString *)title andMessage:(NSString *)message
{
	self = [super init];
	if (self) {
		_title = title;
        _message = message;
		self.items = [[NSMutableArray alloc] init];

        [self resetModes];
	}
	return self;
}

- (void)setupWithTitle:(NSString *)title andMessage:(NSString *)message {

    /*_title = title;
    _message = message;

    self.titleLabel = nil;
    self.messageLabel = nil;

    [self.items removeAllObjects];
    [self.buttons removeAllObjects];*/
}


#pragma mark - Class methods

+ (SIAlertView *)currentAlertView
{
    return __si_alert_current_view;
}

+ (void)setCurrentAlertView:(SIAlertView *)alertView
{
    if(alertView != __si_alert_current_view)
        __si_alert_current_view = alertView;
}
+ (void)showBackground
{

    //force
    if(__si_alert_background_view) {
        [__si_alert_background_view removeFromSuperview];
        __si_alert_background_view = nil;
    }

    if (!__si_alert_background_view) {
        __si_alert_background_view =  [[SIAlertBackgroundView alloc] initWithFrame:[UIScreen mainScreen].bounds
                                                                             andStyle:[SIAlertView currentAlertView].backgroundStyle];

        [[SIAlertView currentAlertView] addSubview:__si_alert_background_view];
        [[SIAlertView currentAlertView] sendSubviewToBack:__si_alert_background_view];


    }


    __si_alert_background_view.hidden = NO;
    __si_alert_background_view.alpha = 0;
     [UIView animateWithDuration:FADE_DURATION
     animations:^{
         __si_alert_background_view.alpha = 1;
    }];

    //__si_alert_background_view.hidden = NO;
    //__si_alert_background_view.alpha = 1;


    //touch back close
    [__si_alert_background_view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewTapped:)]];

}

+ (void) backgroundViewTapped:(UITapGestureRecognizer *)gr {

    //NSLog(@"backgroundViewTapped");
    //[self buttonClose:self.closeButton];

    [[SIAlertView currentAlertView] buttonClose:[SIAlertView currentAlertView].closeButton];
}


+ (void)hideBackgroundAnimated:(BOOL)animated
{
    //__si_alert_background_view.hidden = YES;
    //__si_alert_background_view.alpha = 0;

    //__si_alert_background_view = nil;

    [UIView animateWithDuration:FADE_DURATION
                     animations:^{
                         __si_alert_background_view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [__si_alert_background_view removeFromSuperview];
                         //__si_alert_background_view = nil;
                         __si_alert_background_view.hidden = YES;
                     }];
}

#pragma mark - Setters

- (void)setTitle:(NSString *)title
{
    _title = title;
	[self invalidateLayout];
}

- (void)setMessage:(NSString *)message
{
	_message = message;
    [self invalidateLayout];
}

#pragma mark - Public

- (void)addButtonWithTitle:(NSString *)title type:(SIAlertViewButtonType)type handler:(SIAlertViewHandler)handler
{
    SIAlertItem *item = [[SIAlertItem alloc] init];
	item.title = title;
	item.type = type;
	item.action = handler;
	[self.items addObject:item];
}

- (void)show {
    [self show:YES];
}

- (void)show:(BOOL)showCancel
{
    [self show:YES showContinue:NO];
}

- (void)show:(BOOL)showCancel showContinue:(BOOL)showContinue
{
    [self show:YES showContinue:showContinue playSound:YES];
}

- (void)show:(BOOL)showCancel showContinue:(BOOL)showContinue playSound:(BOOL)playSound
{
    self.continueMode = showContinue;
    self.clicked = NO;

    //force hide flash in case
    if(kAppDelegate.titleController.menuState == menuStateGame) {
        [kAppDelegate.gameController hideFlash];
    }

    if (self.isVisible) {
        //already
        return;
    }

    //always play sound
    if(playSound)
        [kAppDelegate playSound:@"pause.caf"];

    //else
    if(!self.pauseMenuMode && self.soundMode)
    {
        //chat sound
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [kAppDelegate playSound:@"alertchat.caf"];
        });
    }

    //delay ui, click fast
    //if(self.closeButton)
    {
        //self.closeButton.enabled = NO;
        self.closeButton.userInteractionEnabled = NO;
        self.oldmanButton.userInteractionEnabled = NO;
        self.volumeButton.userInteractionEnabled = NO;

        for(UIButton *button in self.buttons) {
            //button.enabled = NO;
            button.userInteractionEnabled = NO;
        }

        float secs = kAlertButtonClickDelay;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            self.closeButton.enabled = YES;
            self.closeButton.userInteractionEnabled = YES;
            self.oldmanButton.userInteractionEnabled = YES;
            self.volumeButton.userInteractionEnabled = YES;

            for(UIButton *button in self.buttons) {
                button.enabled = YES;
                button.userInteractionEnabled = YES;
            }

        });
    }

    self.showCancel = showCancel;

    self.oldKeyWindow = [[UIApplication sharedApplication] keyWindow];

    if (self.willShowHandler) {
        self.willShowHandler(self);
    }

    self.visible = YES;

    if(!self.viewController) {
        [SIAlertView setCurrentAlertView:self];

        self.viewController = [[SIAlertViewController alloc] initWithNibName:nil bundle:nil];
        self.viewController.alertView = self;
        self.viewController.alertView.frame = self.oldKeyWindow.frame;

        [self.oldKeyWindow addSubview:self.viewController.view];
    }

    self.hidden = NO;
    self.viewController.view.hidden = NO;

    [self.oldKeyWindow bringSubviewToFront:self.viewController.view];


    // transition background
    [SIAlertView showBackground];

    [self validateLayout];

    [self transitionInCompletion:^{

        if (self.didShowHandler) {
            self.didShowHandler(self);
        }

        //wobble all
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            /*for(UIButton *button in self.buttons) {
                //[kAppDelegate animateControl:button];
            }*/
        //});

        //wobble ok button, after delay
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.6f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            for (NSUInteger i = 0; i < self.buttons.count; i++) {
                //UIButton *button = self.buttons[i];
                    //if (((SIAlertItem *)self.items[i]).type == SIAlertViewButtonTypeDestructive) {
                    /*if ([((SIAlertItem *)self.items[i]).title isEqualToString:@"Resume"]) {
                        [kAppDelegate animateControl:button];
                    }*/
            }
        });

        //wobble timer

        [self.timerWobble invalidate];
        self.timerWobble = nil;
        self.timerWobble = [NSTimer scheduledTimerWithTimeInterval:1.2f target:self
                                                         selector:@selector(actionTimerWobble:) userInfo:@"actionTimerWobble" repeats:YES];
        [self actionTimerWobble:nil];


        //countdown
        self.countdown = CONTINUE_SECS;
        [self.timerCountdown invalidate];
        self.timerCountdown = nil;
        self.timerCountdown = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self
                                                          selector:@selector(actionTimerCountdown:) userInfo:@"actionTimerCountdown" repeats:YES];
        [self actionTimerCountdown:nil];


        //flash
        [self.timerFlash invalidate];
        self.timerFlash = nil;
        self.timerFlash = [NSTimer scheduledTimerWithTimeInterval:0.15f target:self
                                                          selector:@selector(actionTimerFlash:) userInfo:@"actionTimerFlash" repeats:YES];
        [self actionTimerFlash:nil];


        //voice
        if(self.continueMode)
        {
            if(kVoiceEnabled)
                [kAppDelegate playSound:@"voice_gameover.caf"];
        }

    }];

	//volume
	if(!self.volumeButton) {
		self.volumeButton = [[UIButton alloc] init];
		[self.viewController.view addSubview:self.volumeButton];
		[self.viewController.view bringSubviewToFront:self.volumeButton];

        [self.volumeButton addTarget:self action:@selector(volumeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

		/*[self.volumeButton bk_addEventHandler:^(id sender) {
             [self volumeAction];
        } forControlEvents:UIControlEventTouchUpInside];*/
	}
	//show
    self.volumeButton.frame = CGRectMake(self.containerView.frame.origin.x+20, self.containerView.frame.origin.y+20, 30, 30);
    [self.viewController.view bringSubviewToFront:self.oldmanImageView];
	[self updateVolumeButton];
	self.volumeButton.hidden = !self.pauseMenuMode;

    //old man
    if(OLD_MAN_ENABLED) {
        if(!self.oldmanImageView) {
            self.oldmanImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"oldman_frame1"]];

            NSArray *images = @[[UIImage imageNamed:@"oldman_frame1"], [UIImage imageNamed:@"oldman_frame2"]];

            self.oldmanImageView.animationImages = images;
            self.oldmanImageView.animationRepeatCount = 0;
            self.oldmanImageView.animationDuration = 0.2f;
            [self.oldmanImageView startAnimating];

            //force
            //self.oldmanImageView.frame = CGRectMake(0, 0, 68, 104);
            self.oldmanImageView.frame = CGRectMake(0, 0, 78, 114);
            CGRect rect = self.oldmanImageView.frame;

            rect.origin.x = (self.viewController.view.frame.size.width - self.oldmanImageView.frame.size.width)/2 + 2; //offset for dropshadow
            rect.origin.y = self.viewController.view.frame.size.height - self.oldmanImageView.frame.size.height - 20;
            self.oldmanImageView.frame = rect;

            [self.viewController.view addSubview:self.oldmanImageView];
            [self.viewController.view bringSubviewToFront:self.oldmanImageView];

            //button
            self.oldmanButton = [[UIButton alloc] init];
            [self.viewController.view addSubview:self.oldmanButton];
            [self.viewController.view bringSubviewToFront:self.oldmanButton];
			/*
            [self.oldmanButton bk_addEventHandler:^(id sender) {
                [self oldmanAction];
            } forControlEvents:UIControlEventTouchUpInside];
			 */
        }

        //move
        CGRect rect = self.oldmanImageView.frame;
        rect.origin.y = self.containerView.frame.origin.y + self.containerView.frame.size.height + 25;
        self.oldmanImageView.frame = rect;

        self.oldmanButton.frame = rect;
        self.oldmanButton.hidden = NO;

        self.oldmanImageView.hidden = NO;
        self.oldmanImageView.alpha = 0.0f;
        [UIView animateWithDuration:FADE_DURATION delay:0.0f options:0 animations:^{
            self.oldmanImageView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [self oldmanAction];
        }];

    }
    else {
        self.oldmanImageView.hidden = YES;
        self.oldmanButton.hidden = YES;
    }

    //animate label

    self.messageLabel2.text = self.messageLabel.text;
    self.messageLabel2.frame = self.messageLabel.frame;
    self.messageLabel2.y -= 4;
    self.messageLabel2.height += 4;

    //test color
    //self.messageLabel.backgroundColor = [UIColor purpleColor];

    //color tags in text
    NSString *tempString = self.messageLabel.text;

    //replace colors

    tempString = [kHelpers colorString:tempString];


    NSAttributedString *attrString = nil ;

    if(tempString)
        attrString = [NSAttributedString attributedStringFromHTML:tempString
                                        normalFont:self.messageLabel.font
                                        boldFont:self.messageLabel.font
                                        italicFont:self.messageLabel.font];
    else
        NSLog(@"*** SIAlertView: show: tempString nil");

    //center
    if(attrString)
    {
        tempString = attrString.string;
        NSMutableAttributedString *attrString2 = [attrString mutableCopy];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;

        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        //[paragraphStyle setAlignment:NSTextAlignmentLeft];

        //wrap
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];

        [attrString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [tempString length])];

        self.messageLabel.attributedText = attrString2;
    }

    if(self.messageLabel)
    {
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        //style.lineSpacing = 1;
        style.alignment = NSTextAlignmentCenter;

        //wrap
        [style setLineBreakMode:NSLineBreakByWordWrapping];


        NSDictionary *attrsDictionary = @{NSFontAttributeName : self.messageLabel.font, NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : [UIColor whiteColor]};
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.messageLabel.text attributes:attrsDictionary];


        //color text?
        [self.messageLabel2 setAttributedString:attrString];
        [self.messageLabel2 startAppearAnimation];
    }
}

-(void) updateContinueButton
{

    if(!self.continueMode)
        return;

    for (NSUInteger i = 0; i < self.buttons.count; i++) {
        UIButton *button = self.buttons[i];
        NSString *title = ((SIAlertItem *)self.items[i]).title;

        if([title contains:LOCALIZED(@"kStringWatchAd")])
        {
            if([kHelpers checkOnline])
            {
                //online only
                [kAppDelegate animateControl:button];
                NSString *newTitle = [NSString stringWithFormat:@"%@ (%d)", LOCALIZED(@"kStringWatchAd"), self.countdown];
                [button setTitle:newTitle forState:UIControlStateNormal];
            }
        }
        else if([title contains:LOCALIZED(@"kStringContinue")])
        {
            if([kHelpers checkOnline])
            {
                //online only
                [kAppDelegate animateControl:button];
                NSString *newTitle = [NSString stringWithFormat:@"%@ (%d)", LOCALIZED(@"kStringContinue"), self.countdown];
                [button setTitle:newTitle forState:UIControlStateNormal];
            }
        }

        else if([title contains:LOCALIZED(@"kStringRestartButton")])
        {
            if(![kHelpers checkOnline])
            {
                //offline only
                [kAppDelegate animateControl:button];
            }
        }

    }
}

- (void) actionTimerCountdown:(NSTimer *)incomingTimer
{
    if(!self.continueMode)
        return;

    //only dec if from timer
    if(incomingTimer)
        self.countdown--;

    if(self.countdown <= 0)
    {
        self.countdown = 0;
    }

    [self updateContinueButton];

    if(incomingTimer)
    {
        if(self.countdown > 0)
        {
            //sound
            [kAppDelegate playSound:kCountdownSound];

            //also wobble
            for (NSUInteger i = 0; i < self.buttons.count; i++) {
                UIButton *button = self.buttons[i];
                NSString *title = ((SIAlertItem *)self.items[i]).title;

                if([title contains:LOCALIZED(@"kStringWatchAd")] || [title contains:LOCALIZED(@"kStringContinue")])
                {
                    [kAppDelegate animateControl:button];
                }
            }
        }
        else
        {
            //close
           [self buttonClose:nil];
        }
    }
}

- (void) actionTimerFlash:(NSTimer *)incomingTimer
{
    if(!self.flashMode)
        return;

	//alternate green/orange
     for(UIButton *button in self.buttons)
	 {
         int index = button.tag;

         SIAlertItem *item = self.items[index];
         if (item.type != SIAlertViewButtonTypeDestructive)
             continue;

        if(self.flashFlag)
        {
            //green
            [button setBackgroundColor:[self.destructiveButtonColor colorWithAlphaComponent:0.3f]];
            button.layer.borderColor = [self.destructiveButtonColor colorWithAlphaComponent:0.4f].CGColor;

        }
        else
        {
            //orange
            [button setBackgroundColor:[self.destructiveButtonColor2 colorWithAlphaComponent:0.3f]];
            button.layer.borderColor = [self.destructiveButtonColor2 colorWithAlphaComponent:0.4f].CGColor;
        }
	}

	self.flashFlag = !self.flashFlag;
}

- (void) actionTimerWobble:(NSTimer *)incomingTimer
{
    //skip
    if(self.continueMode)
        return;

    if(self.clicked)
        return;

    for (NSUInteger i = 0; i < self.buttons.count; i++) {
        UIButton *button = self.buttons[i];
        //if (((SIAlertItem *)self.items[i]).type == SIAlertViewButtonTypeDestructive) {
        //				else if([button.titleLabel.text isEqualToString:@"Settings"]) {


        NSString *title = ((SIAlertItem *)self.items[i]).title;
        if ([title isEqualToString:@"Resume"] ||
            [title isEqualToString:LOCALIZED(@"kStringWatchAd")] ||
            [title isEqualToString:LOCALIZED(@"kStringContinue")] ||
            [title isEqualToString:LOCALIZED(@"kStringLoveIt")] ||
            [title contains:@"OK ("] ||
            [title contains:@"Buy ("]
            ) {
            [kAppDelegate animateControl:button];
        }
    }

}

- (IBAction)volumeButtonPressed:(id)sender
{
    [kAppDelegate animateControl:self.volumeButton];

    if(kAppDelegate.soundVolume > 0.0f || kAppDelegate.musicVolume > 0.0f) {
        [kAppDelegate setSoundVolume:0];
        [kAppDelegate setMusicVolume:0];
    }
    else {
        [kAppDelegate setSoundVolume:kDefaultVolumeSound];
        [kAppDelegate setMusicVolume:kDefaultVolumeMusic];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [kAppDelegate playSound:kClickSound];
    });

    [self updateVolumeButton];

    [kAppDelegate saveState];
}

-(void)updateVolumeButton {
    if(kAppDelegate.soundVolume > 0.0f || kAppDelegate.musicVolume > 0.0f) {
        [self.volumeButton setBackgroundImage:[UIImage imageNamed:@"menu_icon_volume"] forState:UIControlStateNormal];
    }
    else {
        [self.volumeButton setBackgroundImage:[UIImage imageNamed:@"menu_icon_volume_off2"] forState:UIControlStateNormal];
    }
}



-(void)oldmanAction {
    if(!OLD_MAN_ENABLED)
        return;

    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state == UIApplicationStateBackground || state == UIApplicationStateInactive)
    {
        //background
        return;
    }

    [kAppDelegate animateControl:self.oldmanImageView];

    //50/50 random
    if([kHelpers randomBool])
        [kAppDelegate playSound:@"oldman.caf"];
    else
        [kAppDelegate playSound:@"oldman2.caf"];


    //disable fast click
    self.oldmanButton.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.oldmanButton.userInteractionEnabled = YES;
    });


}

- (void)dismissAnimated:(BOOL)animated
{
    [self dismissAnimated:animated cleanup:YES];
}

- (void)dismissAnimated:(BOOL)animated cleanup:(BOOL)cleanup
{
    //animated = NO;
    //cleanup = NO;

    [self.timerWobble invalidate];
    self.timerWobble = nil;
    [self.timerCountdown invalidate];
    self.timerCountdown = nil;
    [self.timerFlash invalidate];
    self.timerFlash = nil;

    if(OLD_MAN_ENABLED) {
        if(animated) {
            [UIView animateWithDuration:FADE_DURATION delay:0.0f options:0 animations:^{
                self.oldmanImageView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                self.oldmanImageView.hidden = YES;
                self.oldmanButton.hidden = YES;
            }];

        }
         else {
             self.oldmanImageView.alpha = 0.0f;
             self.oldmanImageView.hidden = YES;
             self.oldmanButton.hidden = YES;
     }
    }

    kAppDelegate.gameScene.lastClickDate = [NSDate date];

    BOOL isVisible = self.isVisible;

    if (isVisible) {
        if (self.willDismissHandler) {
            self.willDismissHandler(self);
        }
    }

    void (^dismissComplete)(void) = ^{

        //stop all sounds
        //[kAppDelegate stopAllAudio];
        [kAppDelegate stopSound:@"alertchat.caf"];

        self.visible = NO;
        self.hidden = YES;

        //reset
        [self resetModes];

        self.viewController.view.hidden = YES;

        [self.oldKeyWindow sendSubviewToBack:self.viewController.view];

        if (self.didDismissHandler) {
            self.didDismissHandler(self);
        }

        [self teardown];
    };

    if (animated && isVisible) {
        [self transitionOutCompletion:dismissComplete];

        [SIAlertView hideBackgroundAnimated:YES];

    } else {
        dismissComplete();

        [SIAlertView hideBackgroundAnimated:YES];
    }
}

#pragma mark - Transitions

- (void)transitionInCompletion:(void(^)(void))completion
{
    switch (self.transitionStyle) {
        case SIAlertViewTransitionStyleSlideFromBottom:
        {
            CGRect rect = self.containerView.frame;
            CGRect originalRect = rect;
            rect.origin.y = self.bounds.size.height;
            self.containerView.frame = rect;
            [UIView animateWithDuration:FADE_DURATION
                             animations:^{
                                 self.containerView.frame = originalRect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case SIAlertViewTransitionStyleSlideFromTop:
        {
            CGRect rect = self.containerView.frame;
            CGRect originalRect = rect;
            rect.origin.y = -rect.size.height;
            self.containerView.frame = rect;
            [UIView animateWithDuration:FADE_DURATION
                             animations:^{
                                 self.containerView.frame = originalRect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case SIAlertViewTransitionStyleFade:
        {
            self.containerView.alpha = 0;
            [UIView animateWithDuration:FADE_DURATION
                             animations:^{
                                 self.containerView.alpha = 1;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case SIAlertViewTransitionStyleBounce:
        {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(0.01), @(1.2), @(0.9), @(1)];
            animation.keyTimes = @[@(0), @(0.4), @(0.6), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.5;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.containerView.layer addAnimation:animation forKey:@"bouce"];
        }
            break;
        case SIAlertViewTransitionStyleDropDown:
        {
            CGFloat y = self.containerView.center.y;
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
            animation.values = @[@(y - self.bounds.size.height), @(y + 20), @(y - 10), @(y)];
            animation.keyTimes = @[@(0), @(0.5), @(0.75), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.4;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.containerView.layer addAnimation:animation forKey:@"dropdown"];
        }
            break;
        default:
            NSLog(@"no style");
            break;
    }
}

- (void)transitionOutCompletion:(void(^)(void))completion
{
    switch (self.transitionStyle) {
        case SIAlertViewTransitionStyleSlideFromBottom:
        {
            CGRect rect = self.containerView.frame;
            rect.origin.y = self.bounds.size.height;
            [UIView animateWithDuration:FADE_DURATION
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.containerView.frame = rect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case SIAlertViewTransitionStyleSlideFromTop:
        {
            CGRect rect = self.containerView.frame;
            rect.origin.y = -rect.size.height;
            [UIView animateWithDuration:FADE_DURATION
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.containerView.frame = rect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case SIAlertViewTransitionStyleFade:
        {
            [UIView animateWithDuration:FADE_DURATION
                             animations:^{
                                 self.containerView.alpha = 0;

                                 //done
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case SIAlertViewTransitionStyleBounce:
        {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(1), @(1.2), @(0.01)];
            animation.keyTimes = @[@(0), @(0.4), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.35;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.containerView.layer addAnimation:animation forKey:@"bounce"];

            self.containerView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        }
            break;
        case SIAlertViewTransitionStyleDropDown:
        {
            CGPoint point = self.containerView.center;
            point.y += self.bounds.size.height;
            [UIView animateWithDuration:FADE_DURATION
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.containerView.center = point;
                                 CGFloat angle = ((CGFloat)arc4random_uniform(100) - 50.f) / 100.f;
                                 self.containerView.transform = CGAffineTransformMakeRotation(angle);
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        default:
            break;
    }
}

- (void)resetTransition
{
    [self.containerView.layer removeAllAnimations];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self validateLayout];
}

- (void)invalidateLayout
{
    self.layoutDirty = YES;
    [self setNeedsLayout];
}

- (void)validateLayout
{
    if (!self.isLayoutDirty) {
        return;
    }
    self.layoutDirty = NO;
#if DEBUG_LAYOUT
    NSLog(@"%@, %@", self, NSStringFromSelector(_cmd));
#endif

    CGFloat height = [self preferredHeight];
    CGFloat left = (self.bounds.size.width - CONTAINER_WIDTH) * 0.5;
    CGFloat top = (self.bounds.size.height - height) * 0.5;

    if(OLD_MAN_ENABLED) {
        if(height > 292)
            top -= 40; //force highter;
        else if(height > 100)
            top -= 20; //force highter;
    }

    self.containerView.transform = CGAffineTransformIdentity;
    self.containerView.frame = CGRectMake(left, top, CONTAINER_WIDTH, height);
    self.containerView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds cornerRadius:self.containerView.layer.cornerRadius].CGPath;

    //border
    self.containerView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9f].CGColor;
    self.containerView.layer.borderWidth = 2.0f;

    CGFloat y = CONTENT_PADDING_TOP;
	if (self.titleLabel) {
        self.titleLabel.text = self.title;
        CGFloat height = [self heightForTitleLabel];
        self.titleLabel.frame = CGRectMake(CONTENT_PADDING_LEFT, y, self.containerView.bounds.size.width - CONTENT_PADDING_LEFT * 2, height);
        y += height;
	}
    if (self.messageLabel) {
        if (y > CONTENT_PADDING_TOP) {
            y += GAP;
        }
        self.messageLabel.text = self.message;
        CGFloat height = [self heightForMessageLabel];
        self.messageLabel.frame = CGRectMake(CONTENT_PADDING_LEFT, y, self.containerView.bounds.size.width - CONTENT_PADDING_LEFT * 2, height);
        y += height;

        self.messageLabel2.text = self.messageLabel.text;
        self.messageLabel2.frame = self.messageLabel.frame;
        self.messageLabel2.y -= 4;
        self.messageLabel2.height += 4;
    }
    if (self.items.count > 0) {
        if (y > CONTENT_PADDING_TOP) {
            y += GAP;
        }
        if (self.items.count == 2 && self.buttonsListStyle == SIAlertViewButtonsListStyleNormal) {
            CGFloat width = (self.containerView.bounds.size.width - CONTENT_PADDING_LEFT * 2 - GAP) * 0.5;
            UIButton *button = self.buttons[0];
            button.frame = CGRectMake(CONTENT_PADDING_LEFT, y, width, BUTTON_HEIGHT);
            button = self.buttons[1];
            button.frame = CGRectMake(CONTENT_PADDING_LEFT + width + GAP, y, width, BUTTON_HEIGHT);
        } else {
            for (NSUInteger i = 0; i < self.buttons.count; i++) {
                UIButton *button = self.buttons[i];
                button.frame = CGRectMake(CONTENT_PADDING_LEFT, y, self.containerView.bounds.size.width - CONTENT_PADDING_LEFT * 2, BUTTON_HEIGHT);
                if (self.buttons.count > 1) {
                    if (i == self.buttons.count - 1 && ((SIAlertItem *)self.items[i]).type == SIAlertViewButtonTypeCancel) {
                        CGRect rect = button.frame;
                        rect.origin.y += CANCEL_BUTTON_PADDING_TOP;
                        button.frame = rect;
                    }
                    y += BUTTON_HEIGHT + GAP;
                }

                //badge, only store
                if([button.titleLabel.text isEqualToString:@"Store"]) {

        					int offsetX = 112-22;
                  int offsetY = -12;
        					int num = [kAppDelegate getNumNewSkins];

                    if(num > 0) {
                        [button setBadgeValue:[NSString stringWithFormat:@"%d", num] withOffsetX:offsetX withOffsetY:offsetY];
                    }
                    else {
                        [button setBadgeValue:nil withOffsetX:offsetX withOffsetY:offsetY];
                    }
                }
                else if([button.titleLabel.text isEqualToString:@"Home"]) {
                    int newRainbow = kAppDelegate.rainbowCount;

                    int offsetX = 112-22; //112-6;
                    int offsetY = -12;
                    int num = [kAppDelegate getNumNewSkins];
                    if(num > 0) {
                        [button setBadgeValue:[NSString stringWithFormat:@"%d", num] withOffsetX:offsetX withOffsetY:offsetY];
                    }
                    else if(newRainbow > 0 || [kAppDelegate.titleController downloadAvailable]) {
                        [button setBadgeValue:@"" withOffsetX:offsetX withOffsetY:offsetY];
                    }
                    else {
                        [button setBadgeValue:nil withOffsetX:offsetX withOffsetY:offsetY];
                    }
                }

                else if([button.titleLabel.text isEqualToString:LOCALIZED(@"kStringFreeGiftButton")]) {

                    int offsetX = 72;
                    int offsetY = -12;
                    [button setBadgeValue:[NSString stringWithFormat:@"%d", 1] withOffsetX:offsetX withOffsetY:offsetY];
                }

            }
        }
    }

    //front close
    [self.containerView bringSubviewToFront:self.closeButton];
}

- (CGFloat)preferredHeight
{
	CGFloat height = CONTENT_PADDING_TOP;
	if (self.title) {
		height += [self heightForTitleLabel];
	}
    if (self.message) {
        if (height > CONTENT_PADDING_TOP) {
            height += GAP;
        }
        height += [self heightForMessageLabel];
    }
    if (self.items.count > 0) {
        if (height > CONTENT_PADDING_TOP) {
            height += GAP;
        }
        if (self.items.count <= 2 && self.buttonsListStyle == SIAlertViewButtonsListStyleNormal) {
            height += BUTTON_HEIGHT;
        } else {
            height += (BUTTON_HEIGHT + GAP) * self.items.count - GAP;
            if (self.buttons.count > 2 && ((SIAlertItem *)[self.items lastObject]).type == SIAlertViewButtonTypeCancel) {
                height += CANCEL_BUTTON_PADDING_TOP;
            }
        }
    }
    height += CONTENT_PADDING_BOTTOM;
	return height;
}

- (CGFloat)heightForTitleLabel
{
    if (self.titleLabel) {
        CGSize size = [self.title sizeWithFont:self.titleLabel.font
                                   minFontSize:
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
                       self.titleLabel.font.pointSize * self.titleLabel.minimumScaleFactor
#else
                       self.titleLabel.minimumFontSize
#endif
                                actualFontSize:nil
                                      forWidth:CONTAINER_WIDTH - CONTENT_PADDING_LEFT * 2
                                 lineBreakMode:self.titleLabel.lineBreakMode];
        return size.height;
    }
    return 0;
}

- (CGFloat)heightForMessageLabel
{
    if(self.forcedHeight > 0.0f)
        return self.forcedHeight;

    CGFloat minHeight = MESSAGE_MIN_LINE_COUNT * self.messageLabel.font.lineHeight;
    if (self.messageLabel) {
        //CGFloat maxHeight = MESSAGE_MAX_LINE_COUNT * self.messageLabel.font.lineHeight;
        CGFloat maxHeight = CGFLOAT_MAX;
#if 1
        //old way
        //NSString *text = self.message;
        NSString *text = self.messageLabel.attributedText.string;

        CGSize size = [text sizeWithFont:self.messageLabel.font
                               constrainedToSize:CGSizeMake(CONTAINER_WIDTH - CONTENT_PADDING_LEFT * 2, maxHeight)
                                   lineBreakMode:self.messageLabel.lineBreakMode];
        CGFloat newHeight = MAX(minHeight, size.height);
#endif

#if 0
        //new way
        //doesn't work any better with \n
        CGSize maxSize = CGSizeMake(CONTAINER_WIDTH - (CONTENT_PADDING_LEFT * 2), CGFLOAT_MAX);
        /*CGRect textRect =
                    [self.messageLabel.attributedText boundingRectWithSize:maxSize
                                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                   //options:0
                                     context:nil];
        */

        NSString *text = self.messageLabel.attributedText.string;

        NSMutableDictionary *attr = [NSMutableDictionary dictionary];
        NSMutableParagraphStyle *paraStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paraStyle.lineBreakMode = NSLineBreakByWordWrapping;

        [attr setObject:paraStyle forKey:NSParagraphStyleAttributeName];
        [attr setObject:self.messageLabel.font forKey:NSFontAttributeName];


        CGRect textRect = [text boundingRectWithSize:maxSize
                                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics
                                              attributes:attr
                                                 context:nil];

        //round
        textRect = CGRectIntegral(textRect);

        CGFloat newHeight = textRect.size.height;
        //litle more padding
        newHeight += 0; //20;
#endif

        //round up
        return ceilf(newHeight);
    }
    return ceilf(minHeight);
}

#pragma mark - Setup

-(void) resetModes {
    self.flashMode = YES;
    self.soundMode = YES;
    self.continueMode = NO;
    self.pauseMenuMode = NO;
    self.forcedHeight = 0.0f;
}

- (void)setup
{
    //[self resetModes];

    [self setupContainerView];
    [self updateTitleLabel];
    [self updateMessageLabel];
    [self setupCloseButton];
    [self setupButtons];
    [self invalidateLayout];
}

- (void)teardown
{
    [self.containerView removeFromSuperview];
    self.containerView = nil;
    self.titleLabel = nil;
    self.messageLabel = nil;
    self.messageLabel2 = nil;
    [self.buttons removeAllObjects];
    [self.alertWindow removeFromSuperview];
    self.alertWindow = nil;
    self.layoutDirty = NO;
}

- (void)setupContainerView
{
    /*if(self.containerView) {
        [self.containerView removeFromSuperview];
        self.containerView = nil;
    }*/

    self.containerView = [[UIView alloc] initWithFrame:self.bounds];
    //self.containerView = [[UIImageView alloc] initWithFrame:self.bounds];
    //self.containerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert_background"]];
    //self.containerView.frame = self.bounds;

    //self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert_background"]];
    //self.imageView.frame = self.bounds;
    //self.imageView.userInteractionEnabled = NO;
    //[self.containerView addSubview:self.imageView];
    //[self.containerView sendSubviewToBack:self.imageView];

    self.containerView.backgroundColor = _viewBackgroundColor ? _viewBackgroundColor : [UIColor purpleColor];
    self.containerView.layer.cornerRadius = self.cornerRadius;
    self.containerView.layer.shadowOffset = CGSizeZero;
    self.containerView.layer.shadowRadius = self.shadowRadius;
    self.containerView.layer.shadowOpacity = 0.5;
    [self addSubview:self.containerView];

    //[self addSubview:self.imageView];
    //[self.containerView sendSubviewToBack:self.imageView];

}

- (void)setupCloseButton {

    if(self.closeButton) {
        [self.closeButton removeFromSuperview];
        self.closeButton = nil;
    }

    //close
    if (!self.closeButton) {
        UIImage *buttonImage = [UIImage imageNamed:@"close-buttonAlert"];
        self.closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];

        int padding = 8; //-8;
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //int x = self.containerView.frame.size.width - buttonImage.size.width - padding;
        //int x = padding;
        int x = CONTAINER_WIDTH - buttonImage.size.width - padding;
        int y = padding;

        self.closeButton.frame = CGRectMake(x,y, buttonImage.size.width,buttonImage.size.width);
        [self.closeButton setBackgroundImage:buttonImage forState:UIControlStateNormal];

        [self.closeButton addTarget:self action:@selector(buttonClose:) forControlEvents:UIControlEventTouchUpInside];

        //bigger
        int buttonResize = 10;
        [self.closeButton setHitTestEdgeInsets:UIEdgeInsetsMake(-buttonResize, -buttonResize, -buttonResize, -buttonResize)];

        [self.containerView addSubview:self.closeButton];
    }

    //show/hide
    self.closeButton.hidden = !self.showCancel;

    //self.closeButton.enabled = NO;
    self.closeButton.userInteractionEnabled = NO;
}

- (void)updateTitleLabel
{
    self.titleLabel = nil;

	if (self.title) {
		if (!self.titleLabel) {
			self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
			self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.backgroundColor = [UIColor clearColor];
			self.titleLabel.font = self.titleFont;
            self.titleLabel.textColor = self.titleColor;
            self.titleLabel.adjustsFontSizeToFitWidth = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
            self.titleLabel.minimumScaleFactor = 0.75;
#else
            self.titleLabel.minimumFontSize = self.titleLabel.font.pointSize * 0.75;
#endif
			[self.containerView addSubview:self.titleLabel];
#if DEBUG_LAYOUT
            self.titleLabel.backgroundColor = [UIColor redColor];
#endif
		}
		self.titleLabel.text = self.title;
	} else {
		[self.titleLabel removeFromSuperview];
		self.titleLabel = nil;
	}
    [self invalidateLayout];
}

- (void)updateMessageLabel
{
    self.messageLabel = nil;
    self.messageLabel2 = nil;

    if (self.message) {
        if (!self.messageLabel) {
            self.messageLabel = [[UILabel alloc] initWithFrame:self.bounds];
            self.messageLabel.textAlignment = NSTextAlignmentCenter;
            self.messageLabel.backgroundColor = [UIColor clearColor];
            self.messageLabel.font = self.messageFont;
            self.messageLabel.textColor = self.messageColor;
            self.messageLabel.numberOfLines = MESSAGE_MAX_LINE_COUNT;
            [self.containerView addSubview:self.messageLabel];
#if DEBUG_LAYOUT
            self.messageLabel.backgroundColor = [UIColor redColor];
#endif

            //ZCAnimatedLabel, ZCRevealLabel
            self.messageLabel2 = [[ZCAnimatedLabel alloc] initWithFrame:self.messageLabel.frame];
            [self.containerView addSubview:self.messageLabel2];

            //self.messageLabel2.font = self.messageFont;
            //self.messageLabel2.textColor = self.messageColor;

        }
        self.messageLabel.text = self.message;
        self.messageLabel2.text = self.message;

        //animate label
        //self.messageLabel2.animationDuration = 0.5f;
        self.messageLabel2.animationDelay = 0.01f; //0.04f;
        //[self.messageLabel2 startAppearAnimation];

        self.messageLabel2.hidden = YES;
        self.messageLabel.hidden = NO;

    } else {
        [self.messageLabel removeFromSuperview];
        self.messageLabel = nil;
    }
    [self invalidateLayout];
}

- (void)setupButtons
{
    BOOL premium = [kAppDelegate isPremium];

    self.buttons = [[NSMutableArray alloc] initWithCapacity:self.items.count];
    for (NSUInteger i = 0; i < self.items.count; i++) {
        UIButton *button = [self buttonForItemIndex:i];
        //button.enabled = NO;
        button.userInteractionEnabled = NO;

        UIImage *buttonImage = nil;

        if(self.continueMode &&
           [button.titleLabel.text isEqualToString:LOCALIZED(@"kStringWatchAd")]) {

            //Continue_watchad -> Continue
            buttonImage = [UIImage imageNamed:@"menu_icon_movie"];
            //[button setTitle:LOCALIZED(@"kStringContinue") forState:UIControlStateNormal];
            //button.tag = TAG_CONTINUE;

            //hide
            button.hidden = NO; //YES;
            button.alpha = 0.0f;

            //show
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                //button.hidden = NO;
                [UIView animateWithDuration:0.3f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:(void (^)(void)) ^{
                                     button.alpha = 1.0f;
                                 }
                                 completion:^(BOOL finished){
                                     //[kAppDelegate animateControl:button];
                                 }];

            });

        }

        //add image based on button text
        else if([button.titleLabel.text isEqualToString:LOCALIZED(@"kStringResume")] ||
           ([button.titleLabel.text isEqualToString:LOCALIZED(@"kStringContinue")] && !premium) ||
           [button.titleLabel.text isEqualToString:LOCALIZED(@"kStringPlay")]
           ) {

            //buttonImage = [UIImage imageNamed:@"menu_icon_play"];
            buttonImage = [UIImage imageNamed:@"menu_icon_resume"];
        }
        else if([button.titleLabel.text contains:@"VIP"] || //"Premium"
                [button.titleLabel.text contains:@"Premium"]
                ) {

            //buttonImage = [UIImage imageNamed:@"menu_icon_play"];
            buttonImage = [UIImage imageNamed:@"menu_icon_premium2"];
        }

        else if([button.titleLabel.text isEqualToString:@"Share"]
                ) {

            buttonImage = [UIImage imageNamed:@"menu_icon_share"];
        }

        else if([button.titleLabel.text isEqualToString:@"Rate"]
                ) {

            buttonImage = [UIImage imageNamed:@"menu_icon_rate"];
        }

        else if([button.titleLabel.text isEqualToString:LOCALIZED(@"kStringRestartButton")]) {
            //"Restart World"
            buttonImage = [UIImage imageNamed:@"menu_icon_restart"];

            //hide
            button.hidden = NO; //YES;
            button.alpha = 0.0f;

            //show, after delay
            CGFloat showDelay = 0.8f; //1.3f;

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, showDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                //button.hidden = NO;
                [UIView animateWithDuration:0.3f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:(void (^)(void)) ^{
                                 button.alpha = 1.0f;
                             }
                             completion:^(BOOL finished){

                                 //and bounce, disabled
                                 //[kAppDelegate animateControl:button];
                             }];

            });
}

        else if([button.titleLabel.text isEqualToString:LOCALIZED(@"kStringFreeGiftButton")]) {
            //"Restart World"
            buttonImage = [UIImage imageNamed:@"menu_icon_gift"];
        }

        else if([button.titleLabel.text isEqualToString:LOCALIZED(@"kStringWatchAd")] ||
                [button.titleLabel.text isEqualToString:LOCALIZED(@"kStringTry")]) {
            //[button.titleLabel.text isEqualToString:LOCALIZED(@"kStringFreeUnlock")]) {

            buttonImage = [UIImage imageNamed:@"menu_icon_movie"];
        }

        else if([button.titleLabel.text isEqualToString:LOCALIZED(@"kStringLoveIt")]) {
            buttonImage = [UIImage imageNamed:@"heart_full"];
        }

        else if([button.titleLabel.text contains:@"❤️ "]) {

            //remove old heart
            NSString *tempString = [button.titleLabel.text stringByReplacingOccurrencesOfString:@"❤️ " withString:@""];
            [button setTitle:tempString forState:UIControlStateNormal];
            buttonImage = [UIImage imageNamed:@"heart_full"];
        }

        else if([button.titleLabel.text isEqualToString:@"Store"]) {
            buttonImage = [UIImage imageNamed:@"menu_icon_shop"];
        }
        else if([button.titleLabel.text isEqualToString:@"Settings"]) {
            buttonImage = [UIImage imageNamed:@"menu_icon_settings"];
        }
        else if([button.titleLabel.text isEqualToString:@"Disable Ads"] || [button.titleLabel.text isEqualToString:@"No Ads"]) {
            //buttonImage = [UIImage imageNamed:@"menu_icon_ads"];
        }
        else if([button.titleLabel.text isEqualToString:@"Home"]) {
            //buttonImage = [UIImage imageNamed:@"menu_icon_settings"];
            //buttonImage = [UIImage imageNamed:@"podium2"]; //arrow
            buttonImage = [UIImage imageNamed:@"podium7"]; //home
        }
        else if([button.titleLabel.text isEqualToString:LOCALIZED(@"kStringHowToPlay")]) {
            //buttonImage = [UIImage imageNamed:@"menu_icon_settings"];
        }



        //resize
        buttonImage = [kHelpers imageByScalingForSize:CGSizeMake(25,25) withImage:buttonImage];

        if(buttonImage) {
            float topOffset = 5;
            //float buttonWidth = 260;
            //UIFont *tempFont = [UIFont fontWithName:kFontName size:16*kFontScale];

            [button setImage:buttonImage forState:UIControlStateNormal];

            //remove title offset
            //button.titleEdgeInsets = UIEdgeInsetsMake(0, -buttonImage.size.width, 0, 0);

            //button.transform = CGAffineTransformScale(self.transform, -1.0f, 1.0f);
            //button.titleLabel.transform = CGAffineTransformScale(self.titleLabel.transform, -1.0f, 1.0f);
            //button.imageView.transform = CGAffineTransformScale(self.imageView.transform, -1.0f, 1.0f);

            //left with padding
            CGFloat spacing = 6; // the amount of spacing to appear between image and title
            button.imageEdgeInsets = UIEdgeInsetsMake(topOffset, 0, 0, spacing);
            button.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);

        }


        [self.buttons addObject:button];
        [self.containerView addSubview:button];
    }
}

- (UIButton *)buttonForItemIndex:(NSUInteger)index
{
    SIAlertItem *item = self.items[index];
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.tag = index;
	button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    button.titleLabel.font = self.buttonFont;
	[button setTitle:item.title forState:UIControlStateNormal];
	UIImage *normalImage = nil;
	UIImage *highlightedImage = nil;
	switch (item.type) {
		case SIAlertViewButtonTypeCancel:
			normalImage = [UIImage imageNamed:@"SIAlertView.bundle/button-cancel"];
			highlightedImage = [UIImage imageNamed:@"SIAlertView.bundle/button-cancel-d"];
			[button setTitleColor:self.cancelButtonColor forState:UIControlStateNormal];
            [button setTitleColor:[self.cancelButtonColor colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
			break;
		case SIAlertViewButtonTypeDestructive:
			normalImage = [UIImage imageNamed:@"SIAlertView.bundle/button-destructive"];
			highlightedImage = [UIImage imageNamed:@"SIAlertView.bundle/button-destructive-d"];
            [button setTitleColor:self.destructiveButtonColor forState:UIControlStateNormal];
            [button setTitleColor:[self.destructiveButtonColor colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
			break;
		case SIAlertViewButtonTypeDefault:
		default:
			normalImage = [UIImage imageNamed:@"SIAlertView.bundle/button-default"];
			highlightedImage = [UIImage imageNamed:@"SIAlertView.bundle/button-default-d"];
			[button setTitleColor:self.buttonColor forState:UIControlStateNormal];
            [button setTitleColor:[self.buttonColor colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];

			break;
	}

	CGFloat hInset = floorf(normalImage.size.width / 2);
	CGFloat vInset = floorf(normalImage.size.height / 2);
	UIEdgeInsets insets = UIEdgeInsetsMake(vInset, hInset, vInset, hInset);
	normalImage = [normalImage resizableImageWithCapInsets:insets];
	highlightedImage = [highlightedImage resizableImageWithCapInsets:insets];
	[button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

    button.layer.borderWidth = 2.0f;
    button.layer.cornerRadius = 12;

    return button;
}

#pragma mark - Actions

- (void)buttonClose:(UIButton *)button {
    if(button && (!button.enabled || button.hidden))
        return;

    self.clicked = YES;

    [kAppDelegate playSound:kClickSound];

    [self dismissAnimated:YES];

    if (self.didCloseHandler)
        self.didCloseHandler(self);

    //needed?
//    if (self.didDismissHandler)
//        self.didDismissHandler(self);

}

- (void)buttonAction:(UIButton *)button
{
    if(!button.enabled)
        return;

    SIAlertItem *item = self.items[button.tag];
	if (item.action) {
		item.action(self);
	}

    [kAppDelegate animateControl:button];

    //don't close, why?
    if([button.titleLabel.text isEqualToString:@"Share"]) {
       // return;
    }

    self.clicked = YES;

    for(UIButton *button in self.buttons) {
        //disable
        button.userInteractionEnabled = NO;
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        //re-enable
        for(UIButton *button in self.buttons) {
            button.userInteractionEnabled = YES;
        }

        [self dismissAnimated:YES];
    });
}

#pragma mark - CAAnimation delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    void(^completion)(void) = [anim valueForKey:@"handler"];
    if (completion) {
        completion();
    }
}

#pragma mark - UIAppearance setters

- (void)setViewBackgroundColor:(UIColor *)viewBackgroundColor
{
    if (_viewBackgroundColor == viewBackgroundColor) {
        return;
    }
    _viewBackgroundColor = viewBackgroundColor;
    self.containerView.backgroundColor = viewBackgroundColor;


    //self.containerView.backgroundColor = [UIColor clearColor];

    //bg image?
    //UIImage *img = [UIImage imageNamed:@"alert_background"];

    //stretch with caps
    //img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(200, 200, 200, 200)];

    //self.containerView.backgroundColor = [UIColor colorWithPatternImage:img];
    //[self.containerView setImage:img];
}

- (void)setTitleFont:(UIFont *)titleFont
{
    if (_titleFont == titleFont) {
        return;
    }
    _titleFont = titleFont;
    self.titleLabel.font = titleFont;
    [self invalidateLayout];
}

- (void)setMessageFont:(UIFont *)messageFont
{
    if (_messageFont == messageFont) {
        return;
    }
    _messageFont = messageFont;
    self.messageLabel.font = messageFont;
    [self invalidateLayout];
}

- (void)setTitleColor:(UIColor *)titleColor
{
    if (_titleColor == titleColor) {
        return;
    }
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (void)setMessageColor:(UIColor *)messageColor
{
    if (_messageColor == messageColor) {
        return;
    }
    _messageColor = messageColor;
    self.messageLabel.textColor = messageColor;
}

- (void)setButtonFont:(UIFont *)buttonFont
{
    if (_buttonFont == buttonFont) {
        return;
    }
    _buttonFont = buttonFont;
    for (UIButton *button in self.buttons) {
        button.titleLabel.font = buttonFont;
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    if (_cornerRadius == cornerRadius) {
        return;
    }
    _cornerRadius = cornerRadius;
    self.containerView.layer.cornerRadius = cornerRadius;
}

- (void)setShadowRadius:(CGFloat)shadowRadius
{
    if (_shadowRadius == shadowRadius) {
        return;
    }
    _shadowRadius = shadowRadius;
    self.containerView.layer.shadowRadius = shadowRadius;
}

- (void)setButtonBackgroundColor:(UIColor *)buttonColor
{
    if (_buttonBackgroundColor == buttonColor) {
        return;
    }
    _buttonBackgroundColor = buttonColor;
    //[self setColor:buttonColor toButtonsOfType:SIAlertViewButtonTypeDefault];
}


- (void)setButtonColor:(UIColor *)buttonColor
{
    if (_buttonColor == buttonColor) {
        return;
    }
    _buttonColor = buttonColor;
    [self setColor:buttonColor toButtonsOfType:SIAlertViewButtonTypeDefault];
}

- (void)setCancelButtonColor:(UIColor *)buttonColor
{
    if (_cancelButtonColor == buttonColor) {
        return;
    }
    _cancelButtonColor = buttonColor;
    [self setColor:buttonColor toButtonsOfType:SIAlertViewButtonTypeCancel];
}

- (void)setDestructiveButtonColor:(UIColor *)buttonColor
{
    if (_destructiveButtonColor == buttonColor) {
        return;
    }
    _destructiveButtonColor = buttonColor;
    [self setColor:buttonColor toButtonsOfType:SIAlertViewButtonTypeDestructive];
}


- (void)setDefaultButtonImage:(UIImage *)defaultButtonImage forState:(UIControlState)state
{
    [self setButtonImage:defaultButtonImage forState:state andButtonType:SIAlertViewButtonTypeDefault];
}


- (void)setCancelButtonImage:(UIImage *)cancelButtonImage forState:(UIControlState)state
{
    [self setButtonImage:cancelButtonImage forState:state andButtonType:SIAlertViewButtonTypeCancel];
}


- (void)setDestructiveButtonImage:(UIImage *)destructiveButtonImage forState:(UIControlState)state
{
    [self setButtonImage:destructiveButtonImage forState:state andButtonType:SIAlertViewButtonTypeDestructive];
}


- (void)setButtonImage:(UIImage *)image forState:(UIControlState)state andButtonType:(SIAlertViewButtonType)type
{
    for (NSUInteger i = 0; i < self.items.count; i++)
    {
        SIAlertItem *item = self.items[i];
        if(item.type == type)
        {
            UIButton *button = self.buttons[i];
            [button setBackgroundImage:image forState:state];
        }
    }
}


-(void)setColor:(UIColor *)color toButtonsOfType:(SIAlertViewButtonType)type {
    for (NSUInteger i = 0; i < self.items.count; i++) {
        SIAlertItem *item = self.items[i];
        if(item.type == type) {
            UIButton *button = self.buttons[i];
            //[button setTitleColor:color forState:UIControlStateNormal];
            //[button setTitleColor:[color colorWithAlphaComponent:0.6] forState:UIControlStateHighlighted];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateHighlighted];

            //[button setBackgroundColor:[color colorWithAlphaComponent:0.1f]];
            [button setBackgroundColor:[color colorWithAlphaComponent:0.3f]];
            button.layer.borderColor = [color colorWithAlphaComponent:0.4f].CGColor;
        }
    }
}

@end
