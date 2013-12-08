//
//  RecipeCollectionViewController.m
//  RecipePhoto
//
//  Created by Don Browning on 11/15/13.
//  Copyright (c) 2013 Don Browning. All rights reserved.
//

#import "RecipeCollectionViewController.h"
#import "CoasterImage.h"
#import "JSCustomBadge.h"

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
    
    self.photos = photos;
    
    for (CoasterImage *img in photos) {
        img.count = 0;
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.backgroundView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"photo-frame"]];
                           
    UIButton *imageButton = (UIButton *) [cell viewWithTag:100];
    
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    UILabel *countLabel = (UILabel *)[cell viewWithTag:2000];

    
    CoasterImage *img = [self.photos objectAtIndex:indexPath.row];
    
    [imageButton setTitle:@"" forState:UIControlStateNormal];
    [imageButton setBackgroundImage:[UIImage imageNamed:img.filename] forState:UIControlStateNormal];
    label.text = img.name;
    countLabel.text = [NSString stringWithFormat:@"%d", img.count];
    
    
    /* This is the custom badge code,
     it doesn't work b/c of the odd lifecycle stuff
     when you scroll the view out of the viewable area
     
    JSCustomBadge *badge = [JSCustomBadge customBadgeWithString:@"0"];
    CGSize size = badge.frame.size;
    badge.frame = CGRectMake(68.0f, 0.4f, size.width, size.height);
    
    [cell.contentView addSubview:badge];
    */
    

    return cell;
}


- (NSArray *) loadFromPList {
    NSURL *plistURL = [[NSBundle mainBundle] URLForResource:@"images" withExtension:@"plist"];
    
    NSArray *photos = [NSArray arrayWithContentsOfURL:plistURL];
    
    NSMutableArray *photoList = [NSMutableArray array];
    
    for(id photo in photos)
    {
        CoasterImage *image = [[CoasterImage alloc]init];
        NSString *name = photo[@"name"];
        
        image.name = [name capitalizedString];
        image.filename = photo[@"filename"];
        
        [photoList addObject:image];
        
    }
    
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject: sortDescriptor];
    
    NSArray *sortedArray = [photoList sortedArrayUsingDescriptors:sortDescriptors];
    NSMutableArray *returnArray = [NSMutableArray arrayWithArray:sortedArray];
    
    return returnArray;
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
  
    
/*
 More badge code i had to pull for now
 
    UICollectionViewCell *topCell = (UICollectionViewCell *) [cell superview];

    NSArray *topSubviews = [topCell.contentView subviews];
    JSCustomBadge *badge = [[topSubviews objectAtIndex:4];
*/
    
    for (CoasterImage *img in self.photos) {
        if ([img.name isEqualToString:label.text]) {
            NSLog(@"Fount it %@", label.text);
            
            if(inc){img.count++;}else{img.count--;}
            
            countLabel.text = [NSString stringWithFormat:@"%d", img.count];
//            [badge autoBadgeSizeWithString:[NSString stringWithFormat:@"%d", img.count]];
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
