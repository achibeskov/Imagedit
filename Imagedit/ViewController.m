
#import "ViewController.h"
#import "ImageOperation.h"
#import "ImageProcessor.h"
#import "CellInfo.h"
#import "CollectionViewCell.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIActionSheetDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSOperationQueue * m_pOperationQueue;
@property (nonatomic, strong) NSMutableArray * m_pImageViewResults;
@property (atomic, strong) CellInfo *cellInfo;
@property NSInteger choosenIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup operation queue
    self.m_pOperationQueue = [[NSOperationQueue alloc] init];
    self.m_pOperationQueue.maxConcurrentOperationCount = 4;

    self.m_pImageViewResults = [NSMutableArray arrayWithCapacity:10];
    
    //setup collection view
    [self.m_pImageViewCollection registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"imageViewCells"];
    self.m_pImageViewCollection.allowsSelection = YES;
    
    // setup main image
    self.cellInfo = [[CellInfo alloc] init];
    [self.cellInfo registerObserver:self.m_pImageView];
    
    // setup main image iteraction
    UITapGestureRecognizer *newTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageActionSheet)];
    [self.m_pImageView setUserInteractionEnabled:YES];
    [self.m_pImageView addGestureRecognizer:newTap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// --- button actions ---

- (void) processOperation:(id<ImageOperation>)_operarion withReceiver:(id<ImageOperationProgress>)_receiver {
    // add new cell
    CellInfo *cellInfo = [[CellInfo alloc] init];
    [self.m_pImageViewResults addObject:cellInfo];
    [cellInfo registerObserver:_receiver];

    [self.m_pImageViewCollection reloadData];

    ImageProcessor *imageProcessor = [[ImageProcessor alloc] initWithOperation:_operarion operationProgress:cellInfo];

    [self.m_pOperationQueue addOperation:imageProcessor];
}

- (IBAction)rotateImage:(id)sender {
    RotateImage * ri = [[RotateImage alloc] initWithImage:_m_pImageView.image];
    [self processOperation:ri withReceiver:nil];
}

- (IBAction)invertColors:(id)sender {
    InvertImage * ri = [[InvertImage alloc] initWithImage:_m_pImageView.image];
    [self processOperation:ri withReceiver:nil];
}

- (IBAction)mirrorImage:(id)sender {
    MirrorImage * ri = [[MirrorImage alloc] initWithImage:_m_pImageView.image];
    [self processOperation:ri withReceiver:nil];
}

// --- image picker ---

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.m_pImageView.image =
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
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageViewCells" forIndexPath:indexPath];

    CellInfo *cellInfo = [self.m_pImageViewResults objectAtIndex:indexPath.item];

    [cell.imageViewWithProgress updateObservable:cellInfo];
    [cellInfo notifyObserver];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.choosenIndex = indexPath.item;
    [self showGalleryActionSheet];
}

// --- action sheets ---

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
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Enter image's URL:" message:@"" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Cancel", nil];

    alert.alertViewStyle = UIAlertViewStylePlainTextInput;

    // enter test url
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.text = @"http://www.necdettas.com/wp-content/uploads/2015/09/test-site-300x279-300x279.jpg";
    alertTextField.clearButtonMode = UITextFieldViewModeAlways;

    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        UITextField * alertTextField = [alertView textFieldAtIndex:0];

        // download entered image
        DownlodImage * ri = [[DownlodImage alloc] initWithUrl:[NSURL URLWithString:alertTextField.text]];
        ImageProcessor *downloader = [[ImageProcessor alloc] initWithOperation:ri operationProgress:self.cellInfo];
        [self.m_pOperationQueue addOperation:downloader];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 1) {
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
