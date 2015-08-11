//
//  VisualizerView.m
//  SoundFi
//
//  Created by Florian Coulon on 20/07/15.
//  Copyright (c) 2015 Florian Coulon. All rights reserved.
//

#import "VisualizerView.h"
#import <QuartzCore/QuartzCore.h>
#import "MeterTable.h"

@implementation VisualizerView {
    MeterTable meterTable;
}


//1 Overrides layerClass to return CAEmitterLayer, which allows this view to act as a particle emitter.
+ (Class)layerClass {
    return [CAEmitterLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.emitterLayer = (CAEmitterLayer *)self.layer;
        
        //2 Shapes the emitter as a rectangle that extends across most of the center of the screen. Particles are initially created within this area.
        CGFloat width = MAX(frame.size.width,frame.size.height);
        //        CGFloat height = MIN(frame.size.width, frame.size.height);
        self.emitterLayer.emitterPosition = CGPointMake(self.centerX, (self.centerY / 2.) + 200);
        self.emitterLayer.emitterSize = CGSizeMake(width-80, 60);
        self.emitterLayer.emitterShape = kCAEmitterLayerRectangle;
        self.emitterLayer.renderMode = kCAEmitterLayerAdditive;
        
        //3 Creates a CAEmitterCell that renders particles using particleTexture.png, included in the starter project.
        self.cell = [CAEmitterCell emitterCell];
        self.cell.name = @"cell";
        
        CAEmitterCell *childCell = [CAEmitterCell emitterCell];
        childCell.name = @"childCell";
        childCell.lifetime = 1.0 / 60.0f;
        childCell.birthRate = 60.0f;//there will be 60 particles emitted per second
        childCell.velocity = 0.0f;
        
        childCell.contents = (id)[[UIImage imageNamed:@"halo.png"] CGImage];
        self.cell.emitterCells = [NSArray arrayWithObject:childCell];
        
        //4 Sets the particle color, along with a range by which each of the red, green, and blue color components may vary.
        self.cell.color = [UIColor whiteColor].CGColor; /*[[UIColor colorWithRed:1.0f green:0.53f blue:0.0f alpha:0.8f] CGColor]*/
        self.cell.redRange = 0.46f;
        self.cell.greenRange = 0.49f;
        self.cell.blueRange = 0.67f;
        self.cell.alphaRange = 0.55f;
        
        //5 Sets the speed at which the color components change over the lifetime of the particle.
        self.cell.redSpeed = 0.11;
        self.cell.greenSpeed = 0.07f;
        self.cell.blueSpeed = -0.25f;
        self.cell.alphaSpeed = 0.15f;
        
        //6 Sets the scale and the amount by which the scale can vary for the generated particles.
        self.cell.scale = 0.5f;
        self.cell.scaleRange = 0.5f;
        
        //7 Sets the amount of time each particle will exist to between (1.0 - 0.25 =) .75 and (1.0 + 0.25 =) 1.25 seconds, and sets it to create 80 particles per second.
        self.cell.lifetime = 1.25f;
        self.cell.lifetimeRange = 0.25f;
        self.cell.birthRate = 80;
        
        //8 Configures the emitter to create particles with a variable velocity, and to emit them in any direction.
        self.cell.velocity = 100.0f;
        self.cell.velocityRange  = 300.0f;
        self.cell.emissionRange = M_PI * 2;
        
        //9 Adds the emitter cell to the emitter layer.
        self.emitterLayer.emitterCells = [NSArray arrayWithObject:self.cell];
        
        // you added above creates an instance of CADisplayLink set up to call update on the target self. That means it will call the update method you just defined during each screen refresh.
    }
    return self;
}

@end
