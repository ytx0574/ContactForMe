//
//  NSObject+Tools.m
//  通讯录
//
//  Created by Johnson on 23/09/2016.
//  Copyright © 2016 BB. All rights reserved.
//

#import "NSObject+Tools.h"
#import "SAMKeychain.h"
#import "MJExtension.h"

@implementation NSObject (Tools)

- (UIAlertView *)showAlert:(NSString *)title message:(NSString *)message;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView show];
    return alertView;
}

- (UIAlertView *)showAlertOk:(NSString *)title message:(NSString *)message;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    return alertView;
}

- (void)showAlert:(NSString *)title message:(NSString *)message delay:(NSTimeInterval)delay;
{
    UIAlertView *alertView = [self showAlert:title message:message];
    [alertView performSelector:@selector(dismissWithClickedButtonIndex:animated:) withObject:nil afterDelay:delay];
}

- (void)showAlert:(NSString *)title message:(NSString *)message delay:(NSTimeInterval)delay complete:(void(^)())complete;
{
    [self showAlert:title message:message delay:delay];
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            complete ? complete() : nil;
        });
    });
}



- (void)addContact:(Contact *)contact;
{
    [SAMKeychain setPassword:@"" forService:contact.mj_JSONString account:account];
}

- (Contact *)queryContactWithPhone:(NSString *)phone;
{
    NSDictionary *dictionary = [[[SAMKeychain allAccounts] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        
        
        Contact *contact = [Contact mj_objectWithKeyValues:evaluatedObject[@"svce"]];
        
        return [evaluatedObject[@"acct"] isEqualToString:account] && [contact.phone isEqualToString:phone];
    }]] firstObject];
    
    return [Contact mj_objectWithKeyValues:dictionary[@"svce"]];
}

- (BOOL)delContactWithPhone:(NSString *)phone;
{
    Contact *contact = [self queryContactWithPhone:phone];
    
    BOOL flag = [SAMKeychain deletePasswordForService:contact.mj_JSONString account:account];
    return flag;
}

- (NSArray <Contact *> *)quereAllContact;
{
    NSMutableArray *ay = [NSMutableArray array];
    [[SAMKeychain allAccounts] enumerateObjectsUsingBlock:^(NSDictionary<NSString *,id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj[@"acct"] isEqualToString:account]) {
            
            Contact *contact = [Contact mj_objectWithKeyValues:obj[@"svce"]];
            [ay addObject:contact];
            
        }
        
    }];
    
    return [ay copy];
}

- (void)makeAPhoneCall:(NSString *)phoneNumber;
{
    UIView *view =[[[[UIApplication sharedApplication] delegate] window] viewWithTag:69723];
    
    [view removeFromSuperview];
    
    
    UIWebView *callWebview = [[UIWebView alloc] init];
    
    callWebview.tag = 69723;
    
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",phoneNumber];
    
    NSURL *telURL = [NSURL URLWithString:telUrl];
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:callWebview];
}

+ (BOOL)validateTelPhone:(NSString *)candidate;
{
    if (candidate == nil || [candidate isEqualToString:@""]) { return NO; }
    
    NSString *regex = @"^1[3|4|5|6|7|8]\\d{9}$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [predicate evaluateWithObject:candidate];
}

+ (BOOL)validateTel:(NSString *)candidate;
{
    if (candidate == nil || [candidate isEqualToString:@""]) { return NO; }
    
    NSString *regex1 = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSString *regex2 = @"^1[3|4|5|6|7|8]\\d{9}$";
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];

    return [predicate1 evaluateWithObject:candidate] || [predicate2 evaluateWithObject:candidate];
}

@end


@implementation Contact

@end


