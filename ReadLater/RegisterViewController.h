//
//  RegisterViewController.h
//  ReadLater
//
//  Created by Ibragim Gapuraev on 05/06/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"

@protocol RegisterDelegate <NSObject>

- (void) userDidRegister:(NSString *) firstname
                lastname:(NSString *) lastname
                     age:(NSInteger*) age
                   email:(NSString *) email
                password:(NSString *) password
                 picture:(NSString *) picture;

@end

@interface RegisterViewController : UIViewController<UIAlertViewDelegate>

@property (nonatomic,strong) Database* db;

@property (nonatomic, weak) id <RegisterDelegate> registerDelegate;

@property (nonatomic, strong) IBOutlet UITextField *tfFirstname;
@property (nonatomic, strong) IBOutlet UITextField *tfLastname;
@property (nonatomic, strong) IBOutlet UITextField *tfAge;
@property (nonatomic, strong) IBOutlet UITextField *tfEmail;
@property (nonatomic, strong) IBOutlet UITextField *tfPassword;
@property (nonatomic, strong) IBOutlet UITextField *tfRePassword;
@property (nonatomic, strong) IBOutlet UITextField *tfPicture;


- (IBAction)userFinishedEnteringText:(UITextField *)sender;
- (IBAction)btnRegisterTapped:(UIButton *)sender;


@end
