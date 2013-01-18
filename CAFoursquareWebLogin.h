//
//  CAFoursquareWebLogin.h
//
//  Created by Carlos Arenas on 2/27/12.
//  Copyright (c) 2012 Polygon Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAFoursquareWebLogin : UIViewController <UIWebViewDelegate>{
	NSString *_url;
	UIWebView *webView;
	id delegate;
	SEL selector;
}

@property(nonatomic,assign) id delegate;
@property (nonatomic,assign)SEL selector;

- (id)initWithUrl:(NSString*)url;

@end