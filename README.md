# HCPopupViewController
# HCPopupViewController
有问题随时联系：微信：hehai_WeChat 邮箱：hehaichi123@163.com

使用方法：
//实例化，并弹出它
HCBasePopupViewController * pc =  [[HCBasePopupViewController alloc]init];
pc.popupDelegate = self;
//        pc.insets = UIEdgeInsetsMake(0, 15, 0, 0);//设置弹出框的偏移量
//        pc.popupViewSize = CGSizeMake(200, 300);//设置弹出框的尺寸
[self presentViewController:pc animated:YES completion:nil];


//实现其协议方法来自定义它的内容
#pragma mark - HCBasePopupViewControllerDelegate
- (void)setupSubViewWithPopupView:(UIView *)popupView withController:(UIViewController *)controller{
UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(popupView.frame)/2 -40, CGRectGetWidth(popupView.frame), 80)];
label.text = @"实现- (void)setupSubViewWithPopupView:(UIView *)popupView withController:(UIViewController *)controller这个协议方法来自定义你的弹出框内容";
label.numberOfLines = 0;
label.font = [UIFont systemFontOfSize:14];
label.textAlignment = NSTextAlignmentCenter;
[popupView addSubview:label];
}

- (void)didTapMaskViewWithMaskView:(UIView *)maskView withController:(UIViewController *)controller{
NSLog(@"点击遮罩");
}
