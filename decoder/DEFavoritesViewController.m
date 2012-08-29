//
//  DEFavoritesViewController.m
//  decoder
//
//  Created by Kamil Kocemba on 8/29/12.
//  Copyright (c) 2012 Roche. All rights reserved.
//

#import "DEFavoritesViewController.h"
#import "GANTracker.h"

@interface DEFavoritesViewController ()

@end

@implementation DEFavoritesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[GANTracker sharedTracker] trackPageview:@"Favorites View" withError:NULL];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
