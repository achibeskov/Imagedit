//
//  ImageOperation.m
//  Imagedit
//
//  Created by archi on 3/24/16.
//
//

#import "ImageOperation.h"

@interface RotateImage ()

@property (nonatomic, strong) UIImage *pImageToProcess;

@end

@implementation RotateImage

@synthesize pImageToProcess;

- (UIImage*) getImage {
    // rotate image
    UIGraphicsBeginImageContext(pImageToProcess.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGSize size = pImageToProcess.size;
    
    CGContextTranslateCTM(context, 0.5f * size.width, 0.5f * size.height);
    CGContextRotateCTM(context, M_PI_2);
    CGContextTranslateCTM(context, -0.5f * size.width, -0.5f * size.height);

    [pImageToProcess drawInRect:CGRectMake(0, 0, pImageToProcess.size.width, pImageToProcess.size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (id) initWithImage:(UIImage*)_pImage {
    if (self = [super init]) {
        pImageToProcess = _pImage;
        return self;
    }
    return nil;
}

@end

@interface InvertImage ()

@property (nonatomic, strong) UIImage *pImageToProcess;

@end

@implementation InvertImage

@synthesize pImageToProcess;

- (UIImage*) getImage {
    // make image black and white
    CGRect imageRect = CGRectMake(0, 0, pImageToProcess.size.width, pImageToProcess.size.height);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, pImageToProcess.size.width, pImageToProcess.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    CGContextDrawImage(context, imageRect, [pImageToProcess CGImage]);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);

    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    return newImage;
}

- (id) initWithImage:(UIImage*)_pImage {
    if (self = [super init]) {
        pImageToProcess = _pImage;
        return self;
    }
    return nil;
}

@end

@interface MirrorImage ()

@property (nonatomic, strong) UIImage *pImageToProcess;

@end

@implementation MirrorImage

@synthesize pImageToProcess;

- (UIImage*) getImage {
    // rotate image
    UIGraphicsBeginImageContext(pImageToProcess.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGSize size = pImageToProcess.size;

    CGContextTranslateCTM(context, 0.5f * size.width, 0.5f * size.height);
    CGContextScaleCTM(context, -1, 1);
    CGContextTranslateCTM(context, -0.5f * size.width, -0.5f * size.height);

    [pImageToProcess drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (id) initWithImage:(UIImage*)_pImage {
    if (self = [super init]) {
        pImageToProcess = _pImage;
        return self;
    }
    return nil;
}

@end


