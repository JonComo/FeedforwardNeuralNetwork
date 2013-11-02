//
//  FNConnection.h
//  FeedforwardNeuralNetwork
//
//  Created by Jon Como on 11/2/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNConnection : NSObject

@property float weight;

-(void)randomWeight;

@end
