//
//  SuperSlider.h
//  RadialDialDemo
//
//  Created by Eytan Moudahi on 11-09-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuperSlider : UIViewController

@property (readwrite) CGFloat startIndex;
@property (readwrite) CGFloat endIndex;
@property (readwrite) CGFloat currentIndex;
@property (readwrite) BOOL isMovingThumb;
@property (readwrite) BOOL flipThumbHorizontal;
@property (readwrite) BOOL flipThumbVertical;
@property (readwrite) CGFloat thumbOffset;
@property (nonatomic, retain) IBOutlet UIView *thumbView;

@end

@interface SuperSlider (MethodsSubclassMustImplement)

- (CGPoint) pointForIndex:(CGFloat)index;

@end


@interface LineSlider : SuperSlider

@property (assign) CGPoint startPoint;
@property (assign) CGPoint endPoint;

@end