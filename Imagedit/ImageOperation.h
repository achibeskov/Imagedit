
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ImageProcessState) {
    ImageProcessStateDefault = 0,
    ImageProcessStateInProgress,
    ImageProcessStateReady
};

@protocol Observable;

@protocol ImageOperationProgress <NSObject>

- (void) update:(float)progress;
- (void) onFinish:(UIImage*)resultImage;
- (void) onStart;

@optional

- (void) updateObservable:(id<Observable>)observable;

@end

@protocol ImageOperation <NSObject>

- (UIImage*) getImageWithProgress:(id<ImageOperationProgress>)progressNotification;

@end

@interface ImageChange : NSObject <ImageOperation>

- (id) initWithImage:(UIImage*)image;
+ (void) fakeDelay:(id<ImageOperationProgress>)progressNotification;

@property (nonatomic, strong) UIImage *imageToProcess;

@end

@interface RotateImage : ImageChange
@end

@interface InvertImage : ImageChange
@end

@interface MirrorImage : ImageChange
@end

@interface DownlodImage : NSObject <ImageOperation, NSURLConnectionDataDelegate>

- (id) initWithUrl:(NSURL*)url;

@end
