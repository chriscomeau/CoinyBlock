#import "UIButton+BadgeValue.h"

@implementation UIButton (BadgeValue)

- (void)setBadgeValue:(NSString *)value {
    [self setBadgeValue:value withOffsetY:0];
}

- (void)setBadgeValue:(NSString *)value withOffsetY:(int)offsetY {
    [self setBadgeValue:value withOffsetX:0 withOffsetY:offsetY];
}

- (void)setBadgeValue:(NSString *)value withOffsetX:(int)offsetX withOffsetY:(int)offsetY
{
    int badgeTag = 7777;
    int badgeTag2 = 7778;
    int size = 20;

    UILabel *lb_badgeValue = (UILabel*)[self viewWithTag:badgeTag];
    UIImageView *badgeBg = (UIImageView*)[self viewWithTag:badgeTag2];

    //remove
    if(lb_badgeValue)
    {
        [lb_badgeValue removeFromSuperview];
        lb_badgeValue = nil;
    }
    if(badgeBg)
    {
        [badgeBg removeFromSuperview];
        badgeBg = nil;
    }
    
    if (value)
    {
        //force blank
        value = @"";
        
        if (!badgeBg) {
            badgeBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"badge2"]];
            badgeBg.frame = CGRectMake(self.frame.size.width - size/4 - offsetX, -size/2 - offsetY, size,size);
            badgeBg.tag = badgeTag2;
            [self addSubview:badgeBg];
        }
        
        if (!lb_badgeValue) {
            //CGRect tempRect = self.frame;
            
            /*
             int size = 20;
             lb_badgeValue = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - size/4, -size/2, size,size)];
             lb_badgeValue.textAlignment = NSTextAlignmentCenter;
             lb_badgeValue.textColor = [UIColor whiteColor];
             lb_badgeValue.backgroundColor = [UIColor redColor];
             lb_badgeValue.layer.masksToBounds = YES;
             lb_badgeValue.layer.cornerRadius = size/2.0f;
             lb_badgeValue.tag = badgeTag;
             [self addSubview:lb_badgeValue];
             */
            
            int offset = 2;
            lb_badgeValue = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                      self.frame.size.width - size/4 - offsetX,
                                                                      -size/2 - offset - offsetY,
                                                                      size, size)];
            lb_badgeValue.textAlignment = NSTextAlignmentCenter;
            lb_badgeValue.textColor = [UIColor whiteColor];
            lb_badgeValue.backgroundColor = [UIColor clearColor];
            lb_badgeValue.tag = badgeTag;
            [self addSubview:lb_badgeValue];
            
        }
        
        //animate
#if 1
        if(![kHelpers isSlowDevice])
        {

            CABasicAnimation *scale;
            scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            scale.fromValue = [NSNumber numberWithFloat:1.0f];
            scale.toValue = [NSNumber numberWithFloat:0.9f];
            scale.duration = 0.3f;
            scale.repeatCount = HUGE_VALF;
            scale.autoreverses = YES;

            if(badgeBg)
            {
                [badgeBg.layer removeAllAnimations];
                [badgeBg.layer addAnimation:scale forKey:@"scale"];
            }
            
            if(lb_badgeValue)
            {
                [lb_badgeValue.layer removeAllAnimations];
                [lb_badgeValue.layer addAnimation:scale forKey:@"scale"];
            }
        }
#endif

        NSInteger frontSize = 14;
        NSInteger length = [value length];
        switch (length) {
            case 1:
                frontSize = 14;
                break;
            case 2:
                frontSize = 12;
                break;
            case 3:
                frontSize = 8;
                break;
            default:
                frontSize = 10;
                break;
        }
        //lb_badgeValue.font = [UIFont systemFontOfSize:frontSize];
        
        float mult = 1.2f;
        lb_badgeValue.font = [UIFont fontWithName:kFontName size:frontSize * mult];
        
        lb_badgeValue.text = value;
    }
    else
    {
        if (lb_badgeValue) {
            [lb_badgeValue removeFromSuperview];
            lb_badgeValue = nil;
        }
        if (badgeBg) {
            [badgeBg removeFromSuperview];
            badgeBg = nil;
        }
    }
}

@end
