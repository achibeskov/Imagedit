
#import "CellInfo.h"

@interface CellInfo ()

@property (nullable, weak) id<ImageOperationProgress> observer;

@end

@implementation CellInfo

- (void) registerObserver:(id<ImageOperationProgress>)observer {
    self.observer = observer;
}

- (void) unregisterObserver:(id<ImageOperationProgress>)observer {
    self.observer = nil;
}

- (void) update:(int)progress {
    [self.observer update:progress];
    self.progress = progress;
}

- (void) onFinish:(UIImage*)resultImage {
    [self.observer onFinish:resultImage];
    self.image = resultImage;
    self.progress = 10;
}

- (void) onStart {
    [self.observer onStart];
    self.image = nil;
    self.progress = 0;
}

@end
