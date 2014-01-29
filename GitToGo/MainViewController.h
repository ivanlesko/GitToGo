//
//  MainViewController.h
//  GitToGo
//
//  Created by Ivan Lesko on 1/28/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SearchPanelViewController.h"

@protocol MainViewControllerDelegate <NSObject>

- (void)toggleSearchPanelVisibility;
- (void)toggleSearchPanelWithTapGesture;

@end

@interface MainViewController : UIViewController <SearchPanelViewController>
{
    CGRect originalPositionRect;
}

@property (unsafe_unretained) id <MainViewControllerDelegate> delegate;

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

// Overlay view will turn this view black when the user presses the search button.
@property (nonatomic, strong) UIView *overlayView;

- (IBAction)searchPanelButtonPushed:(id)sender;

@end
