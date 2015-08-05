//
//  SettingCell.m
//  Lottery
//
//  Created by 熊云桥 on 15/5/20.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "SettingCell.h"
#import "SettingItem.h"
#import "SettingSwitchItem.h"
#import "SettingArrowItem.h"
#import "SettingLabelItem.h"


@interface SettingCell()

@property (nonatomic , strong)UISwitch *switchView;
@property (nonatomic , strong)UIImageView * imgView;
@property (nonatomic , strong)UILabel * labelView;

@property (nonatomic , strong)UIView *divider;

@end

@implementation SettingCell

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    self.divider.hidden = indexPath.row == 0;
}

- (UIView *)divider
{
    if (_divider == nil) {
        if(!IOS7){
            UIView * divider = [[UIView alloc]init];
            divider.backgroundColor = [UIColor blackColor];
            divider.alpha = 0.2;
            [self.contentView addSubview:divider];
            _divider = divider;
        }
    }
    return _divider;
}

- (UILabel *)labelView
{
    if (_labelView == nil) {
        _labelView = [[UILabel alloc]init];
        _labelView.bounds = CGRectMake(0, 0, 100, 44);
        _labelView.textColor = [UIColor redColor];
        _labelView.textAlignment = NSTextAlignmentRight;
//        _labelView.backgroundColor = [UIColor yellowColor];
       
    }
    return _labelView;
}

- (UIImageView *)imgView
{
    if (_imgView== nil) {
        _imgView= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CellArrow"]];
    }
    return _imgView;
}

- (UISwitch *)switchView
{
    if (_switchView == nil) {
        _switchView = [[UISwitch alloc]init];
    }
    return _switchView;
}

- (void)setItem:(SettingItem *)item
{
    _item = item;
    
    [self setupData];
    
    [self setupAccessoryView];
}

// 设置cell子控件的数据
- (void)setupData
{
    if (_item.icon.length) {
        self.imageView.image = [UIImage imageNamed:_item.icon];
    }
    self.textLabel.text = _item.title;
    
    self.detailTextLabel.text = _item.subTitle;
}
// 设置cell右边的视图
- (void)setupAccessoryView
{
    if ([_item isKindOfClass:[SettingArrowItem class]])
    {
        self.accessoryView = self.imgView;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    else if ([_item isKindOfClass:[SettingSwitchItem class]])
    {
        self.accessoryView = self.switchView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if ([_item isKindOfClass:[SettingLabelItem class]])
    {
        self.accessoryView = self.labelView;
        
        SettingLabelItem * labelItem = (SettingLabelItem *)_item;
        self.labelView.text = labelItem.text;
        
        
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    else
    {
        self.accessoryView = nil;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"cell";
    SettingCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SettingCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }    
    return  cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 设置背景图片
        UIView *bg = [[UIView alloc]init];
        bg.backgroundColor = [UIColor whiteColor];
        self.backgroundView = bg;
        
        // 设置选中时 的背景图片
        UIView *selectedBg = [[UIView alloc]init];
        selectedBg.backgroundColor = color(237, 233, 218);
        self.selectedBackgroundView = selectedBg;
        
        
        // 清空子视图的背景
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}


- (void)setFrame:(CGRect)frame
{
    if (!IOS7) {
        frame.size.width += 20;
        frame.origin.x -= 10;
    }
    
    [super setFrame:frame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.divider.frame = CGRectMake(0, 0, self.bounds.size.width, 1);
}

@end
