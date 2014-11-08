//
//  ViewController.m
//  Browseritto
//
//  Created by Jonathan Chou on 11/6/14.
//  Copyright (c) 2014 Jonathan Chou. All rights reserved.
//

#import "ViewController.h"
#import "InstagramCollectionViewCell.h"
#import "FavoritesViewController.h"
#define instagramKey @"430314792.dc2516f.332582c2ad424faa8b72790141d0ac9c"
#define kNSUserDefaultsLastSavedKey @"kNSUserDefaultsLastSavedKey"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UITabBarControllerDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSMutableArray *favoritePhotosArray;
@property NSMutableArray *popularPhotosArray;
@property NSMutableArray *photoDataArray;
@property FavoritesViewController *controllerB;
@property NSString *currentURLString;
@end

@implementation ViewController

//TOODO: Check for Duplicate Favorite Photos

- (void)viewDidLoad {
    
    self.tabBarController.delegate = self;

    [super viewDidLoad];
    self.popularPhotosArray = [@[] mutableCopy];
    self.favoritePhotosArray = [@[] mutableCopy];
    [self load];
    
    self.collectionView.pagingEnabled = YES;

    
    self.currentURLString = @"https://api.instagram.com/v1/media/popular?client_id=dc2516fa17de4dc2a582376c3d69abce";
    [self callURLConnection];
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    flowLayout.minimumLineSpacing = 0;
//    flowLayout.minimumInteritemSpacing = 0;
    

    }

-(void)callURLConnection
{
    NSURL *url = [NSURL URLWithString:self.currentURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *picturesDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.popularPhotosArray = picturesDictionary[@"data"];
        [self.collectionView reloadData];
    }];

}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    InstagramCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *instagramObject = self.popularPhotosArray[indexPath.item];
    NSDictionary *instagramImage = instagramObject[@"images"];
    NSString *instagramImageURL = instagramImage[@"standard_resolution"][@"url"];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:instagramImageURL]];
    cell.imageView.image = [UIImage imageWithData:imageData];

    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    return cell;

}





- (IBAction)onButtonPressedFavoritePhoto:(UIButton *)sender {
    NSIndexPath *indexPath = nil;
    
    int pageCount = (int)(self.collectionView.contentOffset.x / self.collectionView.frame.size.width);
//    indexPath = [self.collectionView indexPathForItemAtPoint:[self.collectionView convertPoint:sender.center fromView:sender.superview]];
//    indexPath = [self.collectionView indexPathFo;
    
    NSDictionary *instagramObject = self.popularPhotosArray[pageCount];
    
    [self.favoritePhotosArray addObject:instagramObject];
    
    NSDictionary *instagramImage = instagramObject[@"images"];
    NSString *instagramImageURL = instagramImage[@"standard_resolution"][@"url"];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:instagramImageURL]];
    
    [self.photoDataArray addObject:imageData];
    
    NSLog(@"%ld",(long)indexPath.item);
    [self save];

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(self.view.frame.size.width, self.view.frame.size.width);
//        cell.imageView.frame = CGRectMake(self.view.frame.origin.x , self.view.frame.origin.y + 100, self.view.frame.size.width, self.view.frame.size.height * .5);
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    self.controllerB = (FavoritesViewController *) [tabBarController.viewControllers objectAtIndex:1];
   
    
//    self.controllerB.favoritePhotosArray = self.favoritePhotosArray;
    self.controllerB.photoDataArray = self.photoDataArray;
    //In our example here, we only have 2 view controllers (A and B)
    //So, index 1 is where controller B resides.
    
    //    self.controllerB.aLabelInControllerB.text = @"Hello!";
    //This will change the text of the label in controller B
}

- (IBAction)onButtonPressedSearchInstagram:(id)sender
{
    NSString *searchString = self.textField.text;
    
    self.currentURLString = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?access_token=%@&count=10", searchString, instagramKey];
    [self callURLConnection];
    
    
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.popularPhotosArray.count;
//    return 10;
}

- (void)save
{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:[NSDate date] forKey:kNSUserDefaultsLastSavedKey ];
//    [userDefaults synchronize];
    
    NSURL *plistURL = [[self documentsDirectory]URLByAppendingPathComponent:@"instagram.plist"];
    [self.photoDataArray writeToURL:plistURL atomically:YES];
    
}

- (void)load
{
    NSURL *plistURL = [[self documentsDirectory]URLByAppendingPathComponent:@"instagram.plist"];
    self.photoDataArray = [NSMutableArray arrayWithContentsOfURL:plistURL];
    
    if(self.photoDataArray == nil){
        self.photoDataArray = [@[] mutableCopy];
        return;
    }


}

-(NSURL *)documentsDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *url = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    return url;
}
@end
