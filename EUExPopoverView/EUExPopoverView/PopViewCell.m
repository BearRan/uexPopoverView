//
//  PopViewCell.m
//  AppCanPlugin
//
//  Created by liguofu on 15/1/30.
//  Copyright (c) 2015年 zywx. All rights reserved.
//

#import "PopViewCell.h"

@implementation PopViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self creatUI];
        
    }
    return self;
}

-(void)creatUI{
    _headView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    [self.contentView addSubview:_headView];
    
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 10, 100, 30)];
    [self.contentView addSubview:_titleLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:NO];

    // Configure the view for the selected state
}

@end
