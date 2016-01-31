//
//  ChatViewController.m
//  GeoChat
//
//  Created by Ivan Diaz on 6/2/15.
//  Copyright (c) 2015 Ivan Diaz. All rights reserved.
//

#import "ChatViewController.h"
#import "UIColor+UIColor_CustomScheme.h"
#import "ChatCell.h"
#import "DBManager.h"
#import "NetworkMethods.h"
#define CHAT_LABEL_HEIGHT_INCREASE 3
#define BUBBLE_VIEW_SIZE_INCREASE 7
#define FONT_SIZE 17
#define MAX_MESSAGE_WIDTH 200
#define MAX_TEXT_LENGTH 140

NSString *const font_name = @"Helvetica";

@implementation ChatViewController

-(instancetype)initWithConversation:(Conversation *)conv {
    if (self = [super init]) {
        _conversation = conv;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        _textAttributes = @{
                            NSFontAttributeName:[UIFont fontWithName:font_name size:FONT_SIZE],
                            NSParagraphStyleAttributeName:paragraphStyle
                            };
        _userID = [[NSUserDefaults standardUserDefaults] integerForKey:@"UserID"];
    }
    return self;
}

- (IBAction)blockButtonPressed:(id)sender {
    
    // on block button
    // show ui alert
    // if they press yes then we block user and resign this chat view and delete the chat
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Block User"
                                                    message:@"Are you sure you want to block this user? The conversation will be deleted and you will not be able to contact each other through the App again."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Continue",nil];
    [alert show];
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        return;
    }

    [[DBManager getInstance] deleteConversationForID:self.conversation.userID];
    [NSURLConnection sendAsynchronousRequest:[NetworkMethods generateRequestToBlockUser:self.conversation.userID]
                                       queue:nil
                           completionHandler:nil];
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}


-(void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateChat) name:@"Reload" object:nil];
    [self costumiseTableView];
    [self.navBar setBarTintColor:[UIColor themeColor1]];
    [self.sendButton setEnabled:NO];
    
}

-(IBAction)back:(id)sender {
    [self.view endEditing:YES];
    [[DBManager getInstance] setConversationToSeen:self.conversation.userID];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)costumiseTableView {
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor themeColor2];
    self.tableView.rowHeight = 80;
    [self.tableView registerNib:[UINib nibWithNibName:@"ChatCell" bundle:nil] forCellReuseIdentifier:@"chat_cell"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

-(void)keyboardFrameWillChange:(NSNotification*)notification {
    NSLog(@"Frame");
    NSDictionary *info = [notification userInfo];
    CGRect kFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat offset = kFrame.size.height;
    if (self.view.bounds.size.height == kFrame.origin.y) {
        offset = 0;
    }
    self.keyBoardHeight.constant = offset;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[info [UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[info [UIKeyboardAnimationCurveUserInfoKey]integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.conversation.messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(void)addMessageToTable:(Message*)m {
    [self.conversation.messages addObject:m];
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:[self.conversation.messages count]-1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)addMessageToDatabase:(Message*)m {
    DBManager *db = [DBManager getInstance];
    NSUInteger convoID = self.conversation.userID;
    [db insertConversation:convoID otherUserID:convoID];
    [db insertMessage:m.message forConversationID:convoID forAuthor:m.userID];
}

-(void)sendMessage:(Message*)m {
    [NSURLConnection sendAsynchronousRequest:[NetworkMethods generateRequestForP2PSendWithMessage:m.message withSenderID:0 withReceiveredID:self.conversation.userID]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               NSLog(@"%@",str);
                           }];
}

-(IBAction)send {
    if (self.textField.text.length == 0) {
        return;
    }
    if ([_conversation.messages count] == 1) {
        [self addMessageToDatabase:[_conversation.messages objectAtIndex:0]];
        [self sendMessage:[_conversation.messages objectAtIndex:0]];
    }
    Message *m = [[Message alloc] initWithMessage:self.textField.text withUserID:self.userID withMessageID:0];
    self.textField.text = nil;
    [self addMessageToTable:m];
    [self addMessageToDatabase:m];
    [self sendMessage:m];
    [self.sendButton setEnabled:NO];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.conversation.messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(IBAction)hideKeyboard {
   [self.view endEditing:YES];
}

-(void)dealloc {
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Reload" object:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self rectForString:[[self.conversation.messages objectAtIndex:indexPath.row] message]].size.height + CHAT_LABEL_HEIGHT_INCREASE + BUBBLE_VIEW_SIZE_INCREASE;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chat_cell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversation.messages.count;
}

-(CGRect)rectForString:(NSString*)string {
    return [string boundingRectWithSize:CGSizeMake(MAX_MESSAGE_WIDTH, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:self.textAttributes
                                           context:nil];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *c = (ChatCell*) cell;
    cell.backgroundColor = [UIColor clearColor];
    Message *m = [self.conversation.messages objectAtIndex:indexPath.row];
    NSString *message = [m message];
    CGSize size = [self rectForString:message].size;
    UIView *v = (UIView*)[c.contentView viewWithTag:1];
    v.clipsToBounds = YES;
    v.layer.cornerRadius = 6.0f;
    c.bubbleHeight.constant = size.height + BUBBLE_VIEW_SIZE_INCREASE;
    c.bubbleWidth.constant = size.width + BUBBLE_VIEW_SIZE_INCREASE;
    UILabel *msgLabel = (UILabel*)[c.contentView viewWithTag:2];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:message attributes:self.textAttributes];
    msgLabel.numberOfLines = 0;
    msgLabel.attributedText = text;
    c.messageHeight.constant = ceilf(size.height);
    c.messageWidth.constant = ceilf(size.width);
    if (m.userID == _userID) {
        [c.contentView removeConstraint:c.leftConstraint];
        c.isLeftConstraint = NO;
        v.backgroundColor = [UIColor colorWithRed:137/256.0 green:232/256.0 blue:148/256.0 alpha:1.0];
    } else {
        v.backgroundColor = [UIColor colorWithRed:145/256.0 green:240/256.0 blue:242/256.0 alpha:1.0];
    }
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    unsigned long newLength = [textField.text length] + [string length]
    - range.length;
    if (newLength > 0) {
        [self.sendButton setEnabled:YES];
    } else {
        [self.sendButton setEnabled:NO];
    }
    return newLength <= MAX_TEXT_LENGTH;
}

-(void)updateChat {
    NSUInteger convoID = self.conversation.userID;
    NSString *s = [[DBManager getInstance] getLastMessageForConversationID:convoID];
    Message *m = [[Message alloc] initWithMessage:s withUserID:convoID withMessageID:0];
    [self addMessageToTable:m];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.conversation.messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


@end
