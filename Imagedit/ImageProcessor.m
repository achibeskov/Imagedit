//
//  ImageProcessor.m
//  Imagedit
//
//  Created by archi on 3/26/16.
//
//

#import "ImageProcessor.h"
#import "ImageOperation.h"
#import <UIKit/UIKit.h>

@implementation ImageProcessor

- (id)initWithOperation:(id<ImageOperation>)_pImageOperation operationProgress:(id<ImageOperationProgress>)_pImageOperationProgress {
    if (self = [super init]) {
        _m_pImageOperation = _pImageOperation;
        _m_pImageOperationProgress = _pImageOperationProgress;
    }
    return self;
}

- (void) main {
    NSLog(@"main2 %@", _m_pImageOperation);
    NSLog(@"main3 %@", _m_pImageOperationProgress);
    NSLog(@"main4 %@", [NSThread currentThread]);

    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
         [_m_pImageOperationProgress onStart];
    }];

    UIImage * image = [self.m_pImageOperation getImageWithProgress:_m_pImageOperationProgress];

    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
         [_m_pImageOperationProgress onFinish:image];
    }];

}

@end
