//
//  ViewController.m
//  Imagedit
//
//  Created by archi on 3/19/16.
//
//

#import "ViewController.h"

@interface ImageFilter : NSOperation

@property (nonatomic,strong) UIImage * m_pImage;

- (id)initWithImage:(UIImage*)_pImage;

@end

@implementation ImageFilter

- (id)initWithImage:(UIImage*)_pImage {
    if (self = [super init]) {
        self.m_pImage = _pImage;
    }
    return self;
}

- (void) main {
    NSLog(@"background operation %@", self.m_pImage);
    for (int i = 0; i < 5; ++i) {
        NSLog(@"iteration in %d", i);
        sleep(1);
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [progressbar setDoubleValue:progr];
            //            [progressbar setNeedsDisplay:YES];
            NSLog(@"background progress %d", i);
        });
        NSLog(@"iteration out %d", i);
    }
}

@end

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationBarDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [m_pImageView ];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.m_pOperationQueue = [[NSOperationQueue alloc]init];
    self.m_pOperationQueue.maxConcurrentOperationCount = 4;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loadImage:(id)sender {
    UIImagePickerController *pickerC =
    [[UIImagePickerController alloc] init];
    pickerC.delegate = self;
    [self presentViewController:pickerC animated:YES completion:nil];
}

- (IBAction)rotateImage:(id)sender {
    _m_pImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
}

- (UIImage *)convertImageToGrayScale:(UIImage *)image {
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}

- (IBAction)invertColors:(id)sender {
    _m_pImageView.image = [self convertImageToGrayScale:_m_pImageView.image];
}

- (IBAction)mirrorImage:(id)sender {
    ImageFilter *downloader = [[ImageFilter alloc] initWithImage:_m_pImageView.image];
    downloader.completionBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"completionBlock");
        });
    };
    [self.m_pOperationQueue addOperation:downloader];
    
    _m_pImageView.transform = CGAffineTransformMakeScale(-1, 1);
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    _m_pImageView.image =
    [info objectForKey:UIImagePickerControllerOriginalImage];
}



- (void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
