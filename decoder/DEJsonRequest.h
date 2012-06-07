//
//  DEJsonRequest.h
//  decoder
//
//  Created by Maciej Skolecki on 6/7/12.
//  Copyright (c) 2012 Roche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DEJsonRequest : NSObject {
   
    NSString *urlString;
	void (^_completion)(id);
	void (^_failure)(NSError *);
}

@property (nonatomic, readonly) NSString *urlString;
@property (nonatomic, copy) void (^completion)(id);
@property (nonatomic, copy) void (^failure)(NSError *);

-(id)initWithURL:(NSString *)url;
-(void)connect;

@end
