//
//  CustomTableViewCell.h
//  TestApp
//
//  Created by Сергей on 11.07.14.
//  Copyright (c) 2014 Вячеслав Ковалев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditTabelCellProtocol.h"
#import "GradientBackground.h"

@protocol NoteTableViewCellDelegate <NSObject>



@end
@interface NoteTabelViewCell : UITableViewCell<EditTabelCellProtocol>
@property (weak, nonatomic) IBOutlet UILabel *noteText;
@property (weak, nonatomic) IBOutlet UILabel *dateCreate;

@property (strong, nonatomic) NSIndexPath* index;
@property (weak, nonatomic) IBOutlet GradientBackground *gradientBackgroundView;

@end
