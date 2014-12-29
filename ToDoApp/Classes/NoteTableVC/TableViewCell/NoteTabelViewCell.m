//
//  CustomTableViewCell.m
//  TestApp
//
//  Created by Сергей on 11.07.14.
//  Copyright (c) 2014 Вячеслав Ковалев. All rights reserved.
//

#import "NoteTabelViewCell.h"

@implementation NoteTabelViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateTextView:(UITextView*)textView time:(UILabel *)time
{
    textView.text = self.noteText.text;
    textView.font = self.noteText.font;
    textView.textColor = self.noteText.textColor;
    time.hidden = NO;
}

- (void)updateBackgroupd:(UIColor*)color
{
    self.contentView.backgroundColor = color;
    self.noteText.backgroundColor = color;
}


- (NSString*)description
{
    return [NSString stringWithFormat:@"%@ %@",self.index,self.noteText];
}

- (GradientBackground*)getGradientBackgroundView
{
    return self.gradientBackgroundView;
}

@end
