//
//  SimpleWebViewController.m
//  ios_twitter_clone
//
//  Created by Victor Liew on 5/31/15.
//  Copyright (c) 2015 alcedo. All rights reserved.
//

#import "SimpleWebViewController.h"

@interface SimpleWebViewController ()

@property(nonatomic, strong) UIWebView* webView;

/**
 *  The webview controller will load the url specified here.
 */
@property(nonatomic, strong) NSString* urlToLoad;

@end

@implementation SimpleWebViewController


- (instancetype)initWithUrlToLoad:(NSString *)url {
    
    if (self = [super init]) {
        self.urlToLoad = url;
        if (self.urlToLoad == nil) {
            self.urlToLoad = @"";
        }
    }
    
    return self;
}

#pragma mark - ViewController Lifecycle

- (void)loadView {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.view = self.webView;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(didTapCloseButton)];
}

-(void)didTapCloseButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Setup

- (void) loadWebView {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlToLoad]]];
}

@end
