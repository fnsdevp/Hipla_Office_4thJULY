//
//  NavigationViewController.m
//  @TCS
//
//  Created by FNSPL on 28/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@end


@implementation NavigationViewController


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];

    
    [self.navigationController.navigationBar setHidden:YES];
    
    NSLog(@"viewDidLoad:%@",self);
    
    BOOL within400Meter = [Userdefaults boolForKey:@"within400Meter"];
    
    if (within400Meter)
    {
        [[ZoneDetection sharedZoneDetection] setDelegate:self];
    }
    
    _sv.delegate = self;
//    _sv.pinchGestureRecognizer.enabled = YES;
    _sv.minimumZoomScale = 1.f;
    _sv.zoomScale = 1.f;
    _sv.maximumZoomScale = 2.f;
    
    [_sv addSubview:_imageView];
    
    arrNames = [[NSMutableArray alloc] initWithObjects:@"director room",@"j p lahiri room",@"conference room",@"toilet",@"director toilet",@"e publishing",@"reception",@"entry",@"developer bay",@"developer entry",@"corridor", nil];
    
    arrPointx = [[NSMutableArray alloc] initWithObjects:@"17.73",@"17.62",@"23.79",@"21.99",@"22.01",@"21.15",@"12.88",@"8.04",@"17.44",@"17.61",@"17.50", nil];
    
    arrPointy = [[NSMutableArray alloc] initWithObjects:@"7.30",@"14.72",@"21.19",@"29.94",@"23.94",@"42.15",@"37.05",@"39.58",@"22.26",@"27.74",@"35.21", nil];
    
    
    // Point on map
    
    _current = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    _current.backgroundColor = [UIColor colorWithHexString:@"#50BDEB"];
    _current.layer.cornerRadius = _current.frame.size.height/2.f;
    
    [_imageView addSubview:_current];
    
    _imageView.userInteractionEnabled = YES;
    
    _isRouting = NO;
    
    [self setupNavigine];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    BOOL within400Meter = [Userdefaults boolForKey:@"within400Meter"];
    
    if (within400Meter)
    {
        [[ZoneDetection sharedZoneDetection] setDelegate:self];
    }
    
    [SVProgressHUD show];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
//    [self.navigationController popViewControllerAnimated:YES];
    
    _navigineCore = nil;
    
    [[ZoneDetection sharedZoneDetection] setDelegate:nil];
}

-(void)dealloc
{
    NSLog(@"dealloc:%@",self);
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self getZone];
    
}

-(void)navigateForConferenceRoom
{
    CGFloat xPoint = [[arrPointx objectAtIndex:0] floatValue];
    CGFloat yPoint = [[arrPointy objectAtIndex:0] floatValue];
    
    [self drawPathWithEndPoint:CGPointMake(xPoint, yPoint)];
    
    _isRouting = YES;
}

-(void)navigateForHotDesking
{
    CGFloat xPoint = [[arrPointx objectAtIndex:1] floatValue];
    CGFloat yPoint = [[arrPointy objectAtIndex:1] floatValue];
    
    [self drawPathWithEndPoint:CGPointMake(xPoint, yPoint)];
    
    _isRouting = YES;
}

-(void)navigateForGentsToilet
{
    CGFloat xPoint = [[arrPointx objectAtIndex:2] floatValue];
    CGFloat yPoint = [[arrPointy objectAtIndex:2] floatValue];
    
    [self drawPathWithEndPoint:CGPointMake(xPoint, yPoint)];
    
    _isRouting = YES;
}


-(void)navigateForLadiesToilet
{
    CGFloat xPoint = [[arrPointx objectAtIndex:3] floatValue];
    CGFloat yPoint = [[arrPointy objectAtIndex:3] floatValue];
    
    [self drawPathWithEndPoint:CGPointMake(xPoint, yPoint)];
    
    _isRouting = YES;
}


- (IBAction)showMenu:(UIButton *)sender
{
    [self stopRoute];
    
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"Conference Room"
                     image:nil
                    target:self
                    action:@selector(navigateForConferenceRoom)],
      
      [KxMenuItem menuItem:@"Hot Desking"
                     image:nil
                    target:self
                    action:@selector(navigateForHotDesking)],
      
      [KxMenuItem menuItem:@"Gents Toilet"
                     image:nil
                    target:self
                    action:@selector(navigateForGentsToilet)],
      
      [KxMenuItem menuItem:@"Ladies Toilet"
                     image:nil
                    target:self
                    action:@selector(navigateForLadiesToilet)]
      
      ];
    
    
    [KxMenu showMenuInView:self.view.window
                  fromRect:CGRectMake((SCREENWIDTH - 65), (sender.frame.origin.y - 20), sender.frame.size.width, sender.frame.size.width)
                 menuItems:menuItems];
    
}


