//
//  DLWBouncyView.m
//  BouncyView
//
//  Created by Li Guangming on 15/9/10.
//  Copyright (c) 2015年 Li Guangming. All rights reserved.
//

#import "DLWBouncyView.h"

@interface DLWBouncyView ()
@property (nonatomic, strong) CAShapeLayer* viewLayer;
@property (nonatomic, strong) UIView* springView;
@property (nonatomic, strong) UIDynamicAnimator* mainAnimator;
@property (nonatomic, strong) UIAttachmentBehavior* springBehaviour;
@end

@implementation DLWBouncyView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.backgroundColor = [UIColor clearColor];
    self.fillColor = [UIColor colorWithRed:0.64 green:0.58 blue:0.84 alpha:1];
    self.length = 1.0f;
    self.damping = 0.5f;
    self.frequency = 1.9f;

    self.mainAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self];

    self.viewLayer = [CAShapeLayer layer];
    self.viewLayer.fillColor = [self.fillColor CGColor];
    [self.layer addSublayer:self.viewLayer];

    self.springView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    self.springView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.springView];
}

- (UIBezierPath*)getViewPath
{
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    UIBezierPath* path = [UIBezierPath bezierPath];

    if (self.direction == DLWBouncyViewDirectionLeft) {
        [path moveToPoint:CGPointMake(width, 0)];
        [path addLineToPoint:CGPointMake(CGRectGetMinX(self.springView.frame), 0)];
        [path addQuadCurveToPoint:CGPointMake(CGRectGetMinX(self.springView.frame), height)
                     controlPoint:CGPointMake(0, self.anchorPoint.y)];
        [path addLineToPoint:CGPointMake(width, height)];
    }else if (self.direction == DLWBouncyViewDirectionRight) {
        [path moveToPoint:CGPointZero];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.springView.frame), 0)];
        [path addQuadCurveToPoint:CGPointMake(CGRectGetMaxX(self.springView.frame), height)
                     controlPoint:CGPointMake(width, self.anchorPoint.y)];
        [path addLineToPoint:CGPointMake(0, height)];
    }else if (self.direction == DLWBouncyViewDirectionUp){
        [path moveToPoint:CGPointMake(0, height)];
        [path addLineToPoint:CGPointMake(width, height)];
        [path addLineToPoint:CGPointMake(width, CGRectGetMinY(self.springView.frame))];
        [path addQuadCurveToPoint:CGPointMake(0, CGRectGetMinY(self.springView.frame))
                     controlPoint:CGPointMake(self.anchorPoint.x, 0)];
        [path addLineToPoint:CGPointMake(0, CGRectGetMinY(self.springView.frame))];
    }else if (self.direction == DLWBouncyViewDirectionDown){
        [path moveToPoint:CGPointZero];
        [path addLineToPoint:CGPointMake(width, 0)];
        [path addLineToPoint:CGPointMake(width, CGRectGetMaxY(self.springView.frame))];
        [path addQuadCurveToPoint:CGPointMake(0, CGRectGetMaxY(self.springView.frame))
                     controlPoint:CGPointMake(self.anchorPoint.x, height)];
        [path addLineToPoint:CGPointMake(0, CGRectGetMidY(self.springView.frame))];
    }

    [path closePath];

    return path;
}

- (UIAttachmentBehavior*)springBehaviour
{
    if (_springBehaviour) {
        return _springBehaviour;
    }

    _springBehaviour = [[UIAttachmentBehavior alloc] initWithItem:self.springView
                                                 attachedToAnchor:self.center];
    _springBehaviour.length = self.length;
    _springBehaviour.damping = self.damping;
    _springBehaviour.frequency = self.frequency;

    __weak typeof(self) weakSelf = self;
    [_springBehaviour setAction:^{
        if (self.direction == DLWBouncyViewDirectionLeft) {
            weakSelf.springView.center = CGPointMake(weakSelf.springView.center.x - weakSelf.frame.origin.x, weakSelf.center.y);
        }else if (self.direction == DLWBouncyViewDirectionRight) {
            weakSelf.springView.center = CGPointMake(weakSelf.springView.center.x, weakSelf.center.y);
        }else if (self.direction == DLWBouncyViewDirectionUp){
            weakSelf.springView.center = CGPointMake(weakSelf.center.x, weakSelf.springView.center.y - weakSelf.frame.origin.y);
        }else if (self.direction == DLWBouncyViewDirectionDown){
            weakSelf.springView.center = CGPointMake(weakSelf.center.x, weakSelf.springView.center.y);
        }
        weakSelf.viewLayer.path = [[weakSelf getViewPath] CGPath];
    }];

    return _springBehaviour;
}

- (void)setDirection:(DLWBouncyViewDirection)direction
{
    _direction = direction;
}

- (void)setFillColor:(UIColor *)fillColor
{
    self.viewLayer.fillColor = [fillColor CGColor];
}

- (void)setAnchorPoint:(CGPoint)anchorPoint
{
    _anchorPoint = anchorPoint;
    CGRect frame = self.frame;
    if (self.direction == DLWBouncyViewDirectionRight) {
        frame.size.width = anchorPoint.x;
    }else if (self.direction == DLWBouncyViewDirectionLeft) {
        CGFloat diff = frame.origin.x - anchorPoint.x ;
        frame.size.width = diff + frame.size.width;
        frame.origin.x = anchorPoint.x;
    }else if (self.direction == DLWBouncyViewDirectionDown) {
        frame.size.height = anchorPoint.y;
    }else if (self.direction == DLWBouncyViewDirectionUp) {
        CGFloat diff = frame.origin.y - anchorPoint.y;
        frame.size.height = diff + frame.size.height;
        frame.origin.y = anchorPoint.y;
    }
    self.frame = frame;
    self.viewLayer.path = [[self getViewPath] CGPath];
}

- (void)stopAnimation
{
    [self.mainAnimator removeAllBehaviors];
}

- (void)startAnimation
{
    [self.mainAnimator removeAllBehaviors];
    [self.mainAnimator addBehavior:self.springBehaviour];
    self.springBehaviour.anchorPoint = _anchorPoint;
}

- (void)setAnchorPoint:(CGPoint)anchorPoint animated:(BOOL)animated
{
    self.anchorPoint = anchorPoint;
    if (animated) {
        [self startAnimation];
    }
}

@end
