//
//  WebViewController.h
//  ReadLater
//
//  Created by Ibragim Gapuraev on 16/07/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (nonatomic,strong) IBOutlet UIWebView *webView;
@property (nonatomic,strong) NSURL *url;

@end
