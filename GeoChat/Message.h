#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Message : NSObject 

@property (copy) NSString *message;
@property CLLocation *location;
@property NSUInteger userID; //user id of the sender of this particular message
@property NSInteger messageID;
@property bool inced;
-(id)initWithMessage:(NSString*)msg withUserID:(NSUInteger)userID withMessageID:(NSInteger)msgID;
-(void)sendMessageToServer;
-(void)methodReceiptConfirmation: (NSData *)data;


@end
