//
//  BaseViewController.m
//  GitToGo
//
//  Created by Ivan Lesko on 1/28/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setupViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViews
{
    if (!self.mainViewController || !self.searchPanelViewController) {
        // Setup the main view controller and set baseviewcontroller (self) to be its delegate and datasource.
        self.mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
        self.mainViewController.delegate = self;
        self.mainViewController.view.frame = self.view.frame;
        
        self.mainViewController.tableView.delegate = self;
        self.mainViewController.tableView.dataSource = self;
        [self.mainViewController.tableView registerNib:[UINib nibWithNibName:@"SearchResultsTableViewCell" bundle:Nil] forCellReuseIdentifier:@"ResultsTableViewCell"];
        
        self.mainViewController.collectionView.delegate = self;
        self.mainViewController.collectionView.dataSource = self;
        [self.mainViewController.collectionView registerNib:[UINib nibWithNibName:@"SearchResultsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ResultsCollectionCell"];
        
        [self addChildViewController:self.mainViewController];
        
        [self.view addSubview:self.mainViewController.view];
        
        [self.mainViewController didMoveToParentViewController:self];
    }
    
    self.panelShowing = NO;
    originalPositionRect = self.view.frame;
    
    self.repos = [NSMutableArray array];
}


#pragma mark - MainViewController Delegate Methods

- (void)toggleSearchPanelVisibility
{
    if (!self.panelShowing) {
        [self addTransparentGestureView];
        [self movePanelRight];
    } else {
        [self movePanelToOriginalPosition];
    }
}

- (void)toggleSearchPanelWithTapGesture
{
    if (self.panelShowing) {
        [self movePanelToOriginalPosition];
    }
}


- (void)addTransparentGestureView
{
    self.mainViewController.overlayView = [[UIView alloc] initWithFrame:self.view.frame];
    self.mainViewController.overlayView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(movePanelToOriginalPosition)];
    [self.mainViewController.overlayView addGestureRecognizer:tap];
    
    [self.mainViewController.view addSubview:self.mainViewController.overlayView];
}



#pragma mark - Toggle MainViewController Position Methods

- (void)resetMainView
{
    if (self.searchPanelViewController) {
        [self.searchPanelViewController.view removeFromSuperview];
        self.searchPanelViewController = nil;
        
        [self.mainViewController.overlayView removeFromSuperview];
        self.mainViewController.overlayView = nil;
    }
}

- (UIView *)getSearchPanelView
{
    if (!self.searchPanelViewController) {
        self.searchPanelViewController = [[SearchPanelViewController alloc] initWithNibName:@"SearchPanelViewController" bundle:nil];
        self.searchPanelViewController.view.frame = self.view.frame;
        self.searchPanelViewController.delegate = self;
        self.searchPanelViewController.searchBar.delegate = self;
        
        [self addChildViewController:self.searchPanelViewController];
        [self.view addSubview:self.searchPanelViewController.view];
        [self.view sendSubviewToBack:self.searchPanelViewController.view];
        
        [self.searchPanelViewController didMoveToParentViewController:self];
    }
    
    [self addShadowToLayer:NO withOffset:0.f toLayer:self.mainViewController.view.layer];
    
    return self.searchPanelViewController.view;
}

- (void)movePanelRight
{
    [self getSearchPanelView];
    
    [UIView animateWithDuration:SLIDE_TIMING
                     animations:^{
                         self.mainViewController.view.frame = CGRectMake(self.view.frame.origin.x,
                                                                         self.view.frame.origin.y + self.searchPanelViewController.searchBar.frame.size.height + self.searchPanelViewController.octocatImageView.frame.size.height + 20,
                                                                         self.view.frame.size.width,
                                                                         self.view.frame.size.height);
                         
                         self.mainViewController.overlayView.backgroundColor = [UIColor colorWithRed:0.f
                                                                                               green:0.f
                                                                                                blue:0.f
                                                                                               alpha:0.85];
                     }
                     completion:^(BOOL finished) {
                         self.panelShowing = !self.panelShowing;
                     }];
    
    
}

