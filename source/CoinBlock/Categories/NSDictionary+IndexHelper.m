
#import "NSDictionary+IndexHelper.h"

@implementation NSDictionary (IndexHelper)
-(id) safeObjectForKey:(NSString*)key {
   
    return [self objectForKey:key];

//    if (index>=self.count) {
//        return nil;
//    }
//    return [self objectAtIndex:index];
}
@end
