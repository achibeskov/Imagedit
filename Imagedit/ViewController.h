
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ImageViewWithProgress.h"

@interface ViewController : UIViewController

@property (nonatomic) IBOutlet ImageViewWithProgress * m_pImageView;
@property (nonatomic) IBOutlet UICollectionView * m_pImageViewCollection;

- (IBAction)rotateImage:(id)sender;
- (IBAction)invertColors:(id)sender;
- (IBAction)mirrorImage:(id)sender;

@end

