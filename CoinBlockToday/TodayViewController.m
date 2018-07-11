//
//  TodayViewController.m
//  CoinBlockToday
//
//  Created by Chris Comeau on 2014-11-28.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

//#import "Helpers.h"
//#import "Config.h"
#import "TodayConfig.h"
#import "NSDate-Utilities.h"

//color
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface TodayViewController () <NCWidgetProviding>

@property (weak, nonatomic) IBOutlet UIImageView *blockImage;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
//@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UIButton *buttonPlay;
@property (weak, nonatomic) IBOutlet UIButton *buttonCell;

- (IBAction)actionButton:(id)sender;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.preferredContentSize = CGSizeMake(0, 100);

    /*self.label1.textColor = [UIColor whiteColor];
    self.label2.textColor = RGB(187,187,187);
    self.label2.font = [UIFont systemFontOfSize:16]; //coins
    self.label1.font = [UIFont systemFontOfSize:17]; //level*/
    
    //transparent?
    /*UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect notificationCenterVibrancyEffect]];
    effectView.frame = self.view.bounds;
    effectView.autoresizingMask = self.view.autoresizingMask;
    __strong UIView *oldView = self.view;
    self.view = effectView;
    [effectView.contentView addSubview:oldView];
    self.view.tintColor = [UIColor clearColor];
     */
    
    //UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];


    //self.buttonPlay.titleLabel.font = [UIFont systemFontOfSize:18];
    
    //cell
    self.buttonCell.hidden = NO;
    
    self.label1.text = @"";
    self.label2.text = @"";
    //self.label3.text = @"";

    //color
    [self.buttonPlay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.buttonPlay.layer.cornerRadius = 8;
    self.buttonPlay.layer.borderColor=  [UIColor whiteColor].CGColor;
    self.buttonPlay.layer.borderWidth= 2.0f;
    self.buttonPlay.alpha = 1.0f;
    

    [self updateUI];
}

//disable margins
-(UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMargrginInsets {
    return UIEdgeInsetsZero;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateUI];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    
    [self updateUI];
    

    completionHandler(NCUpdateResultNewData);
}


- (void) updateUI {
    
    Log(@"today: updateUI");

    //UIColor *yellowColor =  [UIColor colorWithRed:247/255.0f green:216/255.0f blue:1/255.0f alpha:1.0f];
    //UIColor *yellowColor =  [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];


    
    //NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"group.skyriser.coinblock"];

    int clickCount = [[prefs objectForKey:@"clickCount"] intValue];
    Log(@"today: clickcount: %d",  clickCount);
    
    int level = [[prefs objectForKey:@"level"] intValue];
    Log(@"today: level: %d",  level);
    
    int subLevel = [[prefs objectForKey:@"subLevel"] intValue];
    Log(@"today: _subLevel: %d",  level);
    
    //sanitize
    if(level < 1)
        level = 1;
    if(subLevel < 1)
        subLevel = 1;
    
    /*
    NSDate *dateReset = [prefs objectForKey:@"dateReset"];
    if([dateReset isKindOfClass:[NSNull class]])
        dateReset = nil;
    
    //Log(@"today: dateReset: %@",  dateReset);

    int sinceLast = clickCount - [self get1upNumLast];
    int total =  [self get1upNum] - [self get1upNumLast];
    float percent = (sinceLast / (float)total);
    
    if(percent < 0) {
        percent = 0;
    }
    else if (percent > 1.0f) {
        percent = 1.0f;
    }
    
    int subLevelMax = 4;
    int subLevel = 1 + floor(percent * subLevelMax);
    */
    
    self.label1.text = [NSString stringWithFormat:@"World %d-%d", level, subLevel];

    
    //total
    //self.label2.text = [NSString stringWithFormat:@"%d coins", clickCount];
    
    
    NSNumber *count = @(floor(clickCount));
    NSString *countString = [NSString localizedStringWithFormat:@"%@", count];
    self.label2.text = [NSString stringWithFormat:@"%@ coins", countString];
    
    //progress
    //self.label2.text = [NSString stringWithFormat:@"Coins %d/%d", sinceLast, total];

    
    //disabled
    /*if(NO && dateReset && ![dateReset isInPast]) {
        
        NSTimeInterval interval = [dateReset timeIntervalSinceNow];
        interval = abs(interval);
        NSString *timeString = [self stringFromTimeInterval:interval];
        
        Log(@"timeString: %@", timeString);

        self.label3.text = timeString;
        self.label3.textColor = [UIColor redColor];
        self.label3.font = [UIFont boldSystemFontOfSize:16];
        
    } else*/
    /*{
        
        self.label3.text = [NSString stringWithFormat:@"Coins are ready!"];
        //self.label3.textColor = [UIColor greenColor];
        self.label3.textColor = yellowColor;
        self.label3.font = [UIFont boldSystemFontOfSize:16];
        self.label3.hidden = YES; //disabled

    }*/

    

    
    //[self.blockImage setImage:[UIImage imageNamed:[CBSkinManager getBlockImageName]]];
    [self.blockImage setImage:[CBSkinManager getBlockImage]];

}

