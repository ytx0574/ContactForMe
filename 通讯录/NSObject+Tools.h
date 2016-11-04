//
//  NSObject+Tools.h
//  通讯录
//
//  Created by Johnson on 23/09/2016.
//  Copyright © 2016 BB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Contact;

#define SCREEN_WIDTH                              [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT                             [[UIScreen mainScreen] bounds].size.height
#define RESIGN_FIRST_RESPONDER                         [[UIApplication sharedApplication].keyWindow endEditing:YES]

static NSString *cellIdentifier = @"cellIdentifier";

static NSString *account = @"_account_";

@interface NSObject (Tools)


- (UIAlertView *)showAlert:(NSString *)title message:(NSString *)message;

- (UIAlertView *)showAlertOk:(NSString *)title message:(NSString *)message;

- (void)showAlert:(NSString *)title message:(NSString *)message delay:(NSTimeInterval)delay;


- (void)addContact:(Contact *)contact;

- (Contact *)queryContactWithPhone:(NSString *)phone;

- (BOOL)delContactWithPhone:(NSString *)phone;

- (NSArray <Contact *> *)quereAllContact;


- (void)makeAPhoneCall:(NSString *)phoneNumber;

+ (BOOL)validateTelPhone:(NSString *)candidate;

+ (BOOL)validateTel:(NSString *)candidate;

@end



@interface Contact : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *phone;

@end