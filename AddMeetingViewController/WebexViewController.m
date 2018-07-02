//
//  WebexViewController.m
//  @TCS
//
//  Created by FNSPL on 12/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "WebexViewController.h"

@interface WebexViewController ()

@end

@implementation WebexViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self->_view_Confirmation.hidden = YES;
    
    self.confirmMeetingView.layer.cornerRadius = 5.0;
    
    storeController = [[SKStoreProductViewController alloc] init];

}

- (BOOL)isMyAppInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"https://itunes.apple.com/in/app/cisco-webex-meetings/id298844386?mt=8:"]];
}


#pragma mark - Button actions

- (IBAction)btnConfirmDidTap:(id)sender{
    [SVProgressHUD show];
 
    if ([self isMyAppInstalled]){
        //Opens the application
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/in/app/cisco-webex-meetings/id298844386?mt=8"]];
    }
    else { //App is not installed so do one of following:
        
        [SVProgressHUD show];
        [storeController setDelegate:self];
        //set product parameters
        //must be a number wrapped in a string
        NSDictionary *productParameters = @{ SKStoreProductParameterITunesItemIdentifier : @"298844386"};
        [storeController loadProductWithParameters:productParameters completionBlock:^(BOOL result, NSError *error)  {
            if (result) {
                //show
                [SVProgressHUD dismiss];
                [self presentViewController:self->storeController animated:YES completion:nil];
            }else {
                NSLog(@"ERROR WITH STORE CONTROLLER %@\n", error.description);
                //redirect to app store
                //[[UIApplication sharedApplication] openURL:[[self class] appStoreURL]];
            }
        }];
        
        
        
        
        
        
//        //1. Take the user to the apple store so they can download the app
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.com/apps/nameOfMyApp"]];
//
//        //OR
//
//        //2. Take the user to a list of applications from a developer
//        //or company exclude all punctuation and space characters.
//        //for example 'Pavan's Apps'
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.com/apps/PavansApps"]];
//
//        //OR
//
//        //3. Take your users to a website instead, with maybe instructions/information
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.pavan.com/WhyTheHellDidTheAppNotOpen_what_now.html"]];
        
    }
    
    
//
//    [SVProgressHUD show];
//
//    [storeController setDelegate:self];
//    //set product parameters
//    //must be a number wrapped in a string
//    NSDictionary *productParameters = @{ SKStoreProductParameterITunesItemIdentifier : @"298844386"};
//    [storeController loadProductWithParameters:productParameters completionBlock:^(BOOL result, NSError *error)  {
//        if (result) {
//            //show
//            [SVProgressHUD dismiss];
//            [self presentViewController:self->storeController animated:YES completion:nil];
//        }else {
//            NSLog(@"ERROR WITH STORE CONTROLLER %@\n", error.description);
//            //redirect to app store
//            //[[UIApplication sharedApplication] openURL:[[self class] appStoreURL]];
//        }
//    }];
    
    
    
    
    // NSURL *url = [NSURL URLWithString:@"wbx://WbxSignIn"];
    
    //   NSURL *url = [NSURL URLWithString:@"wbx://schedule?attendees=ritamkumarbasu@gmail.com"];
    
// OLD code
    
//    NSURL *url = [NSURL URLWithString:@"wbx://WbxSchedule?attendees=ritamkumarbasu@gmail.com&meetingpwd=1234"];
//
//    if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
//
//        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:NULL];
//    }

//NEW CODE
    

    
    
    
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    // if user do cancel, close it
    [storeController dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)btnAddContactDidTap:(id)sender {
    
    if (SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"9.0")) {

        //        contactVC = [[ContactsTableController alloc] init];
        //
        //        contactVC.delegate = self;
        //
        //        CATransition* transition = [CATransition animation];
        //        transition.duration = 0.3;
        //        transition.type = kCATransitionMoveIn;
        //        transition.subtype = kCATransitionFromTop;
        //
        //        [self.view.window.layer addAnimation:transition forKey:kCATransition];
        //
        //        [self presentViewController:contactVC animated:NO completion:nil];

        //        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //
        //        _fmVC = [storyboard instantiateViewControllerWithIdentifier:@"FragmentViewController"];


        if (_fmVC) {

            _fmVC.amVC = self;
            [self didSelectedContact];

        }

    }
    else
    {
    
        VeeContactPickerViewController *veeContactPickerViewController = [[VeeContactPickerViewController alloc] initWithDefaultConfiguration];
        
        veeContactPickerViewController.contactPickerDelegate = self;
    
       // [self.navigationController pushViewController:veeContactPickerViewController  animated:YES];
        
        [self presentViewController:veeContactPickerViewController animated:YES completion:nil];
        
    }
    
}

- (void)didSelectedContact
{
    //contactVC = [[ContactsTableController alloc] initWithNibName:@"ContactsTableController" bundle:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        self->contactVC = [[ContactsTableController alloc] init];
        
        self->contactVC.delegate = self;
        
        CATransition* transition = [CATransition animation];
        transition.duration = 0.3;
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromTop;
        
        //[self.view.window.layer addAnimation:transition forKey:kCATransition];
        
        UIViewController *top = [UIApplication sharedApplication].keyWindow.rootViewController;
        
        [top presentViewController:self->contactVC animated:NO completion:nil];
        
    });
    
    // [self.navigationController pushViewController:contactVC animated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}


-(void)ContactsTableController:(ContactsTableController *)obj getName:(NSString *)name andphNo:(CNContact *)contact
{
    
    self.lbl_DepartmentName.text = name;

        [_weVC WebexViewController:_weVC getName:name andphNo:contact];
    
    
}

-(void)ContactsTableController:(ContactsTableController *)obj getName:(NSString *)name withphNo:(NSString *)ph
{
    if (_weVC) {
        
        [_weVC WebexViewController:_weVC getName:name andphNo:ph];
        
}
}



-(void)WebexViewController:(WebexViewController *)adm getName:(NSString *)name andphNo:(CNContact *)contact{
    
    
}



- (void)didSelectContact:(id<VeeContactProt>)veeContact
{
    //Do whatever you want with the selected veeContact!
    
    _lbl_DepartmentName.text = [veeContact displayName];
    
    NSString *phoneStr = [[veeContact phoneNumbers]objectAtIndex:0];
    
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"+91" withString:@""];
    
    NSCharacterSet *digits = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *illegalCharacters = [digits invertedSet];
    NSArray *components = [phoneStr componentsSeparatedByCharactersInSet:illegalCharacters];
    
    phone = [components componentsJoinedByString:@""];
    
    [UIView animateWithDuration:0 animations:^{
        
        NSDictionary *userDict = [Userdefaults objectForKey:@"ProfInfo"];
        
        NSString *userType = [userDict objectForKey:@"usertype"];
        
//        if ([userType isEqualToString:@"Guest"]) {
//            
//            [self getEmployeeavailTimeforDate:self->fDateSel];
//            
//        } else {
//            
//            [self getUseravailTimeforDate:self->fDateSel];
//        }
        
    } completion:^(BOOL finished) {
        //Do something after that...
        
    }];
    
}


- (void)didFailToAccessAddressBook
{
    //Show an error?
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please allow Phonebook access."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
