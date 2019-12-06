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

/**
 Calls to create new task
 
 @param title task title
 @param desc task description
 */
- (void)taskDidCreatedWithTitle: (NSString *)title desc: (NSString *)desc;

/**
 Calls when view is removed without task creation
 */
- (void)taskCreationDidCanceled;

@end
