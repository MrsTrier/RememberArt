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
@property (nonatomic, strong) NSArray *myType;
@property (nonatomic, strong) UITextField *gameName;
@property (nonatomic, strong) UITextField *gameDesc;


@end

@implementation PopUpView


- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage*)image andType:(NSArray*)type
{
    
    self = [super initWithFrame:frame];
    if (self) {
        _myImage = image;
        _myType = type;
        // Create translucent view to highlight the layer
        UITapGestureRecognizer* mytapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:mytapGestureRecognizer];
//        [self isUserInteractionEnabled true];
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:frame];
        backgroundView.alpha = 0.5;
        backgroundView.backgroundColor = [UIColor colorWithRed:0.72 green:0.63 blue:0.69 alpha:1.0];
        
        // Pop-Up window view
        UIView *windowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
        windowView.center = self.center;
        windowView.backgroundColor = [UIColor colorWithRed:0.93 green:0.90 blue:0.92 alpha:1.0];
        
        UIFont *font = [UIFont fontWithName:@"Copperplate-Bold" size:20];
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                  15,
                                                                  windowView.frame.size.width - 12,
                                                                  20)];
        
         self.gameName = [[UITextField alloc] initWithFrame:CGRectMake(6,
                                                                              40,
                                                                              windowView.frame.size.width - 12,
                                                                              20)];
        self.gameDesc = [[UITextField alloc] initWithFrame:CGRectMake(6,
                                                                             70,
                                                                             windowView.frame.size.width - 12,
                                                                              windowView.frame.size.height - 140)];
        
        _gameName.layer.cornerRadius = 15;
        _gameName.backgroundColor = UIColor.whiteColor;
        _gameName.textColor = [UIColor colorWithRed:0.02 green:0.03 blue:0.18 alpha:1.0];
        _gameName.textAlignment = NSTextAlignmentCenter;
        //        self.titleText.textAlignment = NSTextAlignmentLeft + 5;
        NSTextAlignment alignment = NSTextAlignmentCenter;
        NSMutableParagraphStyle* alignmentSetting = [[NSMutableParagraphStyle alloc] init];
        alignmentSetting.alignment = alignment;
        NSDictionary *attributes = @{NSParagraphStyleAttributeName : alignmentSetting};
        NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Game name" attributes: attributes];
        _gameName.attributedPlaceholder = str1;
        
        // Description field setup
        [_gameDesc setFont:_gameName.font];
        _gameDesc.textColor = [UIColor colorWithRed:0.02 green:0.03 blue:0.18 alpha:1.0];
        _gameDesc.textAlignment = NSTextAlignmentCenter;
        _gameDesc.backgroundColor = UIColor.whiteColor;
        _gameDesc.layer.cornerRadius = 15;
        alignmentSetting.alignment = alignment;
        NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"Game description" attributes: attributes];
        _gameDesc.attributedPlaceholder = str2;

        UIImageView *myView = [[UIImageView alloc] initWithFrame:CGRectMake(6,
                                                                            40,
                                                                            windowView.frame.size.width - 12,
                                                                            windowView.frame.size.height - 80)];
        myView.image = _myImage;
        myView.contentMode = UIViewContentModeScaleAspectFit;
        
        // Buttons setup
        UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(4,
                                                                        windowView.frame.size.height - 40,
                                                                        windowView.frame.size.width / 2 - 6,
                                                                        15)];
        [okButton setTitleColor:[UIColor colorWithRed:0.04 green:0.17 blue:0.44 alpha:1.0] forState:UIControlStateNormal];
        
        UIButton *noButton = [[UIButton alloc] initWithFrame:CGRectMake(windowView.frame.size.width - 200,
                                                                        windowView.frame.size.height - 40,
                                                                        windowView.frame.size.width / 2 - 6,
                                                                        15)];
        [noButton setTitleColor:[UIColor colorWithRed:0.04 green:0.17 blue:0.44 alpha:1.0] forState:UIControlStateNormal];
        
        if ([_myType[0]  isEqual: @"standart"])
        {
            lable.text = _myType[1];
            [lable setFont:font];
            lable.textColor = [UIColor colorWithRed:0.04 green:0.17 blue:0.44 alpha:1.0];
            [windowView addSubview:lable];
            [windowView addSubview:myView];

        }
        else if ([_myType[0]  isEqual: @"exit"])
        {
            lable.text = _myType[1];
            [lable setFont:font];
            lable.adjustsFontSizeToFitWidth = YES;
            lable.textColor = [UIColor colorWithRed:0.04 green:0.17 blue:0.44 alpha:1.0];
            
            [okButton setTitle:@"Yes" forState:UIControlStateNormal];
            okButton.titleLabel.font = font;
            [okButton addTarget:self action:@selector(shureButtonTapped) forControlEvents:UIControlEventTouchUpInside];
            
            [noButton setTitle:@"No" forState:UIControlStateNormal];
            noButton.titleLabel.font = font;
            [noButton addTarget:self action:@selector(continueButtonTapped) forControlEvents:UIControlEventTouchUpInside];

            [windowView addSubview:lable];
            [windowView addSubview:noButton];
            [windowView addSubview:okButton];
            [windowView addSubview:myView];
        }
        else if ([_myType[0]  isEqual: @"default"])
        {
            lable.text = _myType[1];
            [lable setFont:font];
            lable.textColor = [UIColor colorWithRed:0.04 green:0.17 blue:0.44 alpha:1.0];
            [windowView addSubview:myView];
            [windowView addSubview:lable];
        }
        else if ([_myType[0]  isEqual: @"ng"])
        {
            if ([_myType[1] isEqual: @"error"])
            {
                lable.text = _myType[2];
                [lable setFont:font];
                lable.numberOfLines = 0;
                lable.adjustsFontSizeToFitWidth = YES;
                [windowView addSubview:lable];
                [windowView addSubview:myView];
            }
            else
            {
                lable.text = _myType[1];
                [lable setFont:[UIFont fontWithName:@"Copperplate-Bold" size:20]];
                [okButton addTarget:self action:@selector(createGameTapped) forControlEvents:UIControlEventTouchUpInside];
                [okButton setTitle:@"Create" forState:UIControlStateNormal];
                okButton.titleLabel.font = font;

                [noButton addTarget:self action:@selector(continueButtonTapped) forControlEvents:UIControlEventTouchUpInside];
                [noButton setTitle:@"Cancel" forState:UIControlStateNormal];
                noButton.titleLabel.font = font;

                [windowView addSubview:noButton];
                [windowView addSubview:okButton];
                [windowView addSubview:_gameDesc];
                [windowView addSubview:_gameName];
                [windowView addSubview:lable];
            }
        }
        
        // Add subviews to the root view
        [self addSubview:backgroundView];
        [self addSubview:windowView];
    }
    return self;
}


- (void)handleTap:(UIGestureRecognizer*)recognizer
{
    [self hideViewWithAnimation];
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


- (void)continueButtonTapped
{
    [self hideViewWithAnimation];
}


- (void)createGameTapped
{
    [self.delegate userWantsCreateGameWithName:self.gameName.text desc:self.gameDesc.text];
    [self hideViewWithAnimation];
}


- (void)shureButtonTapped
{
    [self.delegate shureTapped];
    [self hideViewWithAnimation];
}

/**
 Remove the view without any data changes
 */
//- (void)cancelButtonTapped
//{
//    [self hideViewWithAnimation];
////    [self.delegate taskCreationDidCanceled];
//}

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
