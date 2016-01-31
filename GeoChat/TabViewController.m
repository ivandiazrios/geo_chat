//
//  TabViewController.m
//  GeoChat
//
//  Created by Ivan Diaz on 5/26/15.
//  Copyright (c) 2015 Ivan Diaz. All rights reserved.
//

#import "TabViewController.h"
#import "UIColor+UIColor_CustomScheme.h"
#import "DBManager.h"

@interface TabViewController ()

@end

@implementation TabViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tabBar.barStyle = UIBarStyleBlack;
    self.tabBar.translucent = NO;
  self.tabBar.barTintColor = [UIColor themeColor1];
    self.tabBar.tintColor = [UIColor themeColor4];
   
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
