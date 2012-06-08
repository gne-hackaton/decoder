//
//  DEAcronymsDetailViewController.h
//  decoder
//
//  Created by Andrzej N on 12-06-07.
//  Copyright (c) 2012 Roche. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DEAcronym;

@interface DEAcronymsDetailViewController : UITableViewController

- (id)initWithAcronym:(DEAcronym*)acronym;
@end
