//
//  DLWBouncyView.h
//  BouncyView
//
//  Created by Li Guangming on 15/9/10.
//  Copyright (c) 2015年 Li Guangming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DLWBouncyViewDirection) {
    DLWBouncyViewDirectionUp,
    DLWBouncyViewDirectionLeft,
    DLWBouncyViewDirectionDown,
    DLWBouncyViewDirectionRight
};

@interface DLWBouncyView : UIView

@property (nonatomic, assign) DLWBouncyViewDirection direction;
@property (nonatomic, assign) CGPoint anchorPoint;
@property (nonatomic, strong) UIColor* fillColor;
@property (nonatomic, assign) CGFloat length;
@property (nonatomic, assign) CGFloat damping;
@property (nonatomic, assign) CGFloat frequency;

- (void)startAnimation;
- (void)setAnchorPoint:(CGPoint)anchorPoint animated:(BOOL)animated;
- (void)stopAnimation;

@end
