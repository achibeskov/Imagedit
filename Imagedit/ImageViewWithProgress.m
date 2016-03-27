//
//  ImageViewWithProgress.m
//  Imagedit
//
//  Created by archi on 3/21/16.
//
//

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
        
//        UITapGestureRecognizer *newTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myTapMethod)];
//        
//        [self setUserInteractionEnabled:YES];
//        [self addGestureRecognizer:newTap];
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

//        UITapGestureRecognizer *newTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myTapMethod)];
//
//        [self setUserInteractionEnabled:YES];
//        [self addGestureRecognizer:newTap];
    }
}

-(void) myTapMethod {
    NSLog(@"myTapMethod");
    // treat image tap
}

- (void) onFinish:(UIImage*)_resultImage {
//    NSLog(@"onFinish %@", _resultImage);
//    NSLog(@"onFinish %@", [NSThread currentThread]);
    self.image = _resultImage;
    [_m_pProgressView setHidden:true];
    [_m_pProgressView setProgress:.0];
}

- (void) onStart {
//    NSLog(@"onStart");
//    NSLog(@"onStart %@", [NSThread currentThread]);
    [_m_pProgressView setHidden:false];
    [_m_pProgressView setProgress:.0];
}

- (void)update:(int)_progress {
//    NSLog(@"update %d", _progress);
//    NSLog(@"update %@", [NSThread currentThread]);
    [_m_pProgressView setProgress:_progress/10.];
}

@end
