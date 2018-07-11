#import "NSDate+Utilities2.h"
            
@implementation NSDate (Utilities2)

- (NSString*)shortDateString {

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setDateFormat:@"MMM. d"];
        NSString *dateString = [dateFormatter stringFromDate:self];
    
        return dateString;
}

@end
