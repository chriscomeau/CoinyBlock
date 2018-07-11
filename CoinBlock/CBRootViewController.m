//
//  CBRootViewController.m
//  CoinBlock
//
//  Created by Chris Comeau on 2014-11-06.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import "CBRootViewController.h"

@interface CBRootViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageSplash;
@property (weak, nonatomic) IBOutlet UIImageView *scanline;
@property (weak, nonatomic) IBOutlet UIImageView *darkImage;

//@property (strong, nonatomic) UIView *childView;
@property (strong, nonatomic) UIViewController *childViewController;

-(void)setupFade;
@end


@implementation CBRootViewController


- (void)viewDidLoad
{
	[super viewDidLoad];

	self.view.clipsToBounds = YES;

    //background color
    self.view.backgroundColor = [UIColor blackColor];
    if([kHelpers isDebug])
        self.view.backgroundColor = [UIColor blueColor];

    //corner
    [kAppDelegate cornerView:self.view];


	//splash
    if([kHelpers isIphone5Size]) {
        self.bgImageSplash.image = [UIImage imageNamed:@"Default2-568h"];
    }
    else if([kHelpers isIphoneX]) {
        self.bgImageSplash.image = [UIImage imageNamed:@"Default2-iPhoneX"];
    }
	else {
        self.bgImageSplash.image = [UIImage imageNamed:@"Default2"];
	}

	//[self launch];
}

-(void)reset {

	//[kAppDelegate stopAllAudio];

	if(self.presentedViewController) {
		[self dismissViewControllerAnimated:NO completion:^{

		}];
	}

	kAppDelegate.loadingController = nil;
	kAppDelegate.titleController = nil;
	kAppDelegate.gameController = nil;
	kAppDelegate.settingsController = nil;
	//kAppDelegate.storeController = nil;
	//kAppDelegate.skinController = nil;
	//kAppDelegate.statsController = nil;
	kAppDelegate.aboutController = nil;
	kAppDelegate.winController = nil;
	kAppDelegate.cheatController = nil;
}

-(void)hideSplash
{
    self.bgImageSplash.hidden = YES;
}

- (void)launch
{
	[self reset];

	//switch for loading
	self.darkImage.alpha = 1.0f;
	self.darkImage.hidden = YES;

    self.bgImageSplash.hidden = NO;
	self.scanline.hidden = NO;

    //set loading right away
    kAppDelegate.loadingController = [kStoryboard instantiateViewControllerWithIdentifier:@"load"];
    //if(kIsIOS9)
    //    [kAppDelegate.loadingController loadViewIfNeeded];
    kAppDelegate.loadingController.view.hidden = NO;
    [kAppDelegate setViewController:kAppDelegate.loadingController];

    //fade in logo
    /*self.bgImageSplash2.alpha = 0.0f;
    [UIView animateWithDuration:0.6f delay:0.3f options:UIViewAnimationOptionCurveLinear animations:^{
        self.bgImageSplash2.alpha = 1.0f;

    } completion:^(BOOL finished) {
    }];*/
}


-(void)viewDidLayoutSubviews {

}

- (void)viewWillAppear:(BOOL)animated{

	[super viewWillAppear:animated];

	[self setupFade];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    //never called?
    //switch to non-loading
    self.bgImageSplash.hidden = YES;
    self.scanline.hidden = NO;
    self.darkImage.hidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown);
}

-(void)setupFade {

    self.darkImage.alpha = 1.0f;

	//force in main?
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

		if(kAppDelegate.fadingWhite) {
			self.darkImage.image = [UIImage imageNamed:@"white"];
			self.view.backgroundColor = [UIColor whiteColor];
		}
		else {
			self.darkImage.image = [UIImage imageNamed:@"black"];
			self.view.backgroundColor = [UIColor blackColor];
		}

	});

}

-(UIViewController*)currentViewController
{
	#if 0
	//old way
	return self.presentedViewController;
	#endif

	#if 1
	//new way
	return self;
	#endif
}

-(void)setViewController:(UIViewController*)viewController
{
	[self setupFade];

    //hide old
    //self.bgImageSplash.hidden = YES;

	if(!viewController || !viewController.view)
	{
		//invalid?
		if([kHelpers isDebug])
				assert(0);

		return;
	}

    //resize for ipad
    if([kHelpers isIpad])
    {
        viewController.view.frame = CGRectMake(0, 0, 320, 640);
        //viewController.view.x += ((320 * kiPadScaleX) - 320);
        
    }
    
	//new new way

	//delay 1
	//dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

			//remove old
			UIViewController* oldViewController = nil;

			//get directly
			//if(self.childViewControllers.count > 0)
			//	oldViewController = self.childViewControllers objectAtIndex:0];
			//remember
			oldViewController = self.childViewController;

			if(oldViewController)
			{
				[oldViewController removeFromParentViewController];
				[oldViewController.view removeFromSuperview];
			}

			//remember new
			self.childViewController = viewController;

			//resize new
			viewController.view.frame = self.view.frame;

            if([kHelpers isIpad])
            {
                //viewController.view.frame = CGRectMake(0, 0, 320, 640);
                //viewController.view.x += 40; //((320 * kiPadScaleX) - 320);
            }


			//delay 2
			//dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
				//add new
				[self addChildViewController: viewController];
				[self.view addSubview: viewController.view];

				//force layout
                viewController.view.hidden = NO;
				[viewController.view setNeedsLayout];
				[viewController.view layoutIfNeeded];
				[viewController.view setNeedsUpdateConstraints];
				[viewController.view updateConstraintsIfNeeded];

				//delay 3
				//dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                    if(viewController != kAppDelegate.loadingController)
                    {
                        if ([viewController respondsToSelector:@selector(setupFade)])
                            [viewController performSelector:@selector(setupFade)];

                        if ([viewController respondsToSelector:@selector(bringSubviewsToFront)])
                            [viewController performSelector:@selector(bringSubviewsToFront)];
                    }

                    //bring to front
					[self.view bringSubviewToFront:viewController.view];

					//force fade?
					// if ([viewController respondsToSelector:@selector(fadeOut)])
					// 	[viewController performSelector:@selector(fadeOut)];
    


				//});


			//});

	//});

    //hide splash
    if(viewController != kAppDelegate.loadingController)
        [self hideSplash];

}

@end
