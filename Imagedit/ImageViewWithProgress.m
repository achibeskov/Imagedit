
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
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicator.center = self.center;
    [_activityIndicator setHidden:true];
    [self addSubview:_activityIndicator];

    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [_progressView setHidden:true];
    [self addSubview:_progressView];
}

- (void) awakeFromNib {
    self.progressStyle = ImageViewProgressStyleDefinite;
    self.contentMode = UIViewContentModeScaleAspectFit;
    [self setupActivityIndicator];
}

- (void) onFinish:(UIImage*)resultImage {
    self.image = resultImage;
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

- (void)update:(float)progress {
    [self.progressView setProgress:progress];
}

@end
