//
//  NavigatorDetailViewController.m
//  GitHubRestKitExample
//
//  Created by Patrick Dionisio on 6/30/14.
//  Copyright (c) 2014 Patrick Dionisio. All rights reserved.
//

#import <RestKit.h>
#import "NavigatorDetailViewController.h"

#define kOAUTHTOKEN @"309d9833e6148d9ce2835b41ae5a3154f3e36f50"

@interface NavigatorDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
- (IBAction)onClickDoneButton:(id)sender;

- (void)configureView;
@end

@implementation NavigatorDetailViewController

#pragma mark - Managing the detail item

-(void)setRepo:(Repository *)repo
{
    if (repo == nil) {
        _doneButton.enabled = true;
        
    } else if (_repo != repo) {
        _doneButton.enabled = false;
        _repo = repo;
        
        // Update the view.
        [self configureView];
    }
}

- (IBAction)onClickDoneButton:(id)sender {
    Repository *repo = [Repository new];
    
    if (_repo == nil && _nameTextField.text != nil) {
        repo.name = _nameTextField.text;
        
        NSString *token = kOAUTHTOKEN;        
        NSDictionary *queryParams = @{@"access_token" : token};
        [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
        
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Authorization" value: [NSString stringWithFormat:@"token %@", token]];
        [[RKObjectManager sharedManager]
            postObject:repo
            path:@"/user/repos"
            parameters:queryParams
         
         success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
             NSLog(@"Success");
             [self.navigationController popViewControllerAnimated:YES];
             
         } failure:^(RKObjectRequestOperation *operation, NSError *error) {
             NSLog(@"Error");
             [self.navigationController popViewControllerAnimated:YES];
             
         }];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (_repo) {
        self.nameTextField.text = [_repo name];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
