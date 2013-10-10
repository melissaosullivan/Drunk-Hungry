//
//  DrunkHungryViewController.m
//  drunkh
//
//  Created by Serena Simkus on 9/28/13.
//  Copyright (c) 2013 Serena Simkus. All rights reserved.
//

#import "DrunkHungryViewController.h"
#import "Engine.h"
#import "Foursquare.h"
#import <MapKit/MapKit.h>

@interface DrunkHungryViewController ()

@end

@implementation DrunkHungryViewController
int i;
Foursquare *api;
CLLocationManager *locationManager;
@synthesize title, image;
@synthesize fslat;
@synthesize fslng;


- (void)viewDidLoad
{
    http://drunkhackny.herokuapp.com/?lat=41&lng=-74
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    
    [self.navigationController setNavigationBarHidden:true];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        fslng = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        fslat = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        
        NSLog(@"fslat: %@",fslat);
        NSLog(@"fslng: %@",fslng);
    }
    
    [locationManager stopUpdatingLocation];
    
    NSString *fsURL = [NSString stringWithFormat:@"%@%@%@%@", @"http://drunkhackny.herokuapp.com/?lat=",fslat, @"&lng=", fslng];
    //NSLog(@"fslat: %@",fslat);
    //NSLog(@"fslng: %@",fslng);
    
    //NSURL *url1 = [NSURL URLWithString:@"http://drunkhackny.herokuapp.com/?lat=41&lng=-74"];
    
    NSURL *url1 = [NSURL URLWithString:fsURL];
    
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url1];
    [req setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    
    NSError *err = nil;
    NSHTTPURLResponse *res = nil;
    NSData *retData = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
    if (err)
    {
        NSLog(@"%@", err);
    }
    else
    {
        NSString *response = [[NSString alloc]initWithData:retData encoding:NSUTF8StringEncoding];
        
        NSData *jsondata = [response dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *e = nil;
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:&e];
        
        api = [[Foursquare alloc] initWithDictionary:json error:&e];
        
        NSURL *url = [NSURL URLWithString:[[api.venues valueForKey:@"photo"] objectAtIndex: 0]];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        image.image = [UIImage imageWithData:data];
        
        title.text = [[api.venues valueForKey:@"name"] objectAtIndex: i];
        
        i = 0;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reject:(id)sender {
    
    i++;
    [self updateImageView];
    
}

- (IBAction)work:(id)sender {
    id venue = [api.venues objectAtIndex: i];
    NSString *lat = [venue valueForKey:@"lat"];
    NSString *lng = [venue valueForKey:@"lng"];
    MKPlacemark *place = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]) addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:place];
    mapItem.name = [venue valueForKey:@"name"];
    [mapItem openInMapsWithLaunchOptions:nil];
}

- (void)updateImageView {
    NSURL *url = [NSURL URLWithString:[[api.venues valueForKey:@"photo"] objectAtIndex: i]];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    image.image = [UIImage imageWithData:data];
    
    title.text = [[api.venues objectAtIndex: i] valueForKey:@"name"];
}

- (IBAction)swiperight:(id)sender {
    i++;
    
    if (i == api.venues.count) {
        i = 0;
    }
    
    [self updateImageView];
}

- (IBAction)swipeleft:(id)sender {
    if (i == 0) {
        i = api.venues.count - 1;
    } else {
        i--;
    }
    
    [self updateImageView];
}


@end
