//
//  Common.m
//  Scratch
//
//  Created by Can EriK Lu on 9/3/13.
//  Copyright (c) 2013 Can EriK Lu. All rights reserved.
//

#import "Common.h"
#import <sys/utsname.h>
#define kUMengEventError			@"Error"


NSString* machineName()
{
    struct utsname systemInfo;
    uname(&systemInfo);

    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

NSString* systemInfo(NSString* productName)
{
	NSString* productVersion = [NSBundle mainBundle].infoDictionary[(NSString*)kCFBundleVersionKey];
    NSString* machinVersion = machineName();
    if ([machinVersion hasPrefix:@"iPhone6"]) {
        machinVersion = [machinVersion stringByAppendingString:@"(iPhone 5s)"];
    }
    UIDevice *device = [UIDevice currentDevice];
    NSString* systemInfo = [NSString stringWithFormat:@"%@(%@)",device.systemName, device.systemVersion];
    NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSString* localeIdentifier = [[NSLocale currentLocale] localeIdentifier];
    NSString* locale = [NSString stringWithFormat:@"%@ %@", localeIdentifier, [enLocale displayNameForKey:NSLocaleIdentifier value:localeIdentifier]];

    NSString* information = [NSString stringWithFormat:
                             @"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n---------------------------------------\nSystem:%@\nDevice:%@\n%@ version:%@\nLocale:%@\n---------------------------------------\n",
                             systemInfo, machinVersion, productName, productVersion, locale];

    return information;
}

UIColor* rgba(int r, int g, int b, float a)
{
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a];;
}
UIColor* rgb(int r, int g, int b)
{
    return rgba(r, g, b, 1.0);
}

NSArray* imagesWithNames(NSArray* names)
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:names.count];

    for (NSString* name in names) {
        [array addObject:[UIImage imageNamed:name]];
    }
    return array;
}
BOOL isRetina()
{
	return [UIScreen mainScreen].scale == 2.0;
}

NSString* documentDirectory()
{
    static NSString* path;
    if (!path) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        path = paths[0];
        FELog(@"Document directory -> %@", path);
    }

    return path;
}

NSString* deviceInformation()
{
    UIDevice *device = [UIDevice currentDevice];

    return [NSString stringWithFormat:@"\nMachine Name = %@\nName = %@\nSystem Name = %@\t System version = %@\nModal = %@\tLocalized Modal = %@\nIdiom = %@\nDevice ID = %@\nLocale lanugate = %@", machineName(),
            device.name, device.systemName, device.systemVersion, device.model, device.localizedModel,
            device.userInterfaceIdiom == UIUserInterfaceIdiomPhone ? @"UIUserInterfaceIdiomPhone" : @"UIUserInterfaceIdiomPad" , device.identifierForVendor.UUIDString, [NSLocale preferredLanguages][0]];

}
#pragma mark - Objects related
@implementation NSObject (debug)
- (void)printClassTrees
{
    Class class = [self class];
	NSLog(@"Self --> %@", NSStringFromClass(class));

    while ([class superclass] != [NSObject class]) {
        class = [class superclass];
        NSLog(@"Super -> %@", NSStringFromClass(class));
    }

    NSLog(@"Super -> NSObject\n-------------\n");
}
@end
#pragma mark -

BOOL isSimulator()
{
#if TARGET_IPHONE_SIMULATOR
    //[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kBinaryName];
    return YES;
#else
	return NO;
#endif

}

BOOL isiOS7() {
    return floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1;
}

void logSize(NSString* format, CGSize size)
{
    NSLog(format, NSStringFromCGSize(size));
}
void logFrame(NSString* text, UIView* view)
{
    FELog(@"%@  -->  %@", text, NSStringFromCGRect(view.frame));
}
void FELogError(NSString* format, ...)
{
    va_list args;
    va_start(args, format);
#ifdef __FEDEBUG
    NSLogv(format, args);
#else
//    NSString* content = [[NSString alloc] initWithFormat:format arguments:args];
//	[MobClick event:kUMengEventError label:content];
#endif
    va_end(args);

}
NSString* getLanguageCode(void)
{
    return [[NSLocale preferredLanguages] objectAtIndex:0];
}


@implementation UIView (Position)

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)newOrigin {
    self.frame = CGRectMake(newOrigin.x, newOrigin.y, self.frame.size.width, self.frame.size.height);
}

- (CGSize)frameSize {
    return self.frame.size;
}

