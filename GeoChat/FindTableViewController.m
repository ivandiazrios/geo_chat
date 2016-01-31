//
//  FindTableViewController.m
//  GeoChat
//
//  Created by Ivan Diaz on 5/28/15.
//  Copyright (c) 2015 Ivan Diaz. All rights reserved.
//

#import "FindTableViewController.h"
#import "Message.h"
#import "ChatViewController.h"
#import "Conversation.h"
#import "AddScoreButton.h"
#import "UIColor+UIColor_CustomScheme.h"
#import "NetworkMethods.h"
#define EDGE_INSETS 15

@implementation FindTableViewController

-(instancetype)init:(UINavigationController *)navController {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.nav_controller = navController;
    }
    return self;
}

-(void)viewDidLoad {
    self.messages = [[NSMutableArray alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"FindCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor themeColor5];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(findChats)
                  forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    //[self getLatestChats];
    [self costumiseTableView];

}

-(void)costumiseTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.alpha = 0.0;
    self.tableView.backgroundColor = [UIColor themeColor2];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, EDGE_INSETS, 0, EDGE_INSETS)];
    self.tableView.rowHeight = 80;
    self.tableView.separatorColor = [UIColor themeColor3];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)findChats {
    
    NSMutableURLRequest *request = [NetworkMethods generateRequestForGettingMessagesAtLocation:self.locationManager.location.coordinate];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               [self formatData:data];
                           }];

}

-(void)formatData: (NSData *)data {
    NSLog(@"Data returned");
    if (data == nil) {
        NSLog(@"Message error");
        return;
        
    }
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    // we need to return something
    for (id key in json) {
        NSLog(@"key: %@, value: %@ \n", key, [json objectForKey:key]);
    }
    // add all of them to the current array
    NSArray *dataArray = [json objectForKey:@"Messages"];
    for (NSDictionary *key in dataArray) {
        Message *new_msg = [Message alloc];
        new_msg.message = [key objectForKey:@"Msg"];
        new_msg.messageID = [[key objectForKey:@"MsgId"] integerValue];
        new_msg.userID = [[key objectForKey:@"UserId"] integerValue];
        if ([self messageNotAlreadyDisplayed:new_msg]) {
            [self.messages insertObject:new_msg atIndex:0];
            self.cellCount ++;
            [self deleteOldItemsIfNecessary];
        }
    }
    
    [self.tableView reloadData];
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        [self.refreshControl endRefreshing];
    }
}

-(void)deleteOldItemsIfNecessary {
    while (self.cellCount > 25) {
        self.messages.removeLastObject;
        self.cellCount --;
    }
    
}

-(BOOL)messageNotAlreadyDisplayed:(Message *)message {
    for (Message *msg in self.messages) {
        if (msg.messageID == message.messageID) {
            //NSLog(@"already displayed");
            return false;
        }
    }
    return true;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor themeColor2];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:10];
    AddScoreButton *button = (AddScoreButton *) [cell.contentView viewWithTag:11];
    Message *msg = [self.messages objectAtIndex:indexPath.row];
    button.enabled = !msg.inced;
    button.message = msg;
    [button addTarget:self
               action:@selector(incrementScore:)
     forControlEvents:UIControlEventTouchUpInside];
    [label setText:msg.message];
    return cell;
}


-(void)incrementScore:(AddScoreButton *)sender {
    // send network request to increment sender.msgId's score
    [NSURLConnection sendAsynchronousRequest:[NetworkMethods incrementScoreOfPost:(NSUInteger)sender.message.messageID]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:nil];
    sender.enabled = false;
    sender.message.inced = true;
    NSLog(@"%ld",(long)sender.msgId);
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.cellCount;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
// Return the number of sections.
        if (self.messages.count != 0) {
            self.tableView.backgroundView = nil;
            return 1;
        }
        else {
            // Display a message when the table is empty
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            messageLabel.text = @"No messages are currently available in this location. Please pull down to refresh.";
            messageLabel.textColor = [UIColor blackColor];
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
            [messageLabel sizeToFit];
            self.tableView.backgroundView = messageLabel;
        }
        
        return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *m = [self.messages objectAtIndex:indexPath.row];
    Conversation *conversation = [[Conversation alloc] initWithUserId:m.userID WithMessage:m];
    ChatViewController *chatViewController =
                        [[ChatViewController alloc] initWithConversation:conversation];
    [_nav_controller presentViewController:chatViewController animated:YES completion:nil];
}

@end