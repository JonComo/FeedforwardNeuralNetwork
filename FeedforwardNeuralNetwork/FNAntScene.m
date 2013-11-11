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
    SKNode *nodeDragging;
    FNAnt *lastSelected;
    
    BOOL didDrag;
    BOOL didCreateNew;
    
    SKSpriteNode *networkRender;
    
    SKSpriteNode *target;
    SKSpriteNode *spawn;
    
    CGPoint leadingPoint;
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
        
        spawn = [[SKSpriteNode alloc] initWithColor:[UIColor greenColor] size:CGSizeMake(40, 40)];
        spawn.position = CGPointMake(self.size.width/2, 100);
        [self addChild:spawn];
        
        target = [[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:CGSizeMake(40, 40)];
        
        target.position = CGPointMake(size.width/2, size.height/2 + 200);
        [self addChild:target];
        
        target.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:target.size.width/2];
        
        target.physicsBody.mass = 10;
        target.physicsBody.restitution = 0.8;
        [target.physicsBody setDynamic:NO];
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, self.size.width, self.size.height)];
        
//        NSTimer *waveTimer;
//        waveTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(nextGeneration) userInfo:nil repeats:YES];
        
        for (int i = 0; i<2; i++)
        {
            SKSpriteNode *wall = [self addWallAtRect:CGRectMake(self.size.width/2, 300, 200, 20)];
            
            wall.zRotation = (float)(arc4random()%360) * M_PI/180;
        }
        
        [self spawnAntsCount:25 position:[self randomSpawnPoint]];
    }
    
    return self;
}

-(SKSpriteNode *)addWallAtRect:(CGRect)wallRect
{
    SKSpriteNode *wall = [[SKSpriteNode alloc] initWithColor:[UIColor blackColor] size:wallRect.size];
    wall.position = CGPointMake(wallRect.origin.x + wall.size.width/2, wallRect.origin.y + wall.size.height/2);
    [self addChild:wall];
    
    wall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:wall.size];
    [wall.physicsBody setDynamic:NO];
    wall.physicsBody.categoryBitMask = wallCategory;
    
    return wall;
}

-(CGPoint)randomSpawnPoint
{
    return spawn.position;
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

-(void)nextGeneration
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
    
    NSInteger nextGenerationAmount = self.ants.count;
    
    //remove all
    for (FNAnt *ant in self.ants){
        [ant removeFromParent];
    }
    [self.ants removeAllObjects];
    
    
    //duplicate randomly
    for (int i = 0; i<nextGenerationAmount; i++)
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
    nodeDragging = nil;
    lastSelected = nil;
    
    for (FNAnt *ant in self.ants){
        [ant removeFromParent];
    }
    
    [self.ants removeAllObjects];
}

-(void)randomizeWeights
{
    for (SKSpriteNode *node in self.children)
    {
        if (node.physicsBody.categoryBitMask == wallCategory)
        {
            node.zRotation = (float)(arc4random()%360) * M_PI/180;
        }
    }
    
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
    
    ant.zRotation = (float)(arc4random()%360) * M_PI/180;
    
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
    
    leadingPoint = position;
    
    didDrag = NO;
    didCreateNew = NO;
    nodeDragging = nil;
    
    nodeDragging = [self nodeAtPoint:position];
    
    if ([nodeDragging isKindOfClass:[SKScene class]]) nodeDragging = nil;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInNode:self];
    
    didDrag = YES;

    nodeDragging.position = position;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!didDrag && !didCreateNew){
        if (nodeDragging == lastSelected){
            lastSelected = nil;
        }else{
            lastSelected = nodeDragging;
        }
    }
    
    nodeDragging = nil;
}

@end
