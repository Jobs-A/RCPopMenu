//
//  RCPopMenu.m
//  RCDownSheet
//
//  Created by razeen on 1/4/16.
//  Copyright © 2016 razeen. All rights reserved.
//
#import "RCPopMenu.h"

static const CGFloat menuMarginSpace = 8;      //边缘距离
static const CGFloat menuRowHeight =  35;       //行高
static const CGFloat menuWidthScale = 0.42;    //菜单宽度
static const CGFloat menuMaskAlpha = 0.5;      //遮罩的透明透
static const CGFloat menuArrowWidth = 20;      //箭头的宽度
static const CGFloat menuArrowHeight = 10;     //箭头的高
static const NSInteger menuMaxCount = 10;      //一页最多能显示的行数
static const CGFloat menuFixScale = 8;         //视图修正常数
static const CGFloat menuCellMarginSpace = 18; //cell 图标前的空隙
static const CGFloat menuLineWidth = 0.5;      //cell 线的宽度
static const CGFloat menuCellFixScale = 10;    //cell 的上下空隙
//======================================================================================
#pragma mark - RCMenuModel
//======================================================================================

@implementation RCMenuModel
+ (instancetype)MenuTitle:(NSString *)title
                 IconName:(NSString *)iconName
                 Selected:(BOOL)selected
                   Target:(id)target
                   Action:(SEL)action
                     Data:(id)data{
    return [[RCMenuModel alloc]initTitle:title
                                IconName:iconName
                                Selected:selected
                                  Target:target
                                  Action:action
                                    Data:data];
}
- (instancetype)initTitle:(NSString *)title
                 IconName:(NSString *)iconName
                 Selected:(BOOL)selected
                   Target:(id)target
                   Action:(SEL)action
                     Data:(id)data{
    self = [super init];
    if (self) {
        self.title = title;
        self.icon = [UIImage imageNamed:iconName];
        self.selected = selected;
        self.target = target;
        self.action = action;
        self.data = data;
    }
    return self;
}

- (BOOL) enabled {
    return _target != nil && _action != NULL;
}

- (void) performAction {
    __strong id target = self.target;
    
    if (target && [target respondsToSelector:_action]) {
        
        [target performSelectorOnMainThread:_action withObject:self waitUntilDone:YES];
    }
}

- (NSString *) description {
    return [NSString stringWithFormat:@"<%@ #%p %@>", [self class], self, _title];
}

@end

//======================================================================================
#pragma mark - RCMenuCell
//======================================================================================
@interface RCMenuCell : UITableViewCell

@property (nonatomic, strong)UIView *separaView;
@property (nonatomic, strong)UIImageView *iconView;
@property (nonatomic, strong)UILabel *titleLabel;

- (void) setCell:(RCMenuModel *)model IsNeedLine:(BOOL)isNeedLine;

@end


@implementation RCMenuCell

