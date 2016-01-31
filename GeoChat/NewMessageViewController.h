#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Message.h"
#define MAX_TEXT_LENGTH 140

@interface NewMessageViewController : UIViewController <UITextViewDelegate>
  
@property (weak, nonatomic) IBOutlet UITextView *message;
@property Message *msg;
@property (strong, nonatomic) UIBarButtonItem *done;
@property CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property BOOL doneVisible;


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
                                       replacementText:(NSString *)text;
-(void)showDone:(unsigned long) length;
-(void)generateMessage;


@end
