#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "NewMessageViewController.h"
#import "FindTableViewController.h"

@interface FindViewController : UIViewController  <CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingsBarButton;

@property CLLocationManager *locationManager;
@property IBOutlet UIBarButtonItem *composeMessage;
@property FindTableViewController *chatsTable;

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;

@end

