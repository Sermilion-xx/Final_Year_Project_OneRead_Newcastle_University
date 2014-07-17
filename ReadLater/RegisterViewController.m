//
//  RegisterViewController.m
//  ReadLater
//
//  Created by Ibragim Gapuraev on 05/06/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import "RegisterViewController.h"
#import "AFViewShaker.h"



@interface RegisterViewController ()
@property (nonatomic, strong) IBOutletCollection(UIView) NSArray * allTextFields;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray * allButtons;
@property (nonatomic, strong) AFViewShaker * viewShaker;
@property (nonatomic, retain) UIAlertView *alertView;
@end

@implementation RegisterViewController



@synthesize tfFirstname, tfLastname, tfAge, tfEmail, tfPassword, tfPicture, registerDelegate,db;

- (Database* ) db
{
    if (!db) {
        db = [[Database alloc] init];
    }
    
    return db;
}

- (IBAction)btnRegisterTapped:(UIButton *)sender
{
    NSInteger age = (NSInteger)[self.tfAge.text integerValue];
    
    if (![self.tfFirstname.text isEqualToString:@""] &&
        ![self.tfLastname.text isEqualToString:@""] &&
        ![self.tfAge.text isEqualToString:@""] &&
        ![self.tfEmail.text isEqualToString:@""] &&
        ![self.tfRePassword.text isEqualToString:@""] &&
        ![self.tfPassword.text isEqualToString:@""])
    {
        NSLog(@"Register: %@, %@", self.tfRePassword.text, self.tfPassword.text);
        
        if([self.tfRePassword.text isEqualToString:self.tfPassword.text]){
        [self.db openDatabase];
        
        [self.db registerUser:self.tfFirstname.text
                     lastname:self.tfLastname.text
                          age:age
                        email:self.tfEmail.text
                     password:self.tfPassword.text
                      picture:self.tfPicture.text];
        [self.db closeDatabase];
        }
        else{
//           UIAlertView *alert = [[UIAlertView alloc]
//                                        initWithTitle:@"Error:"
//                                        message:@"Passwords do not match!"
//                                        delegate:self
//                                        cancelButtonTitle:@"OK"
//                                        otherButtonTitles:nil];
//        [alert show];
        }
        
    }
//    else {UIAlertView *alert = [[UIAlertView alloc]
//                                  initWithTitle:@"Error:"
//                                  message:@"Please fill all fields"
//                                  delegate:self
//                                  cancelButtonTitle:@"OK"
//                                  otherButtonTitles:nil];
//        [alert show];
//    }
}

- (IBAction)userFinishedEnteringText:(UITextField *)sender
{
    //dismiss the keyboard on this text field:
    [sender resignFirstResponder];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlert:(NSString*) errorMessage {
    if (self.alertView) {
        // if for some reason the code can trigger more alertviews before
        // the user has dismissed prior alerts, make sure we only let one of
        // them actually keep us as a delegate just to keep things simple
        // and manageable. if you really need to be able to issue multiple
        // alert views and be able to handle their delegate callbacks,
        // you'll have to keep them in an array!
        [self.alertView setDelegate:nil];
        self.alertView = nil;
    }
    self.alertView = [[UIAlertView alloc]
                       initWithTitle:@"Error"
                       message:errorMessage
                       delegate:self
                       cancelButtonTitle:@"OK"
                       otherButtonTitles:@"Retry",nil];
    [self.alertView show];
}

- (void)alertView:(UIAlertView *)alertViewParam didDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.alertView = nil; // release it
    // do something...
}



@end
