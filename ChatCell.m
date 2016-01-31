//
//  ChatCell.m
//  GeoChat
//
//  Created by Ivan Diaz on 6/5/15.
//  Copyright (c) 2015 Ivan Diaz. All rights reserved.
//

#import "ChatCell.h"

@implementation ChatCell

- (void)awakeFromNib {
    self.contentView.layoutMargins = UIEdgeInsetsMake(0, 0, 0,0);
    _isLeftConstraint = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse {
    if (!_isLeftConstraint) {
        [self.contentView addConstraint:self.leftConstraint];
        _isLeftConstraint = YES;
    }
}

@end
