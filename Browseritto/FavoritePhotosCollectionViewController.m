//
//  FavoritePhotosCollectionViewController.m
//  Browseritto
//
//  Created by Jonathan Chou on 11/7/14.
//  Copyright (c) 2014 Jonathan Chou. All rights reserved.
//

#import "FavoritePhotosCollectionViewController.h"
#import "InstagramCollectionViewCell.h"

@interface FavoritePhotosCollectionViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation FavoritePhotosCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", self.favoritePhotosArray);
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    NSLog(@"%@", self.photoDataArray);
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete method implementation -- Return the number of sections
//    return 0;
//}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete method implementation -- Return the number of items in the section
    return self.photoDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    InstagramCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
 
    
//    NSDictionary *instagramObject = self.favoritePhotosArray[indexPath.item];
//    NSDictionary *instagramImage = instagramObject[@"images"];
//    NSString *instagramImageURL = instagramImage[@"standard_resolution"][@"url"];
//    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:instagramImageURL]];
    NSData *imageData = self.photoDataArray[indexPath.item];
    cell.favoriteImageView.image = [UIImage imageWithData:imageData];
    
    
    
//    cell.favoriteImageView.image = [UIImage imageWithData:imageData];
//    cell.imageView.frame = CGRectMake(self.view.frame.origin.x , self.view.frame.origin.y + 100, self.view.frame.size.width, self.view.frame.size.height * .5);
//    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
//    return cell;
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
