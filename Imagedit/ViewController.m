//
//  ViewController.m
//  Imagedit
//
//  Created by archi on 3/19/16.
//
//

#import "ViewController.h"
#import "ImageOperation.h"

@interface ImageFilter : NSOperation

@property (nonatomic,strong) UIImage * m_pImage;

- (id)initWithImage:(UIImage*)_pImage;

@end

@implementation ImageFilter

- (id)initWithImage:(UIImage*)_pImage {
    if (self = [super init]) {
        self.m_pImage = _pImage;
//        self.completionBlock =
    }
    return self;
}

- (void) main {
    NSLog(@"background operation %@", self.m_pImage);
    NSLog(@"%@", [NSThread currentThread]);
    for (int i = 0; i < 10; ++i) {
        NSLog(@"iteration in %d", i);
        if (self.isCancelled)
            return;
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

// --- button actions ---

- (IBAction)loadImage:(id)sender {
    UIImagePickerController *pickerC =
    [[UIImagePickerController alloc] init];
    pickerC.delegate = self;
    [self presentViewController:pickerC animated:YES completion:nil];
}

- (IBAction)rotateImage:(id)sender {
    RotateImage * ri = [[RotateImage alloc] initWithImage:_m_pImageView.image];
    _m_pImageViewResult.image = [ri getImage];
}

- (IBAction)invertColors:(id)sender {
    ImageFilter *downloader = [[ImageFilter alloc] initWithImage:_m_pImageView.image];
    downloader.completionBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"completionBlock");
        });
    };

    ImageFilter *downloader1 = [[ImageFilter alloc] initWithImage:_m_pImageView.image];
    downloader1.completionBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"completionBlock");
        });
    };

    [self.m_pOperationQueue addOperation:downloader];
    [self.m_pOperationQueue addOperation:downloader1];
    
    InvertImage * ri = [[InvertImage alloc] initWithImage:_m_pImageView.image];
    _m_pImageViewResult.image = [ri getImage];
}

- (IBAction)mirrorImage:(id)sender {
    [self.m_pOperationQueue cancelAllOperations];
    MirrorImage * ri = [[MirrorImage alloc] initWithImage:_m_pImageView.image];
    _m_pImageViewResult.image = [ri getImage];
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
