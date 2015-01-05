//
//  ViewController.m
//  ToDoApp
//
//  Created by NGUYENHAGIANG on 12/12/14.
//  Copyright (c) 2014 NGUYENHAGIANG. All rights reserved.
//

#import "NoteTableViewController.h"
#import "JTTableViewGestureRecognizer.h"
#import "JTTransformableTableViewCell.h"
#import "UIColor+JTGestureBasedTableViewHelper.h"
#import "ExternTabelDataSource.h"
#define ADDING_CELL @"Continue..."
#define DONE_CELL @"Done"
#define DUMMY_CELL @"Dummy"
#define COMMITING_CREATE_CELL_HEIGHT 60
#define NORMAL_CELL_FINISHING_HEIGHT 60

#define SCROLLTOBACK_HEIGHT 50
#define TOP_TABELVIEW_OFFSET 100

const CGFloat kPerspective = 1.0/400.0;


@interface NoteTableViewController (){

    id<ExternTabelDataSource> dataSource;
    NSMutableArray* dataSourceStack;
    
    NSIndexPath* edetingIndexpath;
    CGFloat height;
    CGPoint originalOffset;
    NSIndexPath* newRow;
    BOOL isDraging;
    
    UIView *scrollToBackView;
    UIImageView* curentPresentation;
}

@property (strong, nonatomic) IBOutlet UITableView *tabelView;
@property (weak, nonatomic) IBOutlet UIView *darkBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *editCellView;
@property (weak, nonatomic) IBOutlet UITextView *editCellTextField;
@property (weak, nonatomic) IBOutlet UILabel *timeDate;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;

@property (weak, nonatomic) IBOutlet GradientBackground *editBackgroundColor;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleItem;
@property (weak, nonatomic) IBOutlet UIView *tableViewContainer;

@property (nonatomic) NSInteger groupID;
@property (nonatomic) NSString *groupName;
@property (nonatomic) NSIndexPath *indexPath;
@end

