
#import "ImageProcessor.h"
#import "ImageOperation.h"
#import <UIKit/UIKit.h>

@implementation ImageProcessor

- (id)initWithOperation:(id<ImageOperation>)imageOperation operationProgress:(id<ImageOperationProgress>)imageOperationProgress {
    self = [super init];
    if (self) {
        _imageOperation = imageOperation;
        _imageOperationProgress = imageOperationProgress;
    }
    return self;
}

- (void) main {
    [self.imageOperationProgress onStart];

    UIImage * image = [self.imageOperation getImageWithProgress:self.imageOperationProgress];

    [self.imageOperationProgress onFinish:image];
}

@end
