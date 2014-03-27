//
//  ViewController.m
//  FetchImageFromWebview
//
//  Created by Can EriK Lu on 3/25/14.
//  Copyright (c) 2014 Can EriK Lu. All rights reserved.
//

#import "ViewController.h"
#import "Common.h"
@interface ViewController ()
{
    BOOL imageSelected;
}
@end

@implementation ViewController

#pragma mark - Webview delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//	NSLog(@"Main: %@	\tCurrent: %@    %i", request.mainDocumentURL, request.URL, (int)navigationType);
    if (imageSelected && navigationType == UIWebViewNavigationTypeLinkClicked) {
        imageSelected = NO;
        NSLog(@"Not jump");
        return NO;
    }
    return YES;
}
- (IBAction)longPressed:(UILongPressGestureRecognizer*)recognizer
{
	[self tap:recognizer];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    UILongPressGestureRecognizer* longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    longPressed.delegate = self;
    [self.webView addGestureRecognizer:longPressed];
//	tap.delegate = self;
//    [[self.webView.subviews[0] subviews][0] addGestureRecognizer:tap];
    self.webView.delegate = self;
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://wallcoo.com"]];
    [self.webView loadRequest:requestObj];
    self.webView.alpha = 0.8;
    NSLog(@"Recognizers are %@ ", self.webView.gestureRecognizers);
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.webView printSubviewsTree];

}
- (IBAction)tap:(UIGestureRecognizer*)sender
{
    CGPoint touchPoint = [sender locationInView:self.webView];
	NSLog(@"Hello from (%f, %f)", touchPoint.x, touchPoint.y);
//    const char * ss = "var element = document.elementFromPoint(%f, %f);"
//    "var openTag = \"<\"+element.tagName.toLowerCase();"
//    "for (var i = 0; i < element.attributes.length; i++) {"
//    "   var attrib = element.attributes[i];"
//    "  openTag += \" \" + attrib.name + \"='\" + attrib.value + \"'\";"
//    "}"
//    "openTag += \" />\";"
//    "openTag";
//    NSString* script = [NSString stringWithUTF8String:ss];
//    NSString *element = [NSString stringWithFormat:script, touchPoint.x, touchPoint.y];
//	NSLog(@"Element is %@",[self.webView stringByEvaluatingJavaScriptFromString:element]);

    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    NSString *urlToSave = [self.webView stringByEvaluatingJavaScriptFromString:imgURL];
//    NSLog(@"urlToSave :%@",urlToSave);
	if (urlToSave.length == 0) {
        return;
    }
	imageSelected = YES;
    NSURL * imageURL = [NSURL URLWithString:urlToSave];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage * image = [UIImage imageWithData:imageData];

	static UIImageView* imageV;
    if (!imageV) {
        imageV = [[UIImageView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:imageV];
        [self.view sendSubviewToBack:imageV];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
    }
    imageV.image = image;//imgView is the reference of UIImageView
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Save %@", image);
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    else {
        NSLog(@"Not save %@", image);
    }


}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    NSLog(@"Touch");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
     otherGestureRecognizer.cancelsTouchesInView = NO;

    if ([otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        otherGestureRecognizer.enabled = NO;
        NSLog(@"Long");
    }
    NSLog(@"Simultaneously %@ and %@", gestureRecognizer.class, otherGestureRecognizer.class);
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    NSLog(@"TAPPED %@", NSStringFromCGPoint([gestureRecognizer locationInView:self.view]) );
    return YES;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"Should %@ begin", gestureRecognizer.class);
    return YES;
}
@end
