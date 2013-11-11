//
//  FNNeuron.h
//  FeedforwardNeuralNetwork
//
//  Created by Jon Como on 11/2/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FNConnection.h"

typedef void (^FireBlock)(float amplitude);

@interface FNNeuron : NSObject

@property (nonatomic, strong) FireBlock fireBlock;
@property CGPoint position;
@property float amplitude;

@property (nonatomic, strong) NSMutableArray *children;
@property (nonatomic, strong) NSMutableArray *connections;

+(FNNeuron *)neuron;
+(FNNeuron *)neuronWithFire:(FireBlock)block;

-(void)receiveImpulse:(float)impulse;

-(void)addChild:(FNNeuron *)child;

-(void)randomizeWeights;

@end