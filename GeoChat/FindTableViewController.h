//
//  FindTableViewController.h
//  GeoChat
//
//  Created by Ivan Diaz on 5/28/15.
//  Copyright (c) 2015 Ivan Diaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface FindTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray *messages;
@property int cellCount;
@property UINavigationController *nav_controller;
@property CLLocationManager *locationManager;

-(instancetype)init:(UINavigationController*)navController;
-(void)findChats;


@end
