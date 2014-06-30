//
//  NavigatorDetailViewController.h
//  GitHubRestKitExample
//
//  Created by Patrick Dionisio on 6/30/14.
//  Copyright (c) 2014 Patrick Dionisio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigatorDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
