//
//  ImageOperation.m
//  Imagedit

#import "ImageOperation.h"

@implementation ImageChange

- (id) initWithImage:(UIImage*)image {
    self = [super init];
    if (self) {
        _imageToProcess = image;
    }
    return self;
}

+ (void) fakeDelay:(id<ImageOperationProgress>)progressNotification {
    int delay = rand()%26+5;
    for (int i = 0; i < delay; ++i) {
        sleep(1);
        [progressNotification update:(float)(i+1)/delay];
    }
}

- (UIImage*) getImageWithProgress:(id<ImageOperationProgress>)progressNotification {
    return nil;
}

@end

@implementation RotateImage

- (UIImage*) getImageWithProgress:(id<ImageOperationProgress>)progressNotification {
    [ImageChange fakeDelay:progressNotification];

    CGSize size = self.imageToProcess.size;
    // rotate image
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0.5f * size.width, 0.5f * size.height);
    CGContextRotateCTM(context, M_PI_2);
    CGContextTranslateCTM(context, -0.5f * size.width, -0.5f * size.height);

    [self.imageToProcess drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end

@implementation InvertImage

- (UIImage*) getImageWithProgress:(id<ImageOperationProgress>)_progressNotification {
    [ImageChange fakeDelay:_progressNotification];

    CGSize size = self.imageToProcess.size;
    // make image black and white
    CGRect imageRect = CGRectMake(0, 0, size.width, size.height);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    CGContextDrawImage(context, imageRect, [self.imageToProcess CGImage]);
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
    [ImageChange fakeDelay:_progressNotification];

    CGSize size = self.imageToProcess.size;
    // mirror image
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextTranslateCTM(context, 0.5f * size.width, 0.5f * size.height);
    CGContextScaleCTM(context, -1, 1);
    CGContextTranslateCTM(context, -0.5f * size.width, -0.5f * size.height);

    [self.imageToProcess drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

@implementation InvertColorImage

- (UIImage*) getImageWithProgress:(id<ImageOperationProgress>)_progressNotification {
    [ImageChange fakeDelay:_progressNotification];

    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *coreImage = [CIImage imageWithCGImage:self.imageToProcess.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"];
    [filter setValue:coreImage forKey:kCIInputImageKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGRect extent = [result extent];
    CGImageRef cgImage = [context createCGImage:result fromRect:extent];
    return [UIImage imageWithCGImage:cgImage];
}

@end

@implementation LeftMirrorImage

- (UIImage*) getImageWithProgress:(id<ImageOperationProgress>)_progressNotification {
    [ImageChange fakeDelay:_progressNotification];

    CGSize size = self.imageToProcess.size;
    // mirror image
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextTranslateCTM(context, 0.5f * size.width, 0.5f * size.height);
    CGContextScaleCTM(context, -1, 1);
    CGContextTranslateCTM(context, -0.5f * size.width, -0.5f * size.height);

    [self.imageToProcess drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *mirrorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    // get halfs
    CGFloat imgWidth = size.width/2;
    CGFloat imgheight = size.height;

    CGRect leftImgFrame = CGRectMake(0, 0, imgWidth, imgheight);
    CGRect rightImgFrame = CGRectMake(imgWidth, 0, imgWidth, imgheight);

    CGImageRef left = CGImageCreateWithImageInRect(self.imageToProcess.CGImage, leftImgFrame);
    CGImageRef right = CGImageCreateWithImageInRect(mirrorImage.CGImage, rightImgFrame);

    UIImage *leftImage = [UIImage imageWithCGImage:left];
    UIImage *rightImage = [UIImage imageWithCGImage:right];

    CGImageRelease(left);
    CGImageRelease(right);

    // draw halfs in one context
    UIGraphicsBeginImageContext(size);
    context = UIGraphicsGetCurrentContext();

    [leftImage drawInRect:leftImgFrame];
    [rightImage drawInRect:rightImgFrame];

    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return resultImage;
}

@end

@interface DownlodImage ()
@property (nonatomic, strong) NSURL *url;
@end

@implementation DownlodImage

- (id) initWithUrl:(NSURL*)url {
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}

- (UIImage*) getImageWithProgress:(id<ImageOperationProgress>)_progressNotification {
    [ImageChange fakeDelay:_progressNotification];

    NSData *data = [NSData dataWithContentsOfURL:_url];
    UIImage *image = [UIImage imageWithData:data];

    return image;
}

@end


