//
//  NoteGroupDataSource.m
//  TestApp
//
//  Created by Сергей on 29.07.14.
//  Copyright (c) 2014 Вячеслав Ковалев. All rights reserved.
//

#import "NoteGroupDataSource.h"
#import "NoteGroupTabelViewCell.h"

@interface NoteGroupDataSource ()
{
    NSMutableArray* _content;
    id _delegate;
    UIImageView* presentation;
    CGPoint contentOffset;
}
@end

@implementation NoteGroupDataSource
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
    
    NoteGroupObject* note = _content[indexPath.row];
    return (int)([note.name sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(tableView.frame.size.width-70, 1000)].height+25.5);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoteGroupObject* note = _content[indexPath.row];
    NoteGroupTabelViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoteGroupCell" forIndexPath:indexPath];
    cell.groupName.text = note.name;
    cell.index = indexPath;
    [self setColorForView:cell.gradientBackgroundView inIndex:indexPath.row];
    //cell.groupName.backgroundColor = [self colorFoIndex:indexPath.row];
    cell.countNotes.text = [NSString stringWithFormat:@"%d",note.noteCount];
    
    return cell;
}

- (UIColor*)getColorForIndex:(NSInteger)index elementCount:(NSInteger)itemCount
{

    UIColor* startColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
    UIColor* endColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:1.0];
    CGFloat sR,sG,sB,sA,eR,eG,eB,eA;
    [startColor getRed:&sR green:&sG blue:&sB alpha:&sA];
    [endColor getRed:&eR green:&eG blue:&eB alpha:&eA];
    CGFloat r,g,b,a;
    CGFloat coff = index*1.0/itemCount;
    r = sR + (eR-sR)*coff;
    g = sG + (eG-sG)*coff;
    b = sB + (eB-sB)*coff;
    a = sA + (eA-sA)*coff;
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

- (void)setColorForView:(GradientBackground*)backGround inIndex:(NSInteger)index
{
    CAGradientLayer* layer = (CAGradientLayer*)backGround.layer;
    //layer.backgroundColor = [UIColor redColor].CGColor;
    //return;
    layer.colors = @[(id)[self getColorForIndex:index elementCount:_content.count+1].CGColor,(id)[self getColorForIndex:index+1 elementCount:_content.count+1].CGColor];
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
    NoteGroupObject* group = _content[index];
    group.name = name;
   // [[DatabaseHelper instance] updateNoteGroup:group];
}

- (void)addNewItem
{
    [_content insertObject:[NoteGroupObject new] atIndex:0];
}

- (void)setDelegate:(id)delegate
{
    _delegate = delegate;
}

- (NSArray*)getContent
{
    return [NSArray arrayWithArray:_content];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_delegate respondsToSelector:@selector(openNotesForGroup:groupName:indexPath:)])
    {
        NoteGroupObject* group = _content[indexPath.row];
        [_delegate openNotesForGroup:group.groupID groupName:group.name indexPath:indexPath];
    }
}

- (void)setPresentationImage:(UIImageView*)image
{
    presentation = image;
}
- (UIImageView*)getPresentationImage:(UIImageView*)image
{
    return presentation;
}

- (void)setContentOffset:(CGPoint)offset
{
    contentOffset = offset;
}
- (CGPoint)getContentOffset
{
    return contentOffset;
}
@end
