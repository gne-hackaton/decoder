//
//  DERecentViewController.m
//  decoder
//
//  Created by Kamil Kocemba on 8/29/12.
//  Copyright (c) 2012 Roche. All rights reserved.
//

#import "DERecentViewController.h"
#import "GANTracker.h"

@interface DERecentViewController ()

@end

@implementation DERecentViewController

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
    [[GANTracker sharedTracker] trackPageview:@"Recents View" withError:NULL];
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
