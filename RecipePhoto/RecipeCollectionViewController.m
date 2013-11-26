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
    
    for (CoasterImage *img in photos) {
        img.count = 0;
    }
    
    // Staple in a count value to the first coaster
    //CoasterImage *img = (CoasterImage *) [self.photos objectAtIndex:0];
    //img.count = 45;
    
    
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
    UILabel *countLabel = (UILabel *)[cell viewWithTag:2000];

    
    CoasterImage *img = [self.photos objectAtIndex:indexPath.row];
    
    //recipeImageView.image = [UIImage imageNamed:img.filename];
    [imageButton setTitle:@"" forState:UIControlStateNormal];
    [imageButton setBackgroundImage:[UIImage imageNamed:img.filename] forState:UIControlStateNormal];
    label.text = img.name;
    countLabel.text = [NSString stringWithFormat:@"%d", img.count];
    
    
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

- (IBAction)decrementButton:(id)sender {
    NSLog(@"down");
    
    UIButton *b = (UIButton *) sender;
    [self modifyCount:b incrementCount:false];
}

- (IBAction)imageTapped:(id)sender {
    
    UIButton *b = (UIButton *)sender;
    [self modifyCount:b  incrementCount:true];
}

- (void) modifyCount:(UIButton *) b incrementCount:(bool)inc {
    
    UICollectionViewCell *cell =  (UICollectionViewCell *)[b superview];
    NSArray *subviews = [cell subviews];
    
    // This is kinda hacky.. what if the label isn't element 0?
    UILabel *label = (UILabel *) [subviews objectAtIndex:0];
    UILabel *countLabel = (UILabel *) [subviews objectAtIndex:2];
    
    
    for (CoasterImage *img in self.photos) {
        if ([img.name isEqualToString:label.text]) {
            NSLog(@"Fount it %@", label.text);
            
            if(inc){img.count++;}else{img.count--;}
            
            countLabel.text = [NSString stringWithFormat:@"%d", img.count];
        }
    }
}


- (IBAction)exportInventory:(id)sender {
    NSString *shareInfo = [self createEmail];
    
    
    UIActivityViewController* avc = [[UIActivityViewController alloc] initWithActivityItems:@[shareInfo] applicationActivities:nil];
    
    NSArray *excludedActivities = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,
                                    UIActivityTypePostToWeibo,
                                    UIActivityTypeMessage,
                                    UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                    UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    avc.excludedActivityTypes = excludedActivities;
    [avc setValue:@"Inventory Export" forKey:@"subject"];
    
    [self presentViewController:avc animated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Are you sure?" message:@"Are you sure you want to clear the inventory numbers"
                                                   delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1){
        for(CoasterImage *i in self.photos){
            i.count = 0;
        }
        
        [self.collectionView reloadData];
    }
}

- (NSString *)createEmail {
    NSMutableString *out = [[NSMutableString alloc] init];
    
    for(CoasterImage *i in self.photos) {
        if(i.count > 0) {
            [out appendString:i.name];
            [out appendString:@" - "];
            [out appendString:[NSString stringWithFormat:@"%i",i.count]];
            [out appendString:@"\n"];
        }
    }
    
    return out;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
