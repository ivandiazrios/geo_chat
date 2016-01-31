//
//  MeViewController.h
//  GeoChat
//
//  Created by Ivan Diaz on 6/11/15.
//  Copyright (c) 2015 Ivan Diaz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *totalScore;
@property (weak, nonatomic) IBOutlet UILabel *totalPosts;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property NSMutableArray *posts;

@end
