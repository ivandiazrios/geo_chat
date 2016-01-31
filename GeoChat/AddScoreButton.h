//
//  AddScoreButton.h
//  GeoChat
//
//  Created by Henry Turner on 03/06/2015.
//  Copyright (c) 2015 Ivan Diaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface AddScoreButton : UIButton

@property NSInteger msgId;
@property Message* message;

@end
