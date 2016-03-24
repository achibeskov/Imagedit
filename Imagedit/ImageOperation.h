//
//  ImageOperation.h
//  Imagedit
//
//  Created by archi on 3/24/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ImageOperation <NSObject>

- (UIImage*) getImage;

@end

@interface RotateImage : NSObject <ImageOperation>

- (id) initWithImage:(UIImage*)_pImage;

@end

@interface InvertImage : NSObject <ImageOperation>

- (id) initWithImage:(UIImage*)_pImage;

@end

@interface MirrorImage : NSObject <ImageOperation>

- (id) initWithImage:(UIImage*)_pImage;

@end
