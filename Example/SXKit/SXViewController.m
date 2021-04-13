//
//  SXViewController.m
//  SXKit
//
//  Created by vince_wang on 04/09/2021.
//  Copyright (c) 2021 vince_wang. All rights reserved.
//

#import "SXViewController.h"
#import <SXHudHeader.h>
@interface SXViewController ()

@end

@implementation SXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    SXShowTips(@"111");
}
@end
