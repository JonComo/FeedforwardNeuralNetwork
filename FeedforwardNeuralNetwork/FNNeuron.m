//
//  FNNeuron.m
//  FeedforwardNeuralNetwork
//
//  Created by Jon Como on 11/2/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "FNNeuron.h"

@implementation FNNeuron

+(FNNeuron *)neuronWithFire:(FireBlock)block
{
    FNNeuron *neuron = [FNNeuron neuron];
    neuron.fireBlock = block;
    
    return neuron;
}

+(FNNeuron *)neuron
{
    FNNeuron *newNeuron = [[self alloc] init];
    return newNeuron;
}


-(id)init
{
    if (self = [super init]) {
        //init
        _amplitude = 0;
        _children = [NSMutableArray array];
        _connections = [NSMutableArray array];
    }
    
    return self;
}

-(void)randomizeWeights
{
    for (FNConnection *connection in self.connections){
        [connection randomWeight];
    }
}

-(void)receiveImpulse:(float)impulse
{
    self.amplitude += impulse;
    
    if (self.amplitude > 1 || self.amplitude < -1)
    {
        [self fireWithAmplitude:self.amplitude];
        self.amplitude = 0;
    }
}

-(void)fireWithAmplitude:(float)amplitude
{
    if (self.fireBlock) self.fireBlock(amplitude);
    
    for (int i = 0; i<self.children.count; i++) {
        FNNeuron *child = self.children[i];
        FNConnection *connection = self.connections[i];
        
        [child receiveImpulse:amplitude * connection.weight];
    }
}

-(void)addChild:(FNNeuron *)child
{
    [self.children addObject:child];
    
    //create connnection for child
    FNConnection *connection = [[FNConnection alloc] init];
    
    [self.connections addObject:connection];
}

@end
