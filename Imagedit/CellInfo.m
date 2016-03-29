
#import "CellInfo.h"

@interface CellInfo ()

@property (nullable, weak, atomic) id<ImageOperationProgress> observer;

@end

@implementation CellInfo

- (id)init {
    if (self = [super init]) {
        self.state = ImageProcessStateDefault;
        return self;
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
    if (self.state == ImageProcessStateInProgress) {
        [self.observer onStart];
        [self.observer update:self.progress];
    } else if (self.state == ImageProcessStateReady)
        [self.observer onFinish:self.image];
}

- (void) update:(float)progress {
    [self.observer update:progress];
    self.progress = progress;
}

- (void) onFinish:(UIImage*)resultImage {
    self.image = resultImage;
    self.progress = 1.f;
    self.state = ImageProcessStateReady;
    [self.observer onFinish:resultImage];
}

- (void) onStart {
    self.image = nil;
    self.progress = .0f;
    self.state = ImageProcessStateInProgress;
    [self.observer onStart];
}

@end
