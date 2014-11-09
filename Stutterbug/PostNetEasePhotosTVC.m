//
//  PostNetEasePhotosTVC.m
//  Stutterbug
//
//  Created by 邵建勇 on 14/10/24.
//  Copyright (c) 2014年 John Shaw. All rights reserved.
//

#import "PostNetEasePhotosTVC.h"

@interface PostNetEasePhotosTVC ()

@end

@implementation PostNetEasePhotosTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchPhotos];
    
}


//cs193p提供的flicker API在中国不能用（GreatWall），所以找了豆瓣的API来代替，
//豆瓣的iOS API文件和库在Github上最后更新是两年前，不知道会不会有什么问题，故直接https访问，获取并解析JSO
- (void)fetchPhotos {
    NSURL *urlTest = [NSURL URLWithString:@"https://api.douban.com/v2/album/74539453/photos?apikey=0114f7586bc18b91033ee6094344a2b3"];
    [self.refreshControl beginRefreshing];
    
    dispatch_queue_t fetchQ = dispatch_queue_create("douban photos", NULL);
    
    dispatch_async(fetchQ, ^{
        
        
        NSData *jsonRes = [NSData dataWithContentsOfURL:urlTest];
        
        NSDictionary *propertyListFromJSON = [NSJSONSerialization JSONObjectWithData:jsonRes
                                                                             options:0
                                                                               error:NULL];
        
//        NSLog(@"douban = \n%@",propertyListFromJSON);
        
        NSArray *photos = [propertyListFromJSON valueForKeyPath:@"photos"];
//        NSArray *photosID = [propertyListFromJSON valueForKeyPath:@"photos.id"];
//        NSDictionary *photosWithID = [NSDictionary dictionaryWithObjects:photos forKeys:photosID];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            self.photos = photos;
//            NSLog(@"photos :%@",photos);
        });
    });
}




@end
