//
//  ViewController.m
//  Imagedit
//
//  Created by archi on 3/19/16.
//
//

#import "ViewController.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationBarDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [m_pImageView ];
    // Do any additional setup after loading the view, typically from a nib.
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
    _m_pImageView.transform = CGAffineTransformMakeScale(-1, 1);
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%@", info);
    
    _m_pImageView.image =
    [info objectForKey:UIImagePickerControllerOriginalImage];
}

UICollectionView

- (void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
