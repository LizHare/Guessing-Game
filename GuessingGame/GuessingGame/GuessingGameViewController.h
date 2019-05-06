//
//  ViewController.h
//  GuessingGame
//
//  Created by Liz on 10/11/16.
//  Copyright © 2016 Liz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface GuessingGameViewController : UIViewController
{

    UILabel* _gameStatusLabel;
    UILabel* _productNameLabel;
    UILabel* _scoreLabel;
    UILabel* _timerLabel;
    UIButton* _priceButton1;
    UIButton* _priceButton2;
    UIButton* _priceButton3;
    UIButton* _priceButton4;
    UIButton* _resetButton;
    UIImageView* _productImageView;
    UIButton* _backToRules;
}

@property(nonatomic,retain) IBOutlet UILabel* timerLabel;
@property(nonatomic,retain) IBOutlet UILabel* gameStatusLabel;
@property(nonatomic,retain) IBOutlet UILabel* scoreLabel;
@property(nonatomic,retain) IBOutlet UILabel* productNameLabel;
@property(nonatomic,retain) IBOutlet UIButton* backToRules;
@property(nonatomic,retain) IBOutlet UIButton* priceButton1;
@property(nonatomic,retain) IBOutlet UIButton* priceButton2;
@property(nonatomic,retain) IBOutlet UIButton* priceButton3;
@property(nonatomic,retain) IBOutlet UIButton* priceButton4;
@property(nonatomic,retain) IBOutlet UIButton* resetButton;
@property(nonatomic,retain) IBOutlet UIImageView* productImageView;

-(void) setupGameBoard;
-(IBAction) guessValue:(id)sender;
-(IBAction) endGame:(id)sender;
-(IBAction) prepareForUnwind:(UIStoryboardSegue *)segue;

@end

