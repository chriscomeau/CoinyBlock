//
//  Helpers.m
//  CoinBlock
//
//  Created by Skyriser Media on 2014-04-17.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import "Helpers.h"
#import "GAI.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "NSString+Utilities.h"
#import "CBAppDelegate.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import "Reachability.h"
#import <ImageIO/ImageIO.h>
#import <ImageIO/CGImageSource.h>
#import <ImageIO/CGImageProperties.h>
#import "NYXImagesKit.h"
#import "UIAlertView+Blocks.h"
#import "SVProgressHUD.h"
#import "float.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import "UIButton+Position.h"
#import "GPUImage.h"

BOOL debugCheat = NO;

@implementation Helpers

//singleton
+ (id)instance {
    static Helpers *myInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myInstance = [[self alloc] init];
    });
    return myInstance;
}

-(id)init {
    if (self = [super init]) {
    }
    return self;
}

/*-(void)dealloc {

    [super dealloc];
}*/

-(void) setupGoogleAnalyticsForView:(NSString*)viewName {
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id tracker = [[GAI sharedInstance] defaultTracker];

    //can be null
    if(!tracker)
        return;

    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:viewName];

    // manual screen tracking
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

-(void) sendGoogleAnalyticsEventWithView:(NSString*)viewName andEvent:(NSString*)eventName {
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id tracker = [[GAI sharedInstance] defaultTracker];

    //can be null
    if(!tracker)
        return;

    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:viewName    // Event category (required)
                                                          action:eventName  // Event action (required)
                                                           label:@""         // Event label
                                                           value:nil] build]];    // Event value
}

-(void) sendGoogleAnalyticsEventWithCategory:(NSString*)category andAction:(NSString*)action andLabel:(NSString*)label  {
    id tracker = [[GAI sharedInstance] defaultTracker];

    //can be null
    if(!tracker)
        return;

    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category    // Event category (required)
                                                          action:action  // Event action (required)
                                                           label:label        // Event label
                                                           value:nil] build]];    // Event value
}


-(void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)message {
	UIAlertView *alert = [[UIAlertView alloc]
												initWithTitle:title
												message:message
												delegate:self
												cancelButtonTitle:LOCALIZED(@"kStringOK")
												otherButtonTitles:nil];
	[alert show];
}


//no button
-(void)showAlertWithTitleNoButton:(NSString*)title andMessage:(NSString*)message {
	UIAlertView *alert = [[UIAlertView alloc]
												initWithTitle:title
												message:message
												delegate:self
												cancelButtonTitle:nil
												otherButtonTitles:nil];
	[alert show];
}

-(void) setupHud {

    //old colors
    //[[SVProgressHUD appearance] setHudBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
    //[[SVProgressHUD appearance] setHudForegroundColor:[UIColor whiteColor]];
}

-(void) dismissHud {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

-(void) showErrorHud:(NSString*)error {

    Log(@"showErrorHud: %@", error);

    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus:error];
        //[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    });


    //after delay
    float secs = kHudWaitDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self dismissHud];
    });

}

/*-(void) showMessageHudDark:(NSString*)message {

    Log(@"showMessageHudDark: %@", message);

    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:message maskType:SVProgressHUDMaskTypeClear];
        //[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    });

}*/

-(void) showMessageHud:(NSString*)message {

    [self showMessageHud:message blockUI:YES];

}

-(void) showMessageHud:(NSString*)message blockUI:(BOOL)blockUI {

    Log(@"showMessageHud: %@", message);
/*
    enum {
    SVProgressHUDMaskTypeNone = 1, // allow user interactions while HUD is displayed
    SVProgressHUDMaskTypeClear, // don't allow
    SVProgressHUDMaskTypeBlack, // don't allow and dim the UI in the back of the HUD
    SVProgressHUDMaskTypeGradient // don't allow and dim the UI with a a-la-alert-view bg gradient
};
*/
    dispatch_async(dispatch_get_main_queue(), ^{
        if(blockUI)
            [SVProgressHUD showWithStatus:message maskType:SVProgressHUDMaskTypeClear];
        else
            [SVProgressHUD showWithStatus:message ];
    });

}


-(void) showSuccessHud:(NSString*)message {

    Log(@"showSuccessHud: %@", message);

    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showSuccessWithStatus:message ];
        //[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    });

    //after delay
    float secs = kHudWaitDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self dismissHud];
    });

}
-(BOOL) isWifi {

    if(![self checkOnline])
        return false;

    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];

    NetworkStatus status = [reachability currentReachabilityStatus];

    if(status == NotReachable)
    {
        //No internet
        return NO;
    }
    else if (status == ReachableViaWiFi)
    {
        //WiFi
        return YES;
    }
    else if (status == ReachableViaWWAN)
    {
        //3G
        return NO;
    }

    return NO;
}

-(BOOL) checkOnline {
    //force
    //return YES;

    BOOL tempOnline = YES;

    if(![self hasConnection])
        tempOnline = NO;

    return tempOnline;
}

-(BOOL) hasConnection {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];

    if (internetStatus == NotReachable)
    {
        return false;
    }
    else
    {
        return true;
    }
}

-(void) textFieldOffset:(UITextField*)textField withWidth:(int)paddingWidth{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, paddingWidth, textField.frame.size.height)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

-(void) textFieldChangePlaceholderColor:(UITextField*)textField withColor:(UIColor*)newColor {
    if ([textField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName: newColor}];
    } else {
        Log(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
    }
}

-(BOOL) isIpad
{
//#ifdef UI_USER_INTERFACE_IDIOM
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
//#else
//    return NO;
//#endif
}

-(BOOL) isIphone
{
    return ![self isIpad];
}

-(BOOL) isIphoneX
{
  return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && SCREEN_SIZE_MAX == 812.0;
}

- (UIEdgeInsets)safeAreaInsets
{
	//iPhoneX
	UIEdgeInsets inset = UIEdgeInsetsZero;

	if (kIsIOS11_0)
	{
		//only on iOS11
		if (@available(ios 11.0, *))
		{
      UIViewController* rootVC = ([UIApplication sharedApplication].windows.firstObject).rootViewController;
      //UIViewController* rootVC = ([kAppDelegate.windows.firstObject).rootViewController;
      //UIViewController *rootVC = kAppDelegate.window.rootViewController;

			if(rootVC)
			{
				inset = rootVC.view.safeAreaInsets;

				//portrait iphone, iphone x, ignore status bar
				if(inset.top == 20.0f || inset.top == 44.0f)
					inset.top -= 20.0f;
			}
		}
	}

	return inset;
}


