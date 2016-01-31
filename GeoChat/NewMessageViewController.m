#import "NewMessageViewController.h"

@implementation NewMessageViewController

-(void)awakeFromNib {
  [super awakeFromNib];
  self.done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
 
}

- (void)viewDidLoad {
  [super viewDidLoad];
    self.msg = [Message alloc];
    
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.message becomeFirstResponder];
  self.doneVisible = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
  [self.message resignFirstResponder];
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender {
  [self generateMessage];
  [self.msg sendMessageToServer];
    [self.message resignFirstResponder];
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textView:(UITextField *)textView shouldChangeTextInRange:(NSRange)range
                                        replacementText:(NSString *)string {
  // Prevent crashing undo bug
  if(range.length + range.location > textView.text.length)
  {
    return NO;
  }
  
  unsigned long newLength = [textView.text length] + [string length]
                            - range.length;
  [self showDone:newLength];
  return newLength <= MAX_TEXT_LENGTH;
}

-(void) showDone:(unsigned long) length {  
  if (length > 0 && !_doneVisible) {
    [self.navBar.topItem setRightBarButtonItem:self.done animated:YES];
    _doneVisible = true;
  } else if (length == 0 && _doneVisible) {
    self.navBar.topItem.rightBarButtonItem = Nil;
    _doneVisible = false;
  }
}

-(void)generateMessage {
    self.msg.message = self.message.text;
    self.msg.location = self.locationManager.location;
}

@end