-(void)getZone{
    
    NSString *url = [NSString stringWithFormat:@"https://api.navigine.com/zone_segment/getAll?userHash=0F17-DAE1-4D0A-1778&sublocationId=3247"];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    //create the Method "GET"
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                          
                                          if(httpResponse.statusCode == 200)
                                          {
                                              NSError *parseError = nil;
                                              
                                              NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                              
                                              NSLog(@"The response is - %@",responseDictionary);
                                              
                                              self->_zoneArray = [NSArray arrayWithArray:[responseDictionary objectForKey:@"zoneSegments"]];
                                              
                                          }
                                          else
                                          {
                                              NSLog(@"Error");
                                          }
                                          
                                          [SVProgressHUD dismiss];
                                          
                                      }];
    
    [dataTask resume];
    
}


-(void) setupNavigine {
    
    NCLocation *location = [ZoneDetection sharedZoneDetection].navigineCore.location;
    if ([location.sublocations count]) {
        
        NCSublocation *sublocation = location.sublocations[0];
        [_imageView removeAllSubviews];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //  _imageView.layer.sublayers = nil;
            [self->_imageView addSubview:self->_current];
            
        });
        
        //   [self presentViewController:_navigineCore.location.viewController animated:YES completion:nil];
        
        NSData *imageData = sublocation.pngImage;
        UIImage *image = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            float scale = 1.f;
            
            if (image.size.width / image.size.height >
                self.view.frame.size.width / self.view.frame.size.height) {
                scale = self.view.frame.size.height / image.size.height;
            }
            else {
                scale = self.view.frame.size.width / image.size.width;
            }
            
//            if (scale<1.f) {
//
//                scale = 1.f;
//            }
            
            self->_imageView.frame = CGRectMake(0, 0, image.size.width * scale, image.size.height * scale);
            
            self->_imageView.image = image;
            self->_sv.contentSize = self->_imageView.frame.size;
            
        });
        
    } else {
        
    }
    
    
    // [self drawZones];
    
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //
    //    });
    
}


- (void) drawZones {
    
    NCSublocation *sublocation = [ZoneDetection sharedZoneDetection].navigineCore.location.sublocations[0];
    NSArray *zones = sublocation.zones;
    
    for (NCZone *zone in zones) {
        UIBezierPath *zonePath     = [[UIBezierPath alloc] init];
        CAShapeLayer *zoneLayer = [CAShapeLayer layer];
        NSArray *points = zone.points;
        NCLocationPoint *point0 = points[0];
        
        [zonePath moveToPoint:CGPointMake(_imageView.width * point0.x.doubleValue / sublocation.width,
                                          _imageView.height * (1. - point0.y.doubleValue / sublocation.height))];
        for (NCLocationPoint *point in zone.points) {
            [zonePath addLineToPoint:CGPointMake(_imageView.width * point.x.doubleValue / sublocation.width,
                                                 _imageView.height * (1. - point.y.doubleValue / sublocation.height))];
        }
        [zonePath addLineToPoint:CGPointMake(_imageView.width * point0.x.doubleValue / sublocation.width,
                                             _imageView.height *(1. - point0.y.doubleValue / sublocation.height))];
        unsigned int result = 0;
        NSScanner *scanner = [NSScanner scannerWithString:zone.color];
        [scanner setScanLocation:1];
        [scanner scanHexInt:&result];
        
        zoneLayer.hidden = NO;
        zoneLayer.path            = [zonePath CGPath];
        zoneLayer.strokeColor     = [kColorFromHex(result) CGColor];
        zoneLayer.lineWidth       = 2.0;
        zoneLayer.lineJoin        = kCALineJoinRound;
        zoneLayer.fillColor       = [[kColorFromHex(result) colorWithAlphaComponent:0.5] CGColor];
        
        [_imageView.layer addSublayer:zoneLayer];
    }
}


