//
//  Post.m
//  GeoChat
//
//  Created by Ivan Diaz on 6/12/15.
//  Copyright (c) 2015 Ivan Diaz. All rights reserved.
//

#import "Post.h"

@implementation Post

-(id)initWithScore:(NSUInteger)score withMessage:(NSString*)m {
    if (self = [super init]) {
        _score = score;
        _message = m;
    }
    return self;
}

@end
