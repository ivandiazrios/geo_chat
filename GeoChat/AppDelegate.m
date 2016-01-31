#import "AppDelegate.h"
#import "NetworkMethods.h"
#import "DBManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
    UIUserNotificationType types = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    if (launchOptions != nil)
    {
        NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (dictionary != nil)
        {
            NSLog(@"Launched from push notification: %@", dictionary);
            [self processNotification];
            
        }
    }
    
    
  return YES;
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    [self processNotification];
    
}


-(void)processNotification {
   // NSLog(@"Received notification: %@", userInfo);
    [NSURLConnection sendAsynchronousRequest:[NetworkMethods getP2PMessagesFromServer]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               [[DBManager getInstance] processPeerToPeerDataReturnedByServer:data];
                           }];
    UITabBarController *tabBar = (UITabBarController *) self.window.rootViewController;
    UITabBarItem *chatItem = (UITabBarItem *) [tabBar.tabBar.items objectAtIndex:1];
    chatItem.badgeValue = @"New";
}
// Delegation methods
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(newToken);
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:newToken forKey:@"DeviceToken"];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"]) {
            
            NSMutableURLRequest *request = [NetworkMethods generateRequestForAddingDeviceTokenToRegistrationWithToken:newToken];
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:nil];
             }
        
        
    } else if (deviceToken != [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"]){
        // token has changed, need to update the server.
        //TODO update token on server
        [[NSUserDefaults standardUserDefaults] setObject:newToken forKey:@"DeviceToken"];
        NSMutableURLRequest *request = [NetworkMethods generateRequestForAddingDeviceTokenToRegistrationWithToken:newToken];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:nil];
        
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}



- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
