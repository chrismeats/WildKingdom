//
//  ViewController.m
//  WildKingdom
//
//  Created by ETC ComputerLand on 8/7/14.
//  Copyright (c) 2014 cmeats. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UICollectionViewDataSource, UITabBarControllerDelegate, UICollectionViewDelegateFlowLayout>// UICollectionViewDelegate, not needed with flow layout
@property (strong, nonatomic) IBOutlet UICollectionView *animalCollectionView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tabBarController.delegate = self;

    [self getPhotosByTag:self.tabBarItem.title];

}

-(void)getPhotosByTag: (NSString *)tag
{
//    NSArray *tags = [[NSArray alloc] initWithObjects:@"lion", @"tiger", @"bear", nil];
//    for (NSString *tag in tags) {

        //NSLog(@"%@", [NSString stringWithFormat:@"https://www.flickr.com/services/rest/?method=flickr.photos.search&format=json&api_key=f7bd790aa038fe1a346ea130bda91f90&tags=%@&per_page=10", tag]);
       // NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=f7bd790aa038fe1a346ea130bda91f90&text=%@&content_type=1&extras=url_m&per_page=10&format=json&nojsoncallback=1", tag]];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.flickr.com/services/rest/?method=flickr.photos.search&format=json&api_key=f7bd790aa038fe1a346ea130bda91f90&tags=%@&per_page=10&nojsoncallback=1", tag]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            self.animals = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil][@"photos"][@"photo"];
            [self.animalCollectionView reloadData];
        }];
//    }
}

#pragma mark - Collection View delegates

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.animals.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    NSDictionary *animal = self.animals[indexPath.row];
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",
                                            animal[@"farm"],
                                            animal[@"server"],
                                            animal[@"id"],
                                            animal[@"secret"]]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:imageData]];
    return cell;
}

#pragma mark - tab bar controller deleagates

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [self getPhotosByTag:self.tabBarItem.title];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.animalCollectionView.collectionViewLayout;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        self.animalCollectionView.collectionViewLayout = flowLayout;
        [self.animalCollectionView.collectionViewLayout invalidateLayout];
    } else {
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.animalCollectionView.collectionViewLayout;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        self.animalCollectionView.collectionViewLayout = flowLayout;
        [self.animalCollectionView.collectionViewLayout invalidateLayout];
    }
}

@end
