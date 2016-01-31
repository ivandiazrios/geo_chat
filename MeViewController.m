//
//  MeViewController.m
//  GeoChat
//
//  Created by Ivan Diaz on 6/11/15.
//  Copyright (c) 2015 Ivan Diaz. All rights reserved.
//

#import "MeViewController.h"
#import "UIColor+UIColor_CustomScheme.h"
#import "NetworkMethods.h"
#import "Post.h"
#define EDGE_INSETS 15

@interface MeViewController ()

@end

@implementation MeViewController

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _posts = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor themeColor2];
    self.table.backgroundColor = [UIColor themeColor2];
    [self.table setSeparatorInset:UIEdgeInsetsMake(0, EDGE_INSETS, 0, EDGE_INSETS)];
    self.table.rowHeight = self.table.bounds.size.height/5;
    self.table.separatorColor = [UIColor themeColor3];
    self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.activityIndicator setHidesWhenStopped:YES];
    [self.table registerNib:[UINib nibWithNibName:@"PostCell" bundle:nil] forCellReuseIdentifier:@"post"];
    self.table.scrollEnabled = NO;
    self.table.allowsSelection = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.activityIndicator startAnimating];
    NSMutableURLRequest *request = [NetworkMethods generateRequestForUsersScores];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               // completion handler
                               NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                               // call method here that processes the json dictionary
                               [_posts removeAllObjects];
                               [self.activityIndicator stopAnimating];
                               [self getTopPosts:json];
                               [self setTotals:json];
                           }];
}

-(void)getTopPosts:(NSDictionary*)json {
    NSArray *a = [json objectForKey:@"Messages"];
    for (NSDictionary *dic in a) {
        Post *p = [[Post alloc] initWithScore:[[dic objectForKey:@"Upvotes"] intValue] withMessage:[dic objectForKey:@"Msg"]];
        [_posts addObject:p];
        [self.table reloadData];
    }
}

-(void)setTotals:(NSDictionary*)json {
    NSUInteger total = [[json objectForKey:@"Total Upvotes"] intValue];
    self.totalScore.text = [NSString stringWithFormat:@"%lu", (unsigned long)total];
    total = [[json objectForKey:@"Num Messages"] intValue];
    self.totalPosts.text = [NSString stringWithFormat:@"%lu", (unsigned long)total];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_posts count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"post" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor themeColor2];
    UILabel *scoreLabel = (UILabel*)[cell viewWithTag:1];
    UILabel *messageLabel = (UILabel*)[cell viewWithTag:2];
    int score = (int)[[_posts objectAtIndex:indexPath.row] score];
    scoreLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)score];
    messageLabel.text = [[_posts objectAtIndex:indexPath.row] message];
    return cell;
}

@end
