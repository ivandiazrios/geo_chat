#import "ChatTableViewController.h"
#import "UIColor+UIColor_CustomScheme.h"
#import "NetworkMethods.h"
#import "DBManager.h"
#import "ChatViewController.h"
#define EDGE_INSETS 15
#define FONT_SIZE 17

extern NSString *font_name;

@implementation ChatTableViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _db = [DBManager getInstance];
        _textAttributes = @{
                            NSFontAttributeName:[UIFont fontWithName:font_name size:FONT_SIZE],
                            };
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self costumiseTableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"ConversationCell" bundle:nil]forCellReuseIdentifier:@"cell"];
    [NSURLConnection sendAsynchronousRequest:[NetworkMethods getP2PMessagesFromServer]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               [[DBManager getInstance] processPeerToPeerDataReturnedByServer:data];
                           }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"Reload" object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [self reloadData];
    [super viewWillAppear:animated];
    UITabBarController *tbVC = (UITabBarController *) self.parentViewController.parentViewController;
    [[tbVC.tabBar.items objectAtIndex:1] setBadgeValue:nil];
}


-(void)costumiseTableView {
    self.tableView.backgroundColor = [UIColor themeColor2];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, EDGE_INSETS, 0, EDGE_INSETS)];
    self.tableView.rowHeight = 50;
    self.tableView.separatorColor = [UIColor themeColor3];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.conIDs count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor themeColor2];
    UILabel *label = (UILabel*)[cell viewWithTag:1];
    NSUInteger conID = [self getConId:indexPath.row];
    NSString *message = [self.db getLastMessageForConversationID:conID];
    label.attributedText = [[NSMutableAttributedString alloc] initWithString:message attributes:self.textAttributes];
    [self setDotInCell:cell forConID:conID];
    return cell;
}

-(void)setDotInCell:(UITableViewCell*)cell forConID:(NSUInteger)conID {
    UIView *dot = [cell viewWithTag:2];
    if ([_db isConversationUnseen:conID]) {
        dot.alpha = 0.5;
        dot.layer.cornerRadius = 4;
        dot.backgroundColor = [UIColor blueColor];
    } else {
        dot.alpha = 0;
    }
}

-(void)reloadData {
    _conIDs = [NSMutableArray arrayWithArray:[self.db getConvoIDs]];
    [self.tableView reloadData];
}

-(NSUInteger)getConId:(NSUInteger)i {
    return (NSUInteger)[[[self.conIDs objectAtIndex:i] objectAtIndex:0] intValue];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Conversation *conv = [self.db getConversationForID:[self getConId:indexPath.row]];
    
    ChatViewController *chatViewController =
    [[ChatViewController alloc] initWithConversation:conv];
    [self presentViewController:chatViewController animated:YES completion:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Reload" object:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.db deleteConversationForID:[self getConId:indexPath.row]];
        [self.conIDs removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}

@end
