//
//  GitUser.h
//  GitToGo
//
//  Created by Ivan Lesko on 1/28/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GitUser : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) UIImage  *userImage;

@property (nonatomic, readwrite) BOOL isDownloading;

@property (nonatomic, strong) NSOperationQueue *downloadQueue;

- (void)downloadAvatar;

@end
