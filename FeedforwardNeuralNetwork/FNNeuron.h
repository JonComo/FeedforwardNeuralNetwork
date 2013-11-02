//
//  FNNeuron.h
//  FeedforwardNeuralNetwork
//
//  Created by Jon Como on 11/2/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FNConnection.h"

@interface FNNeuron : NSObject

@property CGPoint position;

@property float amplitude;

@property (nonatomic, strong) NSMutableArray *children;
@property (nonatomic, strong) NSMutableArray *connections;

+(FNNeuron *)neuron;

-(void)receiveImpulse:(float)impulse;

-(void)addChild:(FNNeuron *)child;

-(void)randomizeWeights;

@end