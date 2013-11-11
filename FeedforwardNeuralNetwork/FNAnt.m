//
//  FNAnt.m
//  FeedforwardNeuralNetwork
//
//  Created by Jon Como on 11/2/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "FNAnt.h"

#import "JCMath.h"

#import "FNAntScene.h"

#import "FNNetwork.h"

@implementation FNAnt
{
    FNNeuron *eyeLeft;
    FNNeuron *eyeRight;
    
    FNNeuron *outTurn;
    FNNeuron *outMove;
    
    SKSpriteNode *eye1sprite;
    SKSpriteNode *eye2sprite;
}

-(FNAnt *)copy
{
    FNAnt *copy = [[FNAnt alloc] initWithColor:self.color size:self.size];
    
    copy.position = self.position;
    copy.parentScene = self.parentScene;
    copy.target = self.target;
    
    copy.zRotation = M_PI_2;
    
    [FNNetwork transferWeightsFromNetwork:self.network toNetwork:copy.network];
    
    [copy.network randomizeWeightsAsGeneration];
    
    return copy;
}

-(id)initWithColor:(UIColor *)color size:(CGSize)size
{
    if (self = [super initWithColor:color size:size]) {
        //init
        
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
        self.physicsBody.mass = 5;
        self.physicsBody.angularDamping = 0.95;
        
        eyeLeft = [FNNeuron neuron];
        eyeRight = [FNNeuron neuron];
        
        outTurn = [FNNeuron neuronWithFire:^(float amplitude) {
            [self.physicsBody applyAngularImpulse:amplitude/100];
        }];
        
        outMove = [FNNeuron neuronWithFire:^(float amplitude) {
            CGPoint impulse = [JCMath pointFromPoint:CGPointMake(0, 0) pushedBy:5000 * amplitude inDirection:self.zRotation];
            [self.physicsBody applyForce:CGVectorMake(impulse.x, impulse.y)];
        }];
        
        _network = [[FNNetwork alloc] initWithLayers:4 inputs:@[eyeLeft, eyeRight] outputs:@[outTurn, outMove]];
        
        
//        eye1sprite = [[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:CGSizeMake(4, 4)];
//        eye2sprite = [[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:CGSizeMake(4, 4)];
    }
    
    return self;
}

-(void)update
{
    self.physicsBody.angularVelocity = self.physicsBody.angularVelocity * 0.9;
    self.physicsBody.velocity = CGVectorMake(self.physicsBody.velocity.dx * 0.95, self.physicsBody.velocity.dy * 0.95);
    
    [self perceiveTarget:self.target];
    
//    for (FNAnt *otherAnt in self.parentScene.ants)
//    {
//        if (otherAnt == self) continue;
//        
//        [self perceiveTarget:otherAnt];
//    }
}

-(void)perceiveTarget:(SKSpriteNode *)target
{
    if (!target) return;
    
//    float desiredAngle = [JCMath angleFromPoint:self.position toPoint:target.position];
//    
//    float turn = [JCMath turnAngle:self.zRotation towardsDesiredAngle:desiredAngle];
    
    CGPoint eye1 = [JCMath pointFromPoint:self.position pushedBy:15 inDirection:(self.zRotation * 180/M_PI - 35) * M_PI/180];
    CGPoint eye2 = [JCMath pointFromPoint:self.position pushedBy:15 inDirection:(self.zRotation * 180/M_PI + 35) * M_PI/180];
    
//    if (self.parent)
//    {
//        if (!eye1sprite.parent) [self.parent addChild:eye1sprite];
//        if (!eye2sprite.parent) [self.parent addChild:eye2sprite];
//    }
//    eye1sprite.position = eye1;
//    eye2sprite.position = eye2;
    
    float eye1dist = [JCMath distanceBetweenPoint:eye1 andPoint:target.position sorting:NO];
    float eye2dist = [JCMath distanceBetweenPoint:eye2 andPoint:target.position sorting:NO];
    //self.zRotation += turn/20;
    
    if (eye1dist > eye2dist){
        [eyeLeft receiveImpulse:0.1];
    }else{
        [eyeRight receiveImpulse:0.1];
    }
}

-(void)randomizeWeights
{
    [self.network randomizeWeights];
}

@end
