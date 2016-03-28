
#import <UIKit/UIKit.h>
#import "ImageOperation.h"
#import "CellInfo.h"

@interface ImageViewWithProgress : UIImageView<ImageOperationProgress>

- (void) updateObservable:(id<Observable>) observable;

@property (nonatomic, strong) UIProgressView *m_pProgressView;
@property (nonatomic, strong) id<Observable> observable;

@end
