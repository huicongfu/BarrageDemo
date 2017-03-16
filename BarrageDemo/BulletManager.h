//
//  BulletManager.h
//  BarrageDemo
//
//  Created by fu on 17/3/11.
//  Copyright © 2017年 fhc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BullerView.h"

@interface BulletManager : NSObject

@property (nonatomic, copy) void(^generateViewBlock)(BullerView *view);

/**
 弹幕开始执行
 */
- (void)start;

/**
 弹幕停止执行
 */
- (void)stop;

@end