- (BOOL) isRetina
{
   if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0))
    {
      // Retina display
      return YES;
    }
    else
    {
        return NO;
    }
}

-(UIImage*)imageWithAlpha:(UIImage*)source alpha:(CGFloat)alpha {
    UIGraphicsBeginImageContextWithOptions(source.size, NO, 0.0f);

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, source.size.width, source.size.height);

    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);

    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);

    CGContextSetAlpha(ctx, alpha);

    CGContextDrawImage(ctx, area, source.CGImage);

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return newImage;
}


-(UIImage*)colorizeImage:(UIImage*)inputImage color:(UIColor*)inputColor
{
    UIColor *color = inputColor;
    UIImage *image = inputImage;// Image to mask with
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, CGRectMake(0, 0, image.size.width, image.size.height), [image CGImage]);
    CGContextFillRect(context, CGRectMake(0, 0, image.size.width, image.size.height));
    
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return coloredImg;
}


- (UIImage*) imageWithImage:(UIImage*)source rotatedByHue:(CGFloat)deltaHueRadians;
{
    // Create a Core Image version of the image.
    CIImage *sourceCore = [CIImage imageWithCGImage:[source CGImage]];

    // Apply a CIHueAdjust filter
    CIFilter *hueAdjust = [CIFilter filterWithName:@"CIHueAdjust"];
    [hueAdjust setDefaults];
    [hueAdjust setValue: sourceCore forKey: @"inputImage"];
    [hueAdjust setValue: [NSNumber numberWithFloat: deltaHueRadians] forKey: @"inputAngle"];
    CIImage *resultCore = [hueAdjust valueForKey: @"outputImage"];

    // Convert the filter output back into a UIImage.
    // This section from http://stackoverflow.com/a/7797578/1318452
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef resultRef = [context createCGImage:resultCore fromRect:[resultCore extent]];
    UIImage *result = [UIImage imageWithCGImage:resultRef];
    CGImageRelease(resultRef);

    return result;
}

-(UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    UIImage *img = nil;

    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                               color.CGColor);
    CGContextFillRect(context, rect);

    img = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return img;
}

/*-(CGSize)parallaxSize:(CGSize)size
{
    float mult = (kParallaxWidth/kNoParallaxWidth);

    CGSize newSize;
    newSize.width = round(size.width * mult);
    newSize.height = round(size.height * mult);

    return newSize;
}*/

/*-(UIImage*)imageByScalingForParallax:(UIImage*)sourceImage
{
    //disabled
    return sourceImage;

    if(!sourceImage)
        return nil;

    UIImage *output = sourceImage;
    CGSize targetSize = sourceImage.size;
    //float targetWidth = 372.0f;
    //float targetWidth = 340.0f;
    float mult = kParallaxWidth / sourceImage.size.width;

    targetSize.width = round(targetSize.width * mult);
    targetSize.height = round(targetSize.height * mult);

    output = [output scaleToSize:targetSize usingMode:NYXResizeModeAspectFill];
    //output = [output cropToSize:targetSize usingMode:NYXCropModeCenter];

    return output;

}*/

-(UIImage*)imageByScalingForSize:(CGSize)targetSize withImage:(UIImage*)sourceImage
{
    if(!sourceImage)
        return nil;

    UIImage *output = sourceImage;

    output = [output scaleToSize:targetSize usingMode:NYXResizeModeAspectFill];

    return output;
}

