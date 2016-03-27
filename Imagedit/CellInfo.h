//
//  CellInfo.h
//  Imagedit
//
//  Created by archi on 3/27/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ImageOperation.h"

@protocol Observable <NSObject>

- (void) registerObserver:(id<ImageOperationProgress>)observer;
- (void) unregisterObserver:(id<ImageOperationProgress>)observer;

@end

@interface CellInfo : NSObject <ImageOperationProgress, Observable>

@property (atomic, strong) UIImage * image;
@property (atomic) int progress;

@end
