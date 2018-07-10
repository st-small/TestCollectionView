//
//  SiSCollectionViewController.m
//  TestCollectionView
//
//  Created by Stanly Shiyanovskiy on 28.10.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import "SiSCollectionViewController.h"
#import "SiSCollectionViewCell.h"

#define targetHeight 170

@interface SiSCollectionViewController ()

@property (nonatomic, assign) CGPoint scrollingPoint, endPoint;
@property (nonatomic, strong) NSTimer *scrollingTimer;

@end

@implementation SiSCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imagesArray = [NSMutableArray array];
    for (int i = 1; i < 6; i++) {
        UIImage* img = [self resizingImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i]]];
        [self.imagesArray addObject:img];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSArray* temp = [NSArray arrayWithArray:self.imagesArray];
        for (int i = 0; i < 100; i++) {
            [self.imagesArray addObjectsFromArray:temp];
            NSLog(@"%lu", (unsigned long)self.imagesArray.count);
        }
    });
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self scrollSlowly];
    
}


#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.imagesArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SiSCollectionViewCell* cell = (SiSCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.imgView.image = self.imagesArray[indexPath.row];
    
    return cell;
}

#pragma mark UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImage* img = self.imagesArray[indexPath.row];
    CGSize origin = CGSizeMake(img.size.width, img.size.height);
    
    return origin;
}

#pragma mark Private methods

- (UIImage*)resizingImage:(UIImage*)image {
    
    CGFloat scaleFactor = targetHeight / image.size.height;
    CGFloat targetWidth = image.size.width * scaleFactor;
    CGSize targetSize = CGSizeMake(targetWidth, targetHeight);
    UIImage* scaledImage = [SiSCollectionViewController imageWithImage:image scaledToSize:targetSize];
    
    return scaledImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark Animation methods

- (void)scrollSlowly {
    self.endPoint = CGPointMake(3000, 0);
    self.scrollingPoint = CGPointMake(0, 0);
    self.scrollingTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(scrollSlowlyToPoint) userInfo:nil repeats:YES];
}

- (void)scrollSlowlyToPoint {
    
    self.itemsTable.contentOffset = self.scrollingPoint;
    if (CGPointEqualToPoint(self.scrollingPoint, self.endPoint)) {
        [self.scrollingTimer invalidate];
    }
    self.scrollingPoint = CGPointMake(self.scrollingPoint.x + 0.5, self.scrollingPoint.y);
}

@end
