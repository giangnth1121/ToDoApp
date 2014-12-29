//
//  CustomView.m
//  TestApp
//
//  Created by Сергей on 20.07.14.
//  Copyright (c) 2014 Вячеслав Ковалев. All rights reserved.
//

#import "CustomView.h"

@interface CustomView ()

@property (nonatomic,weak)IBOutlet UIScrollView* viewToSendEvents;
@end

@implementation CustomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [self addGestureRecognizer:self.viewToSendEvents.panGestureRecognizer];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.viewToSendEvents touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.viewToSendEvents touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.viewToSendEvents touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.viewToSendEvents touchesCancelled:touches withEvent:event];
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
