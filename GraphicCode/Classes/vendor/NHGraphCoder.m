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

- (void)handleSliderValueChangedEvent:(NHSliderEvent)event;

@end

@interface NHGraphicSlider()

@property (nonatomic, assign, getter=isContinuous) BOOL continuous;
@property (nonatomic, assign) CGPoint thumbCenterPoint;

@property (nonatomic, assign) BOOL sliderAbel,sliding;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) FBShimmeringView *shimmer;

#pragma mark - Init and Setup methods
- (void)setup;

#pragma mark - Thumb management methods
- (BOOL)isPointInThumb:(CGPoint)point;

@end
@implementation NHGraphicSlider

@synthesize value=_value;

-(void)setValue:(float)value{
    if (value !=_value) {
        if (value>self.maximumValue) {
            value=self.maximumValue;
        }
        if (value<self.minimumValue) {
            value=self.minimumValue;
        }
        _value=value;
        [self setNeedsDisplay];
        if (self.isContinuous) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}
@synthesize minimumValue=_minimumValue;
-(void)setMinimumValue:(float)minimumValue{
    if (minimumValue !=_minimumValue) {
        _minimumValue = minimumValue;
        if (self.maximumValue <self.minimumValue) {
            self.maximumValue=self.minimumValue;
        }
        if (self.value<self.minimumValue) {
            self.value=self.minimumValue;
        }
    }
}
@synthesize maximumValue=_maximumValue;
-(void)setMaximumValue:(float)maximumValue{
    if (maximumValue!=_maximumValue) {
        _maximumValue=maximumValue;
        if (self.minimumValue>self.maximumValue) {
            self.minimumValue=self.maximumValue;
        }
        if (self.value>self.maximumValue ) {
            self.value=self.maximumValue;
        }
    }
}
@synthesize minimumTrackTintColor=_minimumTrackTintColor;
-(void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor{
    if (![minimumTrackTintColor isEqual:_minimumTrackTintColor]) {
        _minimumTrackTintColor=minimumTrackTintColor;
        [self setNeedsDisplay];
    }
}
@synthesize maximumTrackTintColor = _maximumTrackTintColor;
-(void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor{
    if (![maximumTrackTintColor isEqual:_maximumTrackTintColor]) {
        _maximumTrackTintColor = maximumTrackTintColor;
        [self setNeedsDisplay];
    }
}
@synthesize thumbTintColor = _thumbTintColor;
-(void)setThumbTintColor:(UIColor *)thumbTintColor{
    if (![thumbTintColor isEqual:_thumbTintColor]) {
        _thumbTintColor = thumbTintColor;
        [self setNeedsDisplay];
    }
}
@synthesize  thumbCenterPoint = _thumbCenterPoint;
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)awakeFromNib {
    [self setup];
}
-(void)setup{
    self.sliderAbel = true;
    self.value = 0.0;
    self.minimumValue = 0;
    self.maximumValue=1;
    self.minimumTrackTintColor = [UIColor blueColor];
    self.maximumTrackTintColor = [UIColor whiteColor];
    self.thumbTintColor= [UIColor darkGrayColor];
    self.continuous = YES;
    self.thumbCenterPoint = CGPointZero;
    
    self.backgroundColor = [UIColor lightGrayColor];
    UIImage *thumbImage = [self thumbWithColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0]];
    _slider = [[UISlider alloc]initWithFrame:self.bounds];
    _slider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    CGPoint ctr  = _slider.center;
    CGRect sliderFrame = _slider.frame;
    sliderFrame.size.width-=4;
    _slider.frame = sliderFrame;
    _slider.center = ctr;
    _slider.backgroundColor = [UIColor clearColor];
    [_slider setThumbImage:thumbImage forState:UIControlStateNormal];
    
    UIImage *clearImage = [self clearPixel];
    [_slider setMaximumTrackImage:clearImage forState:UIControlStateNormal];
    [_slider setMinimumTrackImage:clearImage forState:UIControlStateNormal];
    
    _slider.minimumValue = 0;
    _slider.maximumValue=1;
    _slider.continuous = YES;
    _slider.value = 0;
    [self addSubview:_slider];
    
    CGSize thumbSize = thumbImage.size;
    CGFloat infoStart_x = thumbSize.width;
    CGRect bounds = CGRectMake(infoStart_x,0,CGRectGetWidth(self.bounds)-infoStart_x,CGRectGetHeight(self.bounds));
    UILabel *infoLabel= [[UILabel alloc]initWithFrame:bounds];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.font =[UIFont boldSystemFontOfSize:20];
    infoLabel.text = @"拖动滑块完成验证>>>";
    infoLabel.adjustsFontSizeToFitWidth =true;
    
    FBShimmeringView *shimmer =[[FBShimmeringView alloc]initWithFrame:bounds];
    shimmer.shimmering = true;
    shimmer.shimmeringBeginFadeDuration  =1.5;
    shimmer.shimmeringOpacity = 0.3;
    shimmer.contentView = infoLabel;
    [self addSubview:shimmer];
    self.shimmer = shimmer;
    
    [_slider addTarget:self action:@selector(sliderUp:) forControlEvents:UIControlEventTouchUpInside];
    [_slider addTarget:self
                action:@selector(sliderUp:)
      forControlEvents:UIControlEventTouchUpOutside];
    [_slider addTarget:self
                action:@selector(sliderDown:)
      forControlEvents:UIControlEventTouchDown];
    [_slider addTarget:self
                action:@selector(sliderChanged:)
      forControlEvents:UIControlEventValueChanged];
}
-(void)resetSlider{
    [_slider setValue:0 animated:YES];
    self.shimmer.alpha =1;
    if (_event) {
        _event(0,false);
    }
}
-(void)sliderUp:(UISlider *)sender{
    if (_slider) {
        _slider = NO;
        if (_event) {
            _event(sender.value,true);
        }
    }
}
- (void) sliderDown:(UISlider *)sender {
    if (!_slider) {
        
    }
    _sliding = YES;
}
- (void) sliderChanged:(UISlider *)sender {
    self.shimmer.alpha  = MAX(0, 1 - (_slider.value *3.5));
    if (_event) {
        _event(sender.value,false);
    }
}
- (UIImage *) thumbWithColor:(UIColor*)color {
    CGFloat scale =[UIScreen mainScreen].scale;
    if (scale<1.0) {
        scale = 1.0;
    }
    
    CGSize size = CGSizeMake(68*scale, 44*scale);
    CGFloat radius  = 10*scale;
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef 
}
- (UIImage *) clearPixel {

}

@implementation NHGraphCoder

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end






















