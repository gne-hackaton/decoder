@interface DEAcronymsListTableViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, retain) NSArray *listContent;
@property (nonatomic, retain) UITableView *tableView;

@end
