//
//  Helpers.h
//  CoinBlock
//
//  Created by Skyriser Media on 2014-04-17.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.

#import <Foundation/Foundation.h>
//#import <FacebookSDK/FacebookSDK.h>
//#import <MessageUI/MessageUI.h>
//#import <MessageUI/MFMailComposeViewController.h>
#import <MapKit/MapKit.h>
#import "Config.h"

//singleton
#define kHelpers [Helpers instance]

#ifdef DEBUG
    //#define Log(fmt, ...) ; //disabled
    #define Log(fmt, ...) NSLog(fmt, ##__VA_ARGS__) //normal
#else
    #define Log(fmt, ...) ; //disabled
#endif

/*
 #ifdef DEBUG
 #   define NSLog(...) NSLog(__VA_ARGS__)
 #else
 #   define NSLog(...) (void)0
 #endif

 */

extern BOOL debugCheat;

//#define Log(fmt, ...) [kHelpers debuglog}

//System Versioning Preprocessor Macros
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//https://stackoverflow.com/questions/39564510/check-if-device-supports-uifeedbackgenerator-in-ios-10
#define kHapticFeedbackLevel [[UIDevice currentDevice] valueForKey:@"_feedbackSupportLevel"];
/*
 ... These methods seem to return:

 0 = Taptic not available
 1 = First generation (tested on an iPhone 6s) ... which does NOT support UINotificationFeedbackGenerator, etc.
 2 = Second generation (tested on an iPhone 7) ... which does support it.

*/

#define kIsIOS7 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")
#define kIsIOS7_1 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.1")
#define kIsIOS8 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")
#define kIsIOS9 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9")
#define kIsIOS932 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.3.2")
#define kIsIOS10 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")
#define kIsIOS10_2 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.2")
#define kIsIOS10_3 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.3")
#define kIsIOS11_0 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")

