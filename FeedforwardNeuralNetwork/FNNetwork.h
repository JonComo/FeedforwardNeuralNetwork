//
//  FNNetwork.h
//  FeedforwardNeuralNetwork
//
//  Created by Jon Como on 11/2/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FNNeuron.h"

@interface FNNetwork : NSObject

@property (nonatomic, strong) NSMutableArray *layers;

+(void)transferWeightsFromNetwork:(FNNetwork *)network toNetwork:(FNNetwork *)receivingNetwork;

-(id)initWithLayers:(int)layerCount inputs:(NSArray *)inputs outputs:(NSArray *)outputs;

-(UIImage *)renderWithSize:(CGSize)size;

-(void)randomizeWeights;
-(void)randomizeWeightsAsGeneration;

@end