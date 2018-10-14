//
//  WelcomeViewController.m


#import "WelcomeViewController.h"
#import "WelcomePageView.h"

/*


Welcome to Daily Wallpaper!

Download your daily wallpaper.

From the "Gallery" tab, you can sort images by Date, Popularity or Randomly.

From the "Details" view, with an image you can:
• Save to Photo Library
• Preview in Lock Screen

Check the about page to give us some feedback, thanks!

Proudly made in Montreal, Canada!

*/

@implementation WelcomeViewController

@synthesize buttonTest;
@synthesize buttonSkip;
@synthesize labelSkip;
@synthesize pagingScrollView;
@synthesize navImage;
@synthesize mainImage;
@synthesize isDone;
@synthesize pageControl;
@synthesize labelTitle;

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
    Log(@"WelcomeViewController::viewDidLoad");

    [super viewDidLoad];

    
    currentState = welcomeViewState1;
    isDone = YES;
    
    //scroll
    numPages = 4;

   // pagingScrollView.previewInsets = UIEdgeInsetsMake(0, 50, 0, 50);
	[pagingScrollView reloadPages];
    
    pagingScrollView.scrollsToTop = NO;

	pageControl.currentPage = 0;
	pageControl.numberOfPages = numPages;
        
    
    //skip
    [buttonSkip addTarget:self action:@selector(actionSkip) forControlEvents:UIControlEventTouchUpInside];
    
    [[self view] bringSubviewToFront:buttonSkip];
    buttonSkip.hidden = NO;
    buttonSkip.userInteractionEnabled = YES;

    self.buttonSkip.titleLabel.font = [UIFont fontWithName:kFontName size:26];

    int shadowOffset = 2;
    UIColor *shadowColor = kTextShadowColor;

    int buttonCornerRadius = 10;
    int buttonBorderWidth = 2;
    UIColor *buttonColor = RGBA(0,0,0, 0.3f); //RGBA(255,255,255, 0.1f);
    UIColor *borderColor = kYellowTextColor;
    
    float inset = 6.0f;
    [buttonSkip setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, inset, 0.0f)];
    
    [buttonSkip setTintColor:kYellowTextColor];
    [buttonSkip setTitleColor:kYellowTextColor forState:UIControlStateNormal];
    
    CALayer * l = nil;
    
    //[buttonSkip setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    //buttonSkip.titleLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    buttonSkip.clipsToBounds = NO;
    buttonSkip.titleLabel.clipsToBounds = NO;
    buttonSkip.titleLabel.layer.shadowColor = shadowColor.CGColor;
    buttonSkip.titleLabel.layer.shadowOpacity = 1.0f;
    buttonSkip.titleLabel.layer.shadowRadius = 0.0f;
    buttonSkip.titleLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    buttonSkip.titleLabel.layer.masksToBounds = NO;
    buttonSkip.backgroundColor = buttonColor;
    
    l = [buttonSkip layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:buttonCornerRadius];
    [l setBorderWidth:buttonBorderWidth];
    [l setBorderColor:[borderColor CGColor]];

    [buttonSkip setTitle:[NSString stringWithFormat:STR_WELCOME_BUTTON_1] forState:UIControlStateNormal];

    /*
    NSString *tempTitle = nil;
    NSMutableAttributedString *attributedString = nil;
    float spacing = 2.0f;
    
    tempTitle = self.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    self.titleLabel.attributedText = attributedString;
    */

    /*UIFont* tempFont = [UIFont fontWithName:@"Century Gothic" size:18];
    //UIFont* tempFont = [UIFont fontWithName:@"PTSans-Bold" size:20];
    [labelSkip setFont: tempFont];
    labelSkip.text = [NSString stringWithFormat:STR_WELCOME_BUTTON_1];
    labelSkip.textColor = [UIColor whiteColor];*/
    
    

    [[self view] bringSubviewToFront:labelSkip];
    
    //title
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.font = [UIFont fontWithName:kFontName size:16*kFontScale]; //20
    labelTitle.textColor = kYellowTextColor;
    labelTitle.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    //labelTitle.textColor = [UIColor whiteColor];
    labelTitle.text = LOCALIZED(@"kStringHowToPlay");
    labelTitle.hidden = NO;

    //corner
    [kAppDelegate cornerView:self.view];
    
    pageControl.hidden = NO;
    navImage.hidden = YES;

}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown);
}

 - (void)actionSkip
{
    [kAppDelegate playSound:kClickSound];

    [kAppDelegate animateControl:self.buttonSkip];
    [kAppDelegate animateControl:self.labelSkip];

    Log(@"WelcomeViewController::actionSkip");
    float secs = 0.3f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self hide];
        
    });

}
 
- (void)hide
{
    Log(@"WelcomeViewController::hide");

    //already hidding
    //if(isDone)
    //    return;

    //isDone = YES;
	
    //marked as not 1st time
    [kAppDelegate setPrefOpened:YES];
    [kAppDelegate saveState];


    [self dismissViewControllerAnimated:YES completion:nil];
    
    //switch back
    //[[appDelegate mainViewController] showMain];

    /*
    BOOL fade = YES;
    
    if(fade)
    {
        //fade welcome
        [UIView animateWithDuration:SPLASH_FADE_TIME
                         animations:^{
                             [self view].alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             
                            buttonTest.hidden = YES;
                            buttonTest.userInteractionEnabled = NO;
                            [self view].hidden = YES;

                            [appDelegate checkOnline];

                            currentState = welcomeViewState1;
                            isDone = YES;
                            
                            [appDelegate setPrefOpened:YES];
                            [appDelegate saveState];

                             
                         }];
    }
    else
    {
    
        //disable
        buttonTest.hidden = YES;
        buttonTest.userInteractionEnabled = NO;
        [self view].hidden = YES;

        [appDelegate checkOnline];

        currentState = welcomeViewState1;
        isDone = YES;
        
        [appDelegate setPrefOpened:YES];
        [appDelegate saveState];

    }
    */
}