-(UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withImage:(UIImage*)sourceImage withCenter:(BOOL)center
{
    //return sourceImage;

    if(!sourceImage)
        return nil;

    UIImage *output = sourceImage;

    output = [output scaleToSize:targetSize usingMode:NYXResizeModeAspectFill];

    //memory leak?
    /*if(center)
        output = [output cropToSize:targetSize usingMode:NYXCropModeCenter];
    else
        output = [output cropToSize:targetSize usingMode:NYXCropModeTopLeft];*/

    return output;

}

- (UIImage*)imageWithBorderFromImage:(UIImage*)source;
{
    CGSize size = [source size];
    UIGraphicsBeginImageContext(size);
    float thickness = 4.0f;

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    rect = CGRectInset(rect, thickness, thickness);

    [source drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];

    //CGContextSetRGBStrokeColor(context, 1.0, 0.5, 1.0, 1.0); //pink
    CGContextSetRGBStrokeColor(context, 0,0,0, 1.0); //black
    CGContextSetLineWidth(context, thickness);

    CGContextStrokeEllipseInRect(context, rect);
    //CGContextStrokeRect(context, rect);

    UIImage *testImg =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return testImg;
}
- (UIImage*)circularScaleAndCropImage:(UIImage*)image frame:(CGRect)frame {
    // This function returns a newImage, based on image, that has been:
    // - scaled to fit in (CGRect) rect
    // - and cropped within a circle of radius: rectWidth/2

    //Create the bitmap graphics context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(frame.size.width, frame.size.height), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    //Get the width and heights
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat rectWidth = frame.size.width;
    CGFloat rectHeight = frame.size.height;

    //Calculate the scale factor
    CGFloat scaleFactorX = rectWidth/imageWidth;
    CGFloat scaleFactorY = rectHeight/imageHeight;

    //Calculate the centre of the circle
    CGFloat imageCentreX = rectWidth/2;
    CGFloat imageCentreY = rectHeight/2;

    // Create and CLIP to a CIRCULAR Path
    // (This could be replaced with any closed path if you want a different shaped clip)
    CGFloat radius = rectWidth/2;
    CGContextBeginPath (context);
    CGContextAddArc (context, imageCentreX, imageCentreY, radius, 0, 2*M_PI, 0);
    CGContextClosePath (context);
    CGContextClip (context);

    //Set the SCALE factor for the graphics context
    //All future draw calls will be scaled by this factor
    CGContextScaleCTM (context, scaleFactorX, scaleFactorY);

    // Draw the IMAGE
    CGRect myRect = CGRectMake(0, 0, imageWidth, imageHeight);
    [image drawInRect:myRect];

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return img;
}

-(UIImage*)imageWithImage: (UIImage*)sourceImage scaleToWidth:(float)inWidth resizeIfSmaller:(BOOL)resize
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = inWidth / oldWidth;

    //dont resize if smaller
    if(!resize && (oldWidth < inWidth) )
        return sourceImage;

    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;

    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (BOOL) isDebug
{
#ifdef DEBUG
    return YES; //YES
#else
    return NO || debugCheat;
#endif
}

-(BOOL) isSimulator
{

#if TARGET_IPHONE_SIMULATOR
    return YES;
#else
    return NO;
#endif

}

- (NSString*)getVersionString
{
    NSString *debugString = [NSString stringWithFormat:@"%@", [self isDebug]?@" (debug)":@""]; //add debug string
    NSString *output = [NSString stringWithFormat:@"%@%@",
						[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"], debugString];

	return output;
}
- (NSString*)getVersionString2
{
    NSString *debugString = [NSString stringWithFormat:@"%@", [self isDebug]?@" (debug)":@""]; //add debug string
	NSString *output = [NSString stringWithFormat:@"%@ (%@)%@",
						[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] ,
						[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
						debugString];

	return output;
}

- (NSString *) platformString{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (Global)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (Global)";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (GSM)";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini Retina (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini Retina (GSM)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}

//https://gist.github.com/1323251
- (NSString *) platform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}


//to test parallax
-(BOOL) isIpadBig {

    if([[self platform] isEqualToString:@"iPad1,1"] ||
        [[self platform] isEqualToString:@"iPad2,1"] ||
        [[self platform] isEqualToString:@"iPad2,2"] ||
        [[self platform] isEqualToString:@"iPad2,3"] ||
        [[self platform] isEqualToString:@"iPad2,4"] ||
        [[self platform] isEqualToString:@"iPad3,1"] ||
        [[self platform] isEqualToString:@"iPad3,2"] ||
        [[self platform] isEqualToString:@"iPad3,3"] ||
        [[self platform] isEqualToString:@"iPad3,4"] ||
        [[self platform] isEqualToString:@"iPad3,5"] ||
        [[self platform] isEqualToString:@"iPad3,6"] ||
        [[self platform] isEqualToString:@"iPad4,1"] ||
        [[self platform] isEqualToString:@"iPad4,2"] )
        return YES;
    else
        return NO;
}
-(BOOL) isIpadMini {

    if([[self platform] isEqualToString:@"iPad2,5"] ||
        [[self platform] isEqualToString:@"iPad2,6"] ||
        [[self platform] isEqualToString:@"iPad2,7"] ||
        [[self platform] isEqualToString:@"iPad4,4"] ||
        [[self platform] isEqualToString:@"iPad4,5"] )
        return YES;
    else
        return NO;
}


-(BOOL) canMakePayments {
		//disabled
		return YES;
#if 0
    BOOL makePayments = [SKPaymentQueue canMakePayments];

    return makePayments;
#endif
}

-(BOOL) isFriday {

    NSDateComponents *component = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:[NSDate date]];

    BOOL friday = [component weekday] == DAY_FRIDAY;

    return friday;
}

-(BOOL) isSaturday {

    NSDateComponents *component = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:[NSDate date]];

    BOOL friday = [component weekday] == DAY_SATURDAY;

    return friday;
}

-(BOOL) isMonday {

    NSDateComponents *component = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:[NSDate date]];

    BOOL friday = [component weekday] == DAY_MONDAY;

    return friday;
}


-(BOOL) isNight {

    NSDateComponents *component = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:[NSDate date]];

    BOOL night = ([component hour] >= 19 && [component hour] <= 3);

    return night;
}
-(BOOL) isMorning {

    NSDateComponents *component = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:[NSDate date]];

    BOOL night = ([component hour] >= 6 && [component hour] <= 11);

    return night;
}


-(void) loopInBackground
{
    #if kLoopLoadInBg
        //loop in Bg
        while([kHelpers isBackground])
        {
            Log(@"loopInBackground");

            [NSThread sleepForTimeInterval:1000]; //wait a second
        }
    #endif
}

-(BOOL) isBackground {

    return ![self isForeground];
}

-(BOOL) isForeground {

    UIApplicationState state = [[UIApplication sharedApplication] applicationState];

    if (state == UIApplicationStateActive)
        return YES;

    return NO;
}

-(BOOL) canParallax {
    //force
    return NO;

#if 0
    if([self isIphone4])
        return NO;
    else if([self isSimulator])
        return NO;

    return YES;
#endif

}

//to test parallax, slowness
-(BOOL) isIphone4 {
    NSString *platform = [[self platform] lowercaseString];
    if([platform contains:@"iphone3,"])
        return YES;
    else
        return NO;
}

-(BOOL) isIphone4s {
    NSString *platform = [[self platform] lowercaseString];
    if([platform contains:@"iphone4,"])
        return YES;
    else
        return NO;
}

-(BOOL) isIpad2 {

    NSString *platform = [[self platform] lowercaseString];

    if([platform contains:@"ipad2,"])
        return YES;
    else
        return NO;
}

-(BOOL) isIphone4Size {

    return (![self isIphone5Size] && ![self isIphoneX]);
}

#if 0
+ (UIEdgeInsets)safeAreaInsets
{
    //pour iPhoneX, AIOS-2139
    UIEdgeInsets inset = UIEdgeInsetsZero;
    
    //if ([UtilitairesVersionIOS iOS11EstDisponible])
    {
        //pour compiler seulement sur iOS11
        si (@available(ios 11.0, *))
        {
            UIViewController* rootVC = ([UIApplication sharedApplication].windows.firstObject).rootViewController;
            si(rootVC)
            {
                inset = rootVC.view.safeAreaInsets;
                
                //pour portrait iphone, iphone x, ignorer status bar
                if(inset.top == 20.0f || inset.top == 44.0f)
                    inset.top -= 20.0f;
                
                //mode splitview, enlever marge gauche
                UISplitViewController *splitCourant = [GestionnaireInterfaceVC splitView];
                si (splitCourant.preferredDisplayMode == UISplitViewControllerDisplayModeAllVisible)
                {
                    inset.left = 0.0f;
                }
            }
        }
    }
    
    retourne inset;
}
#endif

