//
//  ViewController.m
//  Imagedit
//
//  Created by archi on 3/19/16.
//
//

#import "ViewController.h"
#import "ImageOperation.h"
#import "ImageProcessor.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationBarDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.m_pOperationQueue = [[NSOperationQueue alloc] init];
    self.m_pOperationQueue.maxConcurrentOperationCount = 4;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// --- button actions ---

- (IBAction)loadImage:(id)sender {
//    UIImagePickerController *pickerC =
//    [[UIImagePickerController alloc] init];
//    pickerC.delegate = self;
//    [self presentViewController:pickerC animated:YES completion:nil];
    DownlodImage * ri = [[DownlodImage alloc] initWithUrl:[NSURL URLWithString:@"http://i0.kym-cdn.com/entries/icons/original/000/005/545/OpoQQ.jpg"]];
    [self processOperation:ri withReceiver:self.m_pImageView];
}

- (void) processOperation:(id<ImageOperation>)_operarion withReceiver:(id<ImageOperationProgress>)_receiver {
    // create image view with progress (cell)
    // add cell to down
    // +create nsopeartion with source image and operation to process
    // +use cell as callback receiver
    ImageProcessor *downloader = [[ImageProcessor alloc] initWithOperation:_operarion operationProgress:_receiver];
    [self.m_pOperationQueue addOperation:downloader];
}

- (IBAction)rotateImage:(id)sender {
    RotateImage * ri = [[RotateImage alloc] initWithImage:_m_pImageView.image];
    [self processOperation:ri withReceiver:self.m_pImageViewResult];
}

- (IBAction)invertColors:(id)sender {
    InvertImage * ri = [[InvertImage alloc] initWithImage:_m_pImageView.image];
    [self processOperation:ri withReceiver:self.m_pImageViewResult];
}

- (IBAction)mirrorImage:(id)sender {
    MirrorImage * ri = [[MirrorImage alloc] initWithImage:_m_pImageView.image];
    [self processOperation:ri withReceiver:self.m_pImageViewResult];
}

// --- image picker ---

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
