#import "DEAcronymsListTableViewController.h"
#import "DEAcronymsDetailViewController.h"
#import "DEAcronym.h"
#import "ConnectionManager.h"

#define SEARCH_URL @"http://10.31.213.107:4567/search/"

@implementation DEAcronymsListTableViewController

@synthesize listContent = _listContent;

- (UISearchBar *)getSearchBar {
    UISearchBar *theSearchBar = nil;
    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
    for (UIView *view in mainWindow.subviews)
        if ([view isKindOfClass:[UISearchBar class]]) theSearchBar = (UISearchBar *) view;
    return theSearchBar;
}

#pragma mark - custom getter/setter
- (NSArray *)listContent {
    if (!_listContent) {
        _listContent = [[NSArray alloc] init];
    }
    return _listContent;
}

- (void) setListContent:(NSArray *)listContent {
    if (listContent != _listContent) {
        _listContent = [listContent retain];
        [self.tableView reloadData];
    }
}

#pragma mark - 
#pragma mark Lifecycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"DECODER RING";
	
//	self.tableView.scrollEnabled = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc
{
	[_listContent release];
	
	[super dealloc];
}


#pragma mark -
#pragma mark UITableView data source and delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listContent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}

	DEAcronym *acronym = nil;

	acronym = [self.listContent objectAtIndex:indexPath.row];
	
	cell.textLabel.text = acronym.name;
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    DEAcronym *acronym = nil;
	acronym = [self.listContent objectAtIndex:indexPath.row];
	DEAcronymsDetailViewController *detailsViewController = [[DEAcronymsDetailViewController alloc] initWithAcronym:acronym];

	detailsViewController.title = acronym.name;
	
	[[self navigationController] pushViewController:detailsViewController animated:YES];
	[detailsViewController release];
}

- (void)showAlertWithMessage: (NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Whoops!"
                          message: message
                          delegate: self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}

- (NSString *) trimFrontAndEndWhiteSpaces: (NSString *) string {
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
}

- (void)searchWithSearchTerm: (NSString *) searchText {
    if (r) {
        [r cancel];
    }
    
    if (searchText!=nil && ![searchText isEqualToString:@" "] && ![searchText isEqualToString:@""]) {
        searchText = [self trimFrontAndEndWhiteSpaces:searchText]; // trim leading white spaces
        if ([[ConnectionManager sharedSingleton] hasInternetConnection]) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            
            NSString *searchURL = SEARCH_URL;
            NSString *searchString = [searchURL stringByAppendingString:[searchText capitalizedString]];
            r = [[DEJsonRequest alloc] initWithURL:searchString];
            [r connect];
            
            r.completion = ^(id data) {
                if (data) {
                    NSLog(@"acronyms array: %@", data);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.listContent = data;
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.view endEditing:TRUE];
                        [self showAlertWithMessage:@"Cannot reach server!"];
                    });
                }
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            };
            
        } else {
            [self showAlertWithMessage:@"Internet connection is required to use the app"];
        }
    } else {
        self.listContent = nil;
    }
}

#pragma mark -
#pragma mark UISearchBar Delegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:TRUE];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"searchBarTextDidEndEditing");
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchWithSearchTerm:searchText];
}

#pragma mark - UIScrollView Delegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:TRUE];
}

@end