-(BOOL) isIphone5Size
{
    if([self isIpad])
        return NO;
    
   //if ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
    if([self doublesEqual:(double)[[UIScreen mainScreen] bounds].size.height second:(double)568])
    //if([UIScreen mainScreen] bounds].size.height >= 568)
    {
      // iphone 5
      return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isLowPowerMode {

    /*
    [NSNotificationCenter defaultCenter] addObserver:self
        selector: @selector(yourMethodName:)
        name: NSProcessInfoPowerStateDidChangeNotification
        object: nil];
    */

    if ([[NSProcessInfo processInfo] isLowPowerModeEnabled])
        return YES;

    return NO;
}

- (BOOL)isAlertVisible {

    UIViewController *root = kAppDelegate.window.rootViewController;
    UIViewController *presented = root.presentedViewController;

    if([root isKindOfClass:[SIAlertView class]])
        return YES;
    if([presented isKindOfClass:[SIAlertView class]])
        return YES;

    return NO;
}

- (BOOL)isSlowDevice {

    if([self isSimulator])
        return YES;

    if([self isIpad])
        return YES;

    if([self isIphone4])
        return YES;
    

#if 0
    //force
    //return YES;

    if([self isIphone4])
        return YES;

    if([self isIphone4s])
        return YES;

    if([self isIpad2])
        return YES;

    //if([self isLowPowerMode])
    //    return YES;

  #endif


return NO;

}

-(void)listFilters
{
    if(![kHelpers isDebug])
        return;

    NSArray* filters = [CIFilter filterNamesInCategories:nil];
    for (NSString* filterName in filters)
    {
        Log(@"Filter: %@", filterName);
    }
}

-(void)listFonts {

    if(![kHelpers isDebug])
        return;


    for (NSString* family in [UIFont familyNames])
    {
        Log(@"%@", family);

        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            Log(@"  %@", name);
        }
    }
}

-(UIImageView*)getLogo {
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_logo"]];
    return logo;
}

-(UIButton*)getMenuButton {

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0,26,16+10)]; //10px taller, for alignment

    [button setImage:[UIImage imageNamed:@"nav_menu"] forState:UIControlStateNormal];

    button.contentMode = UIViewContentModeScaleAspectFit;
    [button.imageView setContentMode:UIViewContentModeScaleAspectFit];

    button.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0);

    return button;
}


-(float) getLatitude {
    float latitude = 0.0f; //kAppDelegate.locationManager.location.coordinate.latitude;
    return latitude;
}

-(float) getLongitude {
    float longitude = 0.0f; //kAppDelegate.locationManager.location.coordinate.longitude;
    return longitude;
}

