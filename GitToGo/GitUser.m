//
//  GitUser.m
//  GitToGo
//
//  Created by Ivan Lesko on 1/28/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import "GitUser.h"

@implementation GitUser

- (id)init
{
    self = [super init];
    if (self) {
        self.downloadQueue = [NSOperationQueue new];
    }
    
    return self;
}

- (void)downloadAvatar
{
    _isDownloading = YES;
    [self.downloadQueue addOperationWithBlock:^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_imageURL]];
        _userImage = [UIImage imageWithData:imageData];
        // Notify the view controller when the download finishes.
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:DOWNLOAD_NOTIFICATION object:self];
        }];
    }];
}


@end
