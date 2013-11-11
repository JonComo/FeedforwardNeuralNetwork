//
//  FNNetworkScene.m
//  FeedforwardNeuralNetwork
//
//  Created by Jon Como on 11/2/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "FNNetworkScene.h"

#import "FNNetwork.h"

@implementation FNNetworkScene
{
    FNNetwork *network;
    SKSpriteNode *networkSprite;
    
    FNNeuron *inputL, *inputR;
    float value;
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        //init
        value = 0;
        
        inputL = [FNNeuron neuron];
        inputR = [FNNeuron neuron];
        
        network = [[FNNetwork alloc] initWithLayers:4 neuronsPerLayer:4 inputs:@[inputL, inputR] outputs:@[[FNNeuron neuron], [FNNeuron neuron]]];
        
        NSTimer *run;
        run = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(run) userInfo:nil repeats:YES];
        
        [self renderNetwork];
    }
    
    return self;
}

-(void)run
{
    if (value < 0){
        [inputR receiveImpulse:value];
        [inputL receiveImpulse:-value];
    }else{
        [inputR receiveImpulse:value];
        [inputL receiveImpulse:-value];
    }
    
    [self renderNetwork];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    
    value = (160 - location.x)/160;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [network randomizeWeights];
}

-(void)renderNetwork
{
    SKTexture *texture = [SKTexture textureWithCGImage:[network renderWithSize:CGSizeMake(200, 200)].CGImage];
    texture.filteringMode = SKTextureFilteringNearest;
    
    if (!networkSprite)
    {
        networkSprite = [[SKSpriteNode alloc] initWithTexture:texture];
        networkSprite.size = CGSizeMake(200, 200);
        networkSprite.position = CGPointMake(self.size.width/2, self.size.height/2);
        
        [self addChild:networkSprite];
    }
    
    networkSprite.texture = texture;
}

@end
