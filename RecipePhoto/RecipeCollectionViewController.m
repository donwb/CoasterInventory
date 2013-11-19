//
//  RecipeCollectionViewController.m
//  RecipePhoto
//
//  Created by Don Browning on 11/15/13.
//  Copyright (c) 2013 Don Browning. All rights reserved.
//

#import "RecipeCollectionViewController.h"
#import "CoasterImage.h"

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
                           
    //UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    UIButton *imageButton = (UIButton *) [cell viewWithTag:100];
    
    UILabel *label = (UILabel *)[cell viewWithTag:1000];

    
    CoasterImage *img = [self.photos objectAtIndex:indexPath.row];
    
    //recipeImageView.image = [UIImage imageNamed:img.filename];
    [imageButton setTitle:@"" forState:UIControlStateNormal];
    [imageButton setBackgroundImage:[UIImage imageNamed:img.filename] forState:UIControlStateNormal];
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

- (IBAction)imageTapped:(id)sender {
    UIButton *b = (UIButton *)sender;
    
    UICollectionViewCell *cell =  (UICollectionViewCell *)[b superview];
    NSArray *subviews = [cell subviews];
    
    // This is kinda hacky.. what if the label isn't element 0?
    UILabel *label = (UILabel *) [subviews objectAtIndex:0];
    UILabel *count = (UILabel *) [subviews objectAtIndex:2];
    
    NSLog(label.text);
    NSString *val = count.text;
    NSInteger i = [val intValue];
    i++;
    
    count.text = [NSString stringWithFormat:@"%d", i];
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
