//
//  RedditRoom.h
//  Reddit
//
//  Created by Tim Taylor on 2/5/15.
//  Copyright (c) 2015 Amber Conville. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedditRoom : NSObject

@property (strong, nonatomic) NSString *name;

+ (instancetype)roomWithJSON:(NSDictionary*)json;

@end
