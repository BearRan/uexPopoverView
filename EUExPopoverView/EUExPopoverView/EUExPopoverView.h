//
//  EUExPopoverView.h
//  EUExPopoverView
//
//  Created by liguofu on 15/1/19.
//  Copyright (c) 2015年 AppCan.can. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EUExBaseDefine.h"
#import "EUExBase.h"
#import "EUtility.h"
#import "PopViewCell.h"

@interface EUExPopoverView : EUExBase <UITableViewDataSource,UITableViewDelegate>{
    BOOL currentStatus ;
}

@property (nonatomic, retain) NSMutableDictionary *setPopoverDataDict;
@property (nonatomic, retain) NSArray *dataArr;
@property (nonatomic, retain) NSMutableDictionary *popoverFrame;
@property (nonatomic, retain)  UITableView *popViewTableView;
@property (nonatomic, retain)  NSMutableDictionary *popViewDataDict;
@property (nonatomic, retain)  NSMutableDictionary *popViewTableViewDict;

@end
