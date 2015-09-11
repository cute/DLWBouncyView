//
//  ViewController.m
//  BouncyView
//
//  Created by Li Guangming on 15/9/11.
//  Copyright (c) 2015年 Li Guangming. All rights reserved.
//

#import "DLWBouncyView.h"
#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) DLWBouncyView *bouncyView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect frame = CGRectZero;
    frame.size.height = CGRectGetHeight(self.view.bounds);
    
    self.bouncyView = [[DLWBouncyView alloc] initWithFrame:frame];
    self.bouncyView.backgroundColor = [UIColor clearColor];
    self.bouncyView.direction = DLWBouncyViewDirectionRight;
    self.bouncyView.fillColor = [UIColor colorWithRed:0.29 green:0.76 blue:0.5 alpha:1];
    [self.view addSubview:self.bouncyView];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.view];
    
    if(recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateBegan) {
        self.bouncyView.anchorPoint = location;
    }else if(recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){
        [self.bouncyView startAnimation];
    }
}

@end
