//
//  FNAntScene.h
//  FeedforwardNeuralNetwork
//
//  Created by Jon Como on 11/2/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface FNAntScene : SKScene

@property (nonatomic, strong) NSMutableArray *ants;

-(void)randomizeWeights;
-(void)clear;

@end
