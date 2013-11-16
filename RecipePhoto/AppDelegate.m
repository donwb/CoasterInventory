//
//  AppDelegate.m
//  RecipePhoto
//
//  Created by Don Browning on 11/15/13.
//  Copyright (c) 2013 Don Browning. All rights reserved.
//

#import "AppDelegate.h"
#import "CoasterImage.h"
#import "RecipeCollectionViewController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    /*
    NSArray *photos = [self loadFromPList];
    RecipeCollectionViewController *viewController = (RecipeCollectionViewController *) self.window.rootViewController;
    
    viewController.photos = photos;
    */
    
    return YES;
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

@end
