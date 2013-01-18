//
//  Foursquare_API.h
//
//  Created by Carlos Arenas on 2/27/12.
//  Copyright (c) 2012 Polygon Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Foursquare2.h"

@interface CAFoursquare_API : NSObject{
}

- (void)initFourquare:(NSString *)venueID comment:(NSString *)comment vc:(UIViewController *)vc;
- (void)authorizeWithViewController:(UIViewController*)controller Callback:(Foursquare2Callback)callback;
- (void)setCode:(NSString*)code;

@end

