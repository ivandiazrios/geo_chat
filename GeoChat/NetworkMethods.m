//
//  NetworkMethods.m
//  GeoChat
//
//  Created by Henry Turner on 06/06/2015.
//  Copyright (c) 2015 Ivan Diaz. All rights reserved.
//

#import "NetworkMethods.h"

@implementation NetworkMethods


+(NSMutableURLRequest *)fillPostStandardWithRequest:(NSMutableURLRequest *)request withString:(NSString *)stringData {
    NSData *requestBodyData = [NSData dataWithBytes:[stringData UTF8String] length:[stringData length]];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[requestBodyData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:requestBodyData];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    return request;
}

#pragma mark location messages
+(NSMutableURLRequest *)generateRequestForGettingMessagesAtLocation:(CLLocationCoordinate2D)coordinate {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://178.62.80.125/WebApps/web/retrieve_loc_msg.php"]];
    NSString *stringData =[NSString stringWithFormat:@"basic_auth=ivan&Latitude=%f&Longitude=%f&UserId=%@&Distance=%ld",
                           coordinate.latitude,
                           coordinate.longitude,
                           [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"],
                           (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"distance"]];
    return [self fillPostStandardWithRequest:request withString:stringData];
}

+(NSMutableURLRequest *)generateRequestForSendingLocationMessageWithCoordinate:(CLLocationCoordinate2D)coordinate
                                                                   WithMessage:(NSString *)message {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://178.62.80.125/WebApps/web/loc_msg.php"]];
    NSString *stringData =[NSString stringWithFormat:@"basic_auth=henry&User=%@&Latitude=%f&Longitude=%f&Message=%@",
                           [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"],
                           coordinate.latitude,
                           coordinate.longitude,
                           message];
    return [self fillPostStandardWithRequest:request withString:stringData];

}

+(NSMutableURLRequest *)incrementScoreOfPost:(NSUInteger)msgID {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://178.62.80.125/WebApps/web/inc_score.php"]];
    NSString *stringData = [NSString stringWithFormat:@"basic_auth=islay&MsgId=%lu",msgID];
    return [self fillPostStandardWithRequest:request withString:stringData];
}

+(NSMutableURLRequest *)generateRequestForUsersScores {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://178.62.80.125/WebApps/web/loc_msg_for_user.php"]];
    NSString *stringData =[NSString stringWithFormat:@"basic_auth=aberlour&UserId=%@", [[NSUserDefaults standardUserDefaults]  objectForKey:@"UserID"]];
    return [self fillPostStandardWithRequest:request withString:stringData];
    
}
#pragma mark user registration
+(NSMutableURLRequest *)generateRequestForRegisteringWithCFUUID:(NSString *)CFUUID {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://178.62.80.125/WebApps/web/user_registration.php"]];
    NSString *stringData =[NSString stringWithFormat:@"basic_auth=duncan&CFUUID=%@", CFUUID];
    return [self fillPostStandardWithRequest:request withString:stringData];
    
}
+(NSMutableURLRequest *)generateRequestForRegisteringWithCFUUID:(NSString *)CFUUID
                                                withDeviceToken:(NSString *)deviceToken {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://178.62.80.125/WebApps/web/user_registration.php"]];
    NSString *stringData =[NSString stringWithFormat:@"basic_auth=duncan&CFUUID=%@&PushToken=%@", CFUUID, deviceToken];

    return [self fillPostStandardWithRequest:request withString:stringData];
    
}

+(NSMutableURLRequest *)generateRequestForAddingDeviceTokenToRegistrationWithToken:(NSString *)deviceToken {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://178.62.80.125/WebApps/web/add_pushtoken.php"]];
    NSString *stringData =[NSString stringWithFormat:@"basic_auth=ardbeg&UserId=%@&PushToken=%@",
                           [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"],
                           deviceToken];
    return [self fillPostStandardWithRequest:request withString:stringData];

}

#pragma mark p2p messages

+(NSMutableURLRequest *)generateRequestForP2PSendWithMessage:(NSString *)message
                                                withSenderID:(NSUInteger)senderID
                                            withReceiveredID:(NSUInteger)receiverID {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://178.62.80.125/WebApps/web/send_p2p_msg.php"]];
    NSString *stringData =[NSString stringWithFormat:@"basic_auth=sketch&SenderId=%@&ReceiverId=%lu&Message=%@",
                           [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"], (unsigned long) receiverID, message];
        return [self fillPostStandardWithRequest:request withString:stringData];
   }

+(NSMutableURLRequest *)getP2PMessagesFromServer {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://178.62.80.125/WebApps/web/get_p2p_msg.php"]];
    NSString *stringData =[NSString stringWithFormat:@"basic_auth=jimdawg&ReceiverId=%@",
                           [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"]];
    return [self fillPostStandardWithRequest:request withString:stringData];

}

#pragma mark delete everything
+(NSMutableURLRequest *)deleteEverythingFromServer {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://178.62.80.125/WebApps/web/delete_user.php"]];
    NSString *stringData =[NSString stringWithFormat:@"basic_auth=supermalt&UserId=%@",
                           [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"]];
    return [self fillPostStandardWithRequest:request withString:stringData];
    
}

+(NSMutableURLRequest *)generateRequestToBlockUser:(NSUInteger)blockID {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://178.62.80.125/WebApps/web/block_user.php"]];
    NSString *stringData =[NSString stringWithFormat:@"basic_auth=timder&Blocker=%@&Blockee=%lu",
                           [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"],
                           blockID];
    return [self fillPostStandardWithRequest:request withString:stringData];
}

@end
