//
//  ChatViewController.h
//  GeoChat
//
//  Created by Ivan Diaz on 6/2/15.
//  Copyright (c) 2015 Ivan Diaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Conversation.h"

@interface ChatViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property NSUInteger userID;
@property Conversation *conversation;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyBoardHeight;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property NSDictionary *textAttributes;

-(instancetype)initWithConversation:(Conversation*)conv;
- (IBAction)blockButtonPressed:(id)sender;

@end
