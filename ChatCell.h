//
//  ChatCell.h
//  GeoChat
//
//  Created by Ivan Diaz on 6/5/15.
//  Copyright (c) 2015 Ivan Diaz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCell : UITableViewCell
@property (nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bubbleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bubbleWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageHeight;
@property (nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property BOOL isLeftConstraint;

@end
