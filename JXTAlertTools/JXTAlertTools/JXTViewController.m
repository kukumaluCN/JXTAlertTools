//
//  JXTViewController.m
//  JXTAlertTools
//
//  Created by JXT on 16/1/27.
//  Copyright © 2016年 JXT. All rights reserved.
//
//  ***
//  *   GitHub:https://github.com/kukumaluCN/JXTAlertTools
//  *   博客:http://www.jianshu.com/users/c8f8558a4b1d/latest_articles
//  *   邮箱:1145049339@qq.com
//  ***
//

#import "JXTViewController.h"

#import "JXTLibrary/JXTAlertTools.h"

@interface JXTViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * titleArray;

@end

@implementation JXTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"JXTAlertTools";
    
    _titleArray = @[@"0.showTipAlertView---\n确认",
                    @"1.showTipAlertView---\n取消",
                    @"2.showTipAlertView---\n警告（iOS8以前无效）",
                    @"3.showTipAlertView---\n无按钮（默认显示1秒）",
                    @"4.showTipAlertView---\n检测alert是否显示，可控制去重",
                    @"5.showAlert---\n支持定义不定数量个按钮",
                    @"6.showAlert---\n同样支持不添加按钮，和上面的简易tip类似",
                    @"7.showArrayAlert---\n数组列表alert，iOS8之后支持混合样式，是针对于6的功能扩展",
                    @"8.showArrayAlert---\n数组列表alert，无按钮",
                    @"9.showArrayActionSheet - actionSheet---\n数组列表actionSheet，iOS8之后支持混合样式",
                    @"10.showArrayActionSheet - actionSheet---\n数组列表actionSheet，无按钮",
                    @"11.showBottomTipView - actionSheet---\n底部tip提示，无按钮",
                    @"12.showActionSheet ---\n支持不定数量个动作按钮",
                    @"13.showActionSheet ---\n无按钮"
                    ];
    
    [self setupTableView];
    
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(checkAlert)];
    self.navigationItem.rightBarButtonItem = right;
}
- (void)checkAlert
{
    NSLog(@"显示alert:%@", [JXTAlertTools isAlertShowNow] ? @"是" : @"否");
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"CELL";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.backgroundColor = [self randomColor];
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [JXTAlertTools showTipAlertViewWith:self title:EmptyTitle message:_titleArray[indexPath.row] buttonTitle:@"确认" buttonStyle:JXTAlertActionStyleDefault];
    }
    if (indexPath.row == 1) {
        [JXTAlertTools showTipAlertViewWith:self title:EmptyTitle message:_titleArray[indexPath.row] buttonTitle:@"取消" buttonStyle:JXTAlertActionStyleCancel];
    }
    if (indexPath.row == 2) {
        [JXTAlertTools showTipAlertViewWith:self title:EmptyTitle message:_titleArray[indexPath.row] buttonTitle:@"警告" buttonStyle:JXTAlertActionStyleDestructive];
    }
    if (indexPath.row == 3) {
        [JXTAlertTools showTipAlertViewWith:self title:EmptyTitle message:_titleArray[indexPath.row] buttonTitle:nil buttonStyle:JXTAlertActionStyleDefault];

    }
    if (indexPath.row == 4) {
        [self repeatShowTwiceAtIndexPath:indexPath];
    }
    if (indexPath.row == 5) {
        //block方法序列号和按钮名称相同，按钮类型排列顺序固定
        //如果取消为nil，则index0为特殊，以此往后类推，以第一个有效按钮为0开始累加
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
    }
    if (indexPath.row == 6) {
        //没有按钮时，默认自动消失
        [JXTAlertTools showAlertWith:self title:EmptyTitle message:_titleArray[indexPath.row] callbackBlock:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    }
    if (indexPath.row == 7) {
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
    }
    if (indexPath.row == 8) {
        [JXTAlertTools showArrayAlertWith:self title:EmptyTitle message:_titleArray[indexPath.row] callbackBlock:nil cancelButtonTitle:nil otherButtonTitleArray:nil otherButtonStyleArray:nil];
    }
    if (indexPath.row == 9) {
        NSArray * titles = @[@"确定1", @"特殊1", @"确定2", @"特殊2"];
        NSArray * styles = @[
                             [NSNumber numberWithInteger:JXTAlertActionStyleDefault],
                             [NSNumber numberWithInteger:JXTAlertActionStyleDestructive],
                             [NSNumber numberWithInteger:JXTAlertActionStyleDefault],
                             [NSNumber numberWithInteger:JXTAlertActionStyleDestructive]
                             ];
        [JXTAlertTools showArrayActionSheetWith:self title:_titleArray[indexPath.row] message:_titleArray[indexPath.row] callbackBlock:^(NSInteger btnIndex) {
            
            if (iOS_Version >= 8.0) {
                if (btnIndex == 0) {
                    NSLog(@"取消");
                }
                else
                    NSLog(@"%@", titles[btnIndex - 1]);
            }
            else {
                if (btnIndex == 0) {
                    NSLog(@"iOS8之前有效");
                }
                else if (btnIndex == 1) {
                    NSLog(@"取消");
                }
                else
                    NSLog(@"%@", titles[btnIndex - 2]);
            }
        } cancelButtonTitle:@"取消" destructiveButtonTitle:@"iOS8之前有效" otherButtonTitleArray:titles otherButtonStyleArray:styles];
    }
    if (indexPath.row == 10) {
        NSLog(@"显示sheet:%@", [JXTAlertTools isAlertShowNow] ? @"是" : @"否");
        [JXTAlertTools showArrayActionSheetWith:self title:_titleArray[indexPath.row] message:_titleArray[indexPath.row] callbackBlock:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitleArray:nil otherButtonStyleArray:nil];
        NSLog(@"显示sheet:%@", [JXTAlertTools isAlertShowNow] ? @"是" : @"否");
    }
    if (indexPath.row == 11) {
        NSLog(@"显示sheet:%@", [JXTAlertTools isAlertShowNow] ? @"是" : @"否");
        [JXTAlertTools showBottomTipViewWith:self title:_titleArray[indexPath.row] message:_titleArray[indexPath.row]];
        NSLog(@"显示sheet:%@", [JXTAlertTools isAlertShowNow] ? @"是" : @"否");
    }
    if (indexPath.row == 12) {
        [JXTAlertTools showActionSheetWith:self title:_titleArray[indexPath.row] message:_titleArray[indexPath.row] callbackBlock:^(NSInteger btnIndex) {
            if (btnIndex == 0) {
                NSLog(@"特殊");
            }
            if (btnIndex == 1) {
                NSLog(@"取消");
            }
            if (btnIndex == 2) {
                NSLog(@"其他");
            }
        } destructiveButtonTitle:@"特殊" cancelButtonTitle:@"取消" otherButtonTitles:@"其他", nil];
    }
    if (indexPath.row == 13) {
        [JXTAlertTools showActionSheetWith:self title:_titleArray[indexPath.row] message:_titleArray[indexPath.row] callbackBlock:nil destructiveButtonTitle:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    }
}

#pragma mark - 特殊方法
- (void)repeatShowTwiceAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"显示alert:%@", [JXTAlertTools isAlertShowNow] ? @"是" : @"否");
    if (![JXTAlertTools isAlertShowNow]) {//检测弹窗，控制alertView的去重显示
        [JXTAlertTools showTipAlertViewWith:self title:EmptyTitle message:_titleArray[indexPath.row] buttonTitle:nil buttonStyle:JXTAlertActionStyleDefault];
    }
    NSLog(@"显示alert:%@", [JXTAlertTools isAlertShowNow] ? @"是" : @"否");

    
    //模拟重复调用
    static int count = 0;
    count ++;
    if (count == 2) {
        count = 0;
        return ;
    }
    else {
        //alertViewController连续同时弹出，系统会自动去重并警告
        //JXTAlertTools[32916:1012485] Warning: Attempt to present <UIAlertController: 0x7fd9ee029a90>  on <JXTViewController: 0x7fd9ebc99940> which is already presenting (null)
        //alertView则会叠加
        //只要下次执行时间 <2秒（自动消失弹窗延时1秒），那么就会导致叠加弹窗，可能需要去重显示
        [self performSelector:@selector(repeatShowTwiceAtIndexPath:) withObject:nil afterDelay:0.5];
    }
}

#pragma mark - 随机色
- (UIColor *)randomColor
{
    CGFloat r = arc4random_uniform(255);
    CGFloat g = arc4random_uniform(255);
    CGFloat b = arc4random_uniform(255);
    
    return [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:0.3f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
