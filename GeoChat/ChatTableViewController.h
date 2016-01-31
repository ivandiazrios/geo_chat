#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface ChatTableViewController : UITableViewController

@property DBManager *db;
@property NSDictionary *textAttributes;
@property NSMutableArray *conIDs;


@end

