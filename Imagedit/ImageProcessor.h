//
//  ImageProcessor.h
//  Imagedit
//
//  Created by archi on 3/26/16.
//
//

#import <Foundation/Foundation.h>
#import "ImageOperation.h"

@class UIImage;

@interface ImageProcessor : NSOperation

@property (strong) id<ImageOperation> m_pImageOperation;
@property (strong) id<ImageOperationProgress> m_pImageOperationProgress;

- (id)initWithOperation:(id<ImageOperation>)_pImageOperation operationProgress:(id<ImageOperationProgress>)_pImageOperationProgress;

@end
