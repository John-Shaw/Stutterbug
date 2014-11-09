//
//  ImageViewController.m
//  Imaginarium
//
//  Created by 邵 建勇 on 14-10-12.
//  Copyright (c) 2014年 John Shaw. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation ImageViewController

- (void)setScrolImagelView:(UIScrollView *)scrollImageView
{
    _scrollImageView = scrollImageView;
    _scrollImageView.minimumZoomScale = 0.2;
    _scrollImageView.maximumZoomScale = 2.0;
    _scrollImageView.delegate = self;
    _scrollImageView.contentSize = self.image ? self.image.size : CGSizeZero;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    //    self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    [self startDownloadingImage];
}

- (void)startDownloadingImage
{
    self.image = nil;
    if (self.imageURL) {
        [self.spinner startAnimating];
        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                                                        completionHandler:^(NSURL *localFile, NSURLResponse *response, NSError *error) {
                                                            if (!error) {
                                                                if ([request.URL isEqual:self.imageURL]) {
                                                                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localFile]];
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        self.image = image;
                                                                    });
                                                                    //[self performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
                                                                }
                                                            }
                                                        }];
        [task resume];
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UIImage *)image
{
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image
{
    self.scrollImageView.zoomScale = 1.0;
    self.imageView.image = image;

    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.scrollImageView.contentSize = self.image ? self.image.size : CGSizeZero;
    [self.spinner stopAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollImageView addSubview:self.imageView];
}


@end
