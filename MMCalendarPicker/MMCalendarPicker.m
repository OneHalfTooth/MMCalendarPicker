//
//  MMCalendarPicker.m
//  MMCalendarPicker
//
//  Created by 马扬 on 2016/11/8.
//  Copyright © 2016年 马扬. All rights reserved.
//

#import "MMCalendarPicker.h"
#import "MMCalendarCell.h"


NSString *const MMCalendarCellIdentifier = @"cell";

@interface MMCalendarPicker ()

@property (nonatomic , strong)  UICollectionView *collectionView;
@property (nonatomic , strong)  UILabel *monthLabel;
@property (nonatomic , strong)  UIButton *previousButton;
@property (nonatomic , strong)  UIButton *nextButton;
@property (nonatomic , strong) NSArray *weekDayArray;
@property (nonatomic , strong) UIView *mask;
/** 日期数组 */
@property (nonatomic,strong)NSMutableArray  * todayArray;
@property (nonatomic,copy)FRAMECHANGE frameChangeBlock;
@property (nonatomic , strong) NSDate *date;
@property (nonatomic , strong) NSDate *today;
@property (nonatomic, copy) CALENDARBLOCK calendarBlock;

/** 现实小红点的数组 */
@property (nonatomic,strong)NSArray * redShowArray;

@end

@implementation MMCalendarPicker

- (instancetype)initWithFrame:(CGRect)frame todat:(NSDate *)today date:(NSDate *)date redFlagArray:(NSArray*)redFlagArray calendarBlock:(CALENDARBLOCK)calendarBlock changeFrame:(FRAMECHANGE)frameChangeBlock{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        self.today = today;
        self.date = date;
        self.redShowArray = redFlagArray;
        self.calendarBlock = calendarBlock;
        self.frameChangeBlock = frameChangeBlock;
        [self createTodayArray:today];
        
    }
    return self;
}

-(NSMutableArray *)todayArray{
    if (!_todayArray) {
        _todayArray = [[NSMutableArray alloc]init];
    }
    return _todayArray;
}

- (void)createTodayArray:(NSDate *)date{
    [self.todayArray removeAllObjects];
    
    NSInteger itemCount = 0;
    
    /** 这个月有几天 */
    NSInteger daysInThisMonth = [self totaldaysInMonth:_date];
    /** 当前月是从周几开始 */
    NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
    
    itemCount = daysInThisMonth + firstWeekday;
    NSInteger temp = itemCount / 7;
    NSInteger temp1 = itemCount % 7;
    if ((temp >= 5 && temp1 != 0) || temp == 6) {
        /** cell个数 */
        itemCount = 42;
      }else{
        itemCount = 35;
    }
    [self blackFrame:itemCount];
    /** 上个月有几天 */
    NSInteger daysInLastMonth = [self totaldaysInMonth:[self nextMonth:_date]];
    for (NSInteger i = firstWeekday; i > 0 ; i -- ) {
        
        NSString * dateS = [@([self year:[self lastMonth:self.date]]) stringValue];
        dateS = [dateS stringByAppendingString:@"-"];
        dateS = [dateS stringByAppendingString:[ NSString stringWithFormat:@"%2.ld",[self month:[self lastMonth:self.date]]]];
        dateS = [dateS stringByAppendingString:@"-"];
        dateS = [dateS stringByAppendingString:[NSString stringWithFormat:@"%2.ld",daysInLastMonth - i + 1]];
        [self.todayArray addObject:dateS];
        
    }
    for (NSInteger i = 0; i < daysInThisMonth; i ++) {
        NSString * dateS = [@([self year:self.date]) stringValue];
        dateS = [dateS stringByAppendingString:@"-"];
        dateS = [dateS stringByAppendingString:[ NSString stringWithFormat:@"%2.ld",[self month:self.date]]];
        dateS = [dateS stringByAppendingString:@"-"];
        dateS = [dateS stringByAppendingString:[NSString stringWithFormat:@"%.2ld",i + 1]];
        [self.todayArray addObject:dateS];
    }
    NSInteger flag = self.todayArray.count;
    for (NSInteger i = 1; i <= (itemCount - flag); i++) {
        NSString * dateS = [@([self year:[self nextMonth:self.date]]) stringValue];
        dateS = [dateS stringByAppendingString:@"-"];
        dateS = [dateS stringByAppendingString:[NSString stringWithFormat:@"%.2ld",[self month:[self nextMonth:self.date]]]];
        dateS = [dateS stringByAppendingString:@"-"];
        dateS = [dateS stringByAppendingString:[NSString stringWithFormat:@"%.2ld",i]];
        [self.todayArray addObject:dateS];
        
    }
    [self.collectionView reloadData];
}

#pragma mark -- frame 回调
- (void)blackFrame:(NSInteger)count{
    if (count == 42) {
        if (self.frameChangeBlock) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width,  self.bounds.size.width + 44);
            self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y,  self.bounds.size.width, self.bounds.size.width);
            self.frameChangeBlock(self.frame);
        }
    }else{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width,  self.bounds.size.width / 7.0 * 6.0 + 44);
        self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y, self.bounds.size.width, self.bounds.size.width / 7.0 * 6.0);
        self.frameChangeBlock(self.frame);
    }
}
#pragma mark -- UI创建
- (void)createView{
    [self createMaskView];
    [self createMonthLabel];
    [self createPreviousButton];
    [self createNextButton];
    [self createCollectionView];
    [self addSwipe];
}

