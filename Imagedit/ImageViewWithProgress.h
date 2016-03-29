
#import <UIKit/UIKit.h>
#import "ImageOperation.h"
#import "CellInfo.h"

typedef NS_ENUM(NSInteger, ImageViewProgressStyle) {
    ImageViewProgressStyleIndefinite = 0,
    ImageViewProgressStyleDefinite
};

@interface ImageViewWithProgress : UIImageView<ImageOperationProgress>

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIProgressView *progressView;
@property ImageViewProgressStyle progressStyle;

@end
