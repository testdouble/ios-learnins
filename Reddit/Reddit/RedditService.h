//
//  RedditService.h
//  Reddit
//
//  Created by Amber Conville on 1/29/15.
//  Copyright (c) 2015 Amber Conville. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedditService : NSObject

-(void)getPosts:(void (^)(NSArray *))callback;

@end
