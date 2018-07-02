//
//  WebexViewController.h
//  @TCS
//
//  Created by FNSPL on 12/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BaseViewController.h"
#import "FragmentViewController.h"
#import "VeeContactPickerViewController.h"
#import <StoreKit/StoreKit.h>

#import "ContactsTableController.h"


@class FragmentViewController;

@interface WebexViewController : BaseViewController<UITextFieldDelegate,UIScrollViewDelegate,ContactsTableControllerDelegate,VeeContactPickerDelegate>{
    
    NSString *phone;
    SKStoreProductViewController *storeController;
    NSString *fDateSel;
    ContactsTableController *contactVC;

    
    
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_Back;
@property (strong, nonatomic) IBOutlet UIView *view_Confirmation;
@property (strong, nonatomic) IBOutlet UIView *confirmMeetingView;
@property (weak, nonatomic) IBOutlet UITextField *txtfld_Agenda;
@property (weak, nonatomic) IBOutlet UITextField *txtfld_Email;
@property (weak, nonatomic) IBOutlet UILabel *lbl_DepartmentName;
@property (weak, nonatomic) IBOutlet UIButton *btn_Confirm;
@property (weak, nonatomic) IBOutlet UIButton *btn_AddContact;

@property (weak, nonatomic) IBOutlet UILabel *lblDay1;
@property (weak, nonatomic) IBOutlet UILabel *lblMonth1;
@property (weak, nonatomic) IBOutlet UILabel *lblYear1;

@property (weak, nonatomic) IBOutlet UILabel *lblMeetingWith;
@property (weak, nonatomic) IBOutlet UILabel *lblMeetingDateTime;
@property (weak, nonatomic) WebexViewController *weVC;

@property (weak, nonatomic) FragmentViewController *fmVC;
-(void)WebexViewController:(WebexViewController *)adm getName:(NSString *)name andphNo:(CNContact *)contact;
-(void)WebexViewController:(WebexViewController *)adm getName:(NSString *)name withphNo:(NSString *)contact;

@end