-(double)randomFloatBetween:(double)smallNumber andBig:(double)bigNumber {
    double diff = bigNumber - smallNumber;
    return (((double) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

-(BOOL)doublesEqual:(double)first second:(double)second {
    BOOL equal = NO;

    if ( fabs( first - second) < DBL_EPSILON2 )
        equal = YES;

    return equal;
}

-(float)clamp:(float)value min:(float)min max:(float)max {
    if( value > max ) {
        return max;
    } else if( value < min ) {
        return min;
    } else {
        return value;
    }
}


-(void) startUpdatingLocation {
     //[kAppDelegate startUpdatingLocation];
}

//corners
-(NSArray *)getBoundingBox:(MKMapRect)mRect{
    CLLocationCoordinate2D bottomLeft = [self getSWCoordinate:mRect];
    CLLocationCoordinate2D topRight = [self getNECoordinate:mRect];
    return @[[NSNumber numberWithDouble:bottomLeft.latitude ],
             [NSNumber numberWithDouble:bottomLeft.longitude],
             [NSNumber numberWithDouble:topRight.latitude],
             [NSNumber numberWithDouble:topRight.longitude]];
}

-(CLLocationCoordinate2D)getCoordinateFromMapRectanglePoint:(double)x y:(double)y{
    MKMapPoint swMapPoint = MKMapPointMake(x, y);
    return MKCoordinateForMapPoint(swMapPoint);
}

-(CLLocationCoordinate2D)getNECoordinate:(MKMapRect)mRect{
    return [self getCoordinateFromMapRectanglePoint:MKMapRectGetMaxX(mRect) y:mRect.origin.y];
}
-(CLLocationCoordinate2D)getNWCoordinate:(MKMapRect)mRect{
    return [self getCoordinateFromMapRectanglePoint:MKMapRectGetMinX(mRect) y:mRect.origin.y];
}
-(CLLocationCoordinate2D)getSECoordinate:(MKMapRect)mRect{
    return [self getCoordinateFromMapRectanglePoint:MKMapRectGetMaxX(mRect) y:MKMapRectGetMaxY(mRect)];
}
-(CLLocationCoordinate2D)getSWCoordinate:(MKMapRect)mRect{
    return [self getCoordinateFromMapRectanglePoint:mRect.origin.x y:MKMapRectGetMaxY(mRect)];
}

//size the mapView region to fit its annotations
- (void)zoomMapViewToFitAnnotations:(MKMapView *)mapViewParam animated:(BOOL)animated
{
    NSMutableArray *zoomAnnotations = [[NSMutableArray alloc] initWithArray:[mapViewParam annotations]];

    if(!zoomAnnotations || [zoomAnnotations count] == 0)
        return;

    //remove current
    id userLocation = [mapViewParam userLocation];
    if (userLocation != nil ) {
        [zoomAnnotations removeObject:userLocation]; // avoid removing user location off the map
    }

    //check again
    if(!zoomAnnotations || [zoomAnnotations count] == 0)
        return;


    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;

    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;

    for(MKPointAnnotation *annotation in zoomAnnotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);

        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }

    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.4; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.4; // Add a little extra space on the sides

    region = [mapViewParam regionThatFits:region];
    [mapViewParam setRegion:region animated:animated];
}

-(NSString*) cleanupErrorString:(NSString*)string {

    if(!string)
        return nil;

    NSString *newString = string;

    NSString *remove = @"<strong>ERROR</strong>: ";

    newString = [newString stringByReplacingOccurrencesOfString:remove withString:@""];

    return newString;
}


-(NSString*) unixTimestamp:(NSDate*)date {

    //if(date == nil)
    //    return @"";

    NSDate *newDate = date;

    if(newDate == nil)
        newDate = [NSDate date];

    NSString * output = [NSString stringWithFormat:@"%ld", (long)[newDate timeIntervalSince1970]];
    //Log(@”Time Stamp Value == %@”, timeStampValue);

    return output;
}


-(NSString*) randomString
{
    return [self randomString:20];
}

-(NSString*) randomString:(int)len
{
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *s = [NSMutableString stringWithCapacity:len];
    for (NSUInteger i = 0U; i < len; i++) {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }

    return s;
}

-(NSString*) addRandomParameterToUrl:(NSString*)url {
    NSString *output = url;
    output = [output stringByAppendingString:@"?random="];
    //output = [output stringByAppendingString:[self randomString]];
    output = [output stringByAppendingString:[self unixTimestamp:nil]];
    return output;
}

-(void)textToClipboard:(NSString*)string
{
  [UIPasteboard generalPasteboard].string = string;
}

-(NSString*)textFromClipboard
{
  //	return [[UIPasteboard generalPasteboard].string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  return [UIPasteboard generalPasteboard].string;
}

-(NSString*) colorString:(NSString*)string
{
    NSString *string2 = string;

    string2 = [string2 stringByReplacingOccurrencesOfString:@"<color1>" withString:@"<font color=\"color1\">"]; //orange
    string2 = [string2 stringByReplacingOccurrencesOfString:@"</color1>" withString:@"</font>"]; //orange
    string2 = [string2 stringByReplacingOccurrencesOfString:@"color1" withString:kTextColor1]; //orange

    string2 = [string2 stringByReplacingOccurrencesOfString:@"<color2>" withString:@"<font color=\"color2\">"]; //orange
    string2 = [string2 stringByReplacingOccurrencesOfString:@"</color2>" withString:@"</font>"]; //orange
    string2 = [string2 stringByReplacingOccurrencesOfString:@"color2" withString:kTextColor2]; //orange

    return string2;
}

-(NSString*) addTimestampParameterToUrl:(NSString*)url withDate:(NSDate*)date {
    NSString *output = url;
    output = [output stringByAppendingString:@"&timestamp="];
    output = [output stringByAppendingString:[self unixTimestamp:date]];
    return output;
}

-(NSString*) stripHTML:(NSString*)string {

    if (!string || [string isEqual:[NSNull null]])
        return nil;

    NSString *newString = string;

    NSString *remove = @"<p>";
    newString = [newString stringByReplacingOccurrencesOfString:remove withString:@""];

    remove = @"</p>";
    newString = [newString stringByReplacingOccurrencesOfString:remove withString:@""];

    remove = @"\n";
    newString = [newString stringByReplacingOccurrencesOfString:remove withString:@""];

    remove = @"\r";
    newString = [newString stringByReplacingOccurrencesOfString:remove withString:@""];


    newString = [self stringByDecodingXMLEntities:newString];

    return newString;
}

-(NSString *)stringByDecodingXMLEntities:(NSString*)string {
    NSUInteger myLength = [string length];
    NSUInteger ampIndex = [string rangeOfString:@"&" options:NSLiteralSearch].location;

    // Short-circuit if there are no ampersands.
    if (ampIndex == NSNotFound) {
        return string;
    }
    // Make result string with some extra capacity.
    NSMutableString *result = [NSMutableString stringWithCapacity:(myLength * 1.25)];

    // First iteration doesn't need to scan to & since we did that already, but for code simplicity's sake we'll do it again with the scanner.
    NSScanner *scanner = [NSScanner scannerWithString:string];

    [scanner setCharactersToBeSkipped:nil];

    NSCharacterSet *boundaryCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" \t\n\r;"];

    do {
        // Scan up to the next entity or the end of the string.
        NSString *nonEntityString;
        if ([scanner scanUpToString:@"&" intoString:&nonEntityString]) {
            [result appendString:nonEntityString];
        }
        if ([scanner isAtEnd]) {
            goto finish;
        }
        // Scan either a HTML or numeric character entity reference.
        if ([scanner scanString:@"&amp;" intoString:NULL])
            [result appendString:@"&"];
        else if ([scanner scanString:@"&apos;" intoString:NULL])
            [result appendString:@"'"];
        else if ([scanner scanString:@"&quot;" intoString:NULL])
            [result appendString:@"\""];
        else if ([scanner scanString:@"&lt;" intoString:NULL])
            [result appendString:@"<"];
        else if ([scanner scanString:@"&gt;" intoString:NULL])
            [result appendString:@">"];
        else if ([scanner scanString:@"&#" intoString:NULL]) {
            BOOL gotNumber;
            unsigned charCode;
            NSString *xForHex = @"";

            // Is it hex or decimal?
            if ([scanner scanString:@"x" intoString:&xForHex]) {
                gotNumber = [scanner scanHexInt:&charCode];
            }
            else {
                gotNumber = [scanner scanInt:(int*)&charCode];
            }

            if (gotNumber) {
                [result appendFormat:@"%C", (unichar)charCode];

                [scanner scanString:@";" intoString:NULL];
            }
            else {
                NSString *unknownEntity = @"";

                [scanner scanUpToCharactersFromSet:boundaryCharacterSet intoString:&unknownEntity];


                [result appendFormat:@"&#%@%@", xForHex, unknownEntity];

                //[scanner scanUpToString:@";" intoString:&unknownEntity];
                //[result appendFormat:@"&#%@%@;", xForHex, unknownEntity];
                Log(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);

            }

        }
        else {
            NSString *amp;

            [scanner scanString:@"&" intoString:&amp];  //an isolated & symbol
            [result appendString:amp];

            /*
            NSString *unknownEntity = @"";
            [scanner scanUpToString:@";" intoString:&unknownEntity];
            NSString *semicolon = @"";
            [scanner scanString:@";" intoString:&semicolon];
            [result appendFormat:@"%@%@", unknownEntity, semicolon];
            Log(@"Unsupported XML character entity %@%@", unknownEntity, semicolon);
             */
        }

    }
    while (![scanner isAtEnd]);

finish:
    return result;
}


-(NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    return [calendar dateFromComponents:components];
}


- (void) emptyFileCache {

    //disabled
#if 0
    return;

    NSString* path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                          NSUserDomainMask,
                                                          YES) lastObject];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *cacheFiles = [fileManager contentsOfDirectoryAtPath:path error:&error];
    for (NSString *file in cacheFiles) {
        error = nil;
        [fileManager removeItemAtPath:[path stringByAppendingPathComponent:file] error:&error];

        if(error) {
            Log(@"emptyFileCache error");
        }
    }
