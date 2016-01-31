#import "RegisterDeviceController.h"
#import "FindViewController.h"
#import "Message.h"
#import "DBManager.h"

@implementation FindViewController

-(id)initWithCoder:(NSCoder *)aDecoder {
  if(self = [super initWithCoder:aDecoder]) {
    [self initLocationManager];
    self.navigationController.navigationBar.translucent = NO;
  }
  return self;
}

-(void)initLocationManager {
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  self.locationManager.distanceFilter = 50.0;
  self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
    [self.locationManager requestWhenInUseAuthorization];
  }
}

-(void) checkDeviceRegistered {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if (![defaults objectForKey:@"UserID"]) {
    RegisterDeviceController *rd = [[RegisterDeviceController alloc] init];
    [self presentViewController:rd animated:YES completion:nil];
  }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.settingsBarButton.title = @"\u2699";
    [self.navigationItem setRightBarButtonItem:nil];
    [self.locationManager startUpdatingLocation];
    if (self.chatsTable == nil) {
        self.chatsTable = [[FindTableViewController alloc] init:self.navigationController];
        [self.view addSubview:self.chatsTable.view];
        [UIView animateWithDuration:0.5 animations:^{self.chatsTable.view.alpha = 1.0;}];
        self.chatsTable.locationManager = self.locationManager;
    }
}

-(void)viewDidAppear:(BOOL)animated {
  [self checkDeviceRegistered];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    static BOOL firstLocation = YES;
    if (firstLocation) {
        firstLocation = NO;
        [self.navigationItem setRightBarButtonItem:self.composeMessage animated:YES];
        [self.chatsTable findChats];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"settings"]) {
        
    } else {
    
        NewMessageViewController *mc = [segue destinationViewController];
        mc.locationManager = self.locationManager;
        [self.locationManager startUpdatingLocation];
    }
}

@end
