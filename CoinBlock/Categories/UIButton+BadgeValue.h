#import <UIKit/UIKit.h>

@interface UIButton (BadgeValue)

- (void)setBadgeValue:(NSString *)value;
- (void)setBadgeValue:(NSString *)value withOffsetY:(int)offsetY;
- (void)setBadgeValue:(NSString *)value withOffsetX:(int)offsetX withOffsetY:(int)offsetY;

@end
