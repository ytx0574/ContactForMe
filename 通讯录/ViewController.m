//
//  ViewController.m
//  通讯录
//
//  Created by Johnson on 23/09/2016.
//  Copyright © 2016 BB. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+Tools.h"
#import "AddContactViewController.h"
#import <MessageUI/MessageUI.h>


@interface ViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray <Contact *> *arrayDataSourse;

@property (nonatomic, strong) NSArray <Contact *> *arrayRecordDataSourse;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self updateDataSourse];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {self.automaticallyAdjustsScrollViewInsets = NO;}
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.arrayDataSourse.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    UIButton *buttonMsg = [cell viewWithTag:99];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
        [cell.contentView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickLongGesture:)]];
        
        buttonMsg = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonMsg.tag = 99;
        buttonMsg.frame = CGRectMake(SCREEN_WIDTH - 66, 0, 66, 44);
        [buttonMsg setImage:[UIImage imageNamed:@"msg"] forState:UIControlStateNormal];
        [buttonMsg setImage:buttonMsg.currentImage forState:UIControlStateHighlighted];
        [buttonMsg addTarget:self action:@selector(clickMsg:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:buttonMsg];
    }
    
    cell.textLabel.text = [self.arrayDataSourse[indexPath.row] name];
    
    cell.detailTextLabel.text = [self.arrayDataSourse[indexPath.row] phone];
    
    cell.contentView.tag = indexPath.row;
    
    buttonMsg.hidden = [NSString validateTelPhone:cell.detailTextLabel.text] ? NO : YES;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RESIGN_FIRST_RESPONDER;
    
    [self makeAPhoneCall:[self.arrayDataSourse[indexPath.row] phone]];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self delContactWithPhone:[self.arrayDataSourse[indexPath.row] phone]];
        
        [self updateDataSourse];
        
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    RESIGN_FIRST_RESPONDER;
}


#pragma mark - UISearchBarDelegate

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0);
{
    if ([text isEqualToString:@"\n"]) {
        [searchBar resignFirstResponder];
    }
    
    return YES;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    if (searchText.length != 0) {
        self.arrayDataSourse = [self.arrayRecordDataSourse filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Contact *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            
            return [evaluatedObject.name hasPrefix:searchText] || [evaluatedObject.phone hasPrefix:searchText];
        }]];
        
        [self.tableView reloadData];
    }else {
        [self updateDataSourse];
    }
    
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result;
{
    if (result == MessageComposeResultCancelled) {
        [controller dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Click

- (void)clickLongGesture:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        AddContactViewController *addContactVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:NSStringFromClass([AddContactViewController class])];
        addContactVC.name = self.arrayDataSourse[gesture.view.tag].name;
        addContactVC.phone = self.arrayDataSourse[gesture.view.tag].phone;
        
        __weak typeof(self) wself = self;
        addContactVC.addComplete = ^(NSString *name, NSString *phone){
            
            [wself updateDataSourse];
        };
        
        [self.navigationController pushViewController:addContactVC animated:YES];
    }
    
}

- (void)clickMsg:(UIButton *)button
{
    
    if ([MFMessageComposeViewController canSendText]) {
        Contact *contact = self.arrayDataSourse[button.superview.tag];
        
        MFMessageComposeViewController *msgVC = [[MFMessageComposeViewController alloc] init];
        msgVC.messageComposeDelegate = self;
        msgVC.recipients = @[contact.phone];
        [self presentViewController:msgVC animated:YES completion:nil];
    }
    
}

#pragma mark - GetMethods

- (void)updateDataSourse
{
    self.arrayDataSourse = [self quereAllContact];
    
    self.arrayRecordDataSourse = self.arrayDataSourse;
    
    [self.tableView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //     Get the new view controller using [segue destinationViewController].
    //     Pass the selected object to the new view controller.
    
    __weak typeof(self) wself = self;
    
    AddContactViewController *addVC = segue.destinationViewController;
    
    addVC.addComplete = ^(NSString *name, NSString *phone){
        
        [wself updateDataSourse];
    };
    
}

@end
