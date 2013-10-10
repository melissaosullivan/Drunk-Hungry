//
//  Venues.h
//  drunkh
//
//  Created by Serena Simkus on 9/29/13.
//  Copyright (c) 2013 Serena Simkus. All rights reserved.
//

#import "JSONModel.h"

@protocol Venues
@end

@interface Venues : JSONModel
    @property (strong, nonatomic) NSString *lat;
    @property (strong, nonatomic) NSString *lng;
    @property (strong, nonatomic) NSString *name;
    @property (strong, nonatomic) NSString *photo;
@end
