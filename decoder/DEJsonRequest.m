//
//  DEJsonRequest.m
//  decoder
//
//  Created by Maciej Skolecki on 6/7/12.
//  Copyright (c) 2012 Roche. All rights reserved.
//

#import "DEJsonRequest.h"
#import "JSONKit.h"

#define RESULT_KEY @"result"

@implementation DEJsonRequest

@synthesize urlString, completion, failure;


-(id)initWithURL:(NSString *)u {
	if ((self = [super init])) {
		urlString = [u copy];
	}
	return self;
}

- (void)dealloc {
	[urlString release];
	Block_release(completion);
	Block_release(failure);
	[super dealloc];
}

-(void)connect {
	[self retain];

	NSURL *url = [NSURL URLWithString:urlString];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
	NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	
	[NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
			if ([data length] > 0 && error == nil) {
				NSMutableArray *abbreviationsArray = [NSMutableArray array];
				
				NSDictionary *abbreviations = [data objectFromJSONData];
				NSLog(@"data: %@", abbreviations);
				NSDictionary *results = [abbreviations objectForKey:RESULT_KEY];
				[results enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
						
                }];
            }
			else if ([data length] == 0 && error == nil) {
				NSLog(@"empty reply");
			}
			else if (error != nil) {
				NSLog(@"download error: %@", error);
			}
		}];
}

@end
