//
//  Conversation.m
//  GeoChat
//
//  Created by Ivan Diaz on 6/2/15.
//  Copyright (c) 2015 Ivan Diaz. All rights reserved.
//

#import "Conversation.h"

@implementation Conversation

-(instancetype)initWithUserId:(NSUInteger)userID WithMessage:(Message *)msg {
    if (self = [super init]) {
        self.messages = [[NSMutableArray alloc] initWithObjects:msg, nil];
        self.userID = msg.userID;
    }
    return self;
}

-(instancetype)initWithUserId:(NSUInteger)userID {
    if (self = [super init]) {
        self.messages = [[NSMutableArray alloc] init];
        self.userID = userID;
    }
    return self;
}

@end
