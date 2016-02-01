# JXTAlertTools

# 前言：
UIAlertController是iOS8.0之后出来的新方法，其将系统原先的UIAlertView和UIActionSheet进行了规范整合。iOS9.0之后，UIAlertView和UIActionSheet已经不建议使用，但还未彻底废弃。
alert提示窗可以算得上是十分常用的UI控件了，基于上述情况，考虑到版本兼容，笔者将上述控件进行了简单的整合封装。
封装之后，只需一句话，便可调用系统的alert提示，至于是调用alertView还是alertController，会根据系统版本自行判断，做到了兼容适配。alert提示窗的回调方法，也基于block进行了封装。按钮数量提供了变参和数组两种封装模式，各有用途。

具体见[GitHub](https://github.com/kukumaluCN/JXTAlertTools),已将这个较为简单但个人感觉还算十分实用的库进行了开源共享。代码可能还入不了大牛的眼，水平有限，还望见谅，也欢迎使用和反馈。

**支持的多种效果展示**
![](http://upload-images.jianshu.io/upload_images/1468630-aa29be0f1b64ec17.gif?imageMogr2/auto-orient/strip)


下面叙述一下封装库内部分主要API的具体说明，代码中也有较为详细的注释。

# 1.普通alert 变参 兼容适配alertView和alertController
/**
*  普通alert定义 兼容适配alertView和alertController
*
*  @param viewController    当前视图，alertController模态弹出的指针
*  @param title             标题
*  @param message           详细信息
*  @param block             用于执行方法的回调block
*  @param cancelBtnTitle    取消按钮，可为nil
*  @param destructiveBtn    alertController的特殊按钮类型，可为nil
*  @param otherButtonTitles 其他按钮 变参量 但是按钮类型的相对位置是固定的，可为nil

*  NS_REQUIRES_NIL_TERMINATION 是一个宏，用于编译时非nil结尾的检查 自动添加结尾的nil

***注意1***
//block方法序列号和按钮名称相同，按钮类型排列顺序固定
//如果取消为nil，则index0为特殊，以此往后类推，以第一个有效按钮为0开始累加
//取消有的话默认为0

***注意2***
destructiveButtonTitle
iOS8以前，alert设置无效，因为不支持
iOS8以后，alert设置有效
*/
+ (void) showAlertWith:(UIViewController *)viewController
title:(NSString *)title
message:(NSString *)message
callbackBlock:(CallBackBlock)block
cancelButtonTitle:(NSString *)cancelBtnTitle
destructiveButtonTitle:(NSString *)destructiveBtn
otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;
具体调用实例（默认系统是ios8以后的）：

[JXTAlertTools showAlertWith:self title:EmptyTitle message:_titleArray[indexPath.row] callbackBlock:^(NSInteger btnIndex) {
if (btnIndex == 0) {
NSLog(@"取消");
}
if (btnIndex == 1) {//注意ios8以前，没有这个键
NSLog(@"特殊");
}
if (btnIndex == 2) {
NSLog(@"其他");
}
} cancelButtonTitle:@"取消" destructiveButtonTitle:@"特殊" otherButtonTitles:@"其他", nil];
没有按钮时：

//没有按钮时，默认自动消失
[JXTAlertTools showAlertWith:self title:EmptyTitle message:_titleArray[indexPath.row] callbackBlock:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];

弹窗自动消失的持续时间由宏控制，可自行修改（详见JXTAlertTools.h）：

/**
*  弹框显示的时间，默认1秒
*/
#define AlertViewShowTime 1.0

# 2.多按钮数组模式排布alert 兼容适配alertView和alertController

/**
*  多按钮列表数组排布alert初始化 兼容适配
*
*  @param viewController       当前视图，alertController模态弹出的指针
*  @param title                标题
*  @param message              详细信息
*  @param block                用于执行方法的回调block
*  @param cancelBtnTitle       取消按钮
*  @param otherBtnTitleArray   其他按钮的标题数组
*  @param otherBtnStyleArray   按钮样式分布数组（普通/特殊），alertView默认为普通样式

***注意***
UIAlertActionStyleCancel/JXTAlertActionStyleCancel最多只能有一个，否则崩溃
Log:
'UIAlertController can only have one action with a style of UIAlertActionStyleCancel'
*/
+ (void)showArrayAlertWith:(UIViewController *)viewController
title:(NSString *)title
message:(NSString *)message
callbackBlock:(CallBackBlock)block
cancelButtonTitle:(NSString *)cancelBtnTitle
otherButtonTitleArray:(NSArray *)otherBtnTitleArray
otherButtonStyleArray:(NSArray *)otherBtnStyleArray;

此方法是为了弥补前面那个方法初始化时，alert的按钮样式排布相对固定的局限，当然，这种排布只在iOS8之后有效。

具体调用实例（默认系统是ios8以后的）：

NSArray * titles = @[@"确定1", @"特殊1", @"确定2", @"特殊2"];
NSArray * styles = @[
[NSNumber numberWithInteger:JXTAlertActionStyleDefault],
[NSNumber numberWithInteger:JXTAlertActionStyleDestructive],
[NSNumber numberWithInteger:JXTAlertActionStyleDefault],
[NSNumber numberWithInteger:JXTAlertActionStyleDestructive]
];        
[JXTAlertTools showArrayAlertWith:self title:EmptyTitle message:_titleArray[indexPath.row] callbackBlock:^(NSInteger btnIndex) {
if (btnIndex == 0) {
NSLog(@"取消");
}
else
NSLog(@"%@", titles[btnIndex - 1]);
} cancelButtonTitle:@"取消" otherButtonTitleArray:titles otherButtonStyleArray:styles];
上面要注意按钮的样式是枚举值，添加数组时要注意转化为对象，这里用了NSNumber，因为方法实现中也是按照NSNumber解析的：

NSNumber * styleNum = otherBtnStyleArray[i];
UIAlertActionStyle actionStyle =  styleNum.integerValue;
UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherBtnTitleArray[i] style:actionStyle handler:^(UIAlertAction *action) {
block(count);
}];
[alertController addAction:otherAction];

样式枚举定义：

typedef enum {
JXTAlertActionStyleDefault = 0,
JXTAlertActionStyleCancel,
JXTAlertActionStyleDestructive
}JXTAlertActionStyle;
这里之所以不用系统提供的：

typedef NS_ENUM(NSInteger, UIAlertActionStyle) {
UIAlertActionStyleDefault = 0,
UIAlertActionStyleCancel,
UIAlertActionStyleDestructive
} NS_ENUM_AVAILABLE_IOS(8_0);
是因为为了系统版本适配，系统的样式枚举是iOS8之后才提供的，如果直接使用，系统版本一旦低于iOS8，此时使用可能导致程序崩溃。

没有按钮时，情况同上：

[JXTAlertTools showArrayAlertWith:self title:EmptyTitle message:_titleArray[indexPath.row] callbackBlock:nil cancelButtonTitle:nil otherButtonTitleArray:nil otherButtonStyleArray:nil];

>**关于actionSheet的API，基本同上，也提供了两个相应的方法，同样是兼容适配的。**
**关于方法的具体实现，在此不再赘述，有兴趣的可以参考代码，有什么问题欢迎讨论。**

# 3.两种简易提示窗
这两种建议的提示窗，是基于上述方法的简化，适用于较为简单的提示场景。
- 1.单按钮或无按钮alert提示
[JXTAlertTools showTipAlertViewWith:self title:EmptyTitle message:_titleArray[indexPath.row] buttonTitle:@"确认" buttonStyle:JXTAlertActionStyleDefault];

- 2.窗口底部简易actionSheet，无按钮
[JXTAlertTools showBottomTipViewWith:self title:_titleArray[indexPath.row] message:_titleArray[indexPath.row]];

# 4.两个特殊用途的方法
- 1.判断当前窗口是否有alert/actionSheet显示
+ (BOOL)isAlertShowNow;
这个的用途具体看需求，可以用来去重显示，尤其是在alertView的情况下，有时可能连续多次弹出同一alertView，例如观察者回调，系统貌似没有做去重处理，笔者就遇到过监听回调导致的alert重复显示。但是如果是alertController，就不会发生了，控制台可能会直接给出警告的，因为是试图在一个已经销毁的vc上（第一次弹出的alertController消失时）第二次连续推出视图，这是做不到的。
做去重显示判定时，此方法慎用，因为未做弹窗区分，同时的弹窗有可能是因为重复显示，也可能是不同警告类型的提示窗，去重的话就可能导致第二个不同的提示窗被过滤掉。

用法示例：

NSLog(@"显示alert:%@", [JXTAlertTools isAlertShowNow] ? @"是" : @"否");
if (![JXTAlertTools isAlertShowNow]) {//检测弹窗，控制alertView的去重显示
[JXTAlertTools showTipAlertViewWith:self title:EmptyTitle message:_titleArray[indexPath.row] buttonTitle:nil buttonStyle:JXTAlertActionStyleDefault];
}
NSLog(@"显示alert:%@", [JXTAlertTools isAlertShowNow] ? @"是" : @"否");

控制台输出：
![](http://upload-images.jianshu.io/upload_images/1468630-62f83570ec2235da.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

可能用方法有问题，但我是临时这个解决的。。。

- 2.查找当前活动窗口
+ (UIViewController *)activityViewController;

这个方法源于网络，实际使用可行，主要是用来确定alertController的，也就是上面那个方法有用到此方法（已封装），当然这个方法不局限于只确定alertController。而且，alertView的检测和alertController的检测不是同一个方法，毕竟一个是view，一个是vc。

# 5.封装时遇到的一个小问题
当且仅当模拟器使用6p或者6sp时，alert有至多2个按钮，至少1个按钮，alert的message中使用“\n”时，分为3行，第一行无所谓，第2行字符小于38字符或者第3行字符小于76时（\n算一个字符，数字可能记错了。。。），控制台直接给了下面的警告，警告的达成条件较为苛刻，2、3任意一行多于临界值都不行，但的确是偶然，同样的字符数，没有“\n”就没事，多于这几个临界值也没事，唯独不能少。。。：

**最简单的一个messge实例：@“1\n2\n3”**

警告：
> 2016-01-28 10:13:47.714 JXTAlertTools[2379:60409] the behavior of the UICollectionViewFlowLayout is not defined because:
2016-01-28 10:13:47.715 JXTAlertTools[2379:60409] the item height must be less than the height of the UICollectionView minus the section insets top and bottom values, minus the content insets top and bottom values.
2016-01-28 10:13:47.715 JXTAlertTools[2379:60409] The relevant UICollectionViewFlowLayout instance is <_UIAlertControllerCollectionViewFlowLayout: 0x7fc21ac7ed10>, and it is attached to <UICollectionView: 0x7fc21c877a00; frame = (0 94.6667; 270 44); clipsToBounds = YES; gestureRecognizers = <NSArray: 0x7fc21ac1b5d0>; layer = <CALayer: 0x7fc21ac1c470>; contentOffset: {0, 0}; contentSize: {0, 0}> collection view layout: <_UIAlertControllerCollectionViewFlowLayout: 0x7fc21ac7ed10>.
2016-01-28 10:13:47.715 JXTAlertTools[2379:60409] Make a symbolic breakpoint at UICollectionViewFlowLayoutBreakForInvalidSizes to catch this in the debugger.

不是无聊，只是偶然碰到这个情况，当时还排查了半天，最后才发现是这个问题，这也是很容易遇到的问题，无论是alertView还是alertController，都会出现。

复制代码：

UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"title" message:@"1\n2\n2" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
[al show];
或者：

UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"title" message:@"1\n2\n2" preferredStyle:UIAlertControllerStyleAlert];
UIAlertAction * act =[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
NSLog(@"输出");
}];
[alert addAction:act];
[self presentViewController:alert animated:YES completion:nil];

用6p或者6sp运行，就会出现上述警告，原因不明（系统bug？）。。。其他模拟器都没事。这里提出来只是提醒注意规避吧。

而且分析上述警告也很有意思，大致是说UICollectionView的布局有问题，这是不是可以说明系统的alertView或者alertController都是利用UICollectionView进行封装的呢？

上述临街情况的样式：
1.不会出现的：
![](http://upload-images.jianshu.io/upload_images/1468630-64fd2c89c4ebeca9.gif?imageMogr2/auto-orient/strip)
2.会出现的，仅仅是少了一个字符：
![](http://upload-images.jianshu.io/upload_images/1468630-1a7eb7fcdaefa4b4.gif?imageMogr2/auto-orient/strip)


