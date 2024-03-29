//
//  LoginViewController.m
//  ReadLater
//
//  Created by Ibragim Gapuraev on 05/06/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import "LoginViewController.h"
#import "Database.h"
#import "JCRBlurView.h"
#import "AFViewShaker.h"
#import "InboxViewController.h"


@interface LoginViewController ()
@property (nonatomic, strong) IBOutletCollection(UIView) NSArray * allTextFields;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray * allButtons;
@property (nonatomic, strong) AFViewShaker * viewShaker;
@end

@implementation LoginViewController

@synthesize tfEmail, tfPassword, db;

- (Database* ) db
{
    if (!db) {
        db = [[Database alloc] init];
    }
    
    return db;
}


//blocks segue if login credentials are wrong
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    NSInteger str = -1;
    //user data for logged user; if nil, then login failed =>block segue
    str = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserLoginIdSession"]integerValue];
    if ([identifier isEqualToString:@"Login"]) {
        
        if (str != -1) {
            return YES;
        }else{
            NSLog(@"Locked View");
            return NO;
        }
    }
    return YES;
}

/**
 Action method that defines behaviour when login button is tapped
 **/
- (IBAction)btnLoginTapped:(UIButton *)sender
{
    //check that fields are not empty
    if (![self.tfEmail.text isEqualToString:@"Email"] &&
        ![self.tfPassword.text isEqualToString:@"Password"] && ![self.tfEmail.text isEqualToString:@""] &&
        ![self.tfPassword.text isEqualToString:@""]) {
        User *user = nil;
        [self.db openDatabase];
        //see if entered data exist
        user = [self.db login:self.tfEmail.text password:self.tfPassword.text];
        //if credentials found =>login successufl
        if (user!=nil) {
            //set user object to session
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat: @"%d", (int)user.user_id] forKey:@"UserLoginIdSession"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //import all archived articles for the user
        }else{
            //set user data object to -1, that siginifies failure in login
            [[NSUserDefaults standardUserDefaults] setObject:@"-1"forKey:@"UserLoginIdSession"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [self.db closeDatabase];

    }else{
        //set user data object to -1, that siginifies failure in login
        [[NSUserDefaults standardUserDefaults] setObject:@"-1"forKey:@"UserLoginIdSession"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}

- (IBAction)userFinishedEnteringText:(UITextField *)sender
{
    //dismiss the keyboard on this text field:
    [sender resignFirstResponder];
}

#pragma mark - Other
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
    [super viewDidLoad];
    self.viewShaker = [[AFViewShaker alloc] initWithViewsArray:self.allTextFields];
    
    for (UIButton * button in self.allButtons) {
        button.layer.borderColor = [[UIColor whiteColor] CGColor];
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 5;
    }
    // Do any additional setup after loading the view.
}

//--------------Shakeing ogin--------------///
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - Actions

- (IBAction)onShakeAllAction:(UIButton *)sender {
    [self.viewShaker shake];
   
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(UIStoryboardSegue *)sender
{
    
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if([segue.identifier isEqualToString:@"Menu"]){
//        InboxViewController *controller = (InboxViewController *)segue.destinationViewController;
//        controller.articles = self.articles;
//
//        
//    }
//}

@end
