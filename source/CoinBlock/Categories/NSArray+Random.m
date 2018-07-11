
#import "NSArray+Random.h"
            
@implementation NSArray (Random)
- (id)randomObject
{
  id randomObject = [self count] ? self[arc4random_uniform((u_int32_t)[self count])] : nil;
  return randomObject;
}

@end