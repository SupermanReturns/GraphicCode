//
//  NHGraphCoder.m
//  GraphicCode
//
//  Created by Superman on 2018/9/20.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "NHGraphCoder.h"
#import <objc/runtime.h>
#import "FBShimmeringView.h"
#import "JGAFImageCache.h"


#ifndef PBSCREEN_WIDTH
#define PBSCREEN_WIDTH   ([[UIScreen mainScreen]bounds].size.width)
#endif
#ifndef PBSCREEN_HEIGHT
#define PBSCREEN_HEIGHT  ([[UIScreen mainScreen]bounds].size.height)
#endif
#ifndef PBSCREEN_SCALE
#define PBSCREEN_SCALE  ([UIScreen mainScreen].scale)
#endif
#ifndef PBCONTENT_OFFSET
#define PBCONTENT_OFFSET  (20*PBSCREEN_SCALE)
#endif
#ifndef PBCONTENT_SIZE
#define PBCONTENT_SIZE  (PBSCREEN_WIDTH - PBCONTENT_OFFSET*2)
#endif

#ifndef PBTile_SIZE
#define PBTile_SIZE                 100
#endif
#ifndef PB_BALL_RADIUS_SCALE
#define PB_BALL_RADIUS_SCALE        4
#endif
#ifndef PB_BALL_RADIUS_OFFSET
#define PB_BALL_RADIUS_OFFSET       0.5
#endif
#ifndef PB_BALL_SIZE
#define PB_BALL_SIZE                (PBTile_SIZE/PB_BALL_SCALE)
#endif
#ifndef PBSLIDER_SIZE
#define PBSLIDER_SIZE               40
#endif

#pragma mark -- Custom Slider --

typedef void(^NHSliderEvent)(CGFloat p,BOOL end);

@interface NHGraphicSlider:UIControl

@property (nonatomic, copy) NHSliderEvent event;

@property (nonatomic) float value;

@property (nonatomic) float minimumValue;

@property (nonatomic) float maximumValue;

@property(nonatomic, retain) UIColor *minimumTrackTintColor;

@property(nonatomic, retain) UIColor *maximumTrackTintColor;

@property(nonatomic, retain) UIColor *thumbTintColor;

@implementation NHGraphCoder

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end






















