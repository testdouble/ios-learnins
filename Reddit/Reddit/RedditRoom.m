//
//  RedditRoom.m
//  Reddit
//
//  Created by Tim Taylor on 2/5/15.
//  Copyright (c) 2015 Amber Conville. All rights reserved.
//

#import "RedditRoom.h"

@implementation RedditRoom

+ (instancetype)roomWithJSON:(NSDictionary*)json {
    RedditRoom *room = [[self alloc] init];

    room.name = [json valueForKeyPath:@"data.name"];
    room.url = [json valueForKeyPath:@"data.url"];
    return room;
}

@end
