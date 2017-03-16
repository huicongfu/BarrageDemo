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

@property BOOL bStopAnimation;

@end

@implementation BulletManager

- (instancetype)init {
    if (self = [super init]) {
        self.bStopAnimation = YES;
    }
    return self;
}

- (void)start {
    
    if (!self.bStopAnimation) {
        return;
    }
    self.bStopAnimation = NO;
    [self.bulletComment removeAllObjects];
    [self.bulletComment addObjectsFromArray:self.dataSource];
    
    [self initBulletComment];
    
}

- (void)stop {
    if (self.bStopAnimation) {
        return;
    }
    self.bStopAnimation = YES;
    
    [self.bulletViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BullerView * view = obj;
        [view stopAnimation];
        view = nil;
    }];
    [self.bulletViews removeAllObjects];
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
    if (self.bStopAnimation) {
        return;
    }
    BullerView * view = [[BullerView alloc] initWithComment:comment];
    view.trajectory = trajectory;
    [self.bulletViews addObject:view];
    
    __weak typeof(view) weakView = view;
    __weak typeof(self) weakSelf = self;
    view.moveStatusBlock = ^(MoveStatus status){
        if (self.bStopAnimation) {
            return;
        }
        switch (status) {
            case Start: {
                //弹幕开始进入屏幕， 将View加入弹幕管理的变量中bulletViews
                [weakSelf.bulletViews addObject:weakView];
                
            }
                break;
            case Enter: {
                //弹幕完全进入屏幕，判断是否还有其他内容，如果有则在该弹幕轨迹中创建一个
                NSString * comment = [weakSelf nextComment];
                if (comment) {
                    [weakSelf createBulletView:comment trajectory:trajectory];
                }
            }
                break;
            case End: {
                //弹幕飞出屏幕后从bulletViews中删除，释放资源
                //移出屏幕后销毁弹幕并释放资源
                if ([weakSelf.bulletViews containsObject:weakView]) {
                    [weakView stopAnimation];
                    [weakSelf.bulletViews removeObject:weakView];
                }
                
                if (weakSelf.bulletViews.count == 0) {
                    //说明屏幕上已经没有弹幕了，开始循环滚动
                    self.bStopAnimation = YES;
                    [weakSelf start];
                }
            }
                break;
                
            default:
                break;
        }
      
    };
    
    if (self.generateViewBlock) {
        self.generateViewBlock(view);
    }
}

- (NSString *)nextComment {
    if (self.bulletComment.count == 0) {
        return nil;
    }
    NSString * comment =[self.bulletComment firstObject];
    if (comment) {
        [self.bulletComment removeObjectAtIndex:0];
    }
    return comment;
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithArray:@[@"11111",@"22222222",@"3333",@"422222222",@"53333",@"622222222",@"73333",@"822222222",@"93333",@"102222222",@"113333"]];
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