- (void)setFrameSize:(CGSize)newSize {
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            newSize.width,
                            newSize.height);
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)newX {
    self.frame = CGRectMake(newX,
                            self.frame.origin.y,
                            self.frame.size.width,
                            self.frame.size.height);
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)newY {
    self.frame = CGRectMake(self.frame.origin.x,
                            newY,
                            self.frame.size.width,
                            self.frame.size.height);
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)newRight {
    self.frame = CGRectMake(newRight - self.frame.size.width,
                            self.frame.origin.y,
                            self.frame.size.width,
                            self.frame.size.height);
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)newBottom {
    self.frame = CGRectMake(self.frame.origin.x,
                            newBottom - self.frame.size.height,
                            self.frame.size.width,
                            self.frame.size.height);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)newWidth {
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            newWidth,
                            self.frame.size.height);
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)boundsHeight
{
    return self.bounds.size.height;
}

- (CGFloat)boundsWidth
{
    return self.bounds.size.width;
}

- (void)setHeight:(CGFloat)newHeight {
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            self.frame.size.width,
                            newHeight);
}

- (void)addCenteredSubview:(UIView *)subview {
    subview.x = (int)((self.bounds.size.width - subview.width) / 2);
    subview.y = (int)((self.bounds.size.height - subview.height) / 2);
    [self addSubview:subview];
}

- (void)moveToCenterOfSuperview {
    self.x = (int)((self.superview.bounds.size.width - self.width) / 2);
    self.y = (int)((self.superview.bounds.size.height - self.height) / 2);
}

- (void)centerVerticallyInSuperview
{
	self.y = (int)((self.superview.bounds.size.height - self.height) / 2);
}

- (void)centerHorizontallyInSuperview
{
	self.x = (int)((self.superview.bounds.size.width - self.width) / 2);
}

#pragma mark - Print
- (void)printSubviewsTree
{
    NSLog(@"==========================================================================");
    NSLog(@"%@ {(%.2f, %.2f) (%.2f, %.2f)}:\n",  self.class, self.x, self.y, self.width, self.height );
    NSLog(@" ");
    [self printSubviewsIndex:0];
    NSLog(@" ");
    NSLog(@"==========================================================================\n\n");
}

- (void)printSubviewsIndex:(int)index //Private
{
    NSMutableString *prefix = [NSMutableString stringWithString:@"\t|"];
    //    [prefix appendFormat:@"%d", index];
    for (int i = 0; i < index; i++) {
        [prefix appendString:@"————"];
    }

    for (UIView *subview in self.subviews) {
        NSLog(@"%@%@ \t{(%.2f, %.2f) (%.2f, %.2f)}",  prefix, subview.class, subview.x, subview.y, subview.width, subview.height );
        [subview printSubviewsIndex:index + 1];
    }
}
@end


@implementation UIColor(Image)

-(UIImage *)image
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}
@end


@implementation UIImage(Resize)

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {

    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);

    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return newImage;
}

@end




@implementation Common