- (void)createNextButton{
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.frame = CGRectMake(10, 7, 30, 30);
    [self.nextButton setImage:[UIImage imageNamed:@"bt_previous"] forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nexAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mask addSubview:self.nextButton];
    
}

- (void)createPreviousButton{
    self.previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.previousButton.frame = CGRectMake(self.bounds.size.width - 40, 7, 30, 30);
    [self.previousButton setImage:[UIImage imageNamed:@"bt_next"] forState:UIControlStateNormal];
    [self.previousButton addTarget:self action:@selector(previouseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mask addSubview:self.previousButton];
}
- (void)createMonthLabel{
    self.monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, self.bounds.size.width - 100, 44)];
    self.monthLabel.textAlignment = NSTextAlignmentCenter;
    [self.mask addSubview:self.monthLabel];
}
- (void)createMaskView{
    self.mask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44)];
    self.mask.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:242 / 255.0 blue:245 / 255.0 alpha:1];
    [self addSubview:self.mask];
    
}

- (void)createCollectionView{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height -  self.mask.frame.size.height -  self.mask.frame.origin.y;
    CGFloat itemWidth = width / 7;
    CGFloat itemHeight = width / 7;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.mask.frame.size.height +  self.mask.frame.origin.y, width, height) collectionViewLayout:layout];
    _collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [_collectionView registerClass:[MMCalendarCell class] forCellWithReuseIdentifier:MMCalendarCellIdentifier];
    _weekDayArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    self.collectionView.backgroundColor = [UIColor redColor];
    self.collectionView.bounces = NO;
    [self addSubview:_collectionView];
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    [_monthLabel setText:[NSString stringWithFormat:@"%ld年%ld月",[self year:date],[self month:date]]];
    [_collectionView reloadData];
}

#pragma mark - date

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}


- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}


- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

- (NSInteger)totaldaysInThisMonth:(NSDate *)date{
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totaldaysInMonth.length;
}


/** 返回这个月的长度 */
- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}
- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

#pragma -mark collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return _weekDayArray.count;
    } else {
        return self.todayArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MMCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MMCalendarCellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [cell.dateLabel setText:_weekDayArray[indexPath.row]];
        [cell.dateLabel setTextColor:[UIColor colorWithRed:153 /255.0 green:153 /255.0 blue:153 /255.0 alpha:1]];
        cell.dateLabel.backgroundColor = [UIColor whiteColor];
        cell.redView.hidden = YES;
    } else {
        if(self.todayArray.count > indexPath.row){
            
            NSString * text = [self.todayArray objectAtIndex:indexPath.row];
            NSArray * arr = [text componentsSeparatedByString:@"-"];
            NSString * munth = [NSString stringWithFormat:@"%.2ld",[self month:self.date]];
            if ([arr[1] isEqualToString:munth]) {
                cell.dateLabel.text = [@( [arr[2] integerValue]) stringValue];
                cell.dateLabel.textColor = [UIColor colorWithRed:53 / 255.0 green:53 / 255.0 blue:53 / 255.0 alpha:1];
            }else{
                cell.dateLabel.text = [@( [arr[2] integerValue]) stringValue];
                cell.dateLabel.textColor = [UIColor grayColor];
                cell.dateLabel.backgroundColor = [UIColor whiteColor];
            }
            
            NSString * mouStr = [NSString stringWithFormat:@"%.2ld", [self month:self.today]];
            NSInteger day = [self day:self.today];
            NSString * dayStr = [NSString stringWithFormat:@"%.2ld",day];
            if ([arr[2] isEqualToString:dayStr] && [arr[1] isEqualToString:mouStr]) {
                cell.dateLabel.backgroundColor = [UIColor redColor];
            }else{
                cell.dateLabel.backgroundColor = [UIColor whiteColor];
            }
            for (NSString * time in self.redShowArray) {
                if ([time isEqualToString:text]) {
                    cell.redView.hidden = NO;
                }else{
                    cell.redView.hidden = YES;
                }
            }
        }
        
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(self.todayArray.count > indexPath.row){
        NSString * text = [self.todayArray objectAtIndex:indexPath.row];
        NSArray * arr = [text componentsSeparatedByString:@"-"];
        NSString * munth = [NSString stringWithFormat:@"%.2ld",[self month:self.date]];
        if ([arr[1] isEqualToString:munth]) {
            if (self.calendarBlock) {
                NSDateFormatter * format = [[NSDateFormatter alloc]init];
                format.dateFormat = @"yyyy-MM-dd";
                NSDate * date = [format dateFromString:text];
                self.calendarBlock(date);
                self.today = date;
                [self.collectionView reloadData];
            }
        }else{
            if ([arr[0]integerValue] > [self year:self.date]) {
                [self nexAction:nil];
                return;
            }
            if ([arr[1] integerValue] < [self month:self.date]) {
                [self previouseAction:nil];
            }else{
                [self nexAction:nil];
            }
        }
        
    }
    
}

- (void)previouseAction:(UIButton *)sender
{
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^(void) {
        self.date = [self lastMonth:self.date];
        [self createTodayArray:self.date];
    } completion:nil];
}

- (void)nexAction:(UIButton *)sender
{
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^(void) {
        self.date = [self nextMonth:self.date];
        [self createTodayArray:self.date];
    } completion:nil];
}


- (void)show
{
    self.transform = CGAffineTransformTranslate(self.transform, 0, - self.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL isFinished) {
    }];
}


- (void)addSwipe
{
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nexAction:)];
    swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipLeft];
    
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previouseAction:)];
    swipRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipRight];
}
@end
