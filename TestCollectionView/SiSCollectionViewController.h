//
//  SiSCollectionViewController.h
//  TestCollectionView
//
//  Created by Stanly Shiyanovskiy on 28.10.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SiSCollectionViewController : UIViewController

@property (strong, nonatomic) NSMutableArray* imagesArray;

@property (weak, nonatomic) IBOutlet UICollectionView *itemsTable;

@end
