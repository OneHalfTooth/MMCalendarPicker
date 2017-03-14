//
//  ViewController.m
//  MMCalendarPicker
//
//  Created by 马扬 on 2016/11/8.
//  Copyright © 2016年 马扬. All rights reserved.
//

#import "ViewController.h"
#import "MMCalendarPicker.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)buttonDidClick:(id)sender {
    NSDate * date = [NSDate date];
    MMCalendarPicker * calendarPicker = [[MMCalendarPicker alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 352) todat:date date:date redFlagArray:@[@"2016-11-09"] calendarBlock:^(NSDate * date) {
        NSLog(@"%@",date);
    } changeFrame:^(CGRect frame) {
        NSLog(@"%lf,%lf",frame.size.height,frame.origin.y);
    }];
    [self.view addSubview:calendarPicker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
