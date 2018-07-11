//
//  WelcomeViewController.h

#import <UIKit/UIKit.h>
#import "MHPagingScrollView.h"


#define STR_WELCOME_BUTTON_1 @"Skip intro"
#define STR_WELCOME_BUTTON_2 @"Get started!"
//#define STR_WELCOME_BUTTON_3 @"Done"
#define STR_WELCOME_BUTTON_3 @"Got it!"

enum {
    //welcomeViewNone = 0,
    welcomeViewState1 = 1,
    welcomeViewState2 = 2,
    welcomeViewState3 = 3,
    welcomeViewState4 = 4
    
};

@interface WelcomeViewController : UIViewController <MHPagingScrollViewDelegate, UIScrollViewDelegate>
{
    id appDelegate;
    int currentState;
    BOOL    isDone;
    
    UIButton *buttonTest;
    UIButton *buttonSkip;
    UILabel     *labelSkip;
    UILabel     *labelTitle;
    UIImageView *mainImage;
    UIImageView *navImage;
    
    int numPages;

}

@property(nonatomic,retain)  IBOutlet UIButton *buttonTest;
@property(nonatomic,retain)  IBOutlet UIButton *buttonSkip;
@property(nonatomic,retain)  IBOutlet UILabel *labelSkip;
@property(nonatomic,retain)  IBOutlet UILabel *labelTitle;


@property(nonatomic,retain)  IBOutlet UIImageView *mainImage;
@property(nonatomic,retain)  IBOutlet UIImageView *navImage;
@property(nonatomic, assign) BOOL isDone;

@property (nonatomic, retain) IBOutlet MHPagingScrollView *pagingScrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;

- (IBAction)pageTurn;

- (void)reset;
- (void)show1;
- (void)show2;
- (void)show3;
- (void)show4;
- (void)hide;


@end


