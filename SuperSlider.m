//
//  SuperSlider.m
//  RadialDialDemo
//
//  Created by Eytan Moudahi on 11-09-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SuperSlider.h"

@interface SuperSlider ()
- (void)incrementIndexAtIndex:(CGFloat)index withTouch:(UITouch*)touch;
- (CGFloat)getAngleBetweenNormalAtIndex:(CGFloat)index andTouchPoint:(CGPoint)touchPoint;
- (CGPoint)getNormalVectorAtIndex:(CGFloat)index;
@end

@implementation SuperSlider

@synthesize startIndex, currentIndex, endIndex;
@synthesize thumbView; 
@synthesize isMovingThumb;
@synthesize flipThumbVertical, flipThumbHorizontal, thumbOffset;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        startIndex = 0;
        endIndex = 1;
        currentIndex = 0.5;
        flipThumbVertical = FALSE;
        flipThumbHorizontal = FALSE;
        thumbOffset = 0;
        isMovingThumb = FALSE;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [thumbView release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:thumbView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    thumbView.center = [self pointForIndex:currentIndex];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.view == self.thumbView)
    {
        isMovingThumb = TRUE;
    }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    // Calculate the new angle based on position. Set the new position.
    if (isMovingThumb) {
        [self incrementIndexAtIndex:self.currentIndex withTouch:touch];
        CGPoint newPoint = [self pointForIndex:self.currentIndex];
        self.thumbView.center = newPoint;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // If the thumb was being moved, stop the motion.
    if (isMovingThumb)
    {
        isMovingThumb = FALSE;
    }
}


#pragma mark - Updating Index methodss
- (CGPoint)getNormalVectorAtIndex:(CGFloat)index
{
    CGPoint currentPoint;
    CGPoint nextPoint;
    CGPoint tangentVector;
    CGPoint normalVector;
    CGFloat dIndex = (endIndex - startIndex)/1000;
    
    // Gets the two reference points to calculate the normal vector. If the 
    // Index will exceed the bounds, we take the normal vector of the previous
    // point. If the index is too low, we use the start point plus dIndex;
    if ((index + dIndex) > self.endIndex) {
        nextPoint = [self pointForIndex:index];
        currentPoint = [self pointForIndex:index-dIndex];
    }
    else if (index < self.startIndex)
    {
        nextPoint = [self pointForIndex:self.startIndex + dIndex];
        currentPoint = [self pointForIndex:self.startIndex];
    }
    else
    {
        nextPoint = [self pointForIndex:index + dIndex];
        currentPoint = [self pointForIndex:index];
    }
    
    // Get the tangent vector
    tangentVector = CGPointMake(nextPoint.x - currentPoint.x,
                                nextPoint.y - currentPoint.y);
    
    // Get the normal vector by rotating the tangent vector by 90 degrees
    CGFloat norm = sqrt(tangentVector.x*tangentVector.x + tangentVector.y+tangentVector.y);
    normalVector = CGPointMake(tangentVector.y/norm, 
                               -tangentVector.x/norm);
    return normalVector;
}

- (CGFloat)getAngleBetweenNormalAtIndex:(CGFloat)index andTouchPoint:(CGPoint)touchPoint
{
    // Get vector from current location to touch location
    CGPoint normalVector = [self getNormalVectorAtIndex:index];
    CGPoint currentPoint = [self pointForIndex:index];
    CGPoint touchVector = CGPointMake(touchPoint.x - currentPoint.x, 
                                      touchPoint.y - currentPoint.y);

    // Use the two vectors to get the angle between the two
    CGFloat dy = normalVector.x*touchVector.y - normalVector.y*touchVector.x;
    CGFloat dx = normalVector.x*touchVector.x + normalVector.y*touchVector.y;
    CGFloat angle = atan2(dy, dx);
    
    return angle;
}
- (CGFloat)nextIndexAtIndex:(CGFloat)index withTouch:(UITouch*)touch
{
    CGFloat dIndex = (endIndex - startIndex)/1000;
    
    // Get the angle and determine the closeness factor. If the closeness factor
    // increases on the next iteration, we want to stop. Otherwise, we want to
    // continue iterating.
    CGPoint touchPoint = [touch locationInView:self.view];
    CGFloat angle = [self getAngleBetweenNormalAtIndex:self.currentIndex andTouchPoint:touchPoint];
    
    if (angle < 0) {
        return MAX(self.currentIndex - dIndex, self.startIndex);
    }
    else if (angle == 0) {
        return self.currentIndex;
    }
    else if (0 < angle && angle < M_PI) {
        //self.currentIndex = MAX(self.currentIndex - dIndex, self.startIndex);
        return MIN(self.currentIndex + dIndex, self.endIndex);
    }
    else {
        return self.currentIndex;
    }    
}
- (void)incrementIndexAtIndex:(CGFloat)index withTouch:(UITouch*)touch
{    
    
    NSUInteger iterationCount = 0;
    
    // Get the angle and determine the closeness factor. If the closeness factor
    // increases on the next iteration, we want to stop. Otherwise, we want to
    // continue iterating.
    CGPoint touchPoint = [touch locationInView:self.view];
    CGFloat angle = [self getAngleBetweenNormalAtIndex:self.currentIndex andTouchPoint:touchPoint];
    CGFloat closeness = MIN(fabs(angle), M_PI-fabs(angle));

    CGFloat nextIndex = [self nextIndexAtIndex:self.currentIndex withTouch:touch];
    CGFloat nextAngle = [self getAngleBetweenNormalAtIndex:nextIndex andTouchPoint:touchPoint];
    CGFloat nextCloseness = MIN(fabs(nextAngle), M_PI-fabs(nextAngle));
    //NSLog(@"%.2f", nextCloseness - closeness);
    
    while (nextCloseness < closeness) {
        self.currentIndex = nextIndex;
        angle = [self getAngleBetweenNormalAtIndex:self.currentIndex andTouchPoint:touchPoint];
        closeness = nextCloseness;
        nextIndex = [self nextIndexAtIndex:self.currentIndex withTouch:touch];
        nextAngle = [self getAngleBetweenNormalAtIndex:nextIndex andTouchPoint:touchPoint];
        nextCloseness = nextCloseness = MIN(fabs(nextAngle), M_PI-fabs(nextAngle));
        //NSLog(@"%.2f", nextCloseness - closeness);
        
        // As an insurance policy, don't allow more than 1000 iterations.
        if (++iterationCount > 1000) {
            break;
        }
    }
    
    // Get current angle,
    // Find the angle of the next angle when the increment has been applied
    
}

@end

@implementation LineSlider

@synthesize startPoint, endPoint;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        startPoint = CGPointZero;
        endPoint = CGPointZero;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (CGPoint) pointForIndex:(CGFloat)index
{
    // If startIndex, endIndex, startPoint, or EndPoint are not defined, this function
    // should raise an exception.
    
    // Ensure the index is within the bounds
    if (index <  self.startIndex)
        index = self.startIndex;
    else if (index > self.endIndex)
        index = self.endIndex;
    
    CGFloat stepRatio = (index - self.startIndex)/(self.endIndex - self.startIndex);
    CGFloat x = startPoint.x + (endPoint.x - startPoint.x) * stepRatio;
    CGFloat y = startPoint.y + (endPoint.y - startPoint.y) * stepRatio;
    
    return CGPointMake(x, y);
}

@end





