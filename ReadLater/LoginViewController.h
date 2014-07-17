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


@protocol LoginDelegate <NSObject>

- (void) didLoginWithEmail:(NSString *) email
                  password:(NSString *) password;

@end

@interface LoginViewController : UIViewController

@property (nonatomic, assign) NSInteger logged;

@property (nonatomic, strong) NSMutableArray* articles;
@property (nonatomic, strong) Database* db;

@property (nonatomic, weak) id <LoginDelegate> loginDelegate;

@property (nonatomic, strong) IBOutlet UITextField *tfEmail;
@property (nonatomic, strong) IBOutlet UITextField *tfPassword;

- (IBAction)userFinishedEnteringText:(UITextField *)sender;
- (IBAction)btnLoginTapped:(UIButton *)sender;
- (IBAction)goBack:(UIStoryboardSegue *)sender;



//For HTTP Requests


@end
