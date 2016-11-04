//
//  AddContactViewController.m
//  通讯录
//
//  Created by Johnson on 23/09/2016.
//  Copyright © 2016 BB. All rights reserved.
//

#import "AddContactViewController.h"
#import "NSObject+Tools.h"



@interface AddContactViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPhone;

@end

@implementation AddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponder)]];
    
    self.textFieldName.text = self.name;
    self.textFieldPhone.text = self.phone;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)resignFirstResponder
{
    RESIGN_FIRST_RESPONDER;
    return [super resignFirstResponder];
}

- (IBAction)clickDone:(id)sender {
    
    if (self.textFieldName.text.length == 0) {
        [self showAlert:@"" message:@"请填写名字" delay:1];
        return;
    }else if (self.textFieldPhone.text.length == 0) {
        [self showAlert:@"" message:@"请填写电话号码" delay:1];
        return;
    }
    
    
    if ([self queryContactWithPhone:self.textFieldPhone.text]) {
        
        [self delContactWithPhone:self.textFieldPhone.text];
        
    }
    

    Contact *contact = [[Contact alloc] init];
    contact.name = self.textFieldName.text;
    contact.phone = self.textFieldPhone.text;
    [self addContact:contact];
    
    self.addComplete ? self.addComplete(self.textFieldName.text, self.textFieldPhone.text) : nil;
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if ([textField isEqual:self.textFieldName]) {
        [textField resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller.
}

@end
