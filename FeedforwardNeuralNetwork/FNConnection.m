//
//  FNConnection.m
//  FeedforwardNeuralNetwork
//
//  Created by Jon Como on 11/2/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "FNConnection.h"

@implementation FNConnection

-(id)init
{
    if (self = [super init]) {
        //init
        [self randomWeight];
    }
    
    return self;
}

-(void)randomWeight
{
    _weight = (float)(arc4random()%200) / 100.0f - 1.0f;
}

@end