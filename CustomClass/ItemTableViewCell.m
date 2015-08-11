//
//  ItemTableViewCell.m
//  WebFS Manager
//
//  Created by Florian Coulon on 10/08/15.
//  Copyright (c) 2015 Florian Coulon. All rights reserved.
//

#import "ItemTableViewCell.h"

@implementation ItemTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.image = [[AsyncImageView alloc] init];
        self.image.contentMode = UIViewContentModeScaleAspectFill;
        self.image.clipsToBounds = YES;
        self.image.showActivityIndicator = NO;
        self.image.hidden = YES;
        [self.contentView insertSubview:self.image belowSubview:self.textLabel];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void) buildCellWithItem:(NSString *)item andPath:(NSString *) path {
    [WebFSManager getMeta:path file:item completionBlock:^(BOOL success, NSDictionary *result) {
        NSLog(@"%@\n%@", success ? @"Yes" : @"No", result);
        if ([[result objectForKey:@"mimetype"] isEqualToString:@"inode/directory"]) {
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.type = 0;
        }
        else if ([[result objectForKey:@"mimetype"] isEqualToString:@"image/jpeg"]) {
            self.image.frame = self.contentView.bounds;
            if ([path isEqualToString:@""])
                self.image.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_ENDPOINT, path, item]];
            else
                self.image.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@", API_ENDPOINT, path, item]];
            self.image.hidden = NO;
            self.textLabel.textColor = [UIColor whiteColor];
            self.textLabel.layer.shadowOpacity = 1.0;
            self.textLabel.layer.shadowRadius = 3.0;
            self.textLabel.layer.shadowColor = [UIColor blackColor].CGColor;
            self.textLabel.layer.shadowOffset = CGSizeMake(0.0, 0.0);
            self.type = 1;
        }
        else if ([[result objectForKey:@"mimetype"] isEqualToString:@"audio/mpeg"]) {
            self.type = 3;
        }
        else if ([[result objectForKey:@"mimetype"] isEqualToString:@"video/mp4"] || [[result objectForKey:@"mimetype"] isEqualToString:@"video/x-msvideo"]) {
            self.type = 2;
        }
        self.textLabel.text = item;
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