- (void)drawPathWithEndPoint:(CGPoint)endPoint
{
    NCDeviceInfo *res = [ZoneDetection sharedZoneDetection].navigineCore.deviceInfo;
    
    CGFloat xPoint = endPoint.x;
    CGFloat yPoint = endPoint.y;
    
    NCLocationPoint *location = [NCLocationPoint pointWithLocation:res.location sublocation:res.sublocation x:[NSNumber numberWithFloat:xPoint] y:[NSNumber numberWithFloat:yPoint]];
    
    [[ZoneDetection sharedZoneDetection].navigineCore addTatget:location];
    
}

-(void)enterZoneWithZoneName:(NSString *)zoneName {
    
    if (zoneName) {
        
        if ([zoneName isEqualToString:@"conference area"]) {
            
            [Userdefaults setBool:YES forKey:@"inRange"];
            
            [Userdefaults synchronize];
            
            [Userdefaults setBool:YES forKey:@"isConferenceArea"];
            
            [Userdefaults synchronize];
            
            
        } else if ([zoneName isEqualToString:@"entry area"]) {
            
            [Userdefaults setBool:YES forKey:@"inRange"];
            
            [Userdefaults synchronize];
            
        }
        else if ([zoneName isEqualToString:@"developer bay"]) {
            
            [Userdefaults setBool:YES forKey:@"inRange"];
            
            [Userdefaults synchronize];
            
        }
        else if ([zoneName isEqualToString:@"developer entry"]) {
            
            [Userdefaults setBool:YES forKey:@"inRange"];
            
            [Userdefaults synchronize];
            
        }
        else if ([zoneName isEqualToString:@"coridor"]) {
            
            [Userdefaults setBool:YES forKey:@"inRange"];
            
            [Userdefaults synchronize];
            
        }
        
    }
    
}


-(void)exitZoneWithZoneName:(NSString *)zoneName {
    
    if (zoneName) {
        
        if ([zoneName isEqualToString:@"conference area"]) {
            
            [Userdefaults setBool:false forKey:@"speechConference"];
            
            [Userdefaults setBool:NO forKey:@"isConferenceArea"];
            
            [Userdefaults synchronize];
            
        }
        else if ([zoneName isEqualToString:@"developer entry"]) {
            
            
        }
        else if ([zoneName isEqualToString:@"entry area"])
        {
            [Userdefaults setBool:NO forKey:@"isPreEntry"];
            
            [Userdefaults setBool:NO forKey:@"inRange"];
            
            [Userdefaults synchronize];
            
        }
    }
}



- (NSDictionary *)didEnterZoneWithPoint:(CGPoint)currentPoint {
    
    NSDictionary* zone = nil;
    
    if (_zoneArray) {
        
        for (NSInteger i = 0; i < [_zoneArray count]; i++) {
            
            NSDictionary* dicZone = [NSDictionary dictionaryWithDictionary:[_zoneArray objectAtIndex:i]];
            
            NSArray* coordinates = [NSArray arrayWithArray:[dicZone objectForKey:@"coordinates"]];
            
            if ([coordinates count]>0) {
                
                UIBezierPath* path = [[UIBezierPath alloc]init];
                
                for (NSInteger j=0; j < [coordinates count]; j++) {
                    
                    NSDictionary* dicCoordinate = [NSDictionary dictionaryWithDictionary:[coordinates objectAtIndex:j]];
                    
                    if ([[dicCoordinate allKeys] containsObject:@"kx"]) {
                        
                        float xPoint = (float)[[dicCoordinate objectForKey:@"kx"] floatValue];
                        float yPoint = (float)[[dicCoordinate objectForKey:@"ky"] floatValue];
                        
                        CGPoint point = CGPointMake(xPoint, yPoint);
                        
                        if (j == 0) {
                            
                            [path moveToPoint:point];
                            
                        } else {
                            
                            [path addLineToPoint:point];
                        }
                    }
                }
                
                [path closePath];
                
                if ([path containsPoint:currentPoint]) {
                    
                    zone = [NSDictionary dictionaryWithDictionary:dicZone];
                    
                    break;
                    
                } else {
                    
                    zone = nil;
                    
                }
            }
        }
        
    } else {
        
    }
    
    return zone;
}


- (void)stopRoute {
    
    _isRouting = NO;
    
    [routeLayer removeFromSuperlayer];
    routeLayer = nil;
    
    [uipath removeAllPoints];
    uipath = nil;
    [[ZoneDetection sharedZoneDetection].navigineCore cancelTargets];
}


