//
//  PLLCircleView.m
//  DemoForCircle
//
//  Created by liu poolo on 14-8-1.
//  Copyright (c) 2014年 liu poolo. All rights reserved.
//

#import "PLLCircleProgressView.h"

@interface PLLCircleProgressView(){
    
}
@property (nonatomic,assign) float percenValue;//(value sizein 1~0)

@end


@implementation PLLCircleProgressView{
    UILabel* _title;
}

@synthesize percenValue=_percenValue;
NSArray *gradientColorArray;
float maxRadius;

-(CGFloat)percenValue{
    return _percenValue;
}

-(void)setPercenValue:(float)percenValue{
    if(_percenValue!=percenValue){
        _percenValue=percenValue;
        [self setNeedsDisplay];
    }
}

-(void)setMaxValue:(float)maxValue{
    if(_maxValue!=maxValue){
        _maxValue=maxValue;
        [self setPercenValue:_curValue/_maxValue];
    }
}

-(void)setCurValue:(float)curValue{
    if(_curValue!=curValue){
        _curValue=curValue;
        if(_curValue>_maxValue){

            _title.text=[NSString stringWithFormat:@"%0.0f 越界",curValue];
        }else{
            _title.text=[NSString stringWithFormat:@"%0.0f",curValue];
        }
        [self setPercenValue:_curValue/_maxValue];
    }
}

-(void)setLineWidth:(float)lineWidth maxValue:(float) maxValue curValue:(float) curValue radius:(float)radius  circleOuterRaceBackgroundColor:(UIColor*)circleOuterRaceBackgroundColor circleOuterRaceForegroundColor:(UIColor*)circleOuterRaceForegroundColor circleInterBackgroundColor:(UIColor*)circleInterBackgroundColor{
    _lineWidth=lineWidth;
    _maxValue=maxValue;
    _curValue=curValue;
    _radius=radius;
    _circleInterBackgroundColor=circleInterBackgroundColor;
    _circleOuterRaceBackgroundColor=circleOuterRaceBackgroundColor;
    _circleOuterRaceForegroundColor=circleOuterRaceForegroundColor;
    [self setNeedsDisplay];
}

-(void)setGradinetForeColorRed:(float)foreRed green:(float)foreGreen blue:(float)foreBlue alpha:(float)foreAplha andBackColorRed:(float)backRed green:(float)backGreen blue:(float)backBlue alpha:(float)backAplha{
    gradientColorArray=@[[NSNumber numberWithFloat:foreRed],[NSNumber numberWithFloat:foreGreen],[NSNumber numberWithFloat:foreBlue],[NSNumber numberWithFloat:foreAplha],[NSNumber numberWithFloat:backRed],[NSNumber numberWithFloat:backGreen],[NSNumber numberWithFloat:backBlue],[NSNumber numberWithFloat:backAplha]];
    self.drawMode=KDrawModeGradient;
}

#pragma mark - viewFrame
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque=NO;
        
        //title
        _title=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [self addSubview:_title];
        _title.center=self.center;
        _title.text=@"0";
        [_title setTextColor:[UIColor whiteColor]];
        [_title setTextAlignment:NSTextAlignmentCenter];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // Drawing outerraceBackground & interBackGround
    
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    maxRadius=((MIN(self.frame.size.width, self.frame.size.height)-self.lineWidth)/2);
    if(self.radius>maxRadius){
        self.radius=maxRadius;
    }
    
    CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, self.radius, 0, 2*M_PI, 1);
    [self.circleInterBackgroundColor setFill];
    [self.circleOuterRaceBackgroundColor setStroke];
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    
    //mask
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef imageCtx=UIGraphicsGetCurrentContext();
    CGContextAddArc(imageCtx, rect.size.width/2, rect.size.height/2, self.radius, M_PI*0.5, [self valueToRadian], 1);
    CGContextSetLineWidth(imageCtx, self.lineWidth);
    CGContextSetLineCap(imageCtx, kCGLineCapButt);
    CGContextDrawPath(imageCtx, kCGPathStroke);

    //mask 是bitmap才可 此处不能用UIImage转成CGImage
    CGImageRef mask=CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
    UIGraphicsEndImageContext();

    
    CGContextSaveGState(ctx);
    //clip前先存储以防需要使用clip前的状态
    CGContextClipToMask(ctx, self.bounds, mask);
    CGImageRelease(mask);
    
    if(self.drawMode==KDrawModeSingle){
    //        绘制单色
        CGContextAddRect(ctx,CGRectMake(0, 0, rect.size.width, rect.size.height));
        [self.circleOuterRaceForegroundColor setFill];
        CGContextDrawPath(ctx, kCGPathFill);
    }else if (self.drawMode==KDrawModeGradient){
    //      绘制渐变(梯度)
        CGFloat components[8]={
                                [(NSNumber*)[gradientColorArray objectAtIndex:0] floatValue],[(NSNumber*)[gradientColorArray objectAtIndex:1] floatValue],[(NSNumber*)[gradientColorArray objectAtIndex:2] floatValue],[(NSNumber*)[gradientColorArray objectAtIndex:3] floatValue], //foreColor
                                [(NSNumber*)[gradientColorArray objectAtIndex:4] floatValue],[(NSNumber*)[gradientColorArray objectAtIndex:5] floatValue],[(NSNumber*)[gradientColorArray objectAtIndex:6] floatValue],[(NSNumber*)[gradientColorArray objectAtIndex:7] floatValue]};//backColor
        
        //location 每个数字 代表对应颜色所在的位置0~1
        CGFloat locations[2]={
            0,
            1,
        };

        CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient=CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
        CGPoint startPonit=CGPointMake(CGRectGetMidX(rect),self.center.y-self.radius-self.lineWidth/2);
        CGPoint endPonit=CGPointMake(CGRectGetMidX(rect),self.center.y+self.radius+self.lineWidth/2);
            
        CGContextDrawLinearGradient(ctx, gradient, startPonit, endPonit, kCGGradientDrawsBeforeStartLocation);
            
        //kCGGradientDrawsAfterEndLocation endLocatio(结束点)之后也绘制
        //kCGGradientDrawsBeforeStartLocation StartLocation(开始点)之后也绘制
        CGGradientRelease(gradient),gradient=NULL;
    }
    
}


-(CGFloat)valueToRadian{//just return -1.5p~0.5p
    return [self subRadian:(-2*_percenValue+0.5)]*M_PI;
}

-(CGFloat)subRadian:(CGFloat)radian{

    if(radian>0.5){
        radian=[self subRadian:(radian-2)];
    }else if(radian<((-3.0f/2.0f))){
        radian=[self subRadian:(radian+2)];
    }
    return radian;
}


@end
