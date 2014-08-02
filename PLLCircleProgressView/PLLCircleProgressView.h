//
//  PLLCircleView.h
//  DemoForCircle
//
//  Created by liu poolo on 14-8-1.
//  Copyright (c) 2014年 liu poolo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    KDrawModeSingle=0,
    KDrawModeGradient,
}DrawMode;

@interface PLLCircleProgressView : UIView

@property (nonatomic,assign,setter = setMaxValue:) float maxValue;
@property (nonatomic,assign,setter = setCurValue:) float curValue;
@property (nonatomic,assign) float lineWidth;
@property (nonatomic,assign) float radius;
@property (nonatomic,assign) DrawMode drawMode;//default is singleColor


//color
@property (nonatomic,strong) UIColor *circleOuterRaceBackgroundColor;

@property (nonatomic,strong) UIColor *circleOuterRaceForegroundColor;

@property (nonatomic,strong) UIColor *circleInterBackgroundColor;

-(void)setLineWidth:(float)lineWidth maxValue:(float) maxValue curValue:(float) curValue radius:(float)radius  circleOuterRaceBackgroundColor:(UIColor*)circleOuterRaceBackgroundColor circleOuterRaceForegroundColor:(UIColor*)circleOuterRaceForegroundColor circleInterBackgroundColor:(UIColor*)circleInterBackgroundColor;

-(void)setGradinetForeColorRed:(float)foreRed green:(float)foreGreen blue:(float)foreBlue alpha:(float)foreAplha andBackColorRed:(float)backRed green:(float)backGreen blue:(float)backBlue alpha:(float)backAplha;

@end
