//
//  YLYTableViewIndexView.m
//  城市选择Demo
//
//  Created by Kenfor-YF on 16/5/31.
//  Copyright © 2016年 Kenfor-YF. All rights reserved.
//

#import "YLYTableViewIndexView.h"
@interface YLYTableViewIndexView()
@property(nonatomic,strong)CAShapeLayer *shapeLayer;
@property(nonatomic,strong)NSArray *letters;
@property(nonatomic,assign)CGFloat letterHeight;

@end
@implementation YLYTableViewIndexView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)setup
{
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.lineWidth = 1.0f;
    self.shapeLayer.fillColor = [UIColor redColor].CGColor;
    self.shapeLayer.lineJoin = kCALineCapSquare;
    self.shapeLayer.strokeColor = [UIColor clearColor].CGColor;
    self.shapeLayer.strokeEnd = 1.0f;
    self.layer.masksToBounds = NO;
}

-(void)setTableIndexDelegate:(id<YLYTableViewIndexViewDelegate>)tableIndexDelegate
{
    _tableIndexDelegate = tableIndexDelegate;
    self.letters = [self.tableIndexDelegate tableViewIndexTitle:self];
    [self setup];
    [self setupShapeLayer];
}
-(void)setupShapeLayer
{
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    self.shapeLayer.frame = CGRectMake(0, 0, self.layer.frame.size.width, self.layer.frame.size.height);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(0, self.frame.size.height)];
    self.letterHeight = 16;
    CGFloat fontSize = 12;
    if (self.letterHeight < 14) {
        fontSize = 11;
    }
    [self.letters enumerateObjectsUsingBlock:^(NSString *letter, NSUInteger idx, BOOL *stop) {
        CGFloat originY = idx * self.letterHeight;
        CATextLayer *ctr = [self textLayerWithSize:fontSize string:letter andFrame:CGRectMake(0, originY, self.frame.size.width, self.letterHeight)];
        [self.layer addSublayer:ctr];
        [path moveToPoint:CGPointMake(0, originY)];
        [path addLineToPoint:CGPointMake(ctr.frame.size.width, originY)];
    }];
    self.shapeLayer.path = path.CGPath;
    [self.layer addSublayer:self.shapeLayer];
}
-(CATextLayer *)textLayerWithSize:(CGFloat)size string:(NSString *)title andFrame:(CGRect)frame
{
    CATextLayer *tl = [CATextLayer layer];
    [tl setFont:@"ArialMT"];
    [tl setFontSize:size];
    [tl setFrame:frame];
    [tl setAlignmentMode:kCAAlignmentCenter];
    [tl setContentsScale:[UIScreen mainScreen].scale];
    [tl setForegroundColor:[UIColor blackColor].CGColor];
    [tl setString:title];
    return tl;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self sendEventToDelegate:event];
    [self.tableIndexDelegate tableViewIndexTouchBegan:self];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self sendEventToDelegate:event];
    [self.tableIndexDelegate tableViewIndexTouchEnd:self];
}
-(void)sendEventToDelegate:(UIEvent *)event
{
    UITouch *touch = [[event allTouches]anyObject];
    CGPoint point = [touch locationInView:self];
    NSInteger index = (NSInteger)(point.y / self.letterHeight);
    if (index < 0 || index > self.letters.count - 1) {
        return;
    }
    [self.tableIndexDelegate tableViewIndex:self didSelectedAtIndex:index withTitle:self.letters[index]];
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self sendEventToDelegate:event];
}



@end
