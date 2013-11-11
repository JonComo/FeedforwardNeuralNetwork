//
//  FNAnt.h
//  FeedforwardNeuralNetwork
//
//  Created by Jon Como on 11/2/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "FNNetwork.h"

@class FNAntScene;

@interface FNAnt : SKSpriteNode

@property (nonatomic, weak) FNAntScene *parentScene;
@property (nonatomic, strong) FNNetwork *network;

@property (nonatomic, weak) SKSpriteNode *target;

-(FNAnt *)copy;

-(void)update;
-(void)randomizeWeights;

@end
