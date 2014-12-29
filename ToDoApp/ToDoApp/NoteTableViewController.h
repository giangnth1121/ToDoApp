//
//  ViewController.h
//  ToDoApp
//
//  Created by NGUYENHAGIANG on 12/12/14.
//  Copyright (c) 2014 NGUYENHAGIANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteTabelViewCell.h"
#import "VerticalSwipeScrollView.h"

@interface NoteTableViewController : UIViewController<UITextViewDelegate,UIScrollViewDelegate> {

//    IBOutlet UIView* headerView;
//    IBOutlet UIImageView* headerImageView;
//    IBOutlet UILabel* headerLabel;
//    IBOutlet UIView* footerView;
//    IBOutlet UIImageView* footerImageView;
//    IBOutlet UILabel* footerLabel;
    
//    VerticalSwipeScrollView* verticalSwipeScrollView;
//    NSArray* appData;
//     NSArray* data;
//    NSUInteger startIndex;
//    UIImageView* previousPage;
//    UIImageView* nextPage;
}
@property (nonatomic, assign) NSInteger uID;

@property (nonatomic, retain) IBOutlet UIView* headerView;
@property (nonatomic, retain) IBOutlet UIImageView* headerImageView;
@property (nonatomic, retain) IBOutlet UILabel* headerLabel;
@property (nonatomic, retain) IBOutlet UIView* footerView;
@property (nonatomic, retain) IBOutlet UIImageView* footerImageView;
@property (nonatomic, retain) IBOutlet UILabel* footerLabel;
@property (nonatomic, retain) VerticalSwipeScrollView* verticalSwipeScrollView;
@property (nonatomic, retain) NSArray* appData;
@property (nonatomic) NSUInteger startIndex;
@property (nonatomic, retain) UIImageView* previousPage;
@property (nonatomic, retain) UIImageView* nextPage;

@end

