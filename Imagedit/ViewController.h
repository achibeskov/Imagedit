//
//  ViewController.h
//  Imagedit
//
//  Created by archi on 3/19/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ImageViewWithProgress.h"

@interface ViewController : UIViewController

@property (nonatomic) IBOutlet ImageViewWithProgress * m_pImageView;
@property (nonatomic) IBOutlet ImageViewWithProgress * m_pImageViewResult;
@property (nonatomic, strong) NSOperationQueue * m_pOperationQueue;

- (IBAction)loadImage:(id)sender;
- (IBAction)rotateImage:(id)sender;
- (IBAction)invertColors:(id)sender;
- (IBAction)mirrorImage:(id)sender;

@end

