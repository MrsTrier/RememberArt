//
//  PopUpView.h
//  RemembArt
//
//  Created by Roman Cheremin on 28/11/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopUpViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Task creation view (Pop-Up view) implementation
 */
@interface PopUpView : UIView

@property (nonatomic, weak) id<PopUpViewProtocol> delegate;

/**
 Shows Pop-Up view
 */
- (void) makeViewVisible;


- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage*)image andType:(NSArray*)type;
@end

NS_ASSUME_NONNULL_END
