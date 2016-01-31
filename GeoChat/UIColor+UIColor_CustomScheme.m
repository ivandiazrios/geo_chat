//
//  UIColor+UIColor_CustomScheme.m
//  GeoChat
//
//  Created by Henry Turner on 04/06/2015.
//  Copyright (c) 2015 Ivan Diaz. All rights reserved.
//

#import "UIColor+UIColor_CustomScheme.h"

@implementation UIColor (UIColor_CustomScheme)

+ (UIColor *)themeColor1 {
    static UIColor *customColor;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        customColor = [UIColor colorWithRed:16.0 / 255.0
                                           green:91.0 / 255.0
                                            blue:99.0 / 255.0
                                           alpha:1.0];
    });
    
    return customColor;
}
+ (UIColor *)themeColor2 {
    static UIColor *customColor;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        customColor = [UIColor colorWithRed:255.0 / 255.0
                                      green:250.0 / 255.0
                                       blue:213.0 / 255.0
                                      alpha:1.0];
    });
    
    return customColor;
}

+ (UIColor *)themeColor3 {
    static UIColor *customColor;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        customColor = [UIColor colorWithRed:255.0 / 255.0
                                      green:211.0 / 255.0
                                       blue:78.0 / 255.0
                                      alpha:1.0];
    });
    
    return customColor;
}

+ (UIColor *)themeColor4 {
    static UIColor *customColor;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        customColor = [UIColor colorWithRed:219.0 / 255.0
                                      green:158.0 / 255.0
                                       blue:54.0 / 255.0
                                      alpha:1.0];
    });
    
    return customColor;
}

+ (UIColor *)themeColor5 {
    static UIColor *customColor;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        customColor = [UIColor colorWithRed:189.0 / 255.0
                                      green:73.0 / 255.0
                                       blue:50.0 / 255.0
                                      alpha:1.0];
    });
    
    return customColor;
}



@end
