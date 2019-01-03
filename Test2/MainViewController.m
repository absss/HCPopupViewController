//
//  MainViewController.m
//  Test2
//
//  Created by hehaichi on 2017/12/15.
//  Copyright © 2017年 hehaichi. All rights reserved.
//

#import "MainViewController.h"
#import "HCPopup.h"
#import "HCThreadSafeMutableArray.h"

#define UIViewGetter(NAME) \
- (UIView *)NAME {\
if (!_##NAME) {\
_##NAME = [UIView new];\
}\
return _##NAME;\
}

#define UIImageViewGetter(NAME,IMAGE) \
- (UIImageView *)NAME {\
if (!_##NAME) {\
_##NAME = [UIImageView new];\
_##NAME.contentMode = UIViewContentModeScaleAspectFill;\
_imageView.image = IMAGE;\
}\
return _##NAME;\
}

#define UILabelGetter(NAME,TEXT_COLOR,FONT,TEXT) \
- (UILabel *)NAME {\
if (!_##NAME) {\
_##NAME = [[UILabel alloc]init];\
_##NAME.textColor = TEXT_COLOR;\
_##NAME.font = FONT;\
_##NAME.text = TEXT;\
}\
return _##NAME;\
}


@interface MainViewController ()
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *someView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataSource = [[HCThreadSafeMutableArray alloc] init];
    [self configData];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    
    button.frame = CGRectMake(self.view.center.x - 30, self.view.center.y -15, 60, 30);
    [button setTitle:@"点击" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:startBtn];
    
    startBtn.frame = CGRectMake(self.view.center.x - 30, CGRectGetMaxY(button.frame)+10, 60, 30);
    [startBtn setTitle:@"开始" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:removeBtn];
    
    removeBtn.frame = CGRectMake(self.view.center.x - 30, CGRectGetMaxY(startBtn.frame)+10, 60, 30);
    [removeBtn setTitle:@"移除" forState:UIControlStateNormal];
    [removeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [removeBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    
   
    
    [self testTargetPerformance];
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.someView];
}

UILabelGetter(titleLabel, [UIColor blueColor], [UIFont systemFontOfSize:14], @"texttexttexttexttexttexttexttexttext");
UIImageViewGetter(imageView, nil);
UIViewGetter(someView);



- (void)configData
{
    
    for (int i = 0; i < 100; i++) {
        [self.dataSource addObject:[NSString stringWithFormat:@"Obj - %i", i]];
    }
}


- (void)start {
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        for (int i = 0; i < self.dataSource.count; i++) {
            [NSThread sleepForTimeInterval:0.5];
            NSLog(@"%@", self.dataSource[i]);
        }
    });
    
}

- (void) remove {
      [self.dataSource removeAllObjects];
    NSLog(@"移除所有");
}

- (void)testTargetPerformance{
    NSTimeInterval begin, end, time1,time2;
   
    HCThreadSafeMutableArray *safeArr = [[HCThreadSafeMutableArray alloc] init];
    NSMutableArray *normalArr = [[NSMutableArray alloc] init];
    
    
    int times = 1000;
    
    //NSMutableArray
    begin = CACurrentMediaTime();
    for ( int i = 0; i < times; i ++) {
        [normalArr addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    for ( int i = 0; i < times; i ++) {
        NSLog(@"%@",normalArr[i]);
    }
    end = CACurrentMediaTime();
    time2 = end - begin;
    
    //HCThreadSafeMutableArray
    begin = CACurrentMediaTime();
    for ( int i = 0; i < times; i ++) {
        [safeArr addObject:[NSString stringWithFormat:@"%d",i]];
       
    }
    for ( int i = 0; i < times; i ++) {
        NSLog(@"%@",safeArr[i]);
    }
    end = CACurrentMediaTime();
    time1 = end - begin;
    
    printf("HCThreadSafeMutableArray:   %8.2f\n", time1 * 1000);
    printf("NSMutableArray:   %8.2f\n", time2 * 1000);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)action{
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:nil message:@"弹出框样式" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"中心弹出框" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
#warning 代码在这里.........
        HCCenterPopAlertViewController * pc =  [[HCCenterPopAlertViewController alloc]init];
        [self presentViewController:pc animated:YES completion:nil];
    }];
    
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"基础弹出框" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
#warning 代码在这里.........
        HCBasePopupViewController * bc =  [[HCBasePopupViewController alloc]init];
        [self presentViewController:bc animated:YES completion:nil];
    }];
    
    
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"底部弹出框" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        HCBottomPopupViewController * pc =  [[HCBottomPopupViewController alloc]init];
        HCBottomPopupAction * action1 = [HCBottomPopupAction actionWithTitle:@"选择项1" withSelectedBlock:^{
                NSLog(@"点击选项1");
        } withType:HCBottomPopupActionSelectItemTypeDefault];
        HCBottomPopupAction * action2 = [HCBottomPopupAction actionWithTitle:@"选择项2" withSelectedBlock:^{
                NSLog(@"点击选项2");
        } withType:HCBottomPopupActionSelectItemTypeDefault];
        HCBottomPopupAction * action3 = [HCBottomPopupAction actionWithTitle:@"选择项3" withSelectedBlock:^{
                NSLog(@"点击选项3");
        } withType:HCBottomPopupActionSelectItemTypeDefault];
         HCBottomPopupAction * action4 = [HCBottomPopupAction actionWithTitle:@"取消" withSelectedBlock:nil withType:HCBottomPopupActionSelectItemTypeCancel];
        [pc addAction:action1];
        [pc addAction:action2];
        [pc addAction:action3];
        [pc addAction:action4];
        

        [self presentViewController:pc animated:YES completion:nil];
    }];
    UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [ac addAction:action1];
    [ac addAction:action2];
    [ac addAction:action3];
    [ac addAction:actionCancel];
    
    [self presentViewController:ac animated:YES completion:nil];
}

@end
