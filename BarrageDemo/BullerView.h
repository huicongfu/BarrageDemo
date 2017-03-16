//
//  BullerView.h
//  BarrageDemo
//
//  Created by fu on 17/3/11.
//  Copyright © 2017年 fhc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MoveStatus) {
    Start,
    Enter,
    End
};

@interface BullerView : UIView

/** 弹道 */
@property (nonatomic, assign) int trajectory;

/** 弹幕状态回调 */
@property (nonatomic, copy) void(^moveStatusBlock)(MoveStatus status);

/** 初始化弹幕 */
- (instancetype)initWithComment:(NSString *)comment;

/** 开始动画 */
- (void)startAnimation;

/** 结束动画 */
- (void)stopAnimation;

@end
