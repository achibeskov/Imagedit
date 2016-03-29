
#import "CellInfo.h"

@interface CellInfo ()

@property (nullable, weak, atomic) id<ImageOperationProgress> observer;

@end

@implementation CellInfo

- (id)init {
    if (self = [super init]) {
        self.state = ImageProcessStateDefault;
    }
    return nil;
}

- (void) registerObserver:(id<ImageOperationProgress>)observer {
    self.observer = observer;
}

- (void) unregisterObserver {
    self.observer = nil;
}

- (void) notifyObserver {
    if (self.state == ImageProcessStateInProgress)
        [self.observer onStart];
    else if (self.state == ImageProcessStateReady)
        [self.observer onFinish:self.image];
}

- (void) update:(int)progress {
    [self.observer update:progress];
}

- (void) onFinish:(UIImage*)resultImage {
    self.image = resultImage;
    self.state = ImageProcessStateReady;
    [self.observer onFinish:resultImage];
}

- (void) onStart {
    self.image = nil;
    self.state = ImageProcessStateInProgress;
    [self.observer onStart];
}

@end
