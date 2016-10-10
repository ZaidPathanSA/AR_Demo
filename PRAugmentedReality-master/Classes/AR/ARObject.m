//
//  ARObject.m
//  PrometAR
//
// Created by Geoffroy Lesage on 4/24/13.
// Copyright (c) 2013 Promet Solutions Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "ARObject.h"
#import "AppDelegate.h"
#import "PointCell.h"

@interface ARObject ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *IBimgLogo;
@property (weak, nonatomic) IBOutlet UILabel *IBlblTitle;
@property (weak, nonatomic) IBOutlet UITableView *IBtbl;

@end


@implementation ARObject

@synthesize arTitle, distance;

- (id)initWithId:(int)newId
           title:(NSString*)newTitle
     coordinates:(CLLocationCoordinate2D)newCoordinates
andCurrentLocation:(CLLocationCoordinate2D)currLoc
{
    self = [super init];
    if (self) {
        arId = newId;
        
        arrPointsData = [[NSMutableArray alloc] init];
        arTitle = [[NSString alloc] initWithString:newTitle];
        
        lat = newCoordinates.latitude;
        lon = newCoordinates.longitude;
        
        distance = @([self calculateDistanceFrom:currLoc]);
        
        [self.view setTag:newId];
        
        [self.IBtbl registerNib:[UINib nibWithNibName:@"PointCell" bundle:nil] forCellReuseIdentifier:@"PointCell"];
        
        [self.IBtbl setTableFooterView:[UIView new]];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
        NSData *content = [[NSData alloc] initWithContentsOfFile:filePath];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:content options:kNilOptions error:nil];
        
        
        NSDictionary *section_1 = [json objectForKey:@"section_1"];
        NSDictionary *section_2 = [json objectForKey:@"section_2"];
        NSDictionary *section_3 = [json objectForKey:@"section_3"];
        NSDictionary *section_4 = [json objectForKey:@"section_4"];
        
        UIImage *image1 = [UIImage imageNamed:[section_1 objectForKey:@"image"]];
        UIImage *image2 = [UIImage imageNamed:[section_2 objectForKey:@"image"]];
        UIImage *image3 = [UIImage imageNamed:[section_3 objectForKey:@"image"]];
        UIImage *image4 = [UIImage imageNamed:[section_4 objectForKey:@"image"]];
        
        NSMutableArray *points1 = [section_1 objectForKey:@"points"];
        NSMutableArray *points2 = [section_2 objectForKey:@"points"];
        NSMutableArray *points3 = [section_3 objectForKey:@"points"];
        NSMutableArray *points4 = [section_4 objectForKey:@"points"];
//        arrPointsData = [[NSMutableArray alloc] initWithObjects:
//                         @{@"Title":@"Title 1",
//                           @"Data":@[@"Sub Title 1",@"Sub Title 1",@"Sub Title 1"]
//                           },
//                         @{@"Title":@"Title 2",
//                           @"Data":@[@"Sub Title 2",@"Sub Title 2",@"Sub Title 2"]
//                           },
//                         @{@"Title":@"Title 3",
//                           @"Data":@[@"Sub Title 3",@"Sub Title 3",@"Sub Title 3"]
//                           },
//                         nil];
        
        if (newId == 0) {
            [self.IBlblTitle setText:[section_1 objectForKey:@"title"]];
            
            if (image1 != nil) {
                [self.IBimgLogo setImage:image1];
            }
            
            arrPointsData = points1;
            
        }else if (newId == 1) {
            [self.IBlblTitle setText:[section_2 objectForKey:@"title"]];
            
            if (image2 != nil) {
                [self.IBimgLogo setImage:image2];
            }
            
            arrPointsData = points2;
        }else if (newId == 2) {
            [self.IBlblTitle setText:[section_3 objectForKey:@"title"]];
            
            if (image3 != nil) {
                [self.IBimgLogo setImage:image3];
            }
            
            arrPointsData = points3;
        }else if (newId == 3) {
            [self.IBlblTitle setText:[section_4 objectForKey:@"title"]];
            
            if (image4 != nil) {
                [self.IBimgLogo setImage:image4];
            }
            
            arrPointsData = points4;
        }else{
        
        }
    }
    return self;
}

-(double)calculateDistanceFrom:(CLLocationCoordinate2D)user_loc_coord
{
    CLLocationCoordinate2D object_loc_coord = CLLocationCoordinate2DMake(lat, lon);
    
    CLLocation *object_location = [[CLLocation alloc] initWithLatitude:object_loc_coord.latitude
                                                              longitude:object_loc_coord.longitude];
    CLLocation *user_location = [[CLLocation alloc] initWithLatitude:user_loc_coord.latitude
                                                            longitude:user_loc_coord.longitude];
    
    return [object_location distanceFromLocation:user_location];
}
-(NSString*)getDistanceLabelText
{
    if (distance.doubleValue > POINT_ONE_MILE_METERS)
         return [NSString stringWithFormat:@"%.2f mi", distance.doubleValue*METERS_TO_MILES];
    else return [NSString stringWithFormat:@"%.0f ft", distance.doubleValue*METERS_TO_FEET];
}

- (NSDictionary*)getARObjectData
{
    NSArray *keys = @[@"id",@"title", @"latitude", @"longitude", @"distance"];
    
    NSArray *values = @[@(arId),
                       arTitle,
                       @(lat),
                       @(lon),
                       distance];
    return [NSDictionary dictionaryWithObjects:values forKeys:keys];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [titleL setText:arTitle];
    
    [distanceL setText:[self getDistanceLabelText]];
    
    [self.IBtbl reloadData];
}


#pragma mark -- OO Methods
- (IBAction)IBActionTap:(UIButton*)sender {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.window.rootViewController performSegueWithIdentifier:@"DetailsVC" sender:self];
    NSLog(@"%ld",(long)sender.superview.tag);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ARObject %d - %@ - lat: %f - lon: %f - distance: %@",
            arId, arTitle, lat, lon, distance];
}

#pragma mark -- Delegate/Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrPointsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PointCell *cell = [tableView dequeueReusableCellWithIdentifier: @"PointCell" forIndexPath:indexPath];
    [cell.IBlblPoint setText:[arrPointsData[indexPath.row] objectForKey:@"title"]];
    
    UIImage *image = [UIImage imageNamed:[arrPointsData[indexPath.row] objectForKey:@"image"]];
    
    if (image != nil){
        [cell.IBimgLogo setImage:image];
    }
    
    return cell;
}


@end