+ (NSString*)textToHtml:(NSString*)htmlString
{
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&"  withString:@"&amp;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<"  withString:@"&lt;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@">"  withString:@"&gt;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"""" withString:@"&quot;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"'"  withString:@"&#039;"];
    htmlString = [@"<p>" stringByAppendingString:htmlString];
    htmlString = [htmlString stringByAppendingString:@"</p>"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"\n" withString:@"</p><p>"];

    while ([htmlString rangeOfString:@"  "].length > 0) {
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"  " withString:@"&nbsp;&nbsp;"];
    }
    return htmlString;
}


+ (UIViewController*)topViewController
{
    return [Common topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}


+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [Common topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [Common topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [Common topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

+ (NSMutableURLRequest*)jsonRequestURL:(NSURL*)url withParams:(NSDictionary*)params
{
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
	NSError* error;
	NSData* json = [NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:&error];
    NSLog(@"Json -> %@", [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding]);
    NSMutableData *body = [NSMutableData dataWithData:json];

    if (error != nil) {
        NSLog(@"Error when converting to json -> %@", error);
        return nil;
    }

    [request setHTTPBody:body];

    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", (int)([body length])];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];

    // set URL
    [request setURL:url];

    return request;
}

+ (NSMutableURLRequest*)requestURL:(NSURL*)url withParams:(NSDictionary*)params andImage:(UIImage*)image withName:(NSString*)imageFieldName
{
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString* const BoundaryConstant = @"----------Apps-with-Love";

    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];

    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];

    // post body
    NSMutableData *body = [NSMutableData data];

    // add params (all params are strings)
    for (NSString *key in params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", params[key]] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    if (image && imageFieldName) {

        // add image data
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        NSLog(@"Image data length = %i", (int)imageData.length);
        if (imageData) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", imageFieldName] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }

    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];

    // setting the body of the post to the reqeust
    [request setHTTPBody:body];

    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", (int)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];

    // set URL
    [request setURL:url];

    return request;
}

+ (UIImage*)imageFromText:(NSString*)text maxWidth:(float)width
{
    //    const float padding = 10, paddingBottom = 50;
    const float fontSize = 10.f;
    NSStringDrawingContext* dc = [[NSStringDrawingContext alloc] init];
    dc.minimumScaleFactor = [UIScreen mainScreen].scale;

    //   CGContextSetFillColorWithColor(context, [UIColor purpleColor].CGColor);		//Background
    //CGContextFillRect(context, rect);
    //		Or draw a background image
    UIEdgeInsets padding = UIEdgeInsetsMake(54, 45, 44, 50);
    UIImage* background = [[UIImage imageNamed:@"letterpaper.jpg"] resizableImageWithCapInsets:padding resizingMode:UIImageResizingModeStretch];

    NSLog(@"Image size = %@", NSStringFromCGSize(background.size));
    //iOS 7
    CGRect rect = [text boundingRectWithSize:CGSizeMake(background.size.width - padding.left - padding.right, MAXFLOAT)
                                     options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                  attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}
                                     context:dc];

    NSLog(@"Text boudning rect = %@", NSStringFromCGRect(rect));

	CGSize canvas = CGSizeMake(background.size.width, rect.size.height + padding.top + padding.bottom);

    UIGraphicsBeginImageContextWithOptions(canvas, NO, 0);

    //	CGContextRef context = UIGraphicsGetCurrentContext();
    [background drawInRect:CGRectMake(0, 0, canvas.width, canvas.height)];


    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:24];
    //    [attString addAttribute:NSParagraphStyleAttributeName
    //                      value:style
    //                      range:NSMakeRange(0, strLength)];

    [text drawInRect:UIEdgeInsetsInsetRect(CGRectMake(0, 0, canvas.width, canvas.height), padding) withAttributes:
     @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize],
       NSForegroundColorAttributeName: [UIColor blackColor]//,	NSParagraphStyleAttributeName: style
       }];

    NSString* brand = @"By Instantly";
	CGRect brandSize = [brand boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                           options:kNilOptions
                                        attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.f]}
                                           context:nil];
    //rect.size.width - brandSize.size.width - padding / 4     Draw in left in case of the Weibo logo
	CGRect drawingRect = CGRectMake(30, canvas.height - brandSize.size.height - 12, brandSize.size.width, brandSize.size.height);
    [brand drawInRect:drawingRect
       withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Thonburi" size:13.f], NSForegroundColorAttributeName:rgb(10, 140, 210)}];

    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData* jpeg = UIImageJPEGRepresentation(image, 1.f);
    NSData* png = UIImagePNGRepresentation(image);
    NSLog(@"Jpeg length = %i\tPng length = %i", (int)jpeg.length / 1024, (int)png.length / 1024);
    
    return image;
}


@end




static FECommon *kSingleton;

@implementation FECommon

+ (FECommon*)sharedInstance
{
    if (kSingleton == nil) {
        kSingleton = [[FECommon alloc] initSingleton];
    }

    return kSingleton;
}

- (id)initSingleton
{
    self = [super init];
    if (self) {
        _documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        _tmpPath = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
        _defaultUserAgent = [self generateDefaultUserAgent];

        //键盘
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }

    return self;
}

- (id)init
{
    return [self.class sharedInstance];
}

#pragma mark - Notification
- (void)keyboardWillShow:(NSNotification*)notification
{
    CGRect bounds = [[notification.userInfo valueForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    _keyboardWidth = bounds.size.width;
    _keyboardHeight = bounds.size.height;
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    _keyboardWidth = 0;
    _keyboardHeight = 0;
}

#pragma mark - Public
- (UIColor*)hexRGB:(int)hex alpha:(float)alpha
{
    return [UIColor colorWithRed:(hex>>16)/255.0 green:((hex&0x00FF00)>>8)/255.0 blue:(hex&0x0000FF)/255.0 alpha:alpha];
}

- (NSString*)join:(NSString *)path, ...
{
    NSString *toReturn = [path copy];

    va_list argList;
    id arg;
    if (path) {
        va_start(argList, path);
        while ((arg = va_arg(argList, id))) {
            toReturn = [toReturn stringByAppendingPathComponent:arg];
        }
        va_end(argList);
    }
    return toReturn;
}

- (NSString*)pathForResource:(NSString *)filename
{
    NSString *pure = [filename stringByDeletingPathExtension];
    NSString *type = [filename pathExtension];
    return [[NSBundle mainBundle] pathForResource:pure ofType:type];
}

- (UIImage *)layerToImage:(CALayer*)layer
{
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, 0);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenImage;
}

- (NSString*)stringFromDate:(NSDate*)date withFormat:(NSString*)format
{
    static NSDateFormatter *f = nil;
    if (f == nil) {
        f = [[NSDateFormatter alloc] init];
    }

    f.dateFormat = format;
    return [f stringFromDate:date];
}

- (NSDate*)dateFromString:(NSString *)stringDate format:(NSString *)format
{
    static NSDateFormatter *f = nil;
    if (f == nil) {
        f = [[NSDateFormatter alloc] init];
    }

    f.dateFormat = format;
    return [f dateFromString:stringDate];
}

- (BOOL)isPortrait
{
    UIInterfaceOrientation o = [UIApplication sharedApplication].statusBarOrientation;
    return UIInterfaceOrientationIsPortrait(o);
}

- (void)showAlertWithMessage:(NSString *)message cancelButtonTitle:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:title otherButtonTitles:nil];
    [alert show];
}

- (GPSStatus)currentGPSStatus
{
    GPSStatus status;
    if ([CLLocationManager locationServicesEnabled] == NO) {
        status = GPSStatusLocationServicesNotEnabled;
    }
    else {
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusNotDetermined:
                status = GPSStatusAuthorizationStatusNotDetermined;
                break;
            case kCLAuthorizationStatusDenied:
                status = GPSStatusAuthorizationStatusDenied;
                break;
            case kCLAuthorizationStatusAuthorized:
                status = GPSStatusAuthorizationStatusAuthorized;
                break;
            case kCLAuthorizationStatusRestricted:
                status = GPSStatusAuthorizationStatusRestricted;
                break;
            default:
                status = GPSStatusUnknownError;
                break;
        }
    }
    return status;
}

- (void)startUpdatingLocation
{
    static CLLocationManager *m = nil;
    if (m == nil) {
        m = [[CLLocationManager alloc] init];
        m.delegate = (id)self;
    }
    [m startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSDictionary *info = @{ @"state": [NSNumber numberWithInteger:status] };
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocationManagerDidChangeAuthorizationStatusNotification object:nil userInfo:info];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [manager stopUpdatingLocation];
    CLLocation *location = [locations lastObject];
    if (location) {
        CLLocationCoordinate2D coordinate = [location coordinate];
        NSDictionary *info = @{ @"latitude": [NSNumber numberWithDouble:coordinate.latitude],
                                @"longitude": [NSNumber numberWithDouble:coordinate.longitude] };
        [[NSNotificationCenter defaultCenter] postNotificationName:kLocationManagerDidUpdateLocationNotification object:nil userInfo:info];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocationManagerDidFailNotification object:nil userInfo:@{ @"error": error }];
}

#pragma mark - Private
- (NSString*)generateDefaultUserAgent
{
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    return [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], (__bridge id)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey) ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] ? [[UIScreen mainScreen] scale] : 1.0f)];
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
    return [NSString stringWithFormat:@"%@/%@ (Mac OS X %@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[NSProcessInfo processInfo] operatingSystemVersionString]];
#endif
}

- (BOOL)isRetina
{
    return [self screenScale] > 1.0;
}

- (float)screenScale
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        return [[UIScreen mainScreen] scale];
    }

    return 1.0;
}

- (UIBarButtonItem*)createBarButtonItemWithTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents image:(UIImage*)image
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:controlEvents];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

- (Boolean)isIPhone5
{
    return [UIScreen mainScreen].bounds.size.height > 480;
}

- (float)iosVersion
{
    return [[UIDevice currentDevice].systemVersion floatValue];
}

- (void)refreshUI
{
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
}

- (UIImage*)scaleImage:(UIImage*)image withMaxLenght:(float)maxLenght
{
    float longger = MAX(image.size.width, image.size.height);

    UIImage *result = image;

    if (longger > maxLenght) {

        float newHeight = 0;
        float newWidth = 0;

        if (image.size.height > image.size.width) {
            newHeight = maxLenght;
            newWidth = image.size.width * newHeight / image.size.height;
        }
        else {
            newWidth = maxLenght;
            newHeight = image.size.height * newWidth / image.size.width;
        }

        float adjust = 2; //防止照片出现白边
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight)); //画布大小
        [image drawInRect:CGRectMake(0-adjust, 0-adjust, newWidth+2*adjust, newHeight+2*adjust)]; //图片在画布的frame
        result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }

    return result;
}

- (void)openAppInAppStoreWithAppID:(NSString*)appID
{
    NSLog(@"%s", __FUNCTION__);
}



@end




