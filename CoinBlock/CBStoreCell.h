//
//  CBStoreCell.h
//

#import <UIKit/UIKit.h>

@interface CBStoreCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *desc;
@property (strong, nonatomic) IBOutlet UILabel *desc2;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UIImageView *imageCheck;
@property (strong, nonatomic) IBOutlet UIImageView *block;
@property (strong, nonatomic) IBOutlet UIButton *restoreButton;
@property (strong, nonatomic) IBOutlet UIButton *skinsButton;
@end
