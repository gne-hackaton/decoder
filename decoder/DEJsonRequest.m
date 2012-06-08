//
//  DEJsonRequest.m
//  decoder
//
//  Created by Maciej Skolecki on 6/7/12.
//  Copyright (c) 2012 Roche. All rights reserved.
//

#import "DEJsonRequest.h"
#import "JSONKit.h"
#import "DEAcronym.h"

#define RESULT_KEY @"result"
#define ACRONYM_DEFINITION @"def"
#define ACRONYM_DICTIONARY @"dict"
#define ACRONYM_ID @"id"
#define ACCRONYM_NAME @"name"


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
				NSMutableArray *acronymsArray = [NSMutableArray array];
				
				NSDictionary *abbreviations = [data objectFromJSONData];
				NSArray *results = [abbreviations objectForKey:RESULT_KEY];
				NSLog(@"resuls: %@", results);
				[results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

						NSDictionary *acronymDict = (NSDictionary *)obj;
						NSString *acronymIdentifier = @"not used currently";//[acronymDict objectForKey:ACRONYM_ID];
						NSString *acronymName = [acronymDict objectForKey:ACCRONYM_NAME];
						NSString *acronymDefinition = [acronymDict objectForKey:ACRONYM_DEFINITION];
						NSString *acronymDictionary = [acronymDict objectForKey:ACRONYM_DICTIONARY];
						DEAcronym *acronym = [[DEAcronym alloc] initWithName:acronymName
																		dict:acronymDictionary 
																   identifer:acronymIdentifier
																  definition:acronymDefinition];
						[acronymsArray addObject:acronym];
						[acronym release];
				}];
				if (completion) {
					completion(acronymsArray);
				}
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
