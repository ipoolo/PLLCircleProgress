//
//  PLLViewController.m
//  DemoForCircle
//
//  Created by liu poolo on 14-8-1.
//  Copyright (c) 2014年 liu poolo. All rights reserved.
//

#import "PLLViewController.h"
#import "PLLCircleProgressView.h"
@interface PLLViewController ()

@end

@implementation PLLViewController
PLLCircleProgressView* cv;

- (void)viewDidLoad
{
    [super viewDidLoad];
    cv=[[PLLCircleProgressView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    [cv setLineWidth:10.0f maxValue:100 curValue:0 radius:100 circleOuterRaceBackgroundColor:[UIColor grayColor] circleOuterRaceForegroundColor:[UIColor orangeColor] circleInterBackgroundColor:[UIColor blackColor]];
//    [cv setGradinetForeColorRed:0.0 green:0.0 blue:1.0 alpha:1.0 andBackColorRed:0.0 green:1.0 blue:0.0 alpha:1.0];
    [self.view addSubview:cv];
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(addValue) userInfo:nil repeats:YES];

	// Do any additional setup after loading the view, typically from a nib.
}

-(void)addValue{
    [cv setCurValue:[cv curValue]+1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
