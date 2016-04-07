
#import <Foundation/Foundation.h>
#import "ImageOperation.h"

@interface ImageProcessor : NSOperation

@property (strong) id<ImageOperation> imageOperation;
@property (strong) id<ImageOperationProgress> imageOperationProgress;

- (id)initWithOperation:(id<ImageOperation>)imageOperation operationProgress:(id<ImageOperationProgress>)imageOperationProgress;

@end
