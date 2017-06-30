//
//  ViewController.m
//  王者荣耀碰碰球
//
//  Created by WiKi on 2017/6/30.
//  Copyright © 2017年 wiki. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()<UICollisionBehaviorDelegate>

@property (nonatomic, strong) NSMutableArray *balls;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravity;
@property (nonatomic, strong) UICollisionBehavior *collision;
@property (nonatomic, strong) UIDynamicItemBehavior *dynamic;
@property (nonatomic) CMMotionManager *MotionManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self makeBalls];
    [self addAnimator];
    [self startAnim];
    
}


- (void)makeBalls{
    
 
    
    self.balls = [NSMutableArray array];
    
    NSUInteger numOfBalls = 6;
    for (NSUInteger i = 1; i <= numOfBalls; i ++) {
        
        UIImageView *ball = [UIImageView new];
        ball.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",i]];
        CGFloat width = 60;
        ball.layer.cornerRadius = width/2;
        ball.layer.masksToBounds = YES;
        
        //随机位置
        CGRect frame = CGRectMake(arc4random()%((int)(self.view.bounds.size.width - width)), 0, width, width);
        [ball setFrame:frame];
        
        //添加球体到父视图
        [self.view addSubview:ball];
        //球堆添加该球
        [self.balls addObject:ball];
    }
    
    
}

- (void)addAnimator{
    
    self.animator     = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
    //添加重力的动态特性，使其可执行
    self.gravity = [[UIGravityBehavior alloc]initWithItems:self.balls];
    [self.animator addBehavior:self.gravity];
    
    //添加碰撞的动态特性，使其可执行
    self.collision = [[UICollisionBehavior alloc]initWithItems:self.balls];
    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:self.collision];
    
    //弹性
    self.dynamic = [[UIDynamicItemBehavior alloc] initWithItems:self.balls];
    self.dynamic.allowsRotation = YES;//允许旋转
    self.dynamic.elasticity = 0.6;//弹性
    [self.animator addBehavior:self.dynamic];
}

- (void)startAnim{
    //初始化全局管理对象
    
    self.MotionManager = [[CMMotionManager alloc]init];
    self.MotionManager.deviceMotionUpdateInterval = 0.01;
    
    
    __weak ViewController *weakSelf = self;
    
    [self.MotionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *_Nullable motion,NSError * _Nullable error) {
        
        NSString *yaw = [NSString stringWithFormat:@"%f",motion.attitude.yaw];
        NSString *pitch = [NSString stringWithFormat:@"%f",motion.attitude.pitch];
        NSString *roll = [NSString stringWithFormat:@"%f",motion.attitude.roll];
        
        double rotation = atan2(motion.attitude.pitch, motion.attitude.roll);
        
        //重力角度
        weakSelf.gravity.angle = rotation;
        
        //        NSLog(@"yaw = %@,pitch = %@, roll = %@,rotation = %fd",yaw,pitch,roll,rotation);
        
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
