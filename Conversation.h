//
//  Conversation.h
//  GeoChat
//
//  Created by Ivan Diaz on 6/2/15.
//  Copyright (c) 2015 Ivan Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@interface Conversation : NSObject

@property NSMutableArray *messages;
@property NSUInteger userID; // other users ID

-(instancetype)initWithUserId:(NSUInteger)userID WithMessage:(Message*) msg;
-(instancetype)initWithUserId:(NSUInteger)id;
@end
