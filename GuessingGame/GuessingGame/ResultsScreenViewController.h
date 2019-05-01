//
//  ResultsScreenViewController.h
//  GuessingGame
//
//  Created by Bryan on 10/16/16.
//  Copyright © 2016 bryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsScreenViewController : UIViewController
{
    UIButton* _playAgainButton;
    UIButton* _rulesScreenButton;
    UILabel* _scoreLabel;
    UILabel* _gameMessageLabel;
    UILabel* _previousHighScoreLabel;
    uint _score;
    NSString* _gameMessage;
}

@property(nonatomic,retain) IBOutlet UILabel* previousHighScoreLabel;
@property(nonatomic,retain) IBOutlet UILabel* gameMessageLabel;
@property(nonatomic,retain) IBOutlet UILabel* scoreLabel;
@property(nonatomic,retain) IBOutlet UIButton* playAgainButton;
@property(nonatomic,retain) IBOutlet UIButton* rulesScreenButton;
@property(nonatomic) uint score;
@property(nonatomic,retain) NSString* gameMessage;

-(id)initWithScore:(uint)score;
-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue;

@end