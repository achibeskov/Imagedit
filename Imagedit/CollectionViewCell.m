
#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageViewWithProgress = [[ImageViewWithProgress alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        [self.contentView addSubview:_imageViewWithProgress];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageViewWithProgress.image = nil;
    [self.imageViewWithProgress updateObservable:nil];
}

@end
