//
//  User.h
//  ReadLater
//
//  Created by Ibragim Gapuraev on 02/06/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, strong) NSString* firstname;
@property (nonatomic, strong) NSString* lastname;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* password;
@property (nonatomic, strong) NSString* picture;

- (id) initWithId:(NSInteger)user_id
        firstname:(NSString *)Firstname
         lastname:(NSString *)Lastname
              age:(NSInteger) Age
            email:(NSString *)Email
         password:(NSString *)Password
          picture:(NSString *)Picture;


+ (id) initWithId:(NSInteger)user_id
        firstname:(NSString *)firstname
         lastname:(NSString *)lastname
              age:(NSInteger)age
            email:(NSString *)email
         password:(NSString *)password
          picture:(NSString *)picture;

@end