#endif
}

- (void)saveImage:(UIImage *)image withName:(NSString *)name {
    //NSString* path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString* path = NSTemporaryDirectory();

    //CGSize size = image.size;
    NSString *newName = name;

    //retina
    if([self isRetina]) {
        newName = [newName stringByAppendingString:@"@2x"];
    }

    //extension
    newName = [newName stringByAppendingString:@".png"];

    //NSData *data = UIImageJPEGRepresentation(image, 1.0);
    NSData *data = UIImagePNGRepresentation(image);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fullPath = [path stringByAppendingPathComponent:newName];
    [fileManager createFileAtPath:fullPath contents:data attributes:nil];
}

- (UIImage *)loadImage:(NSString *)name {
    NSString *newName = name;

    //retina
    if([self isRetina]) {
        newName = [newName stringByAppendingString:@"@2x"];
    }

    //extension
    newName = [newName stringByAppendingString:@".png"];

    //NSString* path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString* path = NSTemporaryDirectory();


    NSString *fullPath = [path stringByAppendingPathComponent:newName];
    UIImage *img = [UIImage imageWithContentsOfFile:fullPath];

    /*CGSize size;
    if(img) {
        size = img.size;
    }*/

    return img;
}

- (CGRect) getScreenRect;
{
    CGRect tempRect1 = [[UIScreen mainScreen] bounds];
    //CGRect tempRect2 = [[UIScreen mainScreen] applicationFrame];
    CGRect tempRect = CGRectMake(0,0,tempRect1.size.width, tempRect1.size.height);

    if([kHelpers isIphoneX])
    {
        tempRect = CGRectMake(0,0,tempRect1.size.width/kiPhoneXScaleX, tempRect1.size.height);
    }
    else if([kHelpers isIpad])
    {
        tempRect = CGRectMake(0,0,tempRect1.size.width/kiPadScaleX, tempRect1.size.height);
    }
    
    return tempRect;
}

-(BOOL) validateURL:(NSString*)url {

    if(url == nil || [url isEqual:[NSNull null]] || url.length == 0) {
        Log(@"Invalid URL: %@", url);
        return NO;
    }

    /*NSString *urlRegEx = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    if(![urlTest evaluateWithObject:url]) {
        Log(@"Invalid URL: %@", url);
        return NO;
    }*/

    return YES;

}

-(BOOL) validateEmail:(NSString*)email {
    //Email: Yes standard checking

    if(email == nil || email.length == 0)
        return NO;

    //no spaces
    if ([email contains:@" "])
        return NO;

    //no ampersand
    if ([email contains:@"&"])
        return NO;

    //no %
    if ([email contains:@"%%"])
        return NO;

    //http://stackoverflow.com/questions/3139619/check-that-an-email-address-is-valid-on-ios/3638271#3638271
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    if(![emailTest evaluateWithObject:email])
        return NO;

    return YES;
}

-(BOOL) validateFullName:(NSString*)username {

    if(username == nil)
        return NO;

     if(username.length < 1 || username.length > 100)
        return NO;

    //no ampersand
    if ([username contains:@"&"])
        return NO;

    //no @
    if ([username contains:@"@"])
        return NO;

    //no %
    if ([username contains:@"%%"])
        return NO;

    return YES;
}

-(BOOL) validateUsername:(NSString*)username {

    //Username: No spaces, numbers are allowed

    if(username == nil)
        return NO;

     if(username.length < 1 || username.length > 20)
        return NO;

    //no spaces
    if ([username contains:@" "])
        return NO;

    //no ampersand
    if ([username contains:@"&"])
        return NO;

    //no @
    if ([username contains:@"@"])
        return NO;

    //no %
    if ([username contains:@"%%"])
        return NO;

    return YES;
}

-(BOOL) validatePassword:(NSString*)password showError:(BOOL)showError {

    //disabled
    //return YES;

    if(password == nil) {
        if(showError)
            [kHelpers showAlertWithTitle:LOCALIZED(@"kStringError") andMessage:LOCALIZED(@"kStringErrorValidatePasswordGeneric")];

        return NO;
    }

    if(password.length < 6 || password.length > 100) {
        if(showError)
            [kHelpers showAlertWithTitle:LOCALIZED(@"kStringError") andMessage:LOCALIZED(@"kStringErrorValidatePasswordShort")];

        return NO;
    }

    //no spaces
    if ([password contains:@" "]) {
        if(showError)
            [kHelpers showAlertWithTitle:LOCALIZED(@"kStringError") andMessage:LOCALIZED(@"kStringErrorValidatePasswordInvalidCharacters")];

        return NO;
    }

    //no ampersand
    if ([password contains:@"&"]) {
        if(showError)
            [kHelpers showAlertWithTitle:LOCALIZED(@"kStringError") andMessage:LOCALIZED(@"kStringErrorValidatePasswordInvalidCharacters")];

        return NO;
    }

    //no %
    if ([password contains:@"%%"]) {
        if(showError)
            [kHelpers showAlertWithTitle:LOCALIZED(@"kStringError") andMessage:LOCALIZED(@"kStringErrorValidatePasswordInvalidCharacters")];

        return NO;
    }

    return YES;
}

- (BOOL)isLocationAvailable
{
    //system level
    if(![CLLocationManager locationServicesEnabled])
        return NO;

    //app level
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
       return NO;

    //still 0,0
    //if( [kHelpers doublesEqual:[kHelpers getLatitude] second:0.0f] || [kHelpers doublesEqual:[kHelpers getLongitude] second:0.0f])
    //    return NO;

    return YES;
}

-(BOOL) randomInt:(int)max {
    int temp = arc4random_uniform(max);
    return temp;
}

-(BOOL) randomBool
{
    return (arc4random_uniform(2) == 0);
}

-(BOOL) randomBool100:(int)percentage {
    int temp = arc4random_uniform(100);
    return temp < percentage;
}


-(BOOL) randomBool1000:(int)percentage{
    int temp = arc4random_uniform(1000);
    return temp < percentage;
}

-(void)haptic1
{
    if(kAppDelegate.vibrationEnabled)
        [HapticHelper generateFeedback:FeedbackType_Impact_Light];
    
    /*
     typedef enum {
     FeedbackType_Selection,
     FeedbackType_Impact_Light,
     FeedbackType_Impact_Medium,
     FeedbackType_Impact_Heavy,
     FeedbackType_Notification_Success,
     FeedbackType_Notification_Warning,
     FeedbackType_Notification_Error
     }FeedbackType;
     */
    
}

