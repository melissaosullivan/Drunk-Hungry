//
//  Foursquare.h
//  drunkh
//
//  Created by Serena Simkus on 9/29/13.
//  Copyright (c) 2013 Serena Simkus. All rights reserved.
//
#import "JSONModel.h"
#import "Venues.h"

@interface Foursquare : JSONModel
@property (strong, nonatomic) NSArray<Venues>* venues;
@end

