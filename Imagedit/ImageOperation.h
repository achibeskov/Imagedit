
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ImageProcessState) {
    ImageProcessStateDefault = 0,
    ImageProcessStateInProgress,
    ImageProcessStateReady
};

@protocol Observable;

@protocol ImageOperationProgress <NSObject>

- (void) update:(float)_progress;
- (void) onFinish:(UIImage*)_resultImage;
- (void) onStart;

@optional

- (void) updateObservable:(id<Observable>)observable;

@end

@protocol ImageOperation <NSObject>

- (UIImage*) getImageWithProgress:(id<ImageOperationProgress>)_progressNotification;

@end

@interface ImageChange : NSObject <ImageOperation>

- (id) initWithImage:(UIImage*)_pImage;
+ (void) fakeDelay:(id<ImageOperationProgress>)_progressNotification;

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

@end
