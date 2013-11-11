//
//  FNCreateViewController.m
//  FeedforwardNeuralNetwork
//
//  Created by Jon Como on 11/2/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "FNCreateViewController.h"

#import "FNAntScene.h"

@interface FNCreateViewController ()
{
    __weak IBOutlet SKView *skView;
    SKScene *currentScene;
}

@end

@implementation FNCreateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    currentScene = [FNAntScene sceneWithSize:skView.bounds.size];
    
    [skView presentScene:currentScene];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)randomizeWeights:(id)sender
{
    FNAntScene *antScene = (FNAntScene *)currentScene;
    [antScene randomizeWeights];
}

@end
