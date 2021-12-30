//
//  SXTableViewController.m
//  SXKit_Example
//
//  Created by taihe-imac-ios-01 on 2021/5/10.
//  Copyright © 2021 vince_wang. All rights reserved.
//

#import "SXTableViewController.h"
#import <Masonry/Masonry.h>
#import "SXAlertViewController.h"

@interface SXTableViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SXTableViewController

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    NSLog(@"--- %s %d",__FUNCTION__, animated);
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    NSLog(@"--- %s %d",__FUNCTION__, animated);
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    NSLog(@"--- %s %d",__FUNCTION__, animated);
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear: animated];
//    NSLog(@"--- %s %d",__FUNCTION__, animated);
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor redColor];
    self.tableView.rowHeight = 45;
    self.tableView.estimatedRowHeight = 45;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.mas_equalTo(0);
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.panGestureRecognizer.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"1"];
//
    NSLog(@"ff");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"1" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"--- %@",@(indexPath.row)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SXAlertViewController *vc = [SXAlertViewController new];
    vc.handle = [SXVCTransitioningHandle new];
    vc.handle.overlaySource.hideWhenTouchOverlay = NO;
    vc.transitioningDelegate = vc.handle;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)dealloc {
    NSLog(@"--- %s",__FUNCTION__);
}

@end

