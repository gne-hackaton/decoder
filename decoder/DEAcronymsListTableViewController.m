#import "DEAcronymsListTableViewController.h"
#import "DEAcronymsDetailViewController.h"
#import "DEAcronym.h"
#import "DEJsonRequest.h"

#define SEARCH_URL @"http://10-36-209-202.wifi.gene.com:4567/search/"

@implementation DEAcronymsListTableViewController

@synthesize listContent = _listContent, tableView = _tableView;

- (NSArray *)listContent {
    if (!_listContent) {
        _listContent = [[NSArray alloc] init];
    }
    return _listContent;
}

- (void) setListContent:(NSArray *)listContent {
    if (listContent != _listContent) {
        _listContent = listContent;
        [self.tableView reloadData];
    }
}

#pragma mark - 
#pragma mark Lifecycle methods

- (void)viewDidLoad
{
	self.title = @"DECODER RING";
	
	self.tableView.scrollEnabled = YES;
}

- (void)dealloc
{
	[_listContent release];
    [_tableView release];
	
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

- (void)searchWithSearchTerm: (NSString *) searchText {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *searchURL = SEARCH_URL;
    NSString *searchString = [searchURL stringByAppendingString:[searchText capitalizedString]];
    DEJsonRequest *r = [[DEJsonRequest alloc] initWithURL:searchString];
    [r connect];
    
	r.completion = ^(id data) {
		NSLog(@"acronyms array: %@", data);
        self.listContent = data;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	};
    [r release];
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

