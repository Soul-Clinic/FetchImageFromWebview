//
//  Common.h
//  Scratch
//
//  Created by Can EriK Lu on 9/3/13.
//  Copyright (c) 2013 Can EriK Lu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


#ifndef __FEDEBUG
	#define __FEDEBUG
#endif


#ifdef __FEDEBUG
	#define FELog(s, ...) NSLog(@"%s —> %@", __func__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
	#define FELog(s, ...)
#endif


#define LogFun		NSLog(@"%s", __func__)

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kCommon [FECommon sharedInstance]
#define kFM [NSFileManager defaultManager]
#define kTopBarHeight ([kCommon isPortrait] ? 44 : 32)
#define kBottomBarHeight ([kCommon isPortrait] ? 44 : 32)
#define kStatusBarHeight 20

#define intToNumber(aInt) [NSNumber numberWithInt:aInt]
#define boolToNumber(aBool) [NSNumber numberWithBool:aBool]

#define archiveObject(obj) [NSKeyedArchiver archivedDataWithRootObject:obj]
#define unarchiveData(data) [NSKeyedUnarchiver unarchiveObjectWithData:data]

typedef enum {
    GPSStatusLocationServicesNotEnabled, //设备“设置”不允许所有定位服务
    GPSStatusAuthorizationStatusNotDetermined, //还未询问用户是否允许
    GPSStatusAuthorizationStatusRestricted, //This application is not authorized to use location services.  Due
    // to active restrictions on location services, the user cannot change
    // this status, and may not have personally denied authorization
    GPSStatusAuthorizationStatusDenied, //不允许改应用使用
    GPSStatusAuthorizationStatusAuthorized, //允许程序使用
    GPSStatusUnknownError
} GPSStatus;

#define kLocationManagerDidChangeAuthorizationStatusNotification @"LocationManagerDidChangeAuthorizationStatus"
#define kLocationManagerDidUpdateLocationNotification @"LocationManagerDidUpdateLocation"
#define kLocationManagerDidFailNotification @"LocationManagerDidFail"

#define userDefaultsValueForKey(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define userDefaultsStringForKey(key) [[NSUserDefaults standardUserDefaults] stringForKey:key]
#define userDefaultsBoolForKey(key) [[NSUserDefaults standardUserDefaults] boolForKey:key]
#define userDefaultsIntegerForKey(key) [[NSUserDefaults standardUserDefaults] integerForKey:key]
#define userDefaultsFloatForKey(key) [[NSUserDefaults standardUserDefaults] floatForKey:key]

#define setUserDefaults(key, obj) [[NSUserDefaults standardUserDefaults] setValue:obj forKey:key]

@interface UIView (Position)

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize frameSize;

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;

// Setting these modifies the origin but not the size.
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic, readonly) CGFloat boundsWidth;
@property (nonatomic, readonly) CGFloat boundsHeight;

// Methods for centering.
- (void)addCenteredSubview:(UIView *)subview;
- (void)moveToCenterOfSuperview;
- (void)centerVerticallyInSuperview;
- (void)centerHorizontallyInSuperview;
- (void)printSubviewsTree;		//By Can
@end


UIColor* rgba(int r, int g, int b, float a);
UIColor* rgb(int r, int g, int b);
NSArray* imagesWithNames(NSArray* names);
BOOL isRetina();

NSString* documentDirectory();
NSString* deviceInformation();
NSString* machineName();
NSString* systemInfo(NSString* productName);
BOOL isSimulator();

void logSize(NSString* format, CGSize size);
void logFrame(NSString* text, UIView* view);
void printClassTrees(id object);
BOOL isiOS7();
void FELogError(NSString* format, ...);
NSString* getLanguageCode();
@interface UIColor(Image)
- (UIImage*)image;
@end

@interface NSObject(debug)
- (void)printClassTrees;
@end


@interface UIImage(Resize)
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
@end


@interface Common : NSObject
+ (NSString*)textToHtml:(NSString*)htmlString;
+ (UIViewController*)topViewController;
+ (NSMutableURLRequest*)jsonRequestURL:(NSURL*)url withParams:(NSDictionary*)params;
+ (NSMutableURLRequest*)requestURL:(NSURL*)url withParams:(NSDictionary*)params andImage:(UIImage*)image withName:(NSString*)imageFieldName;
+ (UIImage*)imageFromText:(NSString*)text maxWidth:(float)width;
@end


@interface FECommon : NSObject

@property (strong, nonatomic, readonly) NSString *documentsPath;
@property (strong, nonatomic, readonly) NSString *tmpPath;
@property (strong, nonatomic, readonly) NSString *defaultUserAgent;
@property (nonatomic) float keyboardWidth;
@property (nonatomic) float keyboardHeight;

+ (FECommon*)sharedInstance;
- (UIColor*)hexRGB:(int)hex alpha:(float)alpha;
- (NSString*)join:(NSString*)path, ...NS_REQUIRES_NIL_TERMINATION;
- (NSString*)pathForResource:(NSString *)filename;
- (UIImage *)layerToImage:(CALayer*)layer;
- (NSString*)stringFromDate:(NSDate*)date withFormat:(NSString*)format;
- (NSDate*)dateFromString:(NSString *)stringDate format:(NSString *)format;
- (BOOL)isPortrait;
- (void)showAlertWithMessage:(NSString*)message cancelButtonTitle:(NSString*)title;
- (void)startUpdatingLocation;
- (GPSStatus)currentGPSStatus;
- (BOOL)isRetina;
- (float)screenScale;
- (UIBarButtonItem*)createBarButtonItemWithTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents image:(UIImage*)image;
- (float)iosVersion;
- (Boolean)isIPhone5;
- (void)refreshUI;
- (UIImage*)scaleImage:(UIImage*)image withMaxLenght:(float)maxLenght;
- (void)openAppInAppStoreWithAppID:(NSString*)appID;

@end

