//
//  BLCViewController.m
//  Alcolator
//
//  Created by Douglas Hewitt on 3/9/15.
//  Copyright (c) 2015 Douglas Hewitt. All rights reserved.
//

#import "BLCViewController.h"

@interface BLCViewController () <UITextFieldDelegate>


@property (weak, nonatomic) UIButton *calculateButton;
@property (weak, nonatomic) UITapGestureRecognizer *hideKeyboardTapGestureRecognizer;


@end

@implementation BLCViewController

- (void)loadView {
    self.view = [[UIView alloc] init];
    UITextField *textField = [[UITextField alloc] init];
    UISlider *slider =  [[UISlider alloc] init];
    UILabel *label = [[UILabel alloc] init];
    UILabel *labelTwo = [[UILabel alloc] init];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    
    [self.view addSubview:textField];
    [self.view addSubview:slider];
    [self.view addSubview:label];
    [self.view addSubview:labelTwo];
    [self.view addSubview:button];
    [self.view addGestureRecognizer:tap];
    
    //like drawing the lines between object and property
    self.beerPercentTextField = textField;
    self.beerCountSlider = slider;
    self.resultLabel = label;
    self.beerNumberLabel = labelTwo;
    self.calculateButton = button;
    self.hideKeyboardTapGestureRecognizer = tap;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.beerPercentTextField.backgroundColor = [UIColor lightGrayColor];
    
    self.beerPercentTextField.delegate = self;
    
    self.beerPercentTextField.placeholder = NSLocalizedString(@"% Alcohol Content Per Beer", @"Beer percent placeholder text");
    
    [self.beerCountSlider addTarget:self action:@selector(sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    
    self.beerCountSlider.minimumValue = 1;
    self.beerCountSlider.maximumValue = 10;
    
    self.beerNumberLabel.numberOfLines = 0;
    
    [self.calculateButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.calculateButton setTitle:NSLocalizedString(@"Calculate!", @"Calculate command") forState:UIControlStateNormal];
    
    [self.hideKeyboardTapGestureRecognizer addTarget:self action:@selector(tapGestureDidFire:)];
    
    self.resultLabel.numberOfLines = 0;
}



- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat viewWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat padding = [[UIScreen mainScreen] bounds].size.width / 16;
    CGFloat itemWidth = viewWidth - padding - padding;
    CGFloat itemHeight = [[UIScreen mainScreen] bounds].size.height / 20;
    

    self.beerPercentTextField.frame = CGRectMake(padding, padding, itemWidth, itemHeight);
    
    CGFloat bottomOfTextField = CGRectGetMaxY(self.beerPercentTextField.frame);
    
    self.beerNumberLabel.frame = CGRectMake(padding, bottomOfTextField + padding, itemWidth, itemHeight);
    
    CGFloat bottomOfNumberLabel = CGRectGetMaxY(self.beerNumberLabel.frame);
    
    self.beerCountSlider.frame = CGRectMake(padding, bottomOfNumberLabel + padding, itemWidth, itemHeight);
    
    CGFloat bottomOfSlider = CGRectGetMaxY(self.beerCountSlider.frame);
    
    self.resultLabel.frame = CGRectMake(padding, bottomOfSlider + padding, itemWidth, itemHeight * 4);
    
    CGFloat bottomOfLabel = CGRectGetMaxY(self.resultLabel.frame);
    
    self.calculateButton.frame = CGRectMake(padding, bottomOfLabel + padding, itemWidth, itemHeight);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textFieldDidChange:(UITextField *)sender {
    //Make sure text is a number
    NSString *enteredText = sender.text;
    float enteredNumber = [enteredText floatValue];
    
    if (enteredNumber == 0) {
        //the user typed 0 or something that's not a number, so clear the field
        sender.text = nil;
    }
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
    
    [self calculateWine];
    
    [self.beerPercentTextField resignFirstResponder];
}

- (void)buttonPressed:(UIButton *)sender {
    [self.beerPercentTextField resignFirstResponder];
    [self calculateWine];
}
- (void)tapGestureDidFire:(UITapGestureRecognizer *)sender {
    [self.beerPercentTextField resignFirstResponder];
}

-(void)calculateWine {
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
    
    // generate the result text and display it on the
    
    NSString *resultText = [NSString stringWithFormat:NSLocalizedString(@"%d %@ contains as much alcohol as if %.1f %@ of wine.", nil), numberOfBeers, beerText, numberOfWineGlassesForEquivalentAlcoholAmount, wineText];
    self.resultLabel.text = resultText;
}

@end
