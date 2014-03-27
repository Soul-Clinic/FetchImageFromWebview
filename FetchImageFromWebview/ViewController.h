//
//  ViewController.h
//  FetchImageFromWebview
//
//  Created by Can EriK Lu on 3/25/14.
//  Copyright (c) 2014 Can EriK Lu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;



@end
