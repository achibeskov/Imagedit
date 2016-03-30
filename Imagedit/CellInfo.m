
#import "CellInfo.h"

@interface CellInfo ()

@property (nullable, weak) id<ImageOperationProgress> observer;

@end

@implementation CellInfo

- (id)init {
    self = [super init];
    if (self) {
        self.state = ImageProcessStateDefault;
    }
    return self;
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
    self.progress = progress;
    __weak CellInfo *weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        CellInfo *strongSelf = weakSelf;
        [strongSelf.observer update:progress];
    }];
}

- (void) onFinish:(UIImage*)resultImage {
    self.image = resultImage;
    self.progress = 1.f;
    self.state = ImageProcessStateReady;
    __weak CellInfo *weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        CellInfo *strongSelf = weakSelf;
        [strongSelf.observer onFinish:resultImage];
    }];
}

- (void) onStart {
    self.image = nil;
    self.progress = .0f;
    self.state = ImageProcessStateInProgress;
    __weak CellInfo *weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        CellInfo *strongSelf = weakSelf;
        [strongSelf.observer onStart];
    }];
}

@end
