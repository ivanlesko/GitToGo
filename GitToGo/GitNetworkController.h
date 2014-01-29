//
//  GitNetworkController.h
//  Git2Go
//
//  Created by Ivan Lesko on 1/27/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GitNetworkController : NSObject

@property (nonatomic, strong) NSOperationQueue *operationQueue;

+ (GitNetworkController *)sharedInstance;

- (NSMutableArray *)reposForString:(NSString *)theString;

@end
