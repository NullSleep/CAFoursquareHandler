//
//  Foursquare_API.m
//
//  Created by Carlos Arenas on 2/27/12.
//  Copyright (c) 2012 Polygon Mobile. All rights reserved.
//

#import "CAFoursquare_API.h"
#import "CAFoursquareWebLogin.h"

@implementation CAFoursquare_API

- (void)initFourquare:(NSString *)venueID comment:(NSString *)comment vc:(UIViewController *)vc{
	if([Foursquare2 isNeedToAuthorize]){
		[self authorizeWithViewController:vc 
                                 Callback:^(BOOL success,id result){
			if(success){
				[Foursquare2 getDetailForUser:@"self" callback:^(BOOL success, id result){
                    if(success){
                        [self detailsForUser:venueID comment:comment];
                    }
                    else{
                        NSLog(@"> FOURSQUARE ERROR: Can't get details for first time user.");
                    }
                }];
			}
		}];
	}
    else{
		[Foursquare2 getDetailForUser:@"self" callback:^(BOOL success, id result){
            if(success){
                [self detailsForUser:venueID comment:comment];
            }
            else{
                NSLog(@"> FOURSQUARE ERROR: Can't get details for returning user.");
            }
        }];
	}
}

- (void)detailsForUser:(NSString *)venueID comment:(NSString *)comment{
    [Foursquare2 createCheckinAtVenue:venueID
                                venue:nil
                                shout:comment
                            broadcast:broadcastPublic
                             latitude:nil
                            longitude:nil
                           accuracyLL:nil
                             altitude:nil
                          accuracyAlt:nil
                             callback:^(BOOL success, id result){
                                 if(success){
                                     NSLog(@"FOURSQUARE > Success: %@", result);
                                     [[NSNotificationCenter defaultCenter]postNotificationName:@"ACTIVITY_CHECK_IN_FOURSQUARE_SUCCESS_NOTIFICATION" object:self userInfo:nil];
                                 }
                                 else{
                                     NSLog(@"> FOURSQUARE ERROR: Can't check in");
                                 }
                             }
     ];
}

Foursquare2Callback authorizeCallbackDelegate;
- (void)authorizeWithViewController:(UIViewController*)controller Callback:(Foursquare2Callback)callback{
	authorizeCallbackDelegate = [callback copy];
	NSString *url = [NSString stringWithFormat:@"https://foursquare.com/oauth2/authenticate?display=touch&client_id=%@&response_type=code&redirect_uri=%@",OAUTH_KEY,REDIRECT_URL];
	CAFoursquareWebLogin *loginCon = [[CAFoursquareWebLogin alloc] initWithUrl:url];
	loginCon.delegate = self;
	loginCon.selector = @selector(setCode:);

	UINavigationController *navCon = [[UINavigationController alloc]initWithRootViewController:loginCon];
	[controller presentModalViewController:navCon animated:YES];
    [navCon release];
    
	[loginCon release];
}

- (void)setCode:(NSString*)code{
	[Foursquare2 getAccessTokenForCode:code callback:^(BOOL success,id result){
		if (success) {
			[Foursquare2 setBaseURL:[NSURL URLWithString:@"https://api.foursquare.com/v2/"]];
			[Foursquare2 setAccessToken:[result objectForKey:@"access_token"]];
			authorizeCallbackDelegate(YES,result);
            [authorizeCallbackDelegate release];
		}
	}];
}

@end