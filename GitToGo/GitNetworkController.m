//
//  GitNetworkController.m
//  Git2Go
//
//  Created by Ivan Lesko on 1/27/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import "GitNetworkController.h"

@implementation GitNetworkController

- (id)init
{
    self = [super init];
    if (self) {
        self.operationQueue.maxConcurrentOperationCount = 1;
    }
    
    return self;
}

+ (GitNetworkController *)sharedInstance
{
    static dispatch_once_t pred;
    static GitNetworkController *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[GitNetworkController alloc] init];
    });
    
    return shared;
}


- (NSMutableArray *)reposForString:(NSString *)theString
{
    // Search string is iOS
    // https://api.github.com/search/repositories?q=tetris+language:assembly&sort=stars&order=desc
    
    theString = [NSString stringWithFormat:@"https://api.github.com/search/repositories?q=%@", theString];
    
    NSURL *searchURL = [NSURL URLWithString:theString];
    
    NSData *urlData = [NSData dataWithContentsOfURL:searchURL];
    
    NSError *error;
    NSDictionary *searchDictionary = [NSJSONSerialization JSONObjectWithData:urlData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&error];
//    NSLog(@"%@", searchDictionary[@"items"]);
    
    return [searchDictionary objectForKey:@"items"];
}

@end