-(void)haptic2
{
    if(kAppDelegate.vibrationEnabled)
        [HapticHelper generateFeedback:FeedbackType_Selection];
}

-(void)vibrate
{
    //https://stackoverflow.com/questions/39564510/check-if-device-supports-uifeedbackgenerator-in-ios-10
    //taptic engine?

    //int level = kHapticFeedbackLevel;

    /*
     ... These methods seem to return:

     0 = Taptic not available
     1 = First generation (tested on an iPhone 6s) ... which does NOT support UINotificationFeedbackGenerator, etc.
     2 = Second generation (tested on an iPhone 7) ... which does support it.

     */
    /*if(level > 0)
    {

    }*/


    //disabled
    //return;
    if(!kAppDelegate.vibrationEnabled)
        return;

    //good
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);


    //weak
    //AudioServicesPlaySystemSound(1519); // Actuate `Peek` feedback (weak boom)


    //AudioServicesPlaySystemSound(1519); // Weak
    //AudioServicesPlaySystemSound(1520); // Strong

//    AudioServicesPlaySystemSound(1519) // Actuate `Peek` feedback (weak boom)
//    AudioServicesPlaySystemSound(1520) // Actuate `Pop` feedback (strong boom)
//    AudioServicesPlaySystemSound(1521) // Actuate `Nope` feedback (series of three weak booms)

}

-(void)playSoundCaf:(NSString*)name
{
    //remove extension
    name = [name stringByReplacingOccurrencesOfString:@".caf" withString:@""];

    NSString *soundPath = [[NSBundle mainBundle] pathForResource:name ofType:@"caf"];
    SystemSoundID soundID = 0;
    //CFURLRef soundFileURL = (CFURLRef)[NSURL URLWithString:soundPath];
    CFURLRef soundFileURL = CFBridgingRetain([NSURL URLWithString:soundPath]);

    OSStatus errorCode = AudioServicesCreateSystemSoundID(soundFileURL, &soundID);
    if (errorCode != kAudioServicesNoError) {
        // Handle failure here
        return;
    }

    AudioServicesPlaySystemSoundWithCompletion(soundID, ^{
        AudioServicesDisposeSystemSoundID(soundID);
        //[kAppDelegate setupAudioSession];
    });

    //AudioServicesPlaySystemSound(soundID);
}

-(BOOL)isOtherAudioPlaying
{
	BOOL playing = [[AVAudioSession sharedInstance] isOtherAudioPlaying];
	return playing;
}

- (BOOL)isAirPlayActive{
    CFDictionaryRef currentRouteDescriptionDictionary = nil;
    UInt32 dataSize = sizeof(currentRouteDescriptionDictionary);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRouteDescription, &dataSize, &currentRouteDescriptionDictionary);
    if (currentRouteDescriptionDictionary) {
        CFArrayRef outputs = CFDictionaryGetValue(currentRouteDescriptionDictionary, kAudioSession_AudioRouteKey_Outputs);
        if (outputs) {
            if(CFArrayGetCount(outputs) > 0) {
                CFDictionaryRef currentOutput = CFArrayGetValueAtIndex(outputs, 0);
                CFStringRef outputType = CFDictionaryGetValue(currentOutput, kAudioSession_AudioRouteKey_Type);
                return (CFStringCompare(outputType, kAudioSessionOutputRoute_AirPlay, 0) == kCFCompareEqualTo);
            }
        }
    }

    return NO;
}


- (UIImage *)takeScreenshot:(UIView*)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);

    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];

    // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();


	//shrink
	//CGSize newSize = CGSizeMake(image.size.width/2.0f, image.size.height/2.0f);
    image = [image scaleToSize:image.size usingMode:NYXResizeModeAspectFill];

    return image;
}

- (void)saveScreenshot
{
    //UIImage screenshot* = [self takeScreenshot:nil];

	//assert(screenshot);
}

/*
- (UIImage *)getBluredScreenshot_old:(UIImage*)inputImage {

    //CGImage imageRef = [ss CGImage];

    //filter
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    //CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIBoxBlur"];

    [gaussianBlurFilter setDefaults];
    [gaussianBlurFilter setValue:[CIImage imageWithCGImage:[inputImage CGImage]] forKey:kCIInputImageKey];
    [gaussianBlurFilter setValue:@10 forKey:kCIInputRadiusKey];

    CIImage *outputImage = [gaussianBlurFilter outputImage];
    CIContext *context   = [CIContext contextWithOptions:nil];

    //resize

    CGRect rect          = [outputImage extent];
    rect.origin.x        += (rect.size.width  - inputImage.size.width ) / 2;
    rect.origin.y        += (rect.size.height - inputImage.size.height) / 2;
    rect.size            = inputImage.size;

    //CGRect rect          = [inputImage extent]


    CGImageRef cgimg     = [context createCGImage:outputImage fromRect:rect];

    UIImage *image       = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);

    return image;
}*/

- (UIImage *)getSepiaImage:(UIImage*)inputImage {

    if(!inputImage)
        return nil;

    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
    GPUImageGaussianBlurFilter *stillImageFilter = [[GPUImageGaussianBlurFilter alloc] init];

    [stillImageSource addTarget:stillImageFilter];
    [stillImageFilter useNextFrameForImageCapture];
    [stillImageSource processImage];

    UIImage *currentFilteredVideoFrame = [stillImageFilter imageFromCurrentFramebuffer];

    return currentFilteredVideoFrame;
}

