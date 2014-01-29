//
//  BaseViewController.h
//  GitToGo
//
//  Created by Ivan Lesko on 1/28/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "SearchPanelViewController.h"

#import "ResultsCollectionViewCell.h"

#import "GitNetworkController.h"

#import "GitUser.h"

#define SLIDE_TIMING  0.25
#define SLIDE_WIDTH   0.8
#define CORNER_RADIUS 4.0

@interface BaseViewController : UIViewController <SearchPanelViewController, MainViewControllerDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    CGRect originalPositionRect;
}

@property (nonatomic, strong) NSMutableArray *repos;
@property (nonatomic, strong) NSMutableArray *users;

@property (nonatomic, strong) MainViewController *mainViewController;
@property (nonatomic, strong) SearchPanelViewController *searchPanelViewController;

@property (nonatomic, readwrite) BOOL panelShowing;

@end
