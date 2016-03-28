
#import "ImageViewWithProgress.h"

@implementation ImageViewWithProgress

- (void) updateObservable:(id<Observable>) observable {
    [self.observable unregisterObserver:self];
    self.observable = observable;
    [self.observable registerObserver:self];
}

- (id) initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        _m_pProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        [self addSubview:_m_pProgressView];
        [_m_pProgressView setHidden:true];
        return self;
    }
    return nil;
}

- (void) awakeFromNib {
    BOOL called = NO;
    if(!called)
    {
        called = YES;
        _m_pProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        [self addSubview:_m_pProgressView];
        [_m_pProgressView setHidden:true];
    }
}

- (void) onFinish:(UIImage*)_resultImage {
    self.image = _resultImage;
    [_m_pProgressView setHidden:true];
    [_m_pProgressView setProgress:.0];
}

- (void) onStart {
    [_m_pProgressView setHidden:false];
    [_m_pProgressView setProgress:.0];
}

- (void)update:(int)_progress {
    [_m_pProgressView setProgress:_progress/10.];
}

@end
