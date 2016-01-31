#import "RegisterDeviceController.h"
#import "NetworkMethods.h"
@interface RegisterDeviceController ()

@end

@implementation RegisterDeviceController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)requestUserIDAndStore {
    // generate a CFUUID for this app.
    NSString *CFUUID = [RegisterDeviceController acquireUUID];
    // send the CFUUID to server and get back json object
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"]) {
        request = [NetworkMethods generateRequestForRegisteringWithCFUUID:CFUUID withDeviceToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"]];
    } else {
        request = [NetworkMethods generateRequestForRegisteringWithCFUUID:CFUUID];
    }
    // Create url connection and send request
    NSData * data = [[NSData alloc]init];
    data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:nil
                                                      error:nil];
    if (data == nil) {
        return false;
    }
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (json[@"UserID"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:50 forKey:@"distance"];
        [defaults setObject:[json objectForKey:@"UserID"] forKey:@"UserID"];
        [defaults setObject: CFUUID forKey:@"UUID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return true;
    }
    else {
        return false;
    }
}
    
- (IBAction)registerDevice:(id)sender {

    if ([self requestUserIDAndStore]) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Failed"
                                                        message:@"Sorry but registration with the server could not be completed at this time."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

+ (NSString *)acquireUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge_transfer NSString *)string;
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
