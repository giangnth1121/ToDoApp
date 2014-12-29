//
//  GradientBackground.m
//  TestApp
//
//  Created by Сергей on 11.08.14.
//  Copyright (c) 2014 Вячеслав Ковалев. All rights reserved.
//

#import "GradientBackground.h"

@implementation GradientBackground

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