- (void)movePanelToOriginalPosition
{
    [UIView animateWithDuration:SLIDE_TIMING
                     animations:^{
                         self.mainViewController.view.frame = originalPositionRect;
                         
                         self.mainViewController.overlayView.backgroundColor = [UIColor clearColor];
                     }
                     completion:^(BOOL finished) {
                         self.panelShowing = !self.panelShowing;
                         [self resetMainView];
                     }];
}

#pragma mark - Custom Drawing For Sliding Panel

- (void)addShadowToLayer:(BOOL)value withOffset:(CGFloat)offset toLayer:(CALayer *)theLayer
{
    if (value) {
        theLayer.shadowColor   = [[UIColor blackColor] CGColor];
        theLayer.shadowOpacity = 0.2;
        theLayer.shadowOffset  = CGSizeMake(0, offset);
        theLayer.cornerRadius  = CORNER_RADIUS;
    } else {
        theLayer.cornerRadius  = 0;
        theLayer.shadowOffset  = CGSizeMake(0 ,0);
        theLayer.cornerRadius  = CORNER_RADIUS;
    }
}

#pragma mark - Tableview Delegate Methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *resultCell = [tableView dequeueReusableCellWithIdentifier:@"ResultsTableViewCell"];
    
    NSDictionary *repo = [self.repos objectAtIndex:indexPath.row];
    
    if (![[repo objectForKey:@"name"] isEqualToString:@""]) {
        resultCell.textLabel.text = [repo objectForKey:@"name"];
    } else {
        resultCell.textLabel.text = @"";
    }
    
    /**
     * Dummy Checks
     */
    
    if (![[repo objectForKey:@"description"] isEqualToString:@""]) {
        resultCell.detailTextLabel.text = [repo objectForKey:@"description"];
    } else {
        resultCell.detailTextLabel.text = @"";
    }
    
    return resultCell;
}

#pragma mark - Tableview Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.repos.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    
    switch (section) {
        case 0:
            title = @"Github Repos";
            break;
            
        default:
            break;
    }
    
    return title;   
}

#pragma mark - Collectionview Delegate Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ResultsCollectionViewCell *resultCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ResultsCollectionCell" forIndexPath:indexPath];
    
    GitUser *user = self.users[indexPath.row];
    
    resultCell.userNameLabel.text = user.name;
    
    return resultCell;
}


#pragma mark - Collectionview Data Source Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.users.count;
}

#pragma mark - Search Bar Delegate Methods

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchForUser:searchBar.text];
    self.repos = [[GitNetworkController sharedInstance] reposForString:searchBar.text];
    
    [self.mainViewController.tableView reloadData];
    
    [self movePanelToOriginalPosition];
}

- (void)createUserFromArray:(NSArray *)searchArray
{
    self.users = [NSMutableArray array];
    
    for (NSDictionary *dictionary in searchArray) {
        GitUser *user = [GitUser new];
        user.name = dictionary[@"login"];
        user.imageURL = dictionary[@"avatar_url"];
        [self.users addObject:user];
    }
    
    [self.mainViewController.collectionView reloadData];
}

- (void)searchForUser:(NSString *)searchString
{
    searchString = [NSString stringWithFormat:@"https://api.github.com/search/users?q=%@", searchString];
    [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSURL *searchURL = [NSURL URLWithString:searchString];
    
    // Try the best case scenario
    @try {
        NSData *searchData = [NSData dataWithContentsOfURL:searchURL];
        NSDictionary *searchDictionary = [NSJSONSerialization JSONObjectWithData:searchData
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:&error];
        NSArray *searchArray = searchDictionary[@"items"];
        [self createUserFromArray:searchArray];
    }
    
    // If an exception is raised in try, try catch.  Get's called no matter what.
    @catch (NSException *exception) {
        NSLog(@"API search limit reached");
        if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }
}

@end












