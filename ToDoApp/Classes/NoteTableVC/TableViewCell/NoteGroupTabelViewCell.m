//
//  NoteGroupTabelViewCell.m
//  TestApp
//
//  Created by Сергей on 29.07.14.
//  Copyright (c) 2014 Вячеслав Ковалев. All rights reserved.
//

#import "NoteGroupTabelViewCell.h"

@implementation NoteGroupTabelViewCell

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
    textView.text = self.groupName.text;
    textView.font = self.groupName.font;
    textView.textColor = self.groupName.textColor;
    time.hidden = YES;
}

- (void)updateBackgroupd:(UIColor*)color
{
    self.contentView.backgroundColor = color;
    self.groupName.backgroundColor = color;
}

- (GradientBackground*)getGradientBackgroundView
{
    return self.gradientBackgroundView;
}

@end
