//
//  NetworkMethods.h
//  GeoChat
//
//  Created by Henry Turner on 06/06/2015.
//  Copyright (c) 2015 Ivan Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NetworkMethods : NSObject

+(NSMutableURLRequest *)fillPostStandardWithRequest:(NSMutableURLRequest *)request
                                         withString:(NSString *)stringData;

+(NSMutableURLRequest *)generateRequestForGettingMessagesAtLocation:(CLLocationCoordinate2D)coordinate;

+(NSMutableURLRequest *)generateRequestForSendingLocationMessageWithCoordinate:(CLLocationCoordinate2D)coordinate
                                                                   WithMessage:(NSString *)message;

+(NSMutableURLRequest *)generateRequestForRegisteringWithCFUUID:(NSString *)CFUUID
                                                withDeviceToken:(NSString *)deviceToken;

+(NSMutableURLRequest *)generateRequestForRegisteringWithCFUUID:(NSString *)CFUUID;

+(NSMutableURLRequest *)generateRequestForAddingDeviceTokenToRegistrationWithToken:(NSString *)deviceToken;

+(NSMutableURLRequest *)generateRequestForP2PSendWithMessage:(NSString *)message
                                                withSenderID:(NSUInteger)senderID
                                            withReceiveredID:(NSUInteger)receiverID;

+(NSMutableURLRequest *)incrementScoreOfPost:(NSUInteger)msgID;

+(NSMutableURLRequest *)generateRequestForUsersScores;

+(NSMutableURLRequest *)getP2PMessagesFromServer;

+(NSMutableURLRequest *)deleteEverythingFromServer;

+(NSMutableURLRequest *)generateRequestToBlockUser:(NSUInteger)blockID;

@end
