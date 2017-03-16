//
//  BulletManager.m
//  BarrageDemo
//
//  Created by fu on 17/3/11.
//  Copyright © 2017年 fhc. All rights reserved.
//

#import "BulletManager.h"

@interface BulletManager ()


/** 弹幕数据来源 */
@property (nonatomic, retain) NSMutableArray * dataSource;

/** 弹幕使用过程中的数组变量 */
@property (nonatomic, retain) NSMutableArray * bulletComment;

/** 存储弹幕view的数组变量 */
@property (nonatomic, retain) NSMutableArray * bulletViews;

@end

@implementation BulletManager

- (void)start {
    [self.bulletComment removeAllObjects];
    [self.bulletComment addObjectsFromArray:self.dataSource];
    
    [self initBulletComment];
    
}

- (void)stop {
    
}


/**
 初始化弹幕，随机分配弹幕轨迹
 */
- (void)initBulletComment {
    
    NSMutableArray * trajectorys = [NSMutableArray arrayWithArray:@[@(0),@(1),@(2)]];
    for (int i = 0; i < 3; i ++) {
        if (self.bulletComment.count > 0) {
            //通过随机数获取弹幕轨迹
            NSInteger index = arc4random()%trajectorys.count;
            int trajectory = [[trajectorys objectAtIndex:index] intValue];
            [trajectorys removeObjectAtIndex:index];
            
            //从弹幕数组逐一取出数据
            NSString * comment = [self.bulletComment firstObject];
            [self.bulletComment removeObjectAtIndex:0];
            
            //创建弹幕view
            [self createBulletView:comment trajectory:trajectory];
        }
    }
}

- (void)createBulletView:(NSString *)comment trajectory:(int)trajectory {
    BullerView * view = [[BullerView alloc] initWithComment:comment];
    view.trajectory = trajectory;
    [self.bulletViews addObject:view];
    
    __weak typeof(view) weakView = view;
    __weak typeof(self) weakSelf = self;
    view.moveStatusBlock = ^{
      //移出屏幕后销毁弹幕并释放资源
        [weakView stopAnimation];
        [weakSelf.bulletViews removeObject:weakView];
    };
    
    if (self.generateViewBlock) {
        self.generateViewBlock(view);
    }
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithArray:@[@"11111",@"22222222",@"3333"]];
    }
    return _dataSource;
}

- (NSMutableArray *)bulletComment {
    if (_bulletComment == nil) {
        _bulletComment = [NSMutableArray array];
    }
    return _bulletComment;
}

- (NSMutableArray *)bulletViews {
    if (_bulletViews == nil) {
        _bulletViews = [NSMutableArray array];
    }
    return _bulletViews;
}

@end
