//
//  Post.h
//  GeoChat
//
//  Created by Ivan Diaz on 6/12/15.
//  Copyright (c) 2015 Ivan Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

@property NSUInteger score;
@property NSString *message;

-(id)initWithScore:(NSUInteger)score withMessage:(NSString*)m;

@end
