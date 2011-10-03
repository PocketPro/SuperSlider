//
//  SuperSliderDemoViewController.m
//  SuperSliderDemo
//
//  Created by Eytan Moudahi on 11-09-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SuperSliderDemoViewController.h"
#import "SuperSlider.h"

@implementation SuperSliderDemoViewController
@synthesize slider;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
/*
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    LineSlider *slider = [[LineSlider alloc] init];
    [self.view addSubview:slider.view];
}
*/

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.slider setStartPoint:CGPointZero];
    [self.slider setEndPoint:CGPointMake(320, 160)];
    [self.slider viewWillAppear:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.slider = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [slider release];
    [super dealloc];
}
@end
