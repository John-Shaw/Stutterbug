//
//  ShutterTableViewController.m
//  Stutterbug
//
//  Created by 邵建勇 on 14/10/24.
//  Copyright (c) 2014年 John Shaw. All rights reserved.
//

#import "ShutterTableViewController.h"
#import "ImageViewController.h"

@interface ShutterTableViewController ()

@end

@implementation ShutterTableViewController

- (void)setPhotos:(NSArray *)photos{
    _photos = photos;
    [self.tableView reloadData]; 
}

- (void)viewDidLoad{
    [super viewDidLoad];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = false;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    self.title = @"douban photo";
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.photos count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"douban photo" forIndexPath:indexPath];
    
    NSDictionary *photo = self.photos[indexPath.row];
    
    cell.textLabel.text = [photo valueForKeyPath:@"id"];
    cell.detailTextLabel.text = [photo valueForKeyPath:@"desc"];
    
    return cell;
}

#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    id detail = self.splitViewController.viewControllers[1];
//    if ([detail isKindOfClass:[UINavigationController class]]) {
//        detail = [((UINavigationController *)detail).viewControllers firstObject];
//    }
//    if ([detail isKindOfClass:[ImageViewController class]]) {
//        [self prepareForImageViewController:detail toDisplayPhoto:self.photos[indexPath.row]];
//    }
//}



#pragma mark - Navigation

- (void)prepareForImageViewController:(ImageViewController *)ivc toDisplayPhoto: (NSDictionary *)photo{
    ivc.imageURL = [NSURL URLWithString:[photo valueForKeyPath:@"image"]];
    ivc.title = [photo valueForKeyPath:@"id"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([sender isKindOfClass:[UITableViewCell class]]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if(indexPath){
            if([segue.identifier isEqualToString:@"show Detail"]){
                if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]){
                    ImageViewController *detailVC = (ImageViewController *)((UINavigationController *)segue.destinationViewController).topViewController;
                    [self prepareForImageViewController:detailVC toDisplayPhoto:self.photos[indexPath.row]];
                    detailVC.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
                    detailVC.navigationItem.leftItemsSupplementBackButton = true;
                    
                }
            }
        }
    }
}



@end
