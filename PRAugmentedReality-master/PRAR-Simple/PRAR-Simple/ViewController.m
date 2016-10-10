//
//  ViewController.m
//  PRAR-Simple
//
//  Created by Geoffroy Lesage on 3/27/14.
//  Copyright (c) 2014 Promet Solutions Inc,. All rights reserved.
//

#import "ViewController.h"

#include <stdlib.h>


#define NUMBER_OF_POINTS    20


@interface ViewController ()

@property (nonatomic, strong) PRARManager *prARManager;

@end


@implementation ViewController


- (void)alert:(NSString*)title withDetails:(NSString*)details {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:details
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize the manager so it wakes up (can do this anywhere you want
    self.prARManager = [[PRARManager alloc] initWithSize:self.view.frame.size delegate:self showRadar:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    // Initialize your current location as 0,0 (since it works with our randomly generated locations)
    CLLocationCoordinate2D locationCoordinates = CLLocationCoordinate2DMake(0, 0);
    
    [self.prARManager startARWithData:[self getDummyData] forLocation:locationCoordinates];
}


#pragma mark - Dummy AR Data

// Creates data for `NUMBER_OF_POINTS` AR Objects
-(NSArray*)getDummyData
{
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:NUMBER_OF_POINTS];
    
    srand48(time(0));
//    23.063655, 72.531167 - Cross road
    
    for (int i=0; i<4; i++)
    {
        CLLocationCoordinate2D pointCoordinates = [self getRandomLocation:i];
        NSDictionary *point = [self createPointWithId:i at:pointCoordinates];
        [points addObject:point];
    }
    
    return [NSArray arrayWithArray:points];
}

// Returns a random location
-(CLLocationCoordinate2D)getRandomLocation:(NSUInteger)number
{
    
    CLLocationCoordinate2D locCoordinates;
//    double latRand = drand48() * 90.0;
//    double lonRand = drand48() * 180.0;
    double latSign = drand48();
    double lonSign = drand48();
    
    double latV;// = drand48() * 90.0;
    double lonV;// = drand48() * 180.0;
    
    // TODO:- Zaid
    if (number == 0) {
        latV = -180.0;// * 90.0;
        lonV = -180.0;// * 180.0;

    }else if (number == 1){
        latV = -180.0;// * 90.0;
        lonV = 180.0;// * 180.0;
        
    }else if (number == 2){
        latV = 180.0;// * 90.0;
        lonV = 180.0;// * 180.0;

        
    }else if (number == 3){
        latV = 180.0;// * 90.0;
        lonV = -180.0;// * 180.0;
    
    }else{
//    locCoordinates =  CLLocationCoordinate2DMake(0, 0);
    }

    locCoordinates = CLLocationCoordinate2DMake(latV,lonV);
//    double latRand = latV * 90.0;
//    double lonRand = lonV * 180.0;
//    
//    locCoordinates = CLLocationCoordinate2DMake(latSign > 0.5 ? latRand : -latRand,
//                                                                       lonSign > 0.5 ? lonRand*2 : -lonRand*2);
    return locCoordinates;
}

// Creates the Data for an AR Object at a given location
-(NSDictionary*)createPointWithId:(int)the_id at:(CLLocationCoordinate2D)locCoordinates
{
    NSDictionary *point = @{
                            @"id" : @(the_id),
                            @"title" : [NSString stringWithFormat:@"Place Num %d", the_id],
                            @"lon" : @(locCoordinates.longitude),
                            @"lat" : @(locCoordinates.latitude)
                           };
    return point;
}


#pragma mark - PRARManager Delegate

-(void)prarDidSetupAR:(UIView *)arView withCameraLayer:(AVCaptureVideoPreviewLayer *)cameraLayer andRadarView:(UIView *)radar
{
    NSLog(@"Finished displaying ARObjects");
    
    [self.view.layer addSublayer:cameraLayer];
    [self.view addSubview:arView];
    
    [self.view bringSubviewToFront:[self.view viewWithTag:AR_VIEW_TAG]];
    
    [self.view addSubview:radar];
    
    [loadingV setHidden:YES];
}

-(void)prarUpdateFrame:(CGRect)arViewFrame
{
    [[self.view viewWithTag:AR_VIEW_TAG] setFrame:arViewFrame];
}

-(void)prarGotProblem:(NSString *)problemTitle withDetails:(NSString *)problemDetails
{
    [loadingV setHidden:YES];
    [self alert:problemTitle withDetails:problemDetails];
}

@end