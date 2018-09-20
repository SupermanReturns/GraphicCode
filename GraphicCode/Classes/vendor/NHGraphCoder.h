//
//  NHGraphCoder.h
//  GraphicCode
//
//  Created by Superman on 2018/9/20.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NHGraphCoder;
typedef void(^NHGraphEvent)(NHGraphCoder *coder,BOOL success);
typedef UIImage * _Nonnull (^NHRefreshEvent)();



@interface NHGraphCoder : UIView
-(id) init;

-(id)initWithFrame:(CGRect)frame;

-(id)initWithCoder:(NSCoder *)aDecoder;

/**
 *  @brief generate graph code view
 *
 *  @param img the bg image's instance
 *
 *  @return the graphic code view
 */
+ (NHGraphCoder *)codeWithImage:(UIImage *)img;

/**
 *  @brief generate graph code view
 *
 *  @param url the bg image's url
 *  @attention :TO BE Implementationed !
 *
 *  @return the graphic code view
 */
+ (NHGraphCoder *)codeWithURL:(NSString *)url;

/**
 *  @brief reset state
 */
- (void)resetStateForDetect;

/**
 *  @brief deal with the event
 *
 *  @param event the event
 */
- (void)handleGraphicCoderVerifyEvent:(NHGraphEvent)event;
@end
