//
//  ViewController.m
//  Alcolator
//
//  Created by Douglas Hewitt on 3/9/15.
//  Copyright (c) 2015 Douglas Hewitt. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *beerPercentTextField;
@property (weak, nonatomic) IBOutlet UISlider *beerCountSlider;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *beerNumberLabel;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)textFieldDidChange:(UITextField *)sender {
    //Make sure text is a number
    NSString *enteredText = sender.text;
    float enteredNumber = [enteredText floatValue];
    
    if (enteredNumber == 0) {
        //the user typed 0 or something that's not a number, so clear the field
        sender.text = nil;
    }
}
- (IBAction)sliderValueDidChange:(UISlider *)sender {
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
    
    [self calculate];
    
    [self.beerPercentTextField resignFirstResponder];
}

- (IBAction)buttonPressed:(UIButton *)sender {
    [self.beerPercentTextField resignFirstResponder];
    [self calculate];
}
- (IBAction)tapGestureDidFire:(UITapGestureRecognizer *)sender {
    [self.beerPercentTextField resignFirstResponder];
}

-(void)calculate
{
    //first calculate how much alcohol is in all those beers...
    
    int numberOfBeers = self.beerCountSlider.value;
    int ouncesInOneBeerGlass = 12; //assume they are 12oz beer bottles
    
    float alcoholPercentageOfBeer = [self.beerPercentTextField.text floatValue] / 100;
    float ouncesOfAlcoholPerBeer = ouncesInOneBeerGlass * alcoholPercentageOfBeer;
    float ouncesOfAlchoholTotal = ouncesOfAlcoholPerBeer * numberOfBeers;
    
    //now calculate equivalent amount of wine
    float ouncesInOneWineGlass = 5; //wine glass usually 5oz
    float alcoholPercentageOfWine = 0.13; //13% is average
    
    float ouncesOfAlcoholPerWineGlass = ouncesInOneWineGlass *alcoholPercentageOfWine;
    float numberOfWineGlassesForEquivalentAlcoholAmount = ouncesOfAlchoholTotal / ouncesOfAlcoholPerWineGlass;
    
    // decide whether to use beer/beers and glass/glasses
    
    NSString *beerText;
    if (numberOfBeers == 1) {
        beerText = NSLocalizedString(@"beer", @"singular beer");
    } else {
        beerText = NSLocalizedString(@"beers", @"plural of beer");
    }
    
    NSString *wineText;
    
    if (numberOfWineGlassesForEquivalentAlcoholAmount == 1) {
        wineText = NSLocalizedString(@"glass", @"singular glass");
    } else {
        wineText = NSLocalizedString(@"glasses", @"plural of glass");
    }
    
    // generate the result text and display it on the label
    
    NSString *resultText = [NSString stringWithFormat:NSLocalizedString(@"%d %@ contains as much alcohol as if %.1f %@ of wine.", nil), numberOfBeers, beerText, numberOfWineGlassesForEquivalentAlcoholAmount, wineText];
    self.resultLabel.text = resultText;
}

@end
