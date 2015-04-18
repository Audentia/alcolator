//
//  BLCWhiskeyViewController.m
//  Alcolator
//
//  Created by Douglas Hewitt on 4/14/15.
//  Copyright (c) 2015 Douglas Hewitt. All rights reserved.
//

#import "BLCWhiskeyViewController.h"

@interface BLCWhiskeyViewController ()

@end

@implementation BLCWhiskeyViewController

- (instancetype) init {
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Whiskey", nil);
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.992 green:0.992 blue:0.588 alpha:1];
}

- (void)sliderValueDidChange:(UISlider *)sender {
    NSLog(@"Slider value changed to %f", sender.value);
    int slideValue = (int) sender.value;
    NSInteger numBeers = slideValue;
    
    NSString *beerText;
    if (numBeers == 1) {
        beerText = NSLocalizedString(@"Beer", @"singular beer");
    } else {
        beerText = NSLocalizedString(@"Beers", @"plural of beer");
    }
    
    NSString *stringBeers = [NSString stringWithFormat:@"%ld %@", (long)numBeers, beerText];
    self.beerNumberLabel.text = stringBeers;
    
    [self calculateWhiskey];
    
    [self.beerPercentTextField resignFirstResponder];
    [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%d", (int) sender.value]];

}

-(void)buttonPressed:(UIButton *)sender {
    [self.beerPercentTextField resignFirstResponder];
    [self calculateWhiskey];
}

-(void)calculateWhiskey {
    //first calculate how much alcohol is in all those beers...
    
    int numberOfBeers = self.beerCountSlider.value;
    int ouncesInOneBeerGlass = 12; //assume they are 12oz beer bottles
    
    float alcoholPercentageOfBeer = [self.beerPercentTextField.text floatValue] / 100;
    float ouncesOfAlcoholPerBeer = ouncesInOneBeerGlass * alcoholPercentageOfBeer;
    float ouncesOfAlchoholTotal = ouncesOfAlcoholPerBeer * numberOfBeers;
    
    //now calculate equivalent amount of whiskey
    float ouncesInOneWhiskeyGlass = 1; //Whiskey glass usually 1oz
    float alcoholPercentageOfWhiskey = 0.4; //40% is average
    
    float ouncesOfAlcoholPerWhiskeyGlass = ouncesInOneWhiskeyGlass * alcoholPercentageOfWhiskey;
    float numberOfWhiskeyGlassesForEquivalentAlcoholAmount = ouncesOfAlchoholTotal / ouncesOfAlcoholPerWhiskeyGlass;
    
    // decide whether to use beer/beers and glass/glasses
    
    NSString *beerText;
    if (numberOfBeers == 1) {
        beerText = NSLocalizedString(@"beer", @"singular beer");
    } else {
        beerText = NSLocalizedString(@"beers", @"plural of beer");
    }
    
    NSString *whiskeyText;
    
    if (numberOfWhiskeyGlassesForEquivalentAlcoholAmount == 1) {
        whiskeyText = NSLocalizedString(@"shot", @"singular shot");
    } else {
        whiskeyText = NSLocalizedString(@"shots", @"plural of shot");
    }
    
    // generate the result text and display it on the
    
    NSString *resultText = [NSString stringWithFormat:NSLocalizedString(@"%d %@ contains as much alcohol as if %.1f %@ of whiskey.", nil), numberOfBeers, beerText, numberOfWhiskeyGlassesForEquivalentAlcoholAmount, whiskeyText];
    self.resultLabel.text = resultText;
}


@end
