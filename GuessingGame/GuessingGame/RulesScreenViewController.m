//
//  GuessingScreenViewControll.m
//  GuessingGame
//
//  Created by Bryan on 10/11/16.
//  Copyright © 2016 bryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RulesScreenViewController.h"

@implementation RulesScreenViewController

-(id)init{
    self = [super init];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    NSLog(@"Dealloc called Rules View Controller");
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    NSLog(@"Segue");
}

@end