
#import <UIKit/UIKit.h>
#import "ImageOperation.h"
#import "CellInfo.h"

@interface ImageViewWithProgress : UIImageView<ImageOperationProgress>

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end
