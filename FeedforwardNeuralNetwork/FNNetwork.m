//
//  FNNetwork.m
//  FeedforwardNeuralNetwork
//
//  Created by Jon Como on 11/2/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "FNNetwork.h"

@implementation FNNetwork
{
    NSTimer *timerLoop;
}

-(id)initWithLayers:(int)layerCount inputs:(NSArray *)inputs outputs:(NSArray *)outputs
{
    //Create layers
    
    if (self = [super init])
    {
        _layers = [NSMutableArray array];
        
        timerLoop = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(run) userInfo:nil repeats:YES];
        
        
        for (int i = 0; i<layerCount; i++) {
            
            NSArray *layer;
            
            if (i == 0)
            {
                //input layer
                layer = inputs;
            }else if (i == layerCount-1)
            {
                //output layer
                layer = outputs;
            }else{
                //middle layer
                layer = [self layerWithNumNeurons:4];
            }
            
            [self.layers addObject:layer];
        }
        
        //Connect neurons in layers
        for (int i = 0; i<layerCount-1; i++) {
            NSMutableArray *topLayer = self.layers[i];
            NSMutableArray *bottomLayer = self.layers[i+1];
            
            for (FNNeuron *topNeuron in topLayer)
            {
                for (FNNeuron *bottomNeuron in bottomLayer){
                    [topNeuron addChild:bottomNeuron];
                }
            }
        }
    }
    
    return self;
}

-(void)randomizeWeights
{
    for (NSMutableArray *layer in self.layers)
    {
        for (FNNeuron *neuron in layer)
        {
            [neuron randomizeWeights];
        }
    }
}

-(void)run
{
    
}

-(void)receiveInput:(float)input
{
    //inputNeuron
    FNNeuron *inputNeuron = self.layers[0][0];
    
    [inputNeuron receiveImpulse:input];
}

-(NSArray *)layerWithNumNeurons:(int)numNeurons
{
    NSMutableArray *newLayer = [NSMutableArray array];
    
    for (int i = 0; i<numNeurons; i++) {
        FNNeuron *neuron = [[FNNeuron alloc] init];
        
        [newLayer addObject:neuron];
    }
    
    return newLayer;
}

-(UIImage *)renderWithSize:(CGSize)size
{
    CGSize neuronSize = CGSizeMake(20, 20);
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    float yOffset = 20;
    
    float ySpread = size.height / self.layers.count;
    
    //place neurons
    
    for (NSMutableArray *layer in self.layers)
    {
        float xSpread = size.width / layer.count;
        float xOffset = 20;
        
        for (int i = 0; i<layer.count; i++)
        {
            FNNeuron *neuron = layer[i];
            
            neuron.position = CGPointMake(xOffset, yOffset);
            
            xOffset += xSpread;
        }
        
        yOffset += ySpread;
    }
    
    //render connections
    
    for (NSMutableArray *layer in self.layers)
    {
        for (FNNeuron *neuron in layer)
        {
            for (int i = 0; i<neuron.children.count; i++)
            {
                FNNeuron *child = neuron.children[i];
                FNConnection *connection = neuron.connections[i];
                
                float dashLengths[] = {3, 3};
                
                if (connection.weight > 0)
                {
                    CGContextSetLineDash(context, 0, dashLengths, 0);
                }else{
                    CGContextSetLineDash(context, 0, dashLengths, 2);
                }
                
                if (neuron.amplitude > 0)
                {
                    [[UIColor colorWithRed:0 green:neuron.amplitude blue:0 alpha:1] setStroke];
                }else{
                    [[UIColor colorWithRed:-neuron.amplitude green:0 blue:0 alpha:1] setStroke];
                }
                
                UIBezierPath *path = [[UIBezierPath alloc] init];
                path.lineWidth = 2;
                [path moveToPoint:neuron.position];
                [path addLineToPoint:child.position];
                [path stroke];
            }
        }
    }
    
    //render neurons
    
    for (NSMutableArray *layer in self.layers)
    {
        for (FNNeuron *neuron in layer)
        {
            if (neuron.amplitude > 0)
            {
                [[UIColor colorWithRed:0 green:neuron.amplitude blue:0 alpha:1] setFill];
            }else{
                [[UIColor colorWithRed:-neuron.amplitude green:0 blue:0 alpha:1] setFill];
            }
            
            CGContextFillEllipseInRect(context, CGRectMake(neuron.position.x - neuronSize.width/2, neuron.position.y - neuronSize.height/2, neuronSize.width, neuronSize.height));
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    return image;
}

@end
