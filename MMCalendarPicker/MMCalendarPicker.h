//
//  MMCalendarPicker.h
//  MMCalendarPicker
//
//  Created by 马扬 on 2016/11/8.
//  Copyright © 2016年 马扬. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^CALENDARBLOCK)(NSDate * date);
typedef void(^FRAMECHANGE)(CGRect frame);
@interface MMCalendarPicker : UIView<UICollectionViewDelegate , UICollectionViewDataSource>


- (instancetype)initWithFrame:(CGRect)frame todat:(NSDate *)today date:(NSDate *)date redFlagArray:(NSArray*)redFlagArray calendarBlock:(CALENDARBLOCK)calendarBlock changeFrame:(FRAMECHANGE)frameChangeBlock;


@end
