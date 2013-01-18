//
//  CAFoursquareWebLogin.m
//
//  Created by Carlos Arenas on 2/27/12.
//  Copyright (c) 2012 Polygon Mobile. All rights reserved.
//

#import "CAFoursquareWebLogin.h"
#import "Foursquare2.h"

@implementation CAFoursquareWebLogin
@synthesize delegate,selector;

- (id) initWithUrl:(NSString*)url{
	self = [super init];
	if (self != nil) {
		_url = url;
	}
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
    
    self.navigationItem.title=@"Foursquare Login";
    
	webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url]];
	[webView loadRequest:request];
	[webView setDelegate:self];
	[self.view addSubview:webView];
    
    UIBarButtonItem *cancelBtn=[[UIBarButtonItem alloc] initWithTitle:@"cancel"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem=cancelBtn;
    
    [webView release];
}

-(void)cancel{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Foursquare_Canceled" object:self userInfo:nil];
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	NSString *url =[[request URL] absoluteString];
    
    if([url rangeOfString:@"facebook.com"].location != NSNotFound){ //< To fix the foursquare crash caused by facebook login
        return YES; //Ignores the Facebook authentication
    }
	
    if([url rangeOfString:@"code="].length != 0){
		NSHTTPCookie *cookie;
		NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
		for (cookie in [storage cookies]) {
			if ([[cookie domain]isEqualToString:@"foursquare.com"]) {
				[storage deleteCookie:cookie];
			}
		}
		
		NSArray *arr = [url componentsSeparatedByString:@"="];
		[delegate performSelector:selector withObject:[arr objectAtIndex:1]];
		[self cancel];
	}
    else if([url rangeOfString:@"error="].length != 0){
		NSArray *arr = [url componentsSeparatedByString:@"="];
		[delegate performSelector:selector withObject:[arr objectAtIndex:1]];
		NSLog(@"Foursquare: %@",[arr objectAtIndex:1]);
	} 
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

- (void)dealloc{
    [super dealloc];
}

@end