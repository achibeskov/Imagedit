
#import "ImageViewWithProgress.h"

@interface ImageViewWithProgress()

@property (nonatomic, strong) id<Observable> observable;

@end

@implementation ImageViewWithProgress

- (void) updateObservable:(id<Observable>)observable {
    [self.observable unregisterObserver];
    self.observable = observable;
    [self.observable registerObserver:self];
}

- (void) setupActivityIndicator {
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.center;
    [self.activityIndicator setHidden:true];
    [self addSubview:self.activityIndicator];
}

- (id) initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self setupActivityIndicator];
        return self;
    }
    return nil;
}

- (void) awakeFromNib {
    [self setupActivityIndicator];
}

- (void) onFinish:(UIImage*)_resultImage {
    self.image = _resultImage;
    [self.activityIndicator stopAnimating];
    [self.activityIndicator setHidden:true];
}

- (void) onStart {
    [self.activityIndicator startAnimating];
    [self.activityIndicator setHidden:false];
}

- (void)update:(int)_progress {
}

@end
