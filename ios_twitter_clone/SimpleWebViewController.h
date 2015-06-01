//
//  SimpleWebViewController.h
//  ios_twitter_clone
//
//  Created by Victor Liew on 5/31/15.
//  Copyright (c) 2015 alcedo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleWebViewController : UIViewController
/**
 *  Constructor to init a WebViewController with a specified url that is to be
 *  loaded on initialisation.
 */
- (instancetype)initWithUrlToLoad:(NSString *)url;
@end
