//
//  PopUpViewProtocol.h
//  RemembArt
//
//  Created by Roman Cheremin on 28/11/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

#import "UIKit/UIKit.h"

/**
 Describes task creation view interaction with VC
 */
@protocol PopUpViewProtocol <NSObject>


@optional
- (void)userWantsCreateGameWithName: (NSString *)name desc: (NSString *)desc;

/**
 Calls to create new task
 
 @param title task title
 @param desc task description
 */
@optional
- (void)shureTapped;

/**
 Calls when view is removed without task creation
 */
@optional
- (void)gameCreationDidCanceled;

@end
