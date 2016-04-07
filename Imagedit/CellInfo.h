
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ImageOperation.h"

@protocol Observable <NSObject>

- (void) registerObserver:(id<ImageOperationProgress>)observer;
- (void) unregisterObserver;
- (void) notifyObserver;

@end

@interface CellInfo : NSObject <ImageOperationProgress, Observable>

@property (atomic, strong) UIImage * pimage;
@property (atomic) ImageProcessState state;
@property (atomic) float progress;

@end
