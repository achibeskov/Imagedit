
#import <Foundation/Foundation.h>
#import "ImageOperation.h"

@interface ImageProcessor : NSOperation

@property (strong) id<ImageOperation> m_pImageOperation;
@property (strong) id<ImageOperationProgress> m_pImageOperationProgress;

- (id)initWithOperation:(id<ImageOperation>)_pImageOperation operationProgress:(id<ImageOperationProgress>)_pImageOperationProgress;

@end
