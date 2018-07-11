
#import "WelcomePageView.h"

@implementation WelcomePageView

- (id)init
{
	if ((self = [super init]))
	{
        self.opaque = NO;
        self.hidden = NO;
 
	}
	return self;
}


- (void)setPageIndex:(int)newIndex
{
    switch(newIndex)
    {
        case 0:
            [self setImage:[UIImage imageNamed:@"welcome1"] ];
            self.hidden = NO;
            break;
            
        case 1:
            [self setImage:[UIImage imageNamed:@"welcome2"] ];
            self.hidden = NO;
            break;
            
        case 2:
            [self setImage:[UIImage imageNamed:@"welcome3"] ];
            self.hidden = NO;
            break;
            
        case 3:
            [self setImage:[UIImage imageNamed:@"welcome4"] ];
            self.hidden = NO;
            break;
        
        case 4:
            self.hidden = YES;
            break;
        
        
        default:
            break;
    }
    
    self.contentMode = UIViewContentModeCenter; //UIViewContentModeScaleAspectFit
                   
}

@end
