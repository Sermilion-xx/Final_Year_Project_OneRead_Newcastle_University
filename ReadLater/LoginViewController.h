//
//  LoginViewController.h
//  ReadLater
//
//  Created by Ibragim Gapuraev on 05/06/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"
#import "Article.h"

@interface LoginViewController : UIViewController

//database object declaration, to access methods for database interactions
@property (nonatomic, strong) Database* db;
//textfields for entering login information
@property (nonatomic, strong) IBOutlet UITextField *tfEmail;
@property (nonatomic, strong) IBOutlet UITextField *tfPassword;

//action methods
- (IBAction)userFinishedEnteringText:(UITextField *)sender;
- (IBAction)btnLoginTapped:(UIButton *)sender;
- (IBAction)goBack:(UIStoryboardSegue *)sender;

@end
