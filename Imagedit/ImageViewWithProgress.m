//
//  ImageViewWithProgress.m
//  Imagedit
//
//  Created by archi on 3/21/16.
//
//

#import "ImageViewWithProgress.h"

@implementation ImageViewWithProgress

- (id)init {
    if (self = [super init]) {
        self.m_pProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        [self addSubview:self.m_pProgressView];
        [self.m_pProgressView setHidden:false];
        [self.m_pProgressView setProgress:0.5];
    }
    return self;
}

- (void)updateProgress:(int)_nProgress {
    if (_nProgress < 10)
        [self.m_pProgressView setHidden:false];
    [self.m_pProgressView setProgress:_nProgress/10];
}

@end
