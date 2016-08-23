//
//  ViewController.m
//  KVO
//
//  Created by czbk on 16/8/20.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

#import "ViewController.h"
#import "MyPerson.h"

@interface ViewController ()

@property (strong,nonatomic) MyPerson *testPerson;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self testKVO];
}


-(void)testKVO {
    self.testPerson = [[MyPerson alloc]init];
    self.testPerson.height = 100;
    
    //注册了testPerson这个对象height属性的观察
    [self.testPerson addObserver:self forKeyPath:@"height" options:NSKeyValueObservingOptionNew context:nil];
}
//
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"height"]) {
        NSLog(@"Height is changed! new = %zd",[change valueForKey:NSKeyValueChangeNewKey]);
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSInteger h = [[self.testPerson valueForKey:@"height"] intValue];
    
    [self.testPerson setValue:[NSNumber numberWithInt: (int)h + 1] forKey:@"height"];
    
    NSLog(@"person height = %@", [self.testPerson valueForKey:@"height"]);
}


-(void)dealloc{
    [self.testPerson removeObserver:self forKeyPath:@"height" context:nil];
    
}

@end
