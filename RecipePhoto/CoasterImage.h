//
//  CoasterImage.h
//  RecipePhoto
//
//  Created by Don Browning on 11/15/13.
//  Copyright (c) 2013 Don Browning. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! represents an image stored in the plist
 */

@interface CoasterImage : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *filename;
@property  int count;

@end