#define kAppDelegate ((CBAppDelegate *)[[UIApplication sharedApplication] delegate])

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_SIZE_MAX (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#define kBackgroundQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//#define kBlockAfterDelayCurrent(dly, block)     dispatch_after(dispatch_time(DISPATCH_TIME_NOW,dly*100000),dispatch_get_current_queue(), ^{ block })

//math
#define DBL_EPSILON2 0.00000001f
#define HAS_DECIMALS(x) (x != (int)x)

//color
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

//strings
#define LOCALIZED(x) NSLocalizedString((x), nil)

//log
#define LogRect(RECT) Log(@"%s: (%0.0f, %0.0f) %0.0f x %0.0f", #RECT, RECT.origin.x, RECT.origin.y, RECT.size.width, RECT.size.height)

//rect
#define CGRectSetPos( r, x, y ) CGRectMake( x, y, r.size.width, r.size.height )


//cleanup
//find . -type d -name '.svn' -print0 | xargs -0 rm -rdf
//find . -type d -name '.git' -print0 | xargs -0 rm -rdf
//find . -name ".DS_Store" -depth -exec rm {} \;

@interface Helpers : NSObject

+(id)instance;

//UI
-(void) textFieldOffset:(UITextField*)textField withWidth:(int)paddingWidth;
-(void) textFieldChangePlaceholderColor:(UITextField*)textField withColor:(UIColor*)newColor;
-(BOOL) isIphone5Size;
-(BOOL) isIphone4Size;
-(BOOL) isIpad2;
-(BOOL) isIphone4;
-(BOOL) isIphone4s;
-(BOOL) isSlowDevice;
-(BOOL) isLowPowerMode;
-(BOOL) isSimulator;
-(BOOL) isDebug;
-(BOOL) canParallax;
-(BOOL) isForeground;
-(BOOL) isBackground;
-(void) loopInBackground;
-(BOOL) canMakePayments;
-(BOOL) isMonday;
-(BOOL) isFriday;
-(BOOL) isSaturday;
-(BOOL) isNight;
-(BOOL) isMorning;

//- (BOOL)isAlertVisible;
- (NSString *) platform;
- (NSString *) platformString;
- (NSString*) getVersionString;
- (NSString*) getVersionString2;
-(void)listFonts;
-(void)listFilters;
-(UIButton*)getLogo;

//analytics
-(void) setupGoogleAnalyticsForView:(NSString*)viewName;
-(void) sendGoogleAnalyticsEventWithView:(NSString*)viewName andEvent:(NSString*)eventName;
-(void) sendGoogleAnalyticsEventWithCategory:(NSString*)category andAction:(NSString*)action andLabel:(NSString*)label;

//alerts
-(void) showAlertWithTitle:(NSString*)title andMessage:(NSString*)message;
-(void) showAlertWithTitleNoButton:(NSString*)title andMessage:(NSString*)message;
-(void) showErrorHud:(NSString*)error;
-(void) setupHud;
-(void) dismissHud;
-(void) showSuccessHud:(NSString*)message;
-(void) showMessageHud:(NSString*)message;
-(void) showMessageHud:(NSString*)message blockUI:(BOOL)blockUI;

//validate
-(BOOL) validateURL:(NSString*)url;
-(BOOL) validateEmail:(NSString*)email;
-(BOOL) validateUsername:(NSString*)username;
-(BOOL) validatePassword:(NSString*)password showError:(BOOL)showError;
-(BOOL) validateFullName:(NSString*)username;

//system
-(BOOL) isIpad;
-(BOOL) isIphone;
-(BOOL) isIphoneX;
-(UIEdgeInsets)safeAreaInsets;
-(BOOL) isIpadBig;
-(BOOL) isIpadMini;
-(BOOL) checkOnline;
-(BOOL) isWifi;
- (BOOL)isRetina;
- (CGRect) getScreenRect;
- (BOOL)isLocationAvailable;

//files
-(void)saveImage:(UIImage *)image withName:(NSString *)name;
-(UIImage *)loadImage:(NSString *)name;
- (void) emptyFileCache;

//image
-(UIImage*)colorizeImage:(UIImage*)inputImage color:(UIColor*)inputColor;
-(UIImage*)imageWithImage:(UIImage*)source rotatedByHue:(CGFloat)deltaHueRadians;
-(UIImage*)imageWithAlpha:(UIImage*)source alpha:(CGFloat)alpha;
-(UIImage*)imageWithColor:(UIColor *)color andSize:(CGSize)size;
-(UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withImage:(UIImage*)sourceImage withCenter:(BOOL)center;
-(UIImage*)imageByScalingForSize:(CGSize)targetSize withImage:(UIImage*)sourceImage;
//-(UIImage*)imageByScalingForParallax:(UIImage*)sourceImage;
//-(CGSize)parallaxSize:(CGSize)size;
-(UIImage*)imageWithImage: (UIImage*)sourceImage scaleToWidth:(float)inWidth resizeIfSmaller:(BOOL)resize;
-(UIImage *) imageWithView:(UIView *)view;
- (UIImage*)circularScaleAndCropImage:(UIImage*)image frame:(CGRect)frame;
- (UIImage*)imageWithBorderFromImage:(UIImage*)source;

- (UIImage *)getSepiaImage:(UIImage*)inputImage;
- (UIImage *)getGrayImage:(UIImage*)inputImage;
- (UIImage *)getBlackImage:(UIImage*)inputImage;
- (UIImage *)getBlurredImage:(UIImage*)inputImage;
- (UIImage *)getPixelated:(UIImage*)inputImage;
- (UIImage *)filledImageFrom:(UIImage *)source withColor:(UIColor *)color;

-(UIImage *) generateQRCodeWithString:(NSString *)string scale:(CGFloat) scale;

- (UIImage *)takeScreenshot:(UIView*)view;
- (void)saveScreenshot;

//location
-(float) getLatitude;
-(float) getLongitude;
-(void) startUpdatingLocation;
- (void)zoomMapViewToFitAnnotations:(MKMapView *)mapViewParam animated:(BOOL)animated;

//location, corners
-(NSArray *)getBoundingBox:(MKMapRect)mRect;
-(CLLocationCoordinate2D)getCoordinateFromMapRectanglePoint:(double)x y:(double)y;
-(CLLocationCoordinate2D)getNECoordinate:(MKMapRect)mRect;
-(CLLocationCoordinate2D)getNWCoordinate:(MKMapRect)mRect;
-(CLLocationCoordinate2D)getSECoordinate:(MKMapRect)mRect;
-(CLLocationCoordinate2D)getSWCoordinate:(MKMapRect)mRect;

//strings
-(NSString*) cleanupErrorString:(NSString*)string;
-(NSString*) stripHTML:(NSString*)string;
-(NSString*) randomString;
-(NSString*) randomString:(int)len;
-(NSString*) unixTimestamp:(NSDate*)date;
-(NSString*) addRandomParameterToUrl:(NSString*)url;
-(NSString*) addTimestampParameterToUrl:(NSString*)url withDate:(NSDate*)date;
-(NSString*) colorString:(NSString*)string;
-(void)textToClipboard:(NSString*)string;
-(NSString*)textFromClipboard;

//date
- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;

//math
-(double)randomFloatBetween:(double)smallNumber andBig:(double)bigNumber;

-(BOOL)doublesEqual:(double)first second:(double)second;
-(float)clamp:(float)value min:(float)min max:(float)max;

//date
-(NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

//random
-(BOOL) randomInt:(int)max;
-(BOOL) randomBool;
-(BOOL) randomBool100:(int)percentage;
-(BOOL) randomBool1000:(int)percentage;

//audio
-(void)vibrate;
-(void)playSoundCaf:(NSString*)name;
- (BOOL)isAirPlayActive;
//-(void)debugLog:(NSString*)format, ...;
//-(void)validateReceiptAtURL:(NSURL*)url;
-(BOOL)isOtherAudioPlaying;

-(void)haptic1;
-(void)haptic2;

@end
