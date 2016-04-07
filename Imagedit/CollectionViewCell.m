
#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageViewWithProgress.image = nil;
    [self.imageViewWithProgress updateObservable:nil];
}

@end
