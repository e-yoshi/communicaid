//
//  XYZDetailViewController.h
//  Communicaid
//
//  Created by Yoshi on 9/28/13.
//  Copyright (c) 2013 Yoshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYZDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
