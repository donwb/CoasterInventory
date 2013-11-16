//
//  RecipeCollectionViewController.m
//  RecipePhoto
//
//  Created by Don Browning on 11/15/13.
//  Copyright (c) 2013 Don Browning. All rights reserved.
//

#import "RecipeCollectionViewController.h"
#import "CoasterImage.h"
#import "DetailViewController.h"

@interface RecipeCollectionViewController ()

@end

@implementation RecipeCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    NSArray *photos = [self loadFromPList];
    //RecipeCollectionViewController *viewController = (RecipeCollectionViewController *) self.window.rootViewController;
    
    self.photos = photos;
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.backgroundView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"photo-frame"]];
                           
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    UILabel *label = (UILabel *)[cell viewWithTag:1000];

    
    CoasterImage *img = [self.photos objectAtIndex:indexPath.row];
    
    recipeImageView.image = [UIImage imageNamed:img.filename];
    label.text = img.name;
    
    return cell;
}


- (NSArray *) loadFromPList {
    NSURL *plistURL = [[NSBundle mainBundle] URLForResource:@"images" withExtension:@"plist"];
    
    NSArray *photos = [NSArray arrayWithContentsOfURL:plistURL];
    
    NSMutableArray *photoList = [NSMutableArray array];
    
    for(id photo in photos)
    {
        CoasterImage *image = [[CoasterImage alloc]init];
        image.name = photo[@"name"];
        image.filename = photo[@"filename"];
        
        [photoList addObject:image];
        
    }
    
    return photoList;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailViewController *detail = (DetailViewController *) segue.destinationViewController;
    
    NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
    NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
    
    CoasterImage *img = [self.photos objectAtIndex:indexPath.row];
    detail.selectedImage = img;
    
    NSLog(@"%@", img.name);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
