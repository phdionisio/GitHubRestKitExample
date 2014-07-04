//
//  NavigatorDetailViewController.h
//  GitHubRestKitExample
//
//  Created by Patrick Dionisio on 6/30/14.
//  Copyright (c) 2014 Patrick Dionisio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Repository.h"

@interface NavigatorDetailViewController : UIViewController

@property (nonatomic, strong) Repository *repo;

-(void)setRepo:(Repository *)repo;

@end
