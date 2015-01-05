//
//  NoteDataSource.m
//  TestApp
//
//  Created by Сергей on 28.07.14.
//  Copyright (c) 2014 Вячеслав Ковалев. All rights reserved.
//

#import "NoteDataSource.h"
#import "NoteTabelViewCell.h"

@interface NoteDataSource ()
{
    NSMutableArray* _content;
    NSMutableArray* _dateCreate;
    id<NoteDataSourceDelegate> _delegate;
}
@end

@implementation NoteDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _content.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NoteObject* note = _content[indexPath.row];
    
//    return (int)([note.text sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(tableView.frame.size.width-24, 1000)].height+16);
    return 78.0f;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoteObject* note = _content[indexPath.row];
    NoteTabelViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testCell" forIndexPath:indexPath];
    cell.noteText.text = note.text;
    cell.dateCreate.text = [self dateDiff:note.date];

    cell.index = indexPath;
    [self setColorForView:cell.gradientBackgroundView inIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_delegate respondsToSelector:@selector(beginEditingInIndexPath:)])
    {
        [_delegate beginEditingInIndexPath:indexPath];
    }
}

- (void)setColorForView:(GradientBackground*)backGround inIndex:(NSInteger)index
{
    NSInteger itemCount = _content.count+1;
    CGFloat val = 0, val2 = 0;

    val = index*0.6/itemCount;
    val2 = (index+1)*0.6/itemCount;
    
    CAGradientLayer* layer = (CAGradientLayer*)backGround.layer;
    //layer.backgroundColor = [UIColor redColor].CGColor;
    //return;
    layer.colors = @[(id)[UIColor colorWithRed:1.0 green:val blue:0.0 alpha:1.0].CGColor,(id)[UIColor colorWithRed:1.0 green:val2 blue:0.0 alpha:1.0].CGColor];
    layer.locations = @[@0.0,@1.0];
    layer.startPoint = CGPointMake(0.5, 0.0);
    layer.endPoint = CGPointMake(0.5, 1.0);
    
}

- (void)setContent:(NSArray*)content
{
    _content = [content mutableCopy];

}

- (void)setNewName:(NSString*)name forIndex:(NSInteger)index
{
    NoteObject* note = _content[index];
    note.text = name;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd MMM yyyy HH:mm"];
    NSDate *date =[NSDate date];
    NSString *dateString = [format stringFromDate:date];
    note.date = dateString;
    [[DatabaseHelper instance] updateNote:note];
}

- (void)addNewItem
{
    NoteObject* object = [NoteObject new];
    object.groupID = self.groupID;
    [_content insertObject:object atIndex:0];
}

- (void)setDelegate:(id)delegate
{
    _delegate = delegate;
}

// check time
-(NSString *)dateDiff:(NSString *)origDate {
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"dd MMM yyyy HH:mm"];
    NSDate *convertedDate = [df dateFromString:origDate];
    
    [df setDateFormat:@"dd MMM yyyy"];
    NSString *sOrigDate = [df stringFromDate:convertedDate];
    NSString *sToday = [df stringFromDate:today];
    NSString *sYesterday = [df stringFromDate:yesterday];
    // get hour: minutes
    [df setDateFormat:@"HH:mm"];
    NSString *origHour = [df stringFromDate:convertedDate];
    
    if([sOrigDate isEqualToString:sToday])
        return [NSString stringWithFormat:@"Today %@", origHour];
    else if([sOrigDate isEqualToString:sYesterday])
        return [NSString stringWithFormat:@"Yesterday %@", origHour];
    else
        return origDate;
}
@end