- (UIImage *)getGrayImage:(UIImage*)inputImage {

    if(!inputImage)
        return nil;

    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
    GPUImageGrayscaleFilter *stillImageFilter = [[GPUImageGrayscaleFilter alloc] init];

    [stillImageSource addTarget:stillImageFilter];
    [stillImageFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    //crash in bg?
    UIImage *currentFilteredVideoFrame = [stillImageFilter imageFromCurrentFramebuffer];

    return currentFilteredVideoFrame;
}

- (UIImage *)getBlackImage:(UIImage*)inputImage {

	UIImage *outputImage = [self getGrayImage:inputImage];
	return outputImage;

	//return [self filledImageFrom:inputImage withColor:[[UIColor blackColor] colorWithAlphaComponent:0.8f]];
}

- (UIImage *)filledImageFrom:(UIImage *)source withColor:(UIColor *)color{

	// begin a new image context, to draw our colored image onto with the right scale
	UIGraphicsBeginImageContextWithOptions(source.size, NO, [UIScreen mainScreen].scale);

	// get a reference to that context we created
	CGContextRef context = UIGraphicsGetCurrentContext();

	// set the fill color
	[color setFill];

	// translate/flip the graphics context (for transforming from CG* coords to UI* coords
	CGContextTranslateCTM(context, 0, source.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);

	CGContextSetBlendMode(context, kCGBlendModeColorBurn);
	CGRect rect = CGRectMake(0, 0, source.size.width, source.size.height);
	CGContextDrawImage(context, rect, source.CGImage);

	CGContextSetBlendMode(context, kCGBlendModeSourceIn);
	CGContextAddRect(context, rect);
	CGContextDrawPath(context,kCGPathFill);

	// generate a new UIImage from the graphics context we drew onto
	UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	//return the color-burned image
	return coloredImg;
}

- (UIImage *)getBlurredImage:(UIImage*)inputImage {

    if(!inputImage)
        return nil;

    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
    GPUImageGaussianBlurFilter *stillImageFilter = [[GPUImageGaussianBlurFilter alloc] init];

    stillImageFilter.blurPasses = 1;
    //stillImageFilter.blurRadiusInPixels = 8;
    stillImageFilter.blurRadiusInPixels = 6;

    [stillImageSource addTarget:stillImageFilter];
    [stillImageFilter useNextFrameForImageCapture];
    [stillImageSource processImage];

    UIImage *currentFilteredVideoFrame = [stillImageFilter imageFromCurrentFramebuffer];

    return currentFilteredVideoFrame;
}

- (UIImage *)getPixelated:(UIImage*)inputImage {

    if(!inputImage)
        return nil;

    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
    GPUImagePixellateFilter *stillImageFilter = [[GPUImagePixellateFilter alloc] init];

    //stillImageFilter.blurPasses = 1;
    //stillImageFilter.blurRadiusInPixels = 8;


    [stillImageSource addTarget:stillImageFilter];
    [stillImageFilter useNextFrameForImageCapture];
    [stillImageSource processImage];

    UIImage *currentFilteredVideoFrame = [stillImageFilter imageFromCurrentFramebuffer];

    return currentFilteredVideoFrame;
}


- (UIImage *)getBluredImage:(UIImage*)inputImage {

    if(!inputImage)
        return nil;

    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
    GPUImageSepiaFilter *stillImageFilter = [[GPUImageSepiaFilter alloc] init];

    [stillImageSource addTarget:stillImageFilter];
    [stillImageFilter useNextFrameForImageCapture];
    [stillImageSource processImage];

    UIImage *currentFilteredVideoFrame = [stillImageFilter imageFromCurrentFramebuffer];

    return currentFilteredVideoFrame;
}


-(UIImage *) generateQRCodeWithString:(NSString *)string scale:(CGFloat) scale{

    //NSString *qrString = @"http://itunes.apple.com/app/id359807331"; //appsto.re/passwordgrid
    //qrImage = [self generateQRCodeWithString:qrString scale:1.0f];

    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding ];

    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:stringData forKey:@"inputMessage"];
    [filter setValue:@"M" forKey:@"inputCorrectionLevel"];

    // Render the image into a CoreGraphics image
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:[filter outputImage] fromRect:[[filter outputImage] extent]];

    //Scale the image usign CoreGraphics
    UIGraphicsBeginImageContext(CGSizeMake([[filter outputImage] extent].size.width * scale, [filter outputImage].extent.size.width * scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *preImage = UIGraphicsGetImageFromCurrentImageContext();

    //Cleaning up .
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);

    // Rotate the image
    UIImage *qrImage2 = [UIImage imageWithCGImage:[preImage CGImage]
                                            scale:[preImage scale]
                                      orientation:UIImageOrientationDownMirrored];
    return qrImage2;
}

/*-(void)debugLog:(NSString*)format, ... {
    va_list args, args_copy;
    va_start(args, format);
    va_copy(args_copy, args);
    va_end(args);

    NSString *logString = [[NSString alloc] initWithFormat:format
                                                 arguments:args_copy];
    // Append logString to your logger

    va_end(args_copy);
    //[logString release];
}*/


#if 0
-(void)validateReceiptAtURL:(NSURL*)url {
    BIO *b_receipt;
    BIO *b_x509;

    // Convert receipt data to PKCS #7 Representation
    PKCS7 *p7 = d2i_PKCS7_bio(b_receipt, NULL);
    // Create the certificate store
    X509_STORE *store = X509_STORE_new();
    X509 *appleRootCA = d2i_X509_bio(b_x509, NULL);
    X509_STORE_add_cert(store, appleRootCA);
    // Verify the Signature
    BIO *b_receiptPayload;
    int result = PKCS7_verify(p7, NULL, store, NULL, b_receiptPayload, 0);
    if (result == 1)
    {
        Log(@"valid");
        // Receipt Signature is VALID
        // b_receiptPayload contains the payload
    }
}
#endif

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;

    NSCalendar *calendar = [NSCalendar currentCalendar];

    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];

    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];

    return [difference day];
}

#if 0
- (BOOL)iOS11Available //iOS11EstDisponible
{
	//version runtime
	NSProcessInfo* pi = [NSProcessInfo processInfo];
	NSOperatingSystemVersion version = {11, 0, 0};
	BOOL estiOS11 = [pi respondsToSelector:@selector(isOperatingSystemAtLeastVersion:)] && [pi isOperatingSystemAtLeastVersion:version];


	//version iOS SDK
	//iOS11b4, xcode8.3: "14E8301"
	//iOS11b2 xcode9.0b?: "15A5304i"
	//iOS11b4 xcode9.0b4: "15A5327g"

	//https://stackoverflow.com/a/25540764/4067265
	BOOL ios11SDK = 	[[[NSBundle mainBundle] infoDictionary][@"DTSDKBuild"] compare:@"15A5304i"] == NSOrderedDescending;

	//doit avoir les deux
	retourn (estiOS11 ET ios11SDK);
}
#endif

@end
