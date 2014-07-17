//
//  WebViewController.m
//  ReadLater
//
//  Created by Ibragim Gapuraev on 16/07/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

@synthesize webView, url;

- (NSURL* ) url
{
    if (!url) {
        url = [[NSURL alloc] init];
    }
    
    return url;
}


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
    NSURL *Url = self.url;
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:Url];
    [webView loadRequest:requestURL];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
