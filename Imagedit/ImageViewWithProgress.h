//
//  ImageViewWithProgress.h
//  Imagedit
//
//  Created by archi on 3/21/16.
//
//

#import <UIKit/UIKit.h>

@class Operation;

@interface ImageViewWithProgress : UIImageView

- (void)updateProgress:(int)_nProgress;
    
@property (nonatomic) UIProgressView *m_pProgressView;

@end
