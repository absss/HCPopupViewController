# HCPopupViewController
# HCPopupViewController
有问题随时联系：微信：hehai_WeChat 邮箱：hehaichi123@163.com

<h2>使用方法</h2>
继承HCBasePopupViewController并实现下列方法
```//To be override
/*在这个方法里面设置属性*/
- (void)subViewsWillReload;
/*在这个方法里面添加子视图*/
- (void)subViewsDidReload;
/**在这个方法里面写转场动画*/
- (void)viewController:(HCBasePopupViewController *)controller animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext;```

效果图如下：
![img](https://github.com/absss/HCPopupViewController/blob/master/gif4.gif)

