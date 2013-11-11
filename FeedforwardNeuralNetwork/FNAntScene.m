//
//  FNAntScene.m
//  FeedforwardNeuralNetwork
//
//  Created by Jon Como on 11/2/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "FNAntScene.h"

#import "FNAnt.h"

#import "JCMath.h"

@implementation FNAntScene
{
    FNAnt *antDragging;
    FNAnt *lastSelected;
    
    BOOL didDrag;
    BOOL didCreateNew;
    
    SKSpriteNode *networkRender;
    
    SKSpriteNode *target;
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        //init
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        
        self.backgroundColor = [UIColor whiteColor];
        _ants = [NSMutableArray array];
        
        networkRender = [[SKSpriteNode alloc] initWithColor:[UIColor orangeColor] size:CGSizeMake(100, 100)];
        networkRender.position = CGPointMake(50, 50);
        [self addChild:networkRender];
        
        target = [[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:CGSizeMake(40, 40)];
        
        target.position = CGPointMake(size.width/2, size.height/2);
        
        [self addChild:target];
        
        NSTimer *waveTimer;
        waveTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(nextWave) userInfo:nil repeats:YES];
        
        [self spawnAntsCount:30 position:[self randomSpawnPoint]];
    }
    
    return self;
}

-(CGPoint)randomSpawnPoint
{
    return CGPointMake(arc4random()%(int)self.size.width, 40);
}

-(void)spawnAntsCount:(int)count position:(CGPoint)point
{
    if (self.ants.count == 0)
    {
        //no ants, make some
        for (int i = 0; i<count; i++) {
            [self createAntAtPosition:[self randomSpawnPoint]];
        }
        
        return;
    }
}

-(void)nextWave
{
    //get best performing ants and replicate them
    [self.ants sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        FNAnt *ant1 = obj1;
        FNAnt *ant2 = obj2;
        
        float dist1 = [JCMath distanceBetweenPoint:ant1.position andPoint:target.position sorting:NO];
        float dist2 = [JCMath distanceBetweenPoint:ant2.position andPoint:target.position sorting:NO];
        
        return [@(dist1) compare:@(dist2)];
    }];
    
    NSArray *bestAnts = [self.ants subarrayWithRange:NSMakeRange(0, self.ants.count/4)];
    
    //remove all
    for (FNAnt *ant in self.ants){
        [ant removeFromParent];
    }
    [self.ants removeAllObjects];
    
    
    //duplicate randomly
    for (int i = 0; i<bestAnts.count*4; i++)
    {
        FNAnt *parent = bestAnts[arc4random()%bestAnts.count];
        FNAnt *offspring = [parent copy];
        
        offspring.position = [self randomSpawnPoint];
        
        [self addChild:offspring];
        [self.ants addObject:offspring];
    }
}

-(void)update:(NSTimeInterval)currentTime
{
    for (FNAnt *ant in self.ants){
        [ant update];
    }
    
    if ([lastSelected isKindOfClass:[FNAnt class]]){
        UIImage *render = [lastSelected.network renderWithSize:networkRender.size];
        networkRender.texture = [SKTexture textureWithCGImage:render.CGImage];
        networkRender.position = CGPointMake(lastSelected.position.x, lastSelected.position.y - 40);
        networkRender.alpha = 1;
    }else{
        networkRender.alpha = 0;
    }
}

-(void)clear
{
    antDragging = nil;
    lastSelected = nil;
    
    for (FNAnt *ant in self.ants){
        [ant removeFromParent];
    }
    
    [self.ants removeAllObjects];
}

-(void)randomizeWeights
{
    for (FNAnt *ant in self.ants){
        [ant randomizeWeights];
    }
}

-(FNAnt *)createAntAtPosition:(CGPoint)position
{
    //create node
    FNAnt *ant = [[FNAnt alloc] initWithColor:[UIColor blackColor] size:CGSizeMake(20, 10)];
    
    ant.position = position;
    ant.parentScene = self;
    ant.target = target;
    
    ant.zRotation = M_PI_2;
    
    [self.ants addObject:ant];
    [self addChild:ant];
    
    return ant;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (touches.count > 1)
    {
        [self clear];
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInNode:self];
    
    didDrag = NO;
    didCreateNew = NO;
    antDragging = nil;
    
    if (self.children.count == 0)
    {
        antDragging = [self createAntAtPosition:position];
    }else{
        for (SKSpriteNode *node in self.children)
        {
            float dist = [JCMath distanceBetweenPoint:position andPoint:node.position sorting:NO];
            
            if (dist < 30){
                //touching a node
                antDragging = (FNAnt *)node;
            }
        }
        
        if (!antDragging)
        {
            antDragging = [self createAntAtPosition:position];
            didCreateNew = YES;
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInNode:self];
    
    didDrag = YES;
    
    if (antDragging){
        antDragging.position = position;
        
        if (position.y < 20)
        {
            [self.ants removeObject:antDragging];
            [antDragging removeFromParent];
            antDragging = nil;
            lastSelected = nil;
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!didDrag && !didCreateNew){
        if (antDragging == lastSelected){
            lastSelected = nil;
        }else{
            lastSelected = antDragging;
        }
    }
    
    antDragging = nil;
}

@end
