//
//  SearchPanelViewController.h
//  GitToGo
//
//  Created by Ivan Lesko on 1/28/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchPanelViewController <NSObject>



@end

@interface SearchPanelViewController : UIViewController

@property (unsafe_unretained) id <SearchPanelViewController> delegate;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UIImageView *octocatImageView;

@end
