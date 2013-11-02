//
//  FNCreateViewController.m
//  FeedforwardNeuralNetwork
//
//  Created by Jon Como on 11/2/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "FNCreateViewController.h"

#import "FNNetworkScene.h"

@interface FNCreateViewController ()
{
    SKScene *currentScene;
}

@end

@implementation FNCreateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    SKView *view = (SKView *)self.view;
    
    view.showsFPS = YES;
    view.showsNodeCount = YES;
    
    currentScene = [FNNetworkScene sceneWithSize:view.bounds.size];
    
    [view presentScene:currentScene];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
