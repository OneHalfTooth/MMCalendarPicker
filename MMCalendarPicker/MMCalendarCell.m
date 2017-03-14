//
//  MMCalendarCellCollectionViewCell.m
//  MMCalendarPicker
//
//  Created by 马扬 on 2016/11/8.
//  Copyright © 2016年 马扬. All rights reserved.
//

#import "MMCalendarCell.h"

@implementation MMCalendarCell


- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [_dateLabel setFont:[UIFont systemFontOfSize:17]];
        _dateLabel.layer.masksToBounds = YES;
        _dateLabel.layer.cornerRadius = self.bounds.size.width / 2.0;
        _dateLabel.userInteractionEnabled = YES;
        _dateLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_dateLabel];
    }
    return _dateLabel;
}
- (UIView *)redView{
    if (!_redView) {
        _redView = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.size.width / 2 - 4, self.bounds.size.height - 10, 8, 8)];
        _redView.backgroundColor = [UIColor blueColor];
        [self addSubview:_redView];
        _redView.layer.masksToBounds = YES;
        _redView.layer.cornerRadius = _redView.bounds.size.width / 2.0;
    }
    return _redView;
}



@end
