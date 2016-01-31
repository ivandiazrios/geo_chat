//
//  GlobalViewController.h
//  GeoChat
//
//  Created by Henry Turner on 04/06/2015.
//  Copyright (c) 2015 Ivan Diaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface GlobalViewController : UIViewController <UISearchBarDelegate>


@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) MKPointAnnotation *centerAnnotation;
@property (strong, nonatomic) IBOutlet UIView *MessagesView;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet UILabel *firstMsgLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondMsgLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdMsgLabel;
@property (strong, nonatomic) NSMutableArray *labelArray;

@end