-(int)get1upNumLast{
    
    NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"group.skyriser.coinblock"];
    int level = [[prefs objectForKey:@"level"] intValue] - 1;
    
    int tempNum = (int)((kNum1up * level) * pow(k1upMult, level));
    
    return (tempNum);
}

-(int)get1upNum{
    
    NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"group.skyriser.coinblock"];
    int level = [[prefs objectForKey:@"level"] intValue];
    
    int tempNum = (int)((kNum1up * level) * pow(k1upMult, level));
    return (tempNum);
}


- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    //NSInteger hours = (ti / 3600);
    
    NSString *format = [NSString stringWithFormat:@"%d minutes %d seconds", (int)minutes, (int)seconds];
    
    return format;
}

- (void) actionButton:(id)sender {

    self.buttonPlay.alpha = 0.5f;

    //delay
    float secs = 0.3f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSURL *url = [NSURL URLWithString:@"coinblock://"];
        [self.extensionContext openURL:url completionHandler:nil];
    });
    
    //reset
    secs = 0.4f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.buttonPlay.alpha = 1.0f;
    });
}

-(UIImage*)getBlockImage {
    
    UIImage *image = nil;
    
    //disabled
    if([kHelpers isDebug])
        assert(0);
    return nil;
    
    //image = [UIImage imageNamed:@"block5Frame1"];
    //return image;
    
    NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"group.skyriser.coinblock"];

    NSData* imageData = [prefs objectForKey:@"currentSkinImage"];
    image = [UIImage imageWithData:imageData];

    if(!image) {
        //image = [UIImage imageNamed:[CBSkinManager getBlockImageName]];
        
        //default
        image = [UIImage imageNamed:@"block5Frame1"];
    }
    
    //assert(image);

    return image;
}

-(NSString*)getBlockImageName {
    
    //getBlockImageNameIndex
    
    NSString *name = nil;
    
    NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"group.skyriser.coinblock"];
    int index = [[prefs objectForKey:@"currentSkin"] intValue];

    if(index == kCoinTypeDefault) {
        name = @"block5Frame1";
    }
    
    else if(index == kCoinTypeFlat) {
        name = @"block6Frame1";
    }
    else if(index == kCoinTypeMega) {
        name = @"block7Frame1";
    }
    
    else if(index == kCoinTypeMine) {
        name = @"block8Frame1";
    }
    
    else if(index == kCoinTypeMetal) {
        name = @"block8Frame1";
    }
    
    else if(index == kCoinTypeYoshi) {
        name = @"block9Frame1";
    }
    
    else if(index == kCoinTypeSonic ) {
        name = @"block10Frame1";
    }
    
    else if(index == kCoinTypePew) {
        name = @"block11Frame1";
    }
    
    else if(index == kCoinTypeZelda) {
        name = @"block13Frame1";
    }
    
    else if(index == kCoinTypeBitcoin) {
        name = @"block14Frame1";
    }
    else if(index == kCoinTypeMac) {
        name = @"block15Frame1";
    }
    
    else if(index == kCoinTypeFlap) {
        name = @"block12Frame1";
    }
    
    else if(index == kCoinTypeMario) {
        name = @"block4Frame1";
    }
    
    else if(index == kCoinTypeGameboy) {
        name = @"block16Frame1";
    }
    
    else if(index == kCoinTypeZoella) {
        name = @"block17Frame1";
    }
    
    else if(index == kCoinTypeMontreal) {
        name = @"block18Frame1";
    }
    else if(index == kCoinTypeTA) {
        name = @"block19Frame1";
    }
    else if(index == kCoinTypeNyan) {
        name = @"block20Frame1";
    }
    else if(index == kCoinTypeEmoji) {
        name = @"block21Frame1";
    }
    

    
    else {
        //default
        Log(@"getLockImageName: default");
        name = @"block5Frame1";
    }

    //assert(name);
    return name;
}

@end
