//
//  SettingsViewController.m
//  GeoChat
//
//  Created by Henry Turner on 11/06/2015.
//  Copyright (c) 2015 Ivan Diaz. All rights reserved.
//

#import "SettingsViewController.h"
#import "DBManager.h"
#import "NetworkMethods.h"
#import "UIColor+UIColor_CustomScheme.h"

@implementation SettingsViewController

-(IBAction)back:(id)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:_distance forKey:@"distance"];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)reset:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset App"
                                                    message:@"Are you sure you want to delete all data and re-register the device? This cannot be undone."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Continue",nil];
    [alert show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [NSURLConnection sendSynchronousRequest:[NetworkMethods deleteEverythingFromServer]
                          returningResponse:nil
                                      error:nil];

    [defaults setObject:nil forKey:@"UserID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[DBManager getInstance] deleteEverythingInDatabase];
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidLoad {
    [self.navBar setBarTintColor:[UIColor themeColor1]];
    self.view.backgroundColor = [UIColor themeColor2];
    self.resetButton.backgroundColor = [UIColor themeColor5];
    self.resetButton.layer.borderWidth = 1;
    self.resetButton.layer.cornerRadius = 5;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _distance = [[NSUserDefaults standardUserDefaults] integerForKey:@"distance"];
    self.distanceTextField.text = [NSString stringWithFormat:@"%lu", (unsigned long)_distance];
    self.distanceSlider.value = _distance;
}

-(IBAction)distanceChanged {
    _distance = (int)self.distanceSlider.value;
    self.distanceTextField.text = [NSString stringWithFormat:@"%lu", (unsigned long)_distance];
}

@end
