//
//  ViewController.h
//  Imagedit
//
//  Created by archi on 3/19/16.
//
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic) IBOutlet UIImageView * m_pImageView;

- (IBAction)loadImage:(id)sender;
- (IBAction)rotateImage:(id)sender;
- (IBAction)invertColors:(id)sender;
- (IBAction)mirrorImage:(id)sender;

@end

