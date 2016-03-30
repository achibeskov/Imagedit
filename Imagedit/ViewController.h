
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ImageViewWithProgress.h"

@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet ImageViewWithProgress * imageView;
@property (nonatomic, strong) IBOutlet UICollectionView * imageViewCollection;

- (IBAction)rotateImage:(id)sender;
- (IBAction)invertColors:(id)sender;
- (IBAction)mirrorImage:(id)sender;
- (IBAction)invertColorImage:(id)sender;

@end

