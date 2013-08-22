//
//  ContentTableViewCell.h
//  CloudBooth
//
//  Created by Ares on 13-8-9.
//  Copyright (c) 2013年 watermelontech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentTableViewCell : UITableViewCell

// cell image view
@property (nonatomic, readonly) UIImageView *cellImageView;

// cell title label
@property (nonatomic, readonly) UILabel *cellTitleLabel;

// cell content label
@property (nonatomic, readonly) UILabel *cellContentLabel;

// cell number of be read label
@property (nonatomic, readonly) UILabel *cellNumberOfBeenReadLabel;

// the height of content table view cell
+ (CGFloat)cellHeight;

@end
