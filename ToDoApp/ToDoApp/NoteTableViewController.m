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

    NSIndexPath* edetingIndexpath;
    CGFloat height;
    CGPoint originalOffset;
    NSIndexPath* newRow;
    
    id<ExternTabelDataSource> externTableDataSource;
    NSMutableArray* dataSourceStack;
    NSMutableArray *arrDataSource;
    
    BOOL isDraging;
    
    UIView *scrollToBackView;
    
    UIImageView* curentPresentation;
    NSMutableData *topAppsString;
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


@end

@implementation NoteTableViewController
//@synthesize headerView, headerImageView, headerLabel;
//@synthesize footerView, footerImageView, footerLabel;
//@synthesize verticalSwipeScrollView, appData, startIndex;
//@synthesize previousPage, nextPage;
//
//- (void)viewWillAppear:(BOOL)animated {
//    
//    
//    NSLog(@"frame :%f", self.view.frame.size.height);
//    NSLog(@"frame :%f", self.view.frame.size.width);
//    NSLog(@"header :%f", headerView.frame.size.height);
//    NSLog(@"footer :%f", footerView.frame.size.height);
//    
//    self.verticalSwipeScrollView = [[VerticalSwipeScrollView alloc] initWithFrame:self.view.frame headerView:headerView footerView:footerView startingAt:1 delegate:self];
//    [self.view addSubview:verticalSwipeScrollView];
//}
//
//- (void)viewDidLoad
//{
//    headerImageView.transform = CGAffineTransformMakeRotation(degreesToRadians(180));
//    self.appData = [[NSArray alloc] initWithObjects:@"introduce1@2x.png", @"introduce2@2x.png", @"introduce3@2x.png", @"introduce4@2x.png", nil];
//    data = [[NSArray alloc]initWithObjects:@"PullArrow@2x.png",@"PullArrow@2x.png", nil];
//    headerImageView.image = [UIImage imageNamed:[data objectAtIndex:0]];
//    footerImageView.image =[UIImage imageNamed:[data objectAtIndex:0]];
//}
//
//- (void) rotateImageView:(UIImageView*)imageView angle:(CGFloat)angle
//{
//    NSLog(@"height view :%f",self.view.bounds.size.height);
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.2];
//    imageView.transform = CGAffineTransformMakeRotation(degreesToRadians(angle));
//    [UIView commitAnimations];
//}
//
//# pragma mark VerticalSwipeScrollViewDelegate
//
//-(void) headerLoadedInScrollView:(VerticalSwipeScrollView*)scrollView
//{
//    [self rotateImageView:headerImageView angle:0];
//}
//
//-(void) headerUnloadedInScrollView:(VerticalSwipeScrollView*)scrollView
//{
//    [self rotateImageView:headerImageView angle:180];
//}
//
//-(void) footerLoadedInScrollView:(VerticalSwipeScrollView*)scrollView
//{
//    [self rotateImageView:footerImageView angle:180];
//}
//
//-(void) footerUnloadedInScrollView:(VerticalSwipeScrollView*)scrollView
//{
//    [self rotateImageView:footerImageView angle:0];
//}
//
//-(UIImageView*) viewForScrollView:(VerticalSwipeScrollView*)scrollView atPage:(NSUInteger)page
//{
////    UIWebView* webView = nil;
////    
////    if (page < scrollView.currentPageIndex)
////        webView = [[previousPage retain] autorelease];
////    else if (page > scrollView.currentPageIndex)
////        webView = [[nextPage retain] autorelease];
////    
////    if (!webView)
////        webView = [self createWebViewForIndex:page];
////    
////    self.previousPage = page > 0 ? [self createWebViewForIndex:page-1] : nil;
////    self.nextPage = (page == (appData.count-1)) ? nil : [self createWebViewForIndex:page+1];
////    
////    self.navigationItem.title = [[[appData objectAtIndex:page] objectForKey:@"im:name"] objectForKey:@"label"];
////    if (page > 0)
////        headerLabel.text = [[[appData objectAtIndex:page-1] objectForKey:@"im:name"] objectForKey:@"label"];
////    if (page != appData.count-1)
////        footerLabel.text = [[[appData objectAtIndex:page+1] objectForKey:@"im:name"] objectForKey:@"label"];
////    
////    return webView;
//    UIImageView *imageview;
//    if (!imageview)
//              imageview = [self createWebViewForIndex:page];
//    self.previousPage = page > 0 ? [self createWebViewForIndex:page-1] : nil;
//     self.nextPage = (page == (appData.count-1)) ? nil : [self createWebViewForIndex:page+1];
//    
//    if (page > 0)
//        headerLabel.text = @"1";
//    if (page != appData.count-1)
//        footerLabel.text = @"2";
//
//    
//    return imageview;
//}
//
//-(NSUInteger) pageCount
//{
//    return appData.count;
//}
//
//-(UIImageView*) createWebViewForIndex:(NSUInteger)index
//{
////    UIWebView* webView = [[[UIWebView alloc] initWithFrame:self.view.frame] autorelease];
////    webView.opaque = NO;
////    [webView setBackgroundColor:[UIColor clearColor]];
////    [self hideGradientBackground:webView];
////    
////    NSString* htmlFile = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/DetailView.html"];
////    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
////    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!-- title -->" withString:[[[appData objectAtIndex:index] objectForKey:@"im:name"] objectForKey:@"label"]];
////    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!-- icon -->" withString:[[[[appData objectAtIndex:index] objectForKey:@"im:image"] objectAtIndex:0] objectForKey:@"label"]];
////    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!-- content -->" withString:[[[appData objectAtIndex:index] objectForKey:@"summary"] objectForKey:@"label"]];
////    [webView loadHTMLString:htmlString baseURL:nil];
////    
////    return webView;
//    UIImageView *view = [[UIImageView alloc] initWithFrame:self.view.frame];
////    CGFloat red = arc4random() / (CGFloat)INT_MAX;
////    CGFloat green = arc4random() / (CGFloat)INT_MAX;
////    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
////    view.backgroundColor = [UIColor colorWithRed:red
////                                           green:green
////                                            blue:blue
////                                           alpha:1.0];
//    view.image = [UIImage imageNamed:[appData objectAtIndex:index]];
//    return view;
//}
//
//- (void) hideGradientBackground:(UIView*)theView
//{
//    for (UIView * subview in theView.subviews)
//    {
//        if ([subview isKindOfClass:[UIImageView class]])
//            subview.hidden = YES;
//        
//        [self hideGradientBackground:subview];
//    }
//}
//
//- (void)viewDidUnload
//{
//    self.headerView = nil;
//    self.headerImageView = nil;
//    self.headerLabel = nil;
//    
//    self.footerView = nil;
//    self.footerImageView = nil;
//    self.footerLabel = nil;
//}


- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tabelView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    dataSourceStack = [NSMutableArray array];
    
    externTableDataSource = [NoteGroupDataSource new];
    [externTableDataSource setContent:[[DatabaseHelper instance] getNodeGropus] ];
    [externTableDataSource setDelegate:self];
    [dataSourceStack addObject:externTableDataSource];

    [self setEditingCellViewShow:NO];
    
    scrollToBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -SCROLLTOBACK_HEIGHT/2, self.tabelView.frame.size.width, SCROLLTOBACK_HEIGHT)];
    scrollToBackView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    UILabel* label = [[UILabel alloc] initWithFrame:scrollToBackView.bounds];
    label.text = @"Switch to list";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = scrollToBackView.backgroundColor;
    label.textAlignment = NSTextAlignmentCenter;
    [scrollToBackView addSubview:label];
    scrollToBackView.alpha = 0.0;
    scrollToBackView.layer.anchorPoint = CGPointMake(0.5, 1.0);
    [self.tabelView addSubview:scrollToBackView];
}

- (void) initDataNote {
    void(^successBlock)(ResponseObject *) = ^void(ResponseObject *responseObject) {
        
        if ([[NSString stringWithFormat:@"%@",[responseObject.data objectForKey:KEY_CODE]] isEqualToString:@"0"]) {
        } else {
            NSString *message = [responseObject.data objectForKey:KEY_MESSAGE];
            [Util showAlert:ALERT_ERROR message:message delegate:self];
        }
        [[Util sharedUtil] hideLoadingView];
        
    };
    void(^failBlock)(ResponseObject *) = ^void(ResponseObject *responseObject) {
        [Util showAlertError:ALERT_NETWORK_ERROR];
        [[Util sharedUtil] hideLoadingView];
    };
    
    [[Util sharedUtil] showLoadingView];
    [[APIClient sharedClient] getListNote:@"" success:successBlock
                                  failure:failBlock];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [externTableDataSource numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [externTableDataSource tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([edetingIndexpath isEqual:indexPath])
    {
        return height;
    }
    return [externTableDataSource tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell<EditTabelCellProtocol>* cell = [externTableDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
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
        [UIView animateWithDuration:0.2 animations:^{
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
    [externTableDataSource tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [externTableDataSource setNewName:textView.text forIndex:edetingIndexpath.row];
    CGRect rect = self.editCellView.frame;
    rect.size.height = textView.contentSize.height;
    if(rect.size.height<44)
    {
        rect.size.height = 44;
    }
    if(fabs(height-rect.size.height)>10)
    {
        self.editCellView.frame = rect;
        height = rect.size.height;
    }
    
    [self.tabelView reloadRowsAtIndexPaths:@[edetingIndexpath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.timeDate.hidden = YES;
    [externTableDataSource setNewName:textView.text forIndex:edetingIndexpath.row];
    
    NSIndexPath *path = edetingIndexpath;
    
    [UIView beginAnimations:@"show/hide" context:nil];
    [self setEditingCellViewShow:NO];
    
    CGRect rect = self.editCellView.frame;
    rect.origin.y += self.tabelView.contentOffset.y-originalOffset.y;
    self.editCellView.frame = rect;
    self.tabelView.contentInset = self.tabelView.scrollIndicatorInsets;
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
    rect.origin.y = -TOP_TABELVIEW_OFFSET-rect.size.height;
    curentPresentation.frame = rect;
    [self.tabelView addSubview:curentPresentation];
    [externTableDataSource setPresentationImage:curentPresentation];
    
    NoteDataSource* newDataSource = [NoteDataSource new];
    newDataSource.groupID = groupID;
    [newDataSource setDelegate:self];
    NSArray* newContent = [[DatabaseHelper instance] getNodesForGroup:groupID];
    [newDataSource setContent:newContent];
    [dataSourceStack addObject:newContent];
//    
    [self.titleItem setTitle:name];
    
    [self.tabelView beginUpdates];
    int index = 0;
    NSArray *content = [externTableDataSource getContent];
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
    externTableDataSource = newDataSource;
    
    [self.tabelView endUpdates];
}

- (IBAction)addNewRow:(id)sender
{
    [externTableDataSource addNewItem];
    
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"toa do y: %f", scrollView.contentOffset.y);
    if(dataSourceStack.count<2)
        return;
    if((-scrollView.contentInset.top-scrollView.contentOffset.y)>SCROLLTOBACK_HEIGHT)
    {
        
        UIGraphicsBeginImageContextWithOptions(self.tableViewContainer.bounds.size, self.tableViewContainer.opaque, 0.0);
        [self.tableViewContainer.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
        img = [UIImage imageNamed:@"PullArrow.png"];
        
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
            rect.origin.y = self.navigationBar.frame.size.height;
            curentPresentation.frame = rect;
            
            [self.titleItem setTitle:@""];
        } completion:^(BOOL finished) {
            [dataSourceStack removeLastObject];
            externTableDataSource = [dataSourceStack lastObject];
            
            [self.tabelView reloadData];
            [iv removeFromSuperview];
            [curentPresentation removeFromSuperview];
            
            if(dataSourceStack.count>1)
            {
                scrollToBackView.alpha = 1.0;
            }else
            {
                scrollToBackView.alpha = 0.0;
                
            }
            
        }];

    }
}

@end