@implementation NoteTableViewController
- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
   // [self.navigationBar setTitleVerticalPositionAdjustment:10 forBarMetrics:UIBarMetricsDefault];
    
    self.tabelView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
    
    dataSourceStack = [NSMutableArray array];
    
    dataSource = [NoteGroupDataSource new];
    [dataSource setContent:[[DatabaseHelper instance] getNodeGropus] ];
    [dataSource setDelegate:self];
    [dataSourceStack addObject:dataSource];
    //_content = [[[DatabaseHelper instance] getNodesForGroup:0] mutableCopy];
    
    [self setEditingCellViewShow:NO];
    
    scrollToBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -50, self.tabelView.frame.size.width, SCROLLTOBACK_HEIGHT)];
    scrollToBackView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    UILabel* label = [[UILabel alloc] initWithFrame:scrollToBackView.bounds];
    label.text = @"Switch to list";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = scrollToBackView.backgroundColor;
    label.textAlignment = NSTextAlignmentCenter;
    [scrollToBackView addSubview:label];
    scrollToBackView.alpha = 0.0;
   // scrollToBackView.layer.anchorPoint = CGPointMake(0.5, 1.0);
    [self.tabelView addSubview:scrollToBackView];
    
    [self createHeaderView:_headerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createHeaderView:(UIView*)headerView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tabelView.frame.size.height, 320, 50)];
    _headerView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    [self.tabelView addSubview:_headerView];
    
    UILabel* labelHeader = [[UILabel alloc] initWithFrame:_headerView.bounds];
    labelHeader.text = @"Switch to list";
    labelHeader.textColor = [UIColor whiteColor];
    labelHeader.backgroundColor = _headerView.backgroundColor;
    labelHeader.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:labelHeader];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [dataSource numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [dataSource tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([edetingIndexpath isEqual:indexPath])
    {
        return height;
    }
    return [dataSource tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell<EditTabelCellProtocol>* cell = [dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
    //[cell updateBackgroupd:[dataSource colorFoIndex:indexPath.row]];
    
    if([indexPath isEqual:newRow])
    {
        newRow = nil;
        cell.contentView.layer.anchorPoint = CGPointMake(0.5, 1);
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = kPerspective;
        cell.contentView.layer.transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
        
        __block UITableViewCell<EditTabelCellProtocol>* blockCell = cell;
        __block NSIndexPath* blockIndexPath = indexPath;
        [UIView animateWithDuration:0.5 animations:^{
            cell.contentView.layer.transform = CATransform3DRotate(transform, 0, 1, 0, 0);
        } completion:^(BOOL finished) {
            [self cellBiginEditing:blockCell:NO];
            edetingIndexpath = blockIndexPath;
        }];
        
    }
    
    return cell;
}

- (void)beginEditingInIndexPath:(NSIndexPath*)indexPath
{
    edetingIndexpath = indexPath;
    [self cellBiginEditing:[self.tabelView cellForRowAtIndexPath:indexPath]:YES];
}

- (void)cellBiginEditing:(UITableViewCell<EditTabelCellProtocol>*)cell:(BOOL)isTime
{
    //self.editCellTextField.backgroundColor = self.editCellView.backgroundColor = cell.contentView.backgroundColor;
    CAGradientLayer* editLayer = (CAGradientLayer*)self.editBackgroundColor.layer;
    CAGradientLayer* cellLayer = (CAGradientLayer*)[cell getGradientBackgroundView].layer;
    editLayer.colors = cellLayer.colors;
    editLayer.locations = cellLayer.locations;
    editLayer.startPoint = cellLayer.startPoint;
    editLayer.endPoint = cellLayer.endPoint;
    
    CGRect rect = cell.frame;
    rect.origin.y -=  self.tabelView.contentOffset.y;
    NSLog(@"origin y:%f",rect.origin.y);
    height = rect.size.height;
    self.editCellView.frame = rect;
    [UIView beginAnimations:@"show/hide" context:nil];
    [self setEditingCellViewShow:YES];
    
    CGFloat offset = CGRectGetMaxY(self.navigationBar.frame) - rect.origin.y;
    rect.origin.y = CGRectGetMaxY(self.navigationBar.frame);
    self.editCellView.frame = rect;
    if (isTime) {
        rect = self.editCellView.frame;
        rect.origin.x = 7;
        rect.origin.y = 0;
        rect.size.height = 44;
        rect.size.width = 306;
        self.editCellTextField.frame = rect;
    }
    
    self.timeDate.frame = CGRectMake(10, 44, 300, 20);
    self.timeDate.hidden = NO;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm"];
    NSDate *date =[NSDate date];
    NSString *dateString = [format stringFromDate:date];
    self.timeDate.text = [NSString stringWithFormat:@"Today %@",dateString];
    
    CGPoint cOffset = originalOffset = self.tabelView.contentOffset;
    cOffset.y -= offset;
    
    UIEdgeInsets inset = self.tabelView.contentInset;
    inset.top = -cOffset.y;
    self.tabelView.contentInset = inset;
    
    [UIView commitAnimations];
    
    [cell updateTextView:self.editCellTextField time:self.timeDate];
    
    // move time to view edit
    
    [self.editCellTextField becomeFirstResponder];
}

- (void)setEditingCellViewShow:(BOOL)show
{
    self.darkBackgroundView.alpha = show?1.0:0.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [dataSource tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [dataSource setNewName:textView.text forIndex:edetingIndexpath.row];
    CGRect rect = self.editCellView.frame;
    rect.size.height = textView.contentSize.height;
    if(rect.size.height<44)
    {
        rect.size.height = 44;
    }
    if(fabs(height-rect.size.height)>10)
    {
        //        self.editCellView.frame = rect;
        //        height = rect.size.height;
    }
    
    [self.tabelView reloadRowsAtIndexPaths:@[edetingIndexpath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.timeDate.hidden = YES;
    [dataSource setNewName:textView.text forIndex:edetingIndexpath.row];
    
    NSIndexPath *path = edetingIndexpath;
    
    [UIView beginAnimations:@"show/hide" context:nil];
    [self setEditingCellViewShow:NO];
    
    CGRect rect = self.editCellView.frame;
    rect.origin.y += self.tabelView.contentOffset.y-originalOffset.y;
    self.editCellView.frame = rect;
    //self.tabelView.contentInset = self.tabelView.scrollIndicatorInsets;
   // self.tabelView.contentInset = CGPointMake(0, 0);

    [UIView commitAnimations];
    
    
    edetingIndexpath = nil;
    [self.tabelView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location!=NSNotFound)
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)openNotesForGroup:(NSInteger)groupID groupName:(NSString*)name indexPath:(NSIndexPath*)indexPath
{
    self.groupID = groupID;
    self.groupName = name;
    self.indexPath = indexPath;
    
    scrollToBackView.alpha = 0.0;
    CGPoint offset = self.tabelView.contentOffset;
    
    self.tabelView.contentOffset = CGPointMake(0, -self.tabelView.contentInset.top);
    CGSize size = self.tabelView.contentSize;

    CGRect originFrame = self.tabelView.frame;
    if(size.height>self.tabelView.bounds.size.height)
    {
        CGRect rect = self.tabelView.frame;
        rect.size.height = size.height+self.tabelView.contentInset.top;
        self.tabelView.frame = rect;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, self.tabelView.opaque, 0.0);
    
    [self.tabelView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    self.tabelView.frame = originFrame;
    
    scrollToBackView.alpha = 1.0;
    self.tabelView.contentOffset = offset;
    curentPresentation = [[UIImageView alloc] initWithImage:img];
    
    CGRect rect = curentPresentation.frame;
    rect.origin.y = -64-rect.size.height;
    curentPresentation.frame = rect;
    [self.tabelView addSubview:curentPresentation];
    [dataSource setPresentationImage:curentPresentation];
    
    NoteDataSource* newDataSource = [NoteDataSource new];
    newDataSource.groupID = groupID;
    [newDataSource setDelegate:self];
    NSArray* newContent = [[DatabaseHelper instance] getNodesForGroup:groupID];
    [newDataSource setContent:newContent];
    [dataSourceStack addObject:newContent];
    
    [self.titleItem setTitle:name];
    
    [self.tabelView beginUpdates];
    int index = 0;
    NSArray *content = [dataSource getContent];
    NSMutableArray* changeRow = [NSMutableArray arrayWithCapacity:content.count];
    for (; index<indexPath.row; index++) {
        [changeRow addObject:[NSIndexPath indexPathForRow:index inSection:0]];
    }
    if(changeRow.count>0)
    {
        [self.tabelView deleteRowsAtIndexPaths:changeRow withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tabelView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [changeRow removeAllObjects];
    
    for (index++; index<content.count; index++) {
        [changeRow addObject:[NSIndexPath indexPathForRow:index inSection:0]];
    }
    if(changeRow.count>0)
    {
        [self.tabelView deleteRowsAtIndexPaths:changeRow withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [changeRow removeAllObjects];
    for (index = 0; index<newContent.count; index++) {
        [changeRow addObject:[NSIndexPath indexPathForRow:index inSection:0]];
    }
    
    [self.tabelView insertRowsAtIndexPaths:changeRow withRowAnimation:UITableViewRowAnimationFade];
    dataSource = newDataSource;
    
    [self.tabelView endUpdates];
}

- (IBAction)addNewRow:(id)sender
{
    [dataSource addNewItem];
    
    NSArray* array = [self.tabelView visibleCells];
    // NSLog(@"%@",array);
    
    NSInteger row = 1;
    for (id<EditTabelCellProtocol> cell in array) {
        //[cell updateBackgroupd:[dataSource colorFoIndex:row++]];
    }
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    newRow = index;
    [self.tabelView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    [self.tabelView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  //NSLog(@"content offset y:%f",self.tabelView.contentOffset.y);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // NSLog(@"content inset top y:%f",scrollView.contentInset.top);
//    if(dataSourceStack.count<2)
//        return;
   
    if((-scrollView.contentInset.top-scrollView.contentOffset.y)>SCROLLTOBACK_HEIGHT) {
        
        UIGraphicsBeginImageContextWithOptions(self.tableViewContainer.bounds.size, self.tableViewContainer.opaque, 0.0);
        [self.tableViewContainer.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        __block UIImageView *iv = [[UIImageView alloc] initWithImage:img];
        [self.tableViewContainer addSubview:iv];
        curentPresentation.frame = [curentPresentation convertRect:curentPresentation.bounds toView:self.tableViewContainer];
        [self.tableViewContainer addSubview:curentPresentation];
        
        [UIView animateWithDuration:UIScrollViewDecelerationRateNormal animations:^{
            
            CGRect rect = iv.frame;
            rect.origin.y -= curentPresentation.frame.origin.y - self.navigationBar.frame.size.height;
            iv.frame = rect;
            rect = curentPresentation.frame;
            rect.origin.y = self.navigationBar.frame.size.height ;
            curentPresentation.frame = rect;
            [self.titleItem setTitle:@"My Lists"];
        } completion:^(BOOL finished) {
            [dataSourceStack removeLastObject];
            dataSource = [dataSourceStack lastObject];
            
            [self.tabelView reloadData];
            [iv removeFromSuperview];
            [curentPresentation removeFromSuperview];
            
            if(dataSourceStack.count>1)
            {
                scrollToBackView.alpha = 1.0;
            } else
            {
                scrollToBackView.alpha = 0.0;
                
            }
            
        }];
        return;
    } else if (self.tabelView.contentOffset.y > 40) {
       
    } else {
         NSLog(@"Switch");
    }
//    } else if((-scrollView.contentInset.top+scrollView.contentOffset.y)>50) {
//    }

}
@end
