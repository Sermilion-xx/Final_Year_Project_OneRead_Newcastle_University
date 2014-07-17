//
//  User.m
//  ReadLater
//
//  Created by Ibragim Gapuraev on 02/06/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize firstname,lastname,age,email,password;

- (id) initWithId:(NSInteger)User_id
        firstname:(NSString *)Firstname
         lastname:(NSString *)Lastname
              age:(NSInteger)Age
            email:(NSString*)Email
         password:(NSString *)Password
          picture:(NSString *)Picture
{
    self = [super init];
    if (self) {
        self.user_id = User_id;
        self.firstname = Firstname;
        self.lastname = Lastname;
        self.age = Age;
        self.email = Email;
        self.password = Password;
        self.picture = Picture;
        
        
    }
    return self;
}


+ (id) initWithId:(NSInteger)user_id
        firstname:(NSString *)firstname
         lastname:(NSString *)lastname
              age:(NSInteger)age
            email:(NSString *)email
         password:(NSString *)password
          picture:(NSString *)picture
{
    return [[self alloc] initWithId:user_id
                          firstname:firstname
                           lastname:lastname
                                age:age
                              email:email
                           password:password
                            picture:picture];
}

@end