- (void)reset
{
    [self show1];
    
     //scroll
    //[pageView setPageIndex:0];
    pageControl.currentPage = 0;
    [pagingScrollView selectPageAtIndex:0 animated:NO];
    [pagingScrollView reloadPages];
}

- (void)show1
{
    Log(@"WelcomeViewController::show1");
    
    /*if(USE_ANALYTICS == 1)
	{
        [FlurryAnalytics logEvent:@"WelcomeViewController::show1"];
	}*/
    
    currentState = welcomeViewState1;

    //switch image
    [navImage setImage:[UIImage imageNamed:@"welcome_nav1"] ];
    
    isDone = NO;
    
    mainImage.hidden = YES;
    
    [self view].hidden = NO;
    [self view].alpha = 1.0;
    
    //if([appDelegate prefOpened])
        //labelSkip.text = [NSString stringWithFormat:STR_WELCOME_BUTTON_3];
        [buttonSkip setTitle:[NSString stringWithFormat:STR_WELCOME_BUTTON_3] forState:UIControlStateNormal];
    //else
    //    labelSkip.text = [NSString stringWithFormat:STR_WELCOME_BUTTON_1];

}

- (void)show2
{
    Log(@"WelcomeViewController::show2");
    
    /*if(USE_ANALYTICS == 1)
	{
        [FlurryAnalytics logEvent:@"WelcomeViewController::show2"];
	}*/
    
    currentState = welcomeViewState2;
    
    //switch image
    [navImage setImage:[UIImage imageNamed:@"welcome_nav2"] ];
    
    //if([appDelegate prefOpened])
        //labelSkip.text = [NSString stringWithFormat:STR_WELCOME_BUTTON_3];
        [buttonSkip setTitle:[NSString stringWithFormat:STR_WELCOME_BUTTON_3] forState:UIControlStateNormal];
    //else
    //    labelSkip.text = [NSString stringWithFormat:STR_WELCOME_BUTTON_1];



}

- (void)show3
{
    Log(@"WelcomeViewController::show3");
    
    /*if(USE_ANALYTICS == 1)
	{
        [FlurryAnalytics logEvent:@"WelcomeViewController::show3"];
	}*/
    
    currentState = welcomeViewState3;
    
    //switch image
    [navImage setImage:[UIImage imageNamed:@"welcome_nav3"] ];
    
    //if([appDelegate prefOpened])
        //labelSkip.text = [NSString stringWithFormat:STR_WELCOME_BUTTON_3];
        [buttonSkip setTitle:[NSString stringWithFormat:STR_WELCOME_BUTTON_3] forState:UIControlStateNormal];
    
    //else
    //    labelSkip.text = [NSString stringWithFormat:STR_WELCOME_BUTTON_1];


}

- (void)show4
{
    Log(@"WelcomeViewController::show4");
    
    
    currentState = welcomeViewState4;
    
    //switch image
    [navImage setImage:[UIImage imageNamed:@"welcome_nav4"] ];
    
    //if([appDelegate prefOpened])
        //labelSkip.text = [NSString stringWithFormat:STR_WELCOME_BUTTON_3];
        [buttonSkip setTitle:[NSString stringWithFormat:STR_WELCOME_BUTTON_3] forState:UIControlStateNormal];

    //else
    //    labelSkip.text = [NSString stringWithFormat:STR_WELCOME_BUTTON_2];

}

- (IBAction)pageTurn
{
	[pagingScrollView selectPageAtIndex:pageControl.currentPage animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if([appDelegate isIpad])
    {
        return YES;
    }
    else 
    {
        if(interfaceOrientation == UIDeviceOrientationPortrait) 
            return YES;
        else 
            return NO;
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[pagingScrollView beforeRotation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[pagingScrollView afterRotation];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)theScrollView
{
	pageControl.currentPage = [pagingScrollView indexOfSelectedPage];
	[pagingScrollView scrollViewDidScroll];
    
    
   switch(pageControl.currentPage)
    {
        case 0:
            [self show1];
            break;
            
        case 1:
            [self show2];
            break;
            
        case 2:
            [self show3];
            break;
            
        case 3:
            [self show4];
            break;

         case 4:
            //[self hide];
            break;
            
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //music
    [kAppDelegate playMusic:kMusicNameOptions andRemember:YES];

    [self reset];
	
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[self becomeFirstResponder];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)theScrollView
{
    
    if ([pagingScrollView indexOfSelectedPage] == numPages - 1)
	{
        Log(@"WelcomeViewController::scrollViewDidEndDecelerating: end?");
	}
    
}

#pragma mark - MHPagingScrollViewDelegate

- (NSInteger)numberOfPagesInPagingScrollView:(MHPagingScrollView *)pagingScrollView
{
	return numPages;
}

- (UIView *)pagingScrollView:(MHPagingScrollView *)thePagingScrollView pageForIndex:(NSInteger)index
{
	WelcomePageView *pageView = (WelcomePageView *)[thePagingScrollView dequeueReusablePage];
	if (pageView == nil)
		pageView = [[WelcomePageView alloc] init];

	[pageView setPageIndex:(int)index];
	return pageView;
}

- (void)didReceiveMemoryWarning
{
	[pagingScrollView didReceiveMemoryWarning];
}

    
@end
