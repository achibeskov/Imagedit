
#import "ViewController.h"
#import "ImageOperation.h"
#import "ImageProcessor.h"
#import "CellInfo.h"
#import "CollectionViewCell.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIActionSheetDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSOperationQueue * operationQueue;
@property (nonatomic, strong) NSMutableArray * imageViewResults;
@property (nonatomic, strong) CellInfo *cellInfo;
@property NSInteger chosenIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup operation queue
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 4;

    self.imageViewResults = [NSMutableArray arrayWithCapacity:10];
    
    //setup collection view
    [self.imageViewCollection registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"imageViewCells"];
    self.imageViewCollection.allowsSelection = YES;
    
    // setup main image
    self.cellInfo = [[CellInfo alloc] init];
    [self.cellInfo registerObserver:self.imageView];
    
    // setup main image iteraction
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageActionSheet)];
    [self.imageView setUserInteractionEnabled:YES];
    [self.imageView addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// --- button actions ---

- (void) processOperation:(id<ImageOperation>)operarion {
    // add new cell to collection view
    CellInfo *cellInfo = [[CellInfo alloc] init];
    [self.imageViewResults addObject:cellInfo];

    // add item to collection view and scroll to it
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.imageViewResults count]-1 inSection:0];
    [self.imageViewCollection insertItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];

    [self.imageViewCollection scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

    // start operation processing
    ImageProcessor *imageProcessor = [[ImageProcessor alloc] initWithOperation:operarion operationProgress:cellInfo];
    [self.operationQueue addOperation:imageProcessor];
}

- (IBAction)rotateImage:(id)sender {
    RotateImage * ri = [[RotateImage alloc] initWithImage:self.imageView.image];
    [self processOperation:ri];
}

- (IBAction)invertColors:(id)sender {
    InvertImage * ri = [[InvertImage alloc] initWithImage:self.imageView.image];
    [self processOperation:ri];
}

- (IBAction)mirrorImage:(id)sender {
    MirrorImage * ri = [[MirrorImage alloc] initWithImage:self.imageView.image];
    [self processOperation:ri];
}

// --- image picker ---

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
}

- (void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// --- collection view ---

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.imageViewResults count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageViewCells" forIndexPath:indexPath];

    CellInfo *cellInfo = [self.imageViewResults objectAtIndex:indexPath.item];

    // update observable as view cells are reusable
    [cell.imageViewWithProgress updateObservable:cellInfo];
    [cellInfo notifyObserver];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.chosenIndex = indexPath.item;
    [self showGalleryActionSheet];
}

// --- action sheets ---

- (void) showImageActionSheet {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Get image from:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Library",
                            @"Camera",
                            @"URL",
                            nil];
    popup.tag = 2;
    [popup showInView:self.view];
}

- (bool) isCellReady:(NSInteger)index {
    CellInfo *cellInfo = [self.imageViewResults objectAtIndex:index];
    return cellInfo.state == ImageProcessStateReady;
}

- (void) showGalleryActionSheet {
    if (![self isCellReady:self.chosenIndex]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Image is not ready yet" message:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        return;
    }
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"What to do with image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Save",
                            @"Remove",
                            @"Use",
                            nil];

    popup.tag = 1;
    [popup showInView:self.view];
}

- (void) saveImage:(NSInteger)index {
    CellInfo *cellInfo = [self.imageViewResults objectAtIndex:index];
    UIImageWriteToSavedPhotosAlbum(cellInfo.image, nil, nil, nil);
}

- (void) removeImage:(NSInteger)index {
    [self.imageViewResults removeObjectAtIndex:index];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.imageViewCollection deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
}

- (void) useImage:(NSInteger)index {
    CellInfo *cellInfo = [self.imageViewResults objectAtIndex:index];
    self.imageView.image = cellInfo.image;
}

- (void) getFromLibrary {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void) getFromCamera {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void) getFromInternet {
    // show text field through alert view
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Enter image's URL:" message:@"" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Cancel", nil];

    alert.alertViewStyle = UIAlertViewStylePlainTextInput;

    // setup test url
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
        [self.operationQueue addOperation:downloader];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 1) {
        // GalleryActionSheet
        switch (buttonIndex) {
            case 0:
                [self saveImage:self.chosenIndex];
                break;
            case 1:
                [self removeImage:self.chosenIndex];
                break;
            case 2:
                [self useImage:self.chosenIndex];
                break;
            default:
                break;
        }
    } else if (actionSheet.tag == 2) {
        // ImageActionSheet
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
