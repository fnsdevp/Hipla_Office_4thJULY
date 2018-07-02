//
//  ControlPanelViewController.h
//  @TCS
//
//  Created by FNSPL on 17/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "NavigationViewController.h"
#import "AFNetworking.h"
#import "MQTTClient.h"
#import "Utils.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "NSURLRequest+NSURLRequestSSLY.h"

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@class Common;

@interface ControlPanelViewController : UIViewController<UINavigationControllerDelegate,MQTTSessionDelegate,sharedZoneDetectionDelegate>
{
    MQTTCFSocketTransport *transport;
    MQTTSession *session;
    
    NSString *strHost;
    NSString *strTopicDoor;
    BOOL Contected;
    
    Common *objcommon;
    
    NSString *userId;
}
@property (weak, nonatomic) IBOutlet UIView *detailsVw;

@property (nonatomic, strong) NavigineCore *navigineCore;
@property (nonatomic, strong) NSString *currentZoneName;
@property (nonatomic, strong) NSArray *zoneArray;

@property (weak, nonatomic) IBOutlet UIButton *btnVisibilityPassword;

@property (weak, nonatomic) IBOutlet UILabel *namelbl;
@property (weak, nonatomic) IBOutlet UILabel *designationlbl;
@property (weak, nonatomic) IBOutlet UILabel *departmentlbl;
@property (weak, nonatomic) IBOutlet UILabel *companylbl;
@property (weak, nonatomic) IBOutlet UILabel *locationlbl;
@property (weak, nonatomic) IBOutlet UILabel *meetingTimelbl;
@property (weak, nonatomic) IBOutlet UILabel *meetingWithlbl;

@property (weak, nonatomic) IBOutlet UILabel *wifiUserNamelbl;
@property (weak, nonatomic) IBOutlet UILabel *wifiPasswordlbl;

@property (weak, nonatomic) IBOutlet UIImageView *profPicImg;
@property (weak, nonatomic) IBOutlet UIImageView *QRImg;
@property(strong,nonatomic) NSMutableArray *array_UserName;
@property(strong,nonatomic) NSMutableArray *array_Password;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;


@end
