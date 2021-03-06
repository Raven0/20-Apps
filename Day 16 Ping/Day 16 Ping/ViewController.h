//
//  ViewController.h
//  Day 16 Ping
//
//  Created by Grant Timmerman on 8/24/14.
//  Copyright (c) 2014 Grant Timmerman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) UITextField *websiteTextField;
@property (strong, nonatomic) UIButton *pingButton;
@property (strong, nonatomic) UILabel *pingLabel;

@end