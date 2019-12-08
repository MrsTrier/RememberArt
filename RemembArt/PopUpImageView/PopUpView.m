//
//  PopUpView.m
//  RemembArt
//
//  Created by Roman Cheremin on 28/11/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

#import "PopUpView.h"
#import <UIKit/UIKit.h>

@interface PopUpView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *myImage;

@end

@implementation PopUpView


- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage*)image
{
    
    self = [super initWithFrame:frame];
    if (self) {
        _myImage = image;
        // Create translucent view to highlight the layer
        UIView *backgroundView = [[UIView alloc] initWithFrame:frame];
        backgroundView.alpha = 0.5;
        backgroundView.backgroundColor = [UIColor colorWithRed:0.72 green:0.63 blue:0.69 alpha:1.0];
        
        // Pop-Up window view
        UIView *windowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
        windowView.center = self.center;
        windowView.backgroundColor = [UIColor colorWithRed:0.93 green:0.90 blue:0.92 alpha:1.0];
        
        UIImageView *myView = [[UIImageView alloc] initWithFrame:CGRectMake(6,
                                                                            20,
                                                                            windowView.frame.size.width - 40,
                                                                            windowView.frame.size.height - 80)];
        myView.image = _myImage;
        myView.contentMode = UIViewContentModeScaleAspectFit;

        
        
        // Buttons setup
        UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(4,
                                                                        windowView.frame.size.height - 44,
                                                                        windowView.frame.size.width / 2 - 6,
                                                                        38)];
        [okButton setTitleColor:[UIColor colorWithRed:0.63 green:0.72 blue:0.69 alpha:1.0] forState:UIControlStateNormal];
        [okButton setTitle:@"OK" forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(okButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        
        
        // Add subviews to Pop-Up view
        //        [windowView addSubview:self.];
        [windowView addSubview:myView];
        [windowView addSubview:okButton];
        
        // Add subviews to the root view
        [self addSubview:backgroundView];
        [self addSubview:windowView];
    }
    return self;
}

- (void)makeViewVisible
{
    self.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished){
        self.alpha = 1;
    }];
}

/**
 When OK button is tapped, call delegate to create new task cell; close the view
 */
- (void)okButtonTapped
{
    //    [self.delegate taskDidCreatedWithTitle:self.titleText.text desc:self.descText.text];
    [self hideViewWithAnimation];
}

/**
 Remove the view without any data changes
 */
- (void)cancelButtonTapped
{
    [self hideViewWithAnimation];
    [self.delegate taskCreationDidCanceled];
}

/**
 Hide view with animation and remove from superview at the end
 */
- (void)hideViewWithAnimation
{
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

@end
