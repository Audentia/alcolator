//
//  BLCViewController.h
//  Alcolator
//
//  Created by Douglas Hewitt on 3/9/15.
//  Copyright (c) 2015 Douglas Hewitt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLCViewController : UIViewController

@property (weak, nonatomic) UITextField *beerPercentTextField;
@property (weak, nonatomic) UISlider *beerCountSlider;
@property (weak, nonatomic) UILabel *resultLabel;
@property (weak, nonatomic) UILabel *beerNumberLabel;

-(void)buttonPressed: (UIButton *)sender;
-(void)calculateWine;


@end

