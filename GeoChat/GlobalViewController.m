//
//  GlobalViewController.m
//  GeoChat
//
//  Created by Henry Turner on 04/06/2015.
//  Copyright (c) 2015 Henry Turner. All rights reserved.
//

#import "GlobalViewController.h"
#import "UIColor+UIColor_CustomScheme.h"
#import "Message.h"
#import "NetworkMethods.h"
#define METERS_PER_MILE 1609.344

@interface GlobalViewController()

-(void)doSearch;
-(void)dismissKeyboard;

@end

@implementation GlobalViewController

-(void)viewDidAppear:(BOOL)animated {

}
-(void)viewDidLoad {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.centerAnnotation = [[MKPointAnnotation alloc] init];
    self.MessagesView.backgroundColor = [UIColor themeColor2];
    
    self.firstMsgLabel.hidden = YES;
    self.secondMsgLabel.hidden = YES;
    self.thirdMsgLabel.hidden = YES;
    
    [self.labelArray addObject:self.firstMsgLabel];
    [self.labelArray addObject:self.secondMsgLabel];
    [self.labelArray addObject:self.thirdMsgLabel];
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 51.5072;
    zoomLocation.longitude= -0.1275;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 3*METERS_PER_MILE, 3*METERS_PER_MILE);
    
    [self.map setRegion:viewRegion animated:NO];
    //[self.map addAnnotation:point];
    self.centerAnnotation.coordinate = self.map.centerCoordinate;
    self.centerAnnotation.title = @"";
    self.centerAnnotation.subtitle = @"";
    
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self.map addAnnotation:self.centerAnnotation];
    self.centerAnnotation.coordinate = self.map.centerCoordinate;
    
    // pull messages from this location
    // display the highest scoring three
    self.firstMsgLabel.hidden = YES;
    self.secondMsgLabel.hidden = YES;
    self.thirdMsgLabel.hidden = YES;
    [self findChats];
    
    
    
}

-(void)findChats {
    // load chats from network.
    //NSLog(@"sending message to server");
    // send the CFUUID to server and get back json object
    
    NSMutableURLRequest *request = [NetworkMethods generateRequestForGettingMessagesAtLocation:self.centerAnnotation.coordinate];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               [self formatData:data];
                           }];
}

-(void)formatData: (NSData *)data {
    NSLog(@"Data returned");
    if (data == nil) {
        NSLog(@"Message error");
        return;
        
    }
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    // we need to return something
    for (id key in json) {
        NSLog(@"key: %@, value: %@ \n", key, [json objectForKey:key]);
    }
    // add all of them to the current array
    
    if ([json objectForKey:@"ErrorCode"]) {
        return;
    }
    
    NSArray *dataArray = [json objectForKey:@"Messages"];
    int count = 0;
    NSMutableArray *msgArray = [[NSMutableArray alloc] init];
    for (NSDictionary *key in dataArray) {
        count ++;
        Message *new_msg = [Message alloc];
        new_msg.message = [key objectForKey:@"Msg"];
        new_msg.messageID = [[key objectForKey:@"MsgId"] integerValue];
        new_msg.userID = [[key objectForKey:@"UserId"] integerValue];
        [msgArray addObject:new_msg];
    }
    
    if (count > 2) {
        self.firstMsgLabel.text = [[msgArray objectAtIndex:count-1] message];
        self.secondMsgLabel.text = [[msgArray objectAtIndex:count -2] message];
        self.thirdMsgLabel.text = [[msgArray objectAtIndex:count -3] message];
        
        self.firstMsgLabel.hidden = NO;
        self.secondMsgLabel.hidden = NO;
        self.thirdMsgLabel.hidden = NO;
        
    }
    else if (count > 1) {
        self.firstMsgLabel.text = [[msgArray objectAtIndex:count -1] message];
        self.secondMsgLabel.text = [[msgArray objectAtIndex:count -2] message];
        self.firstMsgLabel.hidden = NO;
        self.secondMsgLabel.hidden = NO;
    }
    else if (count > 0) {
        self.firstMsgLabel.text = [[msgArray objectAtIndex:0] message];
        self.firstMsgLabel.hidden = NO;
    }
        
    
}

#pragma search bar methods

-(void)dismissKeyboard
{
    [self.searchBar resignFirstResponder];
}

-(void)doSearch {
    NSLog(@"do search");
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            return;
        }
        CLPlacemark *firstResult = [placemarks objectAtIndex:0];
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(firstResult.location.coordinate, 3*METERS_PER_MILE, 3*METERS_PER_MILE);
        [self.map setRegion:viewRegion animated:NO];
    }];
    
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self doSearch];
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self doSearch];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

@end
