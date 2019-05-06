//
//  ViewController.m
//  GuessingGame
//
//  Created by Liz on 10/11/16.
//  Copyright © 2016 Liz. All rights reserved.
//

#import "GuessingGameViewController.h"
#import "Product.h"
#import "stdlib.h"
#import "ResultsScreenViewController.h"

#define PRODUCT_URL @"http://www.wayfair.com/v/category/display?category_id=419247&_format=json"

@interface GuessingGameViewController ()
{
    uint score;
    uint potentialScore;
    double timeLeft;
    BOOL jsonLoaded;
    NSTimer* gameTimer;
    NSMutableSet* alreadyGuessed;
    NSMutableSet* skuSet;
    NSArray* gameObjects;
    NSString* correctPrice;
    BOOL allGuessed;
}
@end

@implementation GuessingGameViewController

- (void)viewDidLoad {
    jsonLoaded = NO;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    //Set our values to default
    score = 0;
    timeLeft = 30.0;
    self.scoreLabel.text = @"Score: 0";
    self.gameStatusLabel.text = @"";
    alreadyGuessed = [[NSMutableSet alloc] init];
    
    //See if we have already downlaoded the game data.
    NSManagedObjectContext* managedObjectContext = [self managedObjectContext];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Product"];
    gameObjects = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    if([gameObjects count] != 0)
    {
        self.scoreLabel.text = @"Score: 0";
        [self setupGameBoard];
        jsonLoaded = NO;
    }
    else{
        skuSet = [[NSMutableSet alloc] init];
        [self hideUIWhileLoadingData ];
        jsonLoaded = NO;
        self.gameStatusLabel.text = @"Loading Game Objects";
        
        //Magic Number for objects to load. I opted just for one product type given the time limit it made sense to
        NSURLSession* s = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURL* url = [[NSURL alloc] initWithString:PRODUCT_URL];
        NSURLSessionDataTask*  task = [s dataTaskWithURL:url completionHandler:^void(NSData *data, NSURLResponse *response, NSError *error){
            [self parseJSON:data];
        }];
        
        [task resume];
    }
    [super viewWillAppear:animated];
}

-(void) hideUIWhileLoadingData
{
    _productNameLabel.hidden = YES;
    _scoreLabel.hidden = YES;
    _timerLabel.hidden = YES;
    
    _priceButton1.hidden = YES;
    _priceButton2.hidden = YES;
    _priceButton3.hidden = YES;
    _priceButton4.hidden = YES;
    _resetButton.hidden = YES;
    _backToRules.hidden = YES;
    _productImageView.hidden = YES;
}

-(void) unhideUI
{
    _productNameLabel.hidden = NO;
    _scoreLabel.hidden = NO;
    _timerLabel.hidden = NO;
    _priceButton1.hidden = NO;
    _priceButton2.hidden = NO;
    _priceButton3.hidden = NO;
    _priceButton4.hidden = NO;
    _resetButton.hidden = NO;
    _productImageView.hidden = NO;
    _backToRules.hidden = NO;
}


//Processing
-(void)parseJSON:(NSData*)data
{
    NSError *e = nil;
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];

    NSDictionary* productDict = [[[jsonArray objectForKey:@"product_grid_component"] objectForKey:@"modelData"] objectForKey:@"product_block_collection"];
    
    NSMutableArray* guessingObjects = [[NSMutableArray alloc] init];
    
    for(NSDictionary* d in productDict)
    {
        NSManagedObjectContext* moc = [self managedObjectContext];
        if([self isValid:d] && ![skuSet containsObject:[d objectForKey:@"sku"]])
        {
            /*·         
             I had to deviate from the instructions here:
             For each product in the product_collection, sale_price is the correct sale price and image_url is the URL for the product image you should display.
             
             I used product_grid_component/modelData/product_block_collection because product_collection didn't exist.
             
             Below I use minimum_displayed_price instead of sale_price, because it also isn't in the json.
             */
            Product* o = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:moc];
            o.productName = [d objectForKey:@"name"];
            o.manufacturerName = [d objectForKey:@"manufacturer_name"];
            o.price = [NSString stringWithFormat:@"%@", [[d objectForKey:@"price_block_wrapper"] objectForKey: @"minimum_displayed_price"]];
            o.imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[d objectForKey:@"image_url"]]];
            o.sku = [d objectForKey:@"sku"];
            
            [skuSet addObject:o.sku];
            [guessingObjects addObject:o];
            NSError *error = nil;
            // Save the object to persistent store
            if (![moc save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
        }
    }
    

    gameObjects = guessingObjects;
    jsonLoaded = YES;
    dispatch_async(dispatch_get_main_queue(),^{[self unhideUI];self.gameStatusLabel.text = @"Game Objects Loaded";[self setupGameBoard];});
}

-(BOOL) isValid:(NSDictionary*)d
{
    //Validating data to cofirmin the data set is playable.
    if([[d objectForKey:@"manufacturer_name"] length] == 0 || [[d objectForKey:@"name"] length] == 0 || [NSString stringWithFormat:@"%@", [[d objectForKey:@"price_block_wrapper"] objectForKey: @"minimum_displayed_price"]] == 0)
    {
        return false;
    }
    
    if([[NSString stringWithFormat:@"%@", [[d objectForKey:@"price_block_wrapper"] objectForKey: @"minimum_displayed_price"]]  isEqual: @"RESTRICTED"])
    {
        return false;
    }
    
    
    return true;
}

