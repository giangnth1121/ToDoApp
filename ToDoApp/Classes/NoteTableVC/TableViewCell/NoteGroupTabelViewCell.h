//
//  NoteGroupTabelViewCell.h
//  TestApp
//
//  Created by Сергей on 29.07.14.
//  Copyright (c) 2014 Вячеслав Ковалев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditTabelCellProtocol.h"
#import "GradientBackground.h"

@interface NoteGroupTabelViewCell : UITableViewCell<EditTabelCellProtocol>
@property (weak, nonatomic) IBOutlet UILabel *groupName;
@property (weak, nonatomic) IBOutlet UILabel *countNotes;
@property (weak, nonatomic) IBOutlet GradientBackground *gradientBackgroundView;
@property (strong, nonatomic) NSIndexPath* index;
@end
