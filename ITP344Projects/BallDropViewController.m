//
//  ViewController.m
//  ITP344Projects
//
//  Created by David Richardson on 1/21/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "BallDropViewController.h"

@interface BallDropViewController (){
    UIDynamicAnimator *animator;
    UIGravityBehavior *gravity;
    UICollisionBehavior *collision;
    UIDynamicItemBehavior *itemBehavior;
    BOOL gravityAdded;
}


@end

@implementation BallDropViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    itemBehavior = [[UIDynamicItemBehavior alloc] init];
    
    itemBehavior.elasticity = 0;
    
    gravity = [[UIGravityBehavior alloc] init];
    
    collision = [[UICollisionBehavior alloc] init];
    
    [animator addBehavior:gravity];
    [animator addBehavior:itemBehavior];
    [animator addBehavior:collision];


}

- (IBAction)buttonPressed:(id)sender {
    
    // create new ball
    UIView *ball = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, 0, 50, 50)];
    
    [ball setBackgroundColor:[UIColor redColor]];
    
    ball.layer.cornerRadius = 25;
    
    [self.view addSubview:ball];
    
    [gravity addItem:ball];
    
    collision.translatesReferenceBoundsIntoBoundary = YES;
    
    [collision addItem:ball];
    
    [itemBehavior addItem:ball];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