-(void) setupGameBoard
{
    if(timeLeft == 30.0f )
    {
        gameTimer  = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    
    
    potentialScore = 4;
    int i = arc4random_uniform([gameObjects count]);
    
    if([alreadyGuessed count] == [gameObjects count])
    {
        [gameTimer invalidate];
        allGuessed = YES;
        [self performSegueWithIdentifier:@"segueToResults" sender:self];
        return;
    }
    
    if([alreadyGuessed count] != 0)
    {
        while([alreadyGuessed containsObject:[NSNumber numberWithInt:i]])
        {
            i = arc4random_uniform([gameObjects count]);
        }
    }
    
    
    [alreadyGuessed addObject:[NSNumber numberWithInt:i]];
    Product* objectToGuess = [gameObjects objectAtIndex:i];
    [self.productImageView setImage:[[UIImage alloc] initWithData:objectToGuess.imageData]];
    
    
    self.productNameLabel.text = [NSString stringWithFormat:@"%@ %@",objectToGuess.manufacturerName, objectToGuess.productName];
    
    //Format the number to avoid long decimals.
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:objectToGuess.price];
    
    NSMutableArray* m = [[NSMutableArray alloc] init];
    
    [m addObject:myNumber];
    [m addObject:@([myNumber floatValue] * (arc4random_uniform(200)/100.0f))];
    [m addObject:@([myNumber floatValue] * (arc4random_uniform(200)/100.0f))];
    [m addObject:@([myNumber floatValue] * (arc4random_uniform(200)/100.0f))];
    
    NSMutableArray* priceArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < [m count]; )
    {
        int toPick =arc4random_uniform([m count]);
        [priceArray addObject:[m objectAtIndex:toPick]];
        [m removeObjectAtIndex:toPick];
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    NSString* price1 = [formatter stringFromNumber:[priceArray objectAtIndex:0]];
    NSString* price2 = [formatter stringFromNumber:[priceArray objectAtIndex:1]];
    NSString* price3 = [formatter stringFromNumber:[priceArray objectAtIndex:2]];
    NSString* price4 = [formatter stringFromNumber:[priceArray objectAtIndex:3]];
    
    [self.priceButton1 setTitle:price1 forState:UIControlStateNormal];
    [self.priceButton2 setTitle:price2 forState:UIControlStateNormal];
    [self.priceButton3 setTitle:price3 forState:UIControlStateNormal];
    [self.priceButton4 setTitle:price4 forState:UIControlStateNormal];
    
    correctPrice = [formatter stringFromNumber:myNumber];
}

//Actions
-(IBAction)guessValue:(id)sender
{
    UIButton* buttonRef = sender;
    NSLog(@"%@ == %@", buttonRef.titleLabel.text, correctPrice);
    if([buttonRef.titleLabel.text isEqualToString:correctPrice])
    {
        self.gameStatusLabel.text = [NSString stringWithFormat:@"Correct! +%u points!", potentialScore];
        score += potentialScore;
        _scoreLabel.text = [NSString stringWithFormat:@"Score: %u", score];
        [self setupGameBoard];
    }
    else
    {
        if(potentialScore>0)
        {
            --potentialScore;
        }
        self.gameStatusLabel.text = @"incorrect!";
    }
}

-(IBAction) endGame:(id)sender
{
    [gameTimer invalidate];
    [self performSegueWithIdentifier:@"segueToResults" sender:self];
}


-(void) viewWillDisappear:(BOOL)animated
{
    [gameTimer invalidate];
    gameTimer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    NSLog(@"Dealloc called Guessing Game View Controller");
}


//Segue Methods
- (void)countDown
{
    timeLeft -= 0.01;
    
    dispatch_async(dispatch_get_main_queue(),^{
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMaximumFractionDigits:2];
        [formatter setRoundingMode: NSNumberFormatterRoundUp];
        NSNumber* n = [NSNumber numberWithDouble:timeLeft];
        
        self.timerLabel.text = [NSString stringWithFormat:@"Time Left: %@",[formatter stringFromNumber:n]];
    });
    
    if(timeLeft <= 0.0f)
    {
        [gameTimer invalidate];
        [self performSegueWithIdentifier:@"segueToResults" sender:self];
    }
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    NSLog(@"Segue");
}

- (BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    
    ResultsScreenViewController* rsvc;
    if([fromViewController isKindOfClass:[ResultsScreenViewController class]])
    {
        //Safe given we can only enter if this is already true.
        rsvc = fromViewController;

        if (rsvc.playAgainButton == sender) {
            
            return YES;
            
        }
        if(rsvc.rulesScreenButton == sender)
        {
            return NO;
        }
    }

    
    return NO;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"segueToResults"])
    {
        ResultsScreenViewController* rsvc = segue.destinationViewController;
        
        if(allGuessed)
        {
            rsvc.gameMessage = @"All Objects Guessed! Well done!";
        }
        else{
            rsvc.gameMessage = @"You finished! Well done!";
        }
        rsvc.score = score;
    }
}

//Core Data Methods
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
