
#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageViewWithProgress = [[ImageViewWithProgress alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        [self.contentView addSubview:self.imageViewWithProgress];
    }
    return self;
}

@end
