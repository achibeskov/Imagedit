
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ImageOperationProgress <NSObject>

- (void) update:(int)_progress;
- (void) onFinish:(UIImage*)_resultImage;
- (void) onStart;

@end

@protocol ImageOperation <NSObject>

- (UIImage*) getImageWithProgress:(id<ImageOperationProgress>)_progressNotification;

@end

@interface ImageChange : NSObject <ImageOperation>

- (id) initWithImage:(UIImage*)_pImage;
- (void) fakeDelay:(id<ImageOperationProgress>)_progressNotification;

@property (nonatomic, strong) UIImage *pImageToProcess;

@end

@interface RotateImage : ImageChange
@end

@interface InvertImage : ImageChange
@end

@interface MirrorImage : ImageChange
@end

@interface DownlodImage : NSObject <ImageOperation, NSURLConnectionDataDelegate>

- (id) initWithUrl:(NSURL*)pURL;

@property (nonatomic, strong) NSURL *pURL;

@end
