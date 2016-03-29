
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

    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [self.progressView setHidden:true];
    [self addSubview:self.progressView];
}

- (id) initWithFrame:(CGRect)frame {
    // used in collection view
    if ([super initWithFrame:frame]) {
        self.progressStyle = ImageViewProgressStyleDefinite;
        [self setupActivityIndicator];
        return self;
    }
    return nil;
}

- (void) awakeFromNib {
    // used for main image
    self.progressStyle = ImageViewProgressStyleIndefinite;
    [self setupActivityIndicator];
}

- (void) onFinish:(UIImage*)_resultImage {
    self.image = _resultImage;
    if (self.progressStyle == ImageViewProgressStyleIndefinite) {
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setHidden:true];
    } else {
        self.progressView.progress = 1.f;
        [self.progressView setHidden:true];
    }
}

- (void) onStart {
    if (self.progressStyle == ImageViewProgressStyleIndefinite) {
        [self.activityIndicator startAnimating];
        [self.activityIndicator setHidden:false];
    } else {
        [self.progressView setHidden:false];
        self.progressView.progress = .0f;
    }
}

- (void)update:(float)_progress {
    [self.progressView setProgress:_progress];
}

@end
