//
//  FNAntScene.h
//  FeedforwardNeuralNetwork
//
//  Created by Jon Como on 11/2/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

static const uint32_t wallCategory = 0x1 << 1;

@interface FNAntScene : SKScene

@property (nonatomic, strong) NSMutableArray *ants;

-(void)randomizeWeights;
-(void)nextGeneration;
-(void)clear;

@end
