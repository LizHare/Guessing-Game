//
//  GuessingScreenViewController.h
//  GuessingGame
//
//  Created by Bryan on 10/11/16.
//  Copyright © 2016 bryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RulesScreenViewController : UIViewController
{
    UILabel* _rulesLabel;
    UIButton* _startButton;
}

@property(nonatomic,retain) IBOutlet UILabel* rulesLabel;
@property(nonatomic,retain) IBOutlet UIButton* startButton;
-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue;
@end