- (void) setCell:(RCMenuModel *)model IsNeedLine:(BOOL)isNeedLine{
    
    
    for (UIView *v in self.contentView.subviews) {
        [v removeFromSuperview];
    }
    
    const CGFloat space  = kSCALE(menuCellFixScale);
    const CGFloat row    = kSCALE(menuRowHeight);
    const CGFloat margin = kSCALE(menuCellMarginSpace);
    
    const CGFloat iconX  = margin;
    const CGFloat iconY  = space;
    const CGFloat iconH  = row - 2 * space;
    const CGFloat iconW  = iconH;
    const CGFloat labelX = margin * 2 + iconW;
    const CGFloat labelY = space;
    const CGFloat labelW = menuWidthScale * kScreenWIDTH - margin * 3 - iconW;
    const CGFloat labelH = iconH;
    const CGFloat lineH  = menuLineWidth;
    const CGFloat lineY  = row - menuLineWidth;
    const CGFloat lineW  = menuWidthScale * kScreenWIDTH ;
    
    //icon
    self.iconView = [[UIImageView alloc]initWithFrame:CGRectMake(iconX, iconY, iconW , iconH)];
    self.iconView.image = model.icon;
    [self.contentView addSubview:self.iconView];
    
    //label
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = model.title;
    [self.titleLabel setFont:[UIFont systemFontOfSize:kSCALE(15)]];
    [self.contentView addSubview:self.titleLabel];
    
    
    //line
    if (isNeedLine) {
        self.separaView = [[UIView alloc]initWithFrame:CGRectMake(0, lineY , lineW, lineH)];
        self.separaView.backgroundColor =  RGBAA(208, 210, 206, 1);
        [self addSubview:self.separaView];
    }
    
    
    //
    if (model.selected == YES) {
        self.contentView.backgroundColor = [UIColor redColor];
    }else{
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}


- (void)awakeFromNib {
}


- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end


//======================================================================================
#pragma mark - ArrowView
//======================================================================================
@interface arrowView : UIView

@end

@implementation arrowView

+ (arrowView *)addArrowViewFromRect:(CGRect)rect{
    
    const CGFloat arrowX = rect.origin.x + rect.size.width/2 - kSCALE(menuArrowWidth) /2;
    const CGFloat arrowY = rect.origin.y + rect.size.height;
    const CGFloat arrowW = kSCALE(menuArrowWidth);
    const CGFloat arrowH = kSCALE(menuArrowHeight);
    
    arrowView *arrow = [[arrowView
                         alloc]initWithFrame:CGRectMake( arrowX , arrowY - menuFixScale, arrowW, arrowH + 4)];
    
    arrow.backgroundColor = [UIColor clearColor];
    return arrow;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    const CGFloat x = rect.origin.x;
    const CGFloat y = rect.origin.y;
    const CGFloat w = rect.size.width;
    const CGFloat h = rect.size.height;
    
    
    //设置背景颜色
    [[UIColor clearColor]set];
    UIRectFill([self bounds]);
    //拿到当前视图准备好的画板
    CGContextRef context = UIGraphicsGetCurrentContext();
    //利用path进行绘制三角形
    //标记
    CGContextBeginPath(context);
    //设置起点
    CGContextMoveToPoint(context, x, y+h);
    CGContextAddLineToPoint(context, x+w/2 ,y);
    CGContextAddLineToPoint(context, x+w  , y+h);
    //路径结束标志，不写默认封闭
    CGContextClosePath(context);
    //设置填充色
    
    [[UIColor whiteColor] setFill];
    //设置边框颜色
    [[UIColor whiteColor] setStroke];
    //绘制路径path
    CGContextDrawPath(context,kCGPathFillStroke);
    
    
}
/*
 - (void)drawBackground:(CGRect)frame
 inContext:(CGContextRef) context
 {
 CGFloat R0 = 1, G0 = 1, B0 = 1;
 CGFloat R1 = 0.99, G1 = 0.99, B1 = 0.99;
 
 self.backgroundColor = [UIColor clearColor];
 [self setOpaque:NO];
 UIColor *tintColor = [UIColor whiteColor];
 if (tintColor) {
 
 CGFloat a;
 [tintColor getRed:&R0 green:&G0 blue:&B0 alpha:&a];
 }
 
 CGFloat X0 = frame.origin.x;
 CGFloat X1 = frame.origin.x + frame.size.width;
 CGFloat Y0 = frame.origin.y;
 CGFloat Y1 = frame.origin.y + frame.size.height;
 
 // render arrow
 
 UIBezierPath *arrowPath = [UIBezierPath bezierPath];
 
 // fix the issue with gap of arrow's base if on the edge
 const CGFloat kEmbedFix = 3.f;
 
 
 const CGFloat arrowXM = 1;
 const CGFloat arrowX0 = arrowXM - menuArrowHeight;
 const CGFloat arrowX1 = arrowXM + menuArrowHeight;
 const CGFloat arrowY0 = Y0;
 const CGFloat arrowY1 = Y0 + menuArrowHeight + kEmbedFix;
 
 [arrowPath moveToPoint:    (CGPoint){arrowXM, arrowY0}];
 [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
 [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowY1}];
 [arrowPath addLineToPoint: (CGPoint){arrowXM, arrowY0}];
 
 [[UIColor colorWithRed:R0 green:G0 blue:B0 alpha:1] set];
 
 Y0 += menuArrowHeight;
 
 
 [arrowPath fill];
 
 // render body
 
 const CGRect bodyFrame = {X0, Y0, X1 - X0, Y1 - Y0};
 
 UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:bodyFrame
 cornerRadius:8];
 
 const CGFloat locations[] = {0, 1};
 const CGFloat components[] = {
 R0, G0, B0, 1,
 R1, G1, B1, 1,
 };
 
 CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
 CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace,
 components,
 locations,
 sizeof(locations)/sizeof(locations[0]));
 CGColorSpaceRelease(colorSpace);
 
 
 [borderPath addClip];
 
 CGPoint start, end;
 
 start = (CGPoint){X0, Y0};
 
 end = (CGPoint){X0, Y1};
 
 CGContextDrawLinearGradient(context, gradient, start, end, 0);
 
 CGGradientRelease(gradient);
 }
 */

@end


//======================================================================================
#pragma mark - RCMenuMenuView
//======================================================================================

@interface RCPopMenuView : UIView<UITableViewDataSource,UITableViewDelegate>{
    NSArray *_modelArray;
    CGRect   _itemRect;
}

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) UIView *maskView;