- (void)navigationTicker {
    
    // NCDeviceInfo *res = _navigineCore.deviceInfo;
    
    NCDeviceInfo *res = [ZoneDetection sharedZoneDetection].navigineCore.deviceInfo;
    
    NSLog(@"Error code:%zd",res.error.code);
    
    if (res.error.code == 0) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"RESULT: %lf %lf", res.x, res.y);
        
        NSDictionary* dic = [self didEnterZoneWithPoint:CGPointMake(res.kx, res.ky)];
        
        if ([[dic allKeys] containsObject:@"name"]) {
            
            // NSLog(@"zone detected:%@",dic);
            
            NSString* zoneName = [dic objectForKey:@"name"];
            
            if (!_currentZoneName) {
                
                _currentZoneName = zoneName;
                
                [self enterZoneWithZoneName:_currentZoneName];
                
                
            } else {
                
                if (![zoneName isEqualToString:_currentZoneName]) {
                    
                    [self exitZoneWithZoneName:_currentZoneName];
                    
                    _currentZoneName = zoneName;
                    
                    [self enterZoneWithZoneName:_currentZoneName];
                    
                } else {
                    
                }
            }
            
            
        } else {
            
            if (_currentZoneName) {
                
                [self exitZoneWithZoneName:_currentZoneName];
                
                _currentZoneName = nil;
                
            } else {
                
            }
            
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self->_current.center = CGPointMake(self->_imageView.width / self->_sv.zoomScale * res.kx,
                                                self->_imageView.height / self->_sv.zoomScale * (1. - res.ky));
            
            if ([self.currentRoom isEqualToString:@"conference area"])
            {
                [self performSelector:@selector(navigateForConferenceRoom) withObject:nil afterDelay:0.3];
            }
            
        });
        
    }
    else{
        
        NSLog(@"Error code:%zd",res.error.code);
    }
    
    if (_isRouting) {
        
        NCRoutePath *devicePath = res.paths.firstObject;
        
        NSArray *path = devicePath.points;
        
        float distance = devicePath.lenght;
        
        [self drawRouteWithPath:path andDistance:distance];
        
    }
}


-(void) drawRouteWithPath: (NSArray *)path
              andDistance: (float)distance {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //    // We check that we are close to the finish point of the route
        if (distance <= 0.2) {
            
            [self stopRoute];
            
        }
        else {
            
            [self->routeLayer removeFromSuperlayer];
            [self->uipath removeAllPoints];
            
            self->uipath     = [[UIBezierPath alloc] init];
            self->routeLayer = [CAShapeLayer layer];
            
            for (int i = 0; i < path.count; i++ ) {
                
                NCLocationPoint *point = path[i];
                NCSublocation *sublocation = [ZoneDetection sharedZoneDetection].navigineCore.location.sublocations[0];
                CGSize imageSizeInMeters = CGSizeMake(sublocation.width, sublocation.height);
                
                CGFloat xPoint =  (point.x.doubleValue / imageSizeInMeters.width) * (self->_imageView.width / self->_sv.zoomScale);
                CGFloat yPoint =  (1. - point.y.doubleValue / imageSizeInMeters.height)  * (self->_imageView.height / self->_sv.zoomScale);
                if(i == 0) {
                    [self->uipath moveToPoint:CGPointMake(xPoint, yPoint)];
                }
                else {
                    [self->uipath addLineToPoint:CGPointMake(xPoint, yPoint)];
                }
            }
        }
        
        self->routeLayer.hidden          = NO;
        self->routeLayer.path            = [self->uipath CGPath];
        //    routeLayer.strokeColor     = [kColorFromHex(0x4AADD4) CGColor];
        self->routeLayer.strokeColor     = [[UIColor blueColor] CGColor];
        
        self->routeLayer.lineWidth       = 3.0;
        self->routeLayer.lineJoin        = kCALineJoinRound;
        self->routeLayer.fillColor       = [[UIColor clearColor] CGColor];
        
        [self->_imageView.layer addSublayer:self->routeLayer];
        [self->_imageView bringSubviewToFront:self->_current];
        
    });
    
}


#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return _imageView;
}


#pragma mark NavigineCoreDelegate methods

- (void) didRangePushWithTitle:(NSString *)title
                       content:(NSString *)content
                         image:(NSString *)image
                            id:(NSInteger)id{
    
    // Your code
    
}


- (IBAction)btnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
