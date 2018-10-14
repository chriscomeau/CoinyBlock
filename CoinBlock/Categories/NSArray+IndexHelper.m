
#import "NSArray+IndexHelper.h"

@implementation NSArray (IndexHelper)
-(id) safeObjectAtIndex:(NSUInteger)index {
    if (index>=self.count) {
        return nil;
    }
    return [self objectAtIndex:index];
}
@end