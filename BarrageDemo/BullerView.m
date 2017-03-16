//
//  BullerView.m
//  BarrageDemo
//
//  Created by fu on 17/3/11.
//  Copyright © 2017年 fhc. All rights reserved.
//

#import "BullerView.h"

#define Padding 10
#define PhotoHeight 30

@interface BullerView ()

@property (nonatomic, retain) UILabel * lbComment;
@property (nonatomic, retain) UIImageView * photoHead;

@end

@implementation BullerView


/** 初始化弹幕 */
- (instancetype)initWithComment:(NSString *)comment {
    if (self = [super init]) {
        self.backgroundColor = [UIColor redColor];
        self.layer.cornerRadius = 15;
        
        //计算弹幕的实际宽度
        NSDictionary * attr = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0]};
        CGFloat width = [comment sizeWithAttributes:attr].width;
        
        self.bounds = CGRectMake(0, 0, width + 2 * Padding + PhotoHeight, 30);
        self.lbComment.text = comment;
        self.lbComment.frame = CGRectMake(Padding + PhotoHeight, 0, width, 30);
        
        self.photoHead.frame = CGRectMake(-Padding, -Padding, PhotoHeight + Padding, PhotoHeight + Padding);
        self.photoHead.layer.cornerRadius = (PhotoHeight + Padding)/2;
        self.photoHead.layer.borderColor = [UIColor orangeColor].CGColor;
        self.photoHead.layer.borderWidth = 1;
        self.photoHead.image = [UIImage imageNamed:@"timg.jpg"];
    }
    
    return self;
}

/** 开始动画 */
- (void)startAnimation {
    
//    根据弹幕的长度执行动画效果
//    根据 v = s/t ,时间相同的情况下，距离越长，速度越快
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat duration = 4.0f;
    CGFloat wholeWidth = screenWidth + CGRectGetWidth(self.bounds);
    
    //弹幕开始
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Start);
    }
    // t = s/v
    CGFloat speed = wholeWidth / duration;
    CGFloat enterDuration = CGRectGetWidth(self.bounds)/speed;
    
    [self performSelector:@selector(enterScreen) withObject:nil afterDelay:enterDuration];
    //取消 
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x -= wholeWidth;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        if (self.moveStatusBlock) {
            self.moveStatusBlock(End);
        }
    }];
}

- (void)enterScreen {
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Enter);
    }
}

/** 结束动画 */
- (void)stopAnimation {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

- (UILabel *)lbComment {
    if (_lbComment == nil) {
        _lbComment = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbComment.font = [UIFont systemFontOfSize:14.0];
        _lbComment.textColor = [UIColor whiteColor];
        _lbComment.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lbComment];
    }
    return _lbComment;
}

- (UIImageView *)photoHead {
    if (_photoHead == nil) {
        _photoHead = [UIImageView new];
        _photoHead.clipsToBounds = YES;
        _photoHead.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_photoHead];
    }
    return _photoHead;
}

@end
