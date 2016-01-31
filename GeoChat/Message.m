#import "Message.h"
#import "NetworkMethods.h"

@implementation Message

-(id)initWithMessage:(NSString *)msg withUserID:(NSUInteger)userID withMessageID:(NSInteger)msgID {
    if (self = [super init]) {
        _message = msg;
        _userID = userID;
        _messageID = msgID;
    }
    return self;
}

-(void)sendMessageToServer {
    
    // send the CFUUID to server and get back json object

    NSMutableURLRequest *request = [NetworkMethods generateRequestForSendingLocationMessageWithCoordinate:self.location.coordinate WithMessage:self.message];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               [self methodReceiptConfirmation:data];
                           }];
}

-(void)methodReceiptConfirmation: (NSData *)data{
    
    if (data == nil) {
        [self sendMessageInBackground];
    }
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    // we need to return something
    if (json[@"ErrorCode"]) {
        [self sendMessageInBackground];
    }
    NSLog(@"Message sent");
}

-(void)sendMessageInBackground {
    NSLog(@"Message send error occured");
}

@end
