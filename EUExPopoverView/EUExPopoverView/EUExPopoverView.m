//
//  EUExPopoverView.m
//  EUExPopoverView
//
//  Created by liguofu on 15/1/19.
//  Copyright (c) 2015年 AppCan.can. All rights reserved.
//
#import "EUExPopoverView.h"
#import "EUtility.h"
#import "EBrowserView.h"
#import "JSON.h"
@implementation EUExPopoverView {
    NSString *popviewBgColor ;
    NSString *dividerColor;
    NSString *textColor;
    NSString *popviewID;
    NSMutableDictionary *dataDict;
    NSString *selectedKey;
    NSInteger row;
}

-(id)initWithBrwView:(EBrowserView *)eInBrwView {
    if (self = [super initWithBrwView:eInBrwView]) {
        self.popViewDataDict = [NSMutableDictionary dictionary];
        self.popViewTableViewDict = [NSMutableDictionary dictionary];
        dataDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setPopoverData:(NSMutableArray *)inArguments {
    
    NSString *jsonStr = nil;
    
    if (inArguments.count > 0) {
        jsonStr = [inArguments objectAtIndex:0];
        self.setPopoverDataDict = [jsonStr JSONValue];
        popviewID = [NSString stringWithFormat:@"%@",[self.setPopoverDataDict objectForKey:@"id"]];
        [self.popViewDataDict setObject:self.setPopoverDataDict forKey:popviewID];
    } else {
        return;
    }
}

- (void)showPopover:(NSMutableArray *)inArguments {
    
    NSString *jsonStr = nil;
    if(inArguments.count  > 0 ) {
        jsonStr = [inArguments objectAtIndex:0];
        self.popoverFrame= [jsonStr JSONValue];
    }
    NSString *openId = [NSString stringWithFormat:@"%@",[self.popoverFrame objectForKey:@"id"]];
    float x = [[self.popoverFrame objectForKey:@"x"] floatValue];
    float y = [[self.popoverFrame objectForKey:@"y"] floatValue];
    float w = [[self.popoverFrame objectForKey:@"w"] floatValue];
    float h = [[self.popoverFrame objectForKey:@"h"] floatValue];
    _popViewTableView =[_popViewTableViewDict objectForKey:openId];
    
    if (_popViewTableView) {
        
        if (_popViewTableView.hidden == YES) {
            _popViewTableView.hidden = NO;
        } else {
            
            return;
        }
    } else {
        
        dataDict = [self.popViewDataDict objectForKey:openId];
        if (dataDict) {
            //背景颜色
            popviewBgColor = [dataDict objectForKey:@"bgColor"];
            //分割线颜色
            dividerColor = [dataDict objectForKey:@"dividerColor"];
            //字体颜色
            textColor = [dataDict objectForKey:@"textColor"];
            self.dataArr = [dataDict objectForKey:@"data"];
            _popViewTableView = [[UITableView alloc] initWithFrame:CGRectMake(x, y, w, h) style:UITableViewStylePlain];
            _popViewTableView.backgroundColor = [UIColor clearColor];
            self.popViewTableView.dataSource = self;
            self.popViewTableView.delegate =self;
            self.popViewTableView.bounces = NO;
            [self.popViewTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
            self.popViewTableView.tableFooterView = [[UIView alloc] init];
            self.popViewTableView.separatorColor = [EUtility ColorFromString:dividerColor];
            self.popViewTableView.userInteractionEnabled = YES;
            [EUtility brwView:meBrwView addSubview:self.popViewTableView];
            [self.popViewTableViewDict setObject:_popViewTableView forKey:openId];
        }
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    PopViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil ) {
        cell = [[PopViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSArray *arr=[_popViewTableViewDict allKeys];
    for (NSString *key in arr) {
        
        if (tableView == [_popViewTableViewDict objectForKey:key]) {
            dataDict = [self.popViewDataDict objectForKey:key];
            self.dataArr = [dataDict objectForKey:@"data"];
            //背景颜色
            popviewBgColor = [dataDict objectForKey:@"bgColor"];
            //分割线颜色
            dividerColor = [dataDict objectForKey:@"dividerColor"];
            //字体颜色
            textColor = [dataDict objectForKey:@"textColor"];
        }
    }
    [cell setBackgroundColor:[EUtility ColorFromString:popviewBgColor]];
    NSString *iconImagePath = [[self.dataArr objectAtIndex:indexPath.row]objectForKey:@"icon"];
    NSString *title = [[self.dataArr objectAtIndex:indexPath.row]objectForKey:@"text"];
    iconImagePath = [self absPath:iconImagePath];
    UIImage *iconImage = [UIImage imageWithData:[self getImageDataByPath:iconImagePath]];
    cell.headView.image = iconImage;
    cell.titleLabel.text =title;
    cell.titleLabel.textColor  = [EUtility ColorFromString:textColor];
    [cell.titleLabel sizeToFit];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *arr=[_popViewTableViewDict allKeys];
    for (NSString *key in arr) {
        if (tableView == [_popViewTableViewDict objectForKey:key]){
            selectedKey = [[NSString alloc]initWithString:key];
            row = indexPath.row;
            [self performSelector:@selector(onClickItem) withObject:self afterDelay:0.1];
            return;
        }
    }
}

- (void) onClickItem {
    NSString *js = [NSString stringWithFormat:@"uexPopoverView.onItemClick(%ld);",(long)row];
    [self.meBrwView stringByEvaluatingJavaScriptFromString:js];
    [self hiddenSelectedPopView:[_popViewTableViewDict objectForKey:selectedKey]];
}

-(void)close:(NSMutableArray *) inArguments {
    
    if (inArguments.count > 0) {
        
        NSString *closePopViewID = [inArguments objectAtIndex:0];
        _popViewTableView =[_popViewTableViewDict objectForKey:closePopViewID];
        if (_popViewTableView) {
            [_popViewTableView removeFromSuperview];
            [_popViewTableViewDict removeObjectForKey:closePopViewID];
            _popViewTableView = nil;
        }
    }
}

- (void)hiddenPopover:(NSMutableArray *)inArguments {
    
    if (inArguments.count > 0) {
        NSString *hiddenPopoverID = [inArguments objectAtIndex:0];
        _popViewTableView =[_popViewTableViewDict objectForKey:hiddenPopoverID];
        if (_popViewTableView) {
            _popViewTableView.hidden = YES;
        }
    }
}

- (void)hiddenSelectedPopView:(UITableView *)selectedTable {
    
    if (selectedTable) {
        selectedTable.hidden = YES;
    }
    
}

-(NSData *)getImageDataByPath:(NSString *)imagePath {
    
    NSData *imageData = nil;
    if ([imagePath hasPrefix:@"http://"]) {
        NSURL *imagePathURL = [NSURL URLWithString:imagePath];
        imageData = [NSData dataWithContentsOfURL:imagePathURL];
        
    } else {
        
        imageData = [NSData dataWithContentsOfFile:imagePath];
    }
    return imageData;
}
@end
