//
//  ItemTableViewCell.h
//  WebFS Manager
//
//  Created by Florian Coulon on 10/08/15.
//  Copyright (c) 2015 Florian Coulon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemTableViewCell : UITableViewCell
// Property
@property (nonatomic) AsyncImageView *image;
@property (nonatomic) int type;
/*****
 
 0 : directory
 1 : image
 2 : movie / video
 3 : music
 
 *****/

// Methode
- (void) buildCellWithItem:(NSString *)item andPath:(NSString *) path;

@end