@end

@implementation RCPopMenuView


- (instancetype)initWithFrame:(CGRect)frame FromRect:(CGRect)rect ModelArray:(NSArray *)modelArray{
    
    self = [super initWithFrame:frame];
    if (self) {
        _modelArray = [NSArray arrayWithArray:modelArray];
        
        //set mask view
        self.maskView = [[UIView alloc]initWithFrame:self.frame];
        self.maskView.backgroundColor = [UIColor grayColor];
        self.maskView.alpha = menuMaskAlpha;
        [self addSubview:self.maskView];
        
        //set table view
        const CGFloat tableViewX = kScreenWIDTH * (1 - menuWidthScale) - menuMarginSpace;
        const CGFloat tableViewY = rect.origin.y  + rect.size.height + kSCALE(menuArrowHeight) - menuFixScale;
        const CGFloat tableViewW = kScreenWIDTH * menuWidthScale;
        CGFloat tableViewH;
        
        if (_modelArray.count  < menuMaxCount) {
            tableViewH = kSCALE(menuRowHeight) * _modelArray.count + 2 ;
        }else{
            tableViewH = kSCALE(menuRowHeight) * menuMaxCount ;
        }
        
        //set tableview
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(tableViewX,tableViewY ,tableViewW,tableViewH) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.alpha = 1;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.showsHorizontalScrollIndicator = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.layer.cornerRadius = 5.0f;
        //        self.tableView.layer.borderWidth = 1.5f;
        //        self.tableView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        
        
        [self addSubview:self.tableView];
        
        if (_modelArray.count < 10) {
            self.tableView.scrollEnabled = NO;
        }
        
        //setArrow
        [self addSubview:[arrowView addArrowViewFromRect:rect]];
    }
    return self;
}

//判断选择的位置，如果在下拉框之外 下拉框消失
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //    UITouch *oneTouch = [touches anyObject];
    //    CGPoint point = [oneTouch locationInView:self];
    [self removeFromSuperview];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"menuCell";
    
    RCMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[RCMenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    BOOL isNeedLine = YES;
    if (indexPath.row == _modelArray.count - 1) {
        isNeedLine = NO;
    }
    [cell setCell:_modelArray[indexPath.row] IsNeedLine:isNeedLine];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kSCALE(menuRowHeight);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RCMenuModel *model = _modelArray[indexPath.row];
    
    [model performAction];
    
    [self removeFromSuperview];
}

@end


//======================================================================================
#pragma mark - RCMenuMenu


@implementation RCPopMenu

+ (void)showMenuInView:(UIView *)view fromRect:(CGRect)rect menuItems:(NSArray *)menuItems {
    RCPopMenu *menu = [[RCPopMenu alloc]init];
    [menu showMenuInView:view fromRect:rect menuItems:menuItems];
}


- (void)showMenuInView:(UIView *)view fromRect:(CGRect)rect menuItems:(NSArray *)menuItems{
    
    RCPopMenuView *menuView = [[RCPopMenuView alloc]initWithFrame:view.frame FromRect:rect ModelArray:menuItems];
    
    [view addSubview:menuView];
    
}


@end



