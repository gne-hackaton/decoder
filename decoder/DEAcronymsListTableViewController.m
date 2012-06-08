#import "DEAcronymsListTableViewController.h"
#import "DEAcronymsDetailViewController.h"
#import "DEAcronym.h"
#import "DEJsonRequest.h"

@implementation DEAcronymsListTableViewController

@synthesize listContent, savedSearchTerm, searchWasActive;


#pragma mark - 
#pragma mark Lifecycle methods

- (void)viewDidLoad
{
	self.title = @"DECODER RING";
    
    if (!self.listContent) {
        self.listContent = [[NSArray alloc] init];
    }
	
	// restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];

        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
	
	[self.tableView reloadData];
	self.tableView.scrollEnabled = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    // save the state of the search UI so that it can be restored if the view is re-created
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];

}

- (void)dealloc
{
	[listContent release];
	[filteredListContent release];
	
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
    NSLog(@"indexPath.row: %d", indexPath.row);
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


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"searchBarTextDidEndEditing");
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"textDidChange: %@", searchText);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *searchURL = @"http://10-36-209-202.wifi.gene.com:4567/search/";
    NSString *searchString = [searchURL stringByAppendingString:[searchText capitalizedString]];
    DEJsonRequest *r = [[DEJsonRequest alloc] initWithURL:searchString];
    [r connect];
    
	r.completion = ^(id data) {
		NSLog(@"acronyms array: %@", data);
        self.listContent = data;
        [self.tableView reloadData];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	};
    [r release];
}

@end

