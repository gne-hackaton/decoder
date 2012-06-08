#import "DEJsonRequest.h"

@interface DEAcronymsListTableViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate> {
    DEJsonRequest *r;
}

@property (nonatomic, retain) NSArray *listContent;

@end
