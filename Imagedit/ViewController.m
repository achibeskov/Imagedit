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
#import "CellInfo.h"
#import "CollectionViewCell.h"

@interface ViewController () <UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIActionSheetDelegate>

@property (strong) NSMutableArray * m_pImageViewResults;
@property (strong) CellInfo *cellInfo;
@property NSInteger choosenIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.m_pOperationQueue = [[NSOperationQueue alloc] init];
    self.m_pOperationQueue.maxConcurrentOperationCount = 4;

    self.m_pImageViewResults = [NSMutableArray arrayWithCapacity:10];
    
    [self.m_pImageViewCollection registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"myIdentifier"];
    self.m_pImageViewCollection.allowsSelection = YES;
    
    self.cellInfo = [[CellInfo alloc] init];
    [self.cellInfo registerObserver:self.m_pImageView];
    
    // setup image view
    UITapGestureRecognizer *newTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageActionSheet)];
    
    [self.m_pImageView setUserInteractionEnabled:YES];
    [self.m_pImageView addGestureRecognizer:newTap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// --- button actions ---

- (IBAction)loadImage:(id)sender {
    DownlodImage * ri = [[DownlodImage alloc] initWithUrl:[NSURL URLWithString:@"http://i0.kym-cdn.com/entries/icons/original/000/005/545/OpoQQ.jpg"]];
//    [self processOperation:ri withReceiver:self.m_pImageView];
    ImageProcessor *downloader = [[ImageProcessor alloc] initWithOperation:ri operationProgress:self.cellInfo];
    
    [self.m_pOperationQueue addOperation:downloader];
}

- (void) processOperation:(id<ImageOperation>)_operarion withReceiver:(id<ImageOperationProgress>)_receiver {
    // create image view with progress (cell)
    // add cell to down
    // +create nsopeartion with source image and operation to process
    // +use cell as callback receiver
    
    CellInfo *cellInfo = [[CellInfo alloc] init];
    [self.m_pImageViewResults addObject:cellInfo];
    [cellInfo registerObserver:_receiver];
    
    ImageProcessor *downloader = [[ImageProcessor alloc] initWithOperation:_operarion operationProgress:cellInfo];
    [self.m_pImageViewCollection reloadData];

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

// --- collection view ---

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.m_pImageViewResults count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"cell %@ %d %d", indexPath, indexPath.item, indexPath.row );
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myIdentifier" forIndexPath:indexPath];
    
    CellInfo *cellInfo = [self.m_pImageViewResults objectAtIndex:indexPath.item];

    if (cellInfo.image == nil)
        [cell.imageViewWithProgress updateObservable:cellInfo];
    else
        cell.imageViewWithProgress.image = cellInfo.image;

//    NSLog(@"subviews count %d", [[cell.contentView subviews] count]);
    
    return cell;
}

- (void) showImageActionSheet {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Get image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Library",
                            @"Camera",
                            @"URL",
                            nil];
    popup.tag = 2;
    [popup showInView:self.view];
}

- (void) showGalleryActionSheet {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"What to do with image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Save",
                            @"Remove",
                            @"Use",
                            nil];

    popup.tag = 1;
    [popup showInView:self.view];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectItemAtIndexPath %d", indexPath.item);
    
    self.choosenIndex = indexPath.item;
    [self showGalleryActionSheet];
}

- (void) saveImage:(NSInteger)index {
    CellInfo *cellInfo = [self.m_pImageViewResults objectAtIndex:index];
    UIImageWriteToSavedPhotosAlbum(cellInfo.image, nil, nil, nil);
}

- (void) removeImage:(NSInteger)index {
    [self.m_pImageViewResults removeObjectAtIndex:index];
    [self.m_pImageViewCollection reloadData];
}

- (void) useImage:(NSInteger)index {
    CellInfo *cellInfo = [self.m_pImageViewResults objectAtIndex:index];
    self.m_pImageView.image = cellInfo.image;
}

- (void) getFromLibrary {
    UIImagePickerController *picker =
    [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void) getFromCamera {
    UIImagePickerController *picker =
    [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void) getFromInternet {
    DownlodImage * ri = [[DownlodImage alloc] initWithUrl:[NSURL URLWithString:@"http://i0.kym-cdn.com/entries/icons/original/000/005/545/OpoQQ.jpg"]];

    ImageProcessor *downloader = [[ImageProcessor alloc] initWithOperation:ri operationProgress:self.cellInfo];
    
    [self.m_pOperationQueue addOperation:downloader];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 1) {
        NSLog(@"buttonIndex %d", buttonIndex);
        switch (buttonIndex) {
            case 0:
                [self saveImage:self.choosenIndex];
                break;
            case 1:
                [self removeImage:self.choosenIndex];
                break;
            case 2:
                [self useImage:self.choosenIndex];
                break;
            default:
                break;
        }
    } else if (actionSheet.tag == 2) {
        NSLog(@"zopa buttonIndex %d", buttonIndex);
        switch (buttonIndex) {
            case 0:
                [self getFromLibrary];
                break;
            case 1:
                [self getFromCamera];
                break;
            case 2:
                [self getFromInternet];
                break;
            default:
                break;
        }
    }
}

@end
