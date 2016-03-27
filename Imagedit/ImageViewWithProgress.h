//
//  ImageViewWithProgress.h
//  Imagedit
//
//  Created by archi on 3/21/16.
//
//

#import <UIKit/UIKit.h>
#import "ImageOperation.h"
#import "CellInfo.h"

@interface ImageViewWithProgress : UIImageView<ImageOperationProgress>

- (void) updateObservable:(id<Observable>) observable;

@property (nonatomic, strong) UIProgressView *m_pProgressView;
@property (nonatomic, strong) id<Observable> observable;

@end
