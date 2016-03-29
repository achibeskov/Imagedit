//
//  ImageOperation.m
//  Imagedit

#import "ImageOperation.h"

@implementation ImageChange

- (id) initWithImage:(UIImage*)_pImage {
    if (self = [super init]) {
        _pImageToProcess = _pImage;
        return self;
    }
    return nil;
}

- (void) fakeDelay:(id<ImageOperationProgress>)_progressNotification {
    int delay = rand()%26+5;
    for (int i = 0; i < delay; ++i) {
        sleep(1);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [_progressNotification update:i];
        }];
    }
}

- (UIImage*) getImageWithProgress:(id<ImageOperationProgress>)_progressNotification {
    return nil;
}

@end

@implementation RotateImage

- (UIImage*) getImageWithProgress:(id<ImageOperationProgress>)_progressNotification {
    [self fakeDelay:_progressNotification];

    CGSize size = self.pImageToProcess.size;
    // rotate image
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0.5f * size.width, 0.5f * size.height);
    CGContextRotateCTM(context, M_PI_2);
    CGContextTranslateCTM(context, -0.5f * size.width, -0.5f * size.height);

    [self.pImageToProcess drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end

@implementation InvertImage

- (UIImage*) getImageWithProgress:(id<ImageOperationProgress>)_progressNotification {
    [self fakeDelay:_progressNotification];

    CGSize size = self.pImageToProcess.size;
    // make image black and white
    CGRect imageRect = CGRectMake(0, 0, size.width, size.height);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    CGContextDrawImage(context, imageRect, [self.pImageToProcess CGImage]);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);

    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    return newImage;
}

@end

@implementation MirrorImage

- (UIImage*) getImageWithProgress:(id<ImageOperationProgress>)_progressNotification {
    [self fakeDelay:_progressNotification];

    CGSize size = self.pImageToProcess.size;
    // mirror image
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextTranslateCTM(context, 0.5f * size.width, 0.5f * size.height);
    CGContextScaleCTM(context, -1, 1);
    CGContextTranslateCTM(context, -0.5f * size.width, -0.5f * size.height);

    [self.pImageToProcess drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

@interface DownlodImage ()
@property (nonatomic) NSMutableData *imageData;
@property (nonatomic) NSUInteger totalBytes;
@property (nonatomic) NSUInteger receivedBytes;
@end

@implementation DownlodImage

- (id) initWithUrl:(NSURL*)pURL {
    if (self = [super init]) {
        _pURL = pURL;
        return self;
    }
    return nil;
}

- (UIImage*) getImageWithProgress:(id<ImageOperationProgress>)_progressNotification {
    NSData *myData = [NSData dataWithContentsOfURL:_pURL];
    UIImage *image = [UIImage imageWithData:myData];
    NSLog(@"DownlodImage %@ %@ %@", _pURL, myData, image);
    return image;
}

@end


