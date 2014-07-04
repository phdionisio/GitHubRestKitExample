//
//  NavigatorMasterViewController.m
//  GitHubRestKitExample
//
//  Created by Patrick Dionisio on 6/30/14.
//  Copyright (c) 2014 Patrick Dionisio. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "NavigatorMasterViewController.h"
#import "NavigatorDetailViewController.h"
#import "Repository.h"

#define kCLIENTID @"32208d10d949b22a7400"
#define kCLIENTSECRET @"a02a8bae9dbcad5de81064341f79cac95c004184"
#define kOAUTHTOKEN @"309d9833e6148d9ce2835b41ae5a3154f3e36f50"

@interface NavigatorMasterViewController ()
@property (nonatomic, strong) NSArray *repos;
@end

@implementation NavigatorMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)configureRestKit
{
    // Log all HTTP traffic with request and response bodies
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"https://api.github.com"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // setup object mappings
    // repository
    RKObjectMapping *repoResponseMapping = [RKObjectMapping mappingForClass:[Repository class]];
    [repoResponseMapping addAttributeMappingsFromDictionary:@{
                                                      @"id": @"repoId",
                                                      @"name": @"name",
                                                      }];
    
    // register mappings with the provider using a request descriptor
    RKRequestDescriptor *requestDescriptor =
    [RKRequestDescriptor requestDescriptorWithMapping:[repoResponseMapping inverseMapping] objectClass:[Repository class] rootKeyPath:nil method:RKRequestMethodPOST];
    [objectManager addRequestDescriptor:requestDescriptor];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:repoResponseMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/users/phdionisio/repos"
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureRestKit];
    [self loadRepos];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadRepos];
}

- (void)loadRepos
{
    //NSString *clientID = kCLIENTID;
    //NSString *clientSecret = kCLIENTSECRET;
    NSString *token = kOAUTHTOKEN;
    
    NSDictionary *queryParams = @{@"access_token" : token};
    
    //NSDictionary *queryParams = @{@"client_id" : clientID,
    //                              @"client_secret" : clientSecret};
    
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Authorization" value:token];
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/users/phdionisio/repos"
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  _repos = mappingResult.array;
                                                  [self.tableView reloadData];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                              }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _repos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Repository *repo = _repos[indexPath.row];
    cell.textLabel.text = repo.name;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Repository *repo = _repos[indexPath.row];
        [[segue destinationViewController] setRepo:repo];
    }
}

@end
