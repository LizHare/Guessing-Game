//
//  ResultsScreenViewController.m
//  GuessingGame
//
//  Created by Bryan on 10/16/16.
//  Copyright © 2016 bryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultsScreenViewController.h"
#import <CoreData/CoreData.h>
@interface ResultsScreenViewController()
{
}
@end

@implementation ResultsScreenViewController

-(id)init{
    self = [super init];
    
    return self;
}
- (void)viewDidLoad {
    _scoreLabel.text = [NSString stringWithFormat:@"Score: %u",_score ];
    _gameMessageLabel.text = _gameMessage;
    _previousHighScoreLabel.text = [NSString stringWithFormat:@"High Score: %@",[self getHighScoreOrNewHighScoreString]];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) dealloc
{
    NSLog(@"Dealloc called Results Screen View Controller");
}

-(NSString*)getHighScoreOrNewHighScoreString
{
    NSMutableString* highScore = [[NSMutableString alloc] init];
    
    NSManagedObjectContext* managedObjectContext = [self managedObjectContext];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Score"];
    NSArray* highScoreArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    //if there is no previous high score.
    if([highScoreArray count] == 0)
    {
        NSManagedObject* newScore = [NSEntityDescription insertNewObjectForEntityForName:@"Score"
                                                                    inManagedObjectContext:managedObjectContext];
        
        [newScore setValue:[NSString stringWithFormat:@"%u",_score] forKey:@"highScore"];
        NSError *error = nil;
        // Save the object to persistent store
        if (![managedObjectContext save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        highScore = [NSMutableString stringWithFormat:@"%u",_score];
        return highScore;
    }
    //There is a previous highscore evaluate if it is higher than ours
    else{
        NSManagedObject* mo = [highScoreArray objectAtIndex:0];
        highScore = [mo valueForKey:@"highScore"];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterBehaviorDefault;
        NSNumber *highScoreNumber = [f numberFromString:highScore];
        
        //If high score is less than ours save ours and return our new score
        if(highScoreNumber.integerValue < _score )
        {
            [[highScoreArray objectAtIndex:0] setValue:[NSString stringWithFormat:@"%u", _score] forKey:@"highScore"];
            NSError *error = nil;
            // Save the object to persistent store
            if (![managedObjectContext save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
            return [NSString stringWithFormat:@"%u", _score];
        }
        else{
            //return the old high score
            return highScore;
        }
    }
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end