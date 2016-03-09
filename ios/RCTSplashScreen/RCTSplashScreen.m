//
//  RCTSplashScreen.m
//  RCTSplashScreen
//
//  Created by fangyunjiang on 15/11/20.
//  Copyright (c) 2015年 remobile. All rights reserved.
//

#import "RCTSplashScreen.h"

static RCTRootView *rootView = nil;

@interface RCTSplashScreen()

@end

@implementation RCTSplashScreen

RCT_EXPORT_MODULE(SplashScreen)

+ (void)show:(RCTRootView *)v {
    
    rootView = v;
    rootView.loadingViewFadeDelay = 0.2;
    rootView.loadingViewFadeDuration = 0.6;
    
    NSBundle* bundle = [NSBundle mainBundle];
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString* viewOrientation = @"Portrait";
    if (UIDeviceOrientationIsLandscape(orientation)) {
        viewSize = CGSizeMake(viewSize.height, viewSize.width);
        viewOrientation = @"Landscape";
    }
    NSString *launchImageName;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
            launchImageName = dict[@"UILaunchImageName"];
    }
    UIImage *launchImage = [UIImage imageNamed:launchImageName inBundle:bundle compatibleWithTraitCollection:nil];
    
    UIImageView *view = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view.image = launchImage;
    
    [[NSNotificationCenter defaultCenter] removeObserver:rootView  name:RCTContentDidAppearNotification object:rootView];
    
    [rootView setLoadingView:view];
}

RCT_EXPORT_METHOD(launchImageName:(RCTResponseSenderBlock)callback)
{
    NSBundle* bundle = [NSBundle mainBundle];
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString* viewOrientation = @"Portrait";
    if (UIDeviceOrientationIsLandscape(orientation)) {
        viewSize = CGSizeMake(viewSize.height, viewSize.width);
        viewOrientation = @"Landscape";
    }
    NSString *launchImageName;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
            launchImageName = dict[@"UILaunchImageName"];
    }
    callback(@[launchImageName]);
}

RCT_EXPORT_METHOD(hide) {
    if (!rootView) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(rootView.loadingViewFadeDuration * NSEC_PER_SEC)),
                   dispatch_get_main_queue(),
                   ^{
                       [UIView transitionWithView: rootView
                                         duration:rootView.loadingViewFadeDelay
                                          options:UIViewAnimationOptionTransitionCrossDissolve
                                       animations:^{
                                           rootView.loadingView.hidden = YES;
                                       } completion:^(__unused BOOL finished) {
                                           [rootView.loadingView removeFromSuperview];
                                       }];
                   });
}

@end
