//
//  ContentTableViewCell.m
//  CloudBooth
//
//  Created by Ares on 13-8-9.
//  Copyright (c) 2013年 watermelontech. All rights reserved.
//

#import "ContentTableViewCell.h"

// content table view cell height
#define CONTENT_TABLEVIEWCELL_HEIGHT    80.0

// cell components margin and padding
#define MARGIN  2.0
#define PADDING_LR  10.0
#define PADDING_TB  2.0

// cell image view border view width and height
#define CELL_IMAGEVIEWBORDERVIEW_WIDTH  100.0
#define CELL_IMAGEVIEWBORDERVIEW_HEIGHT (CONTENT_TABLEVIEWCELL_HEIGHT - 2 * MARGIN)

// cell title and content label width
#define CELL_TITLE7CONTENTLABEL_WIDTH   146.0

// cell number of be read label width and height
#define CELL_NUMBEROFBEREADLABEL_WIDTH7HEIGHT   22.0

@implementation ContentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // init subviews
        // cell image view border view
        UIView *_cellImageViewBorderView = [[UIView alloc] init];
        
        // set frame
        [_cellImageViewBorderView setFrame:CGRectMake(self.contentView.bounds.origin.x + MARGIN, self.contentView.bounds.origin.y + MARGIN, CELL_IMAGEVIEWBORDERVIEW_WIDTH, CELL_IMAGEVIEWBORDERVIEW_HEIGHT)];
        
        // set background color
        _cellImageViewBorderView.backgroundColor = [UIColor lightGrayColor];
        
        // cell image view
        _cellImageView = [[UIImageView alloc] init];
        
        // set frame
        [_cellImageView setFrame:CGRectMake(_cellImageViewBorderView.bounds.origin.x + MARGIN, _cellImageViewBorderView.bounds.origin.y + MARGIN, _cellImageViewBorderView.bounds.size.width - 2 * MARGIN, _cellImageViewBorderView.bounds.size.height - 2 * MARGIN)];
        
        // set content mode
        _cellImageView.contentMode = UIViewContentModeScaleToFill;
        
        // add as subview of cell image view border view
        [_cellImageViewBorderView addSubview:_cellImageView];
        
        // cell title label
        _cellTitleLabel = [[UILabel alloc] init];
        
        // set frame
        [_cellTitleLabel setFrame:CGRectMake(_cellImageViewBorderView.frame.origin.x + CELL_IMAGEVIEWBORDERVIEW_WIDTH + PADDING_LR, _cellImageViewBorderView.frame.origin.y, CELL_TITLE7CONTENTLABEL_WIDTH, (CELL_IMAGEVIEWBORDERVIEW_HEIGHT - PADDING_TB) / 2.0)];
        
        // cell content label
        _cellContentLabel = [[UILabel alloc] init];
        
        // set frame
        [_cellContentLabel setFrame:CGRectMake(_cellTitleLabel.frame.origin.x, _cellTitleLabel.frame.origin.y + _cellTitleLabel.bounds.size.height + PADDING_TB, _cellTitleLabel.bounds.size.width, _cellTitleLabel.bounds.size.height)];
        
        // set text color and font
        _cellContentLabel.textColor = [UIColor darkGrayColor];
        _cellContentLabel.font = [UIFont systemFontOfSize:13.0];
        
        // cell number of been read label
        _cellNumberOfBeenReadLabel = [[UILabel alloc] init];
        
        // set frame
        [_cellNumberOfBeenReadLabel setFrame:CGRectMake(_cellTitleLabel.frame.origin.x + CELL_TITLE7CONTENTLABEL_WIDTH + PADDING_LR, self.contentView.bounds.origin.y + (CONTENT_TABLEVIEWCELL_HEIGHT - CELL_NUMBEROFBEREADLABEL_WIDTH7HEIGHT) / 2.0, CELL_NUMBEROFBEREADLABEL_WIDTH7HEIGHT, CELL_NUMBEROFBEREADLABEL_WIDTH7HEIGHT)];
        
        // set text color, alignmenet and font
        _cellNumberOfBeenReadLabel.textColor = [UIColor darkGrayColor];
        _cellNumberOfBeenReadLabel.textAlignment = NSTextAlignmentRight;
        _cellNumberOfBeenReadLabel.font = [UIFont systemFontOfSize:13.0];
        
        // add cell image border view, title, content and number of be read label as subview of content view
        [self.contentView addSubview:_cellImageViewBorderView];
        [self.contentView addSubview:_cellTitleLabel];
        [self.contentView addSubview:_cellContentLabel];
        [self.contentView addSubview:_cellNumberOfBeenReadLabel];
        
        // set cell accessory type
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight
{
    // content table view cell height
    return CONTENT_TABLEVIEWCELL_HEIGHT;
}

@end
