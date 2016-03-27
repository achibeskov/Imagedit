//
//  ImageViewWithProgress.h
//  Imagedit
//
//  Created by archi on 3/21/16.
//
//

#import <UIKit/UIKit.h>
#import "ImageOperation.h"

@interface ImageViewWithProgress : UIImageView<ImageOperationProgress>

@property (nonatomic, strong) UIProgressView *m_pProgressView;

@end
