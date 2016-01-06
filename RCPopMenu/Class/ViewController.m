//
//  ViewController.m
//  RCPopMenu
//
//  Created by razeen on 1/6/16.
//  Copyright © 2016 razeen. All rights reserved.
//

#import "ViewController.h"
#import "RCPopMenu.h"
@interface ViewController (){
    
    NSMutableArray *_dropMenuArray;
}

- (IBAction)DownSheetClick:(id)sender;
@property (nonatomic) CGRect popMoreBtnRect;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    [self text2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)text2{
    
    _dropMenuArray = [[NSMutableArray alloc]initWithCapacity:0] ;
    
    for (int i = 0 ; i < 100;  i ++) {
        
        RCMenuModel *model = [[RCMenuModel alloc]initTitle:[NSString stringWithFormat:@"第%d行",i]
                                                  IconName:@"icon"
                                                  Selected:NO
                                                    Target:self
                                                    Action:@selector(selectedPopMenuItem:)
                                                      Data:@(i)];
        
        if (i == 10) {
            model.selected = YES;
        }
        
        
        [_dropMenuArray addObject:model];
    }
}



- (IBAction)DownSheetClick:(id)sender {
    
    [RCPopMenu showMenuInView:self.navigationController.view fromRect:self.popMoreBtnRect menuItems:_dropMenuArray ];
}


- (void)selectedPopMenuItem:(id)sender{
    
    RCMenuModel *model = (RCMenuModel *)sender;
    
    NSLog(@"%@",model.data);
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    //write your code here
}



- (CGRect)popMoreBtnRect
{
    if (CGRectEqualToRect(_popMoreBtnRect, CGRectZero)) {
        NSMutableArray* buttons = [[NSMutableArray alloc] init];
        for (UIControl* btn in self.navigationController.navigationBar.subviews)
            if ([btn isKindOfClass:NSClassFromString(@"UINavigationButton")])
                [buttons addObject:btn];
        if (buttons.count > 0) {
            UIView* view = [buttons lastObject];
            _popMoreBtnRect = [view convertRect:view.bounds toView:nil];
            //            _popMoreBtnRect.origin.y += 20;
        }
        else
        {
            _popMoreBtnRect = CGRectMake(kScreenWIDTH *4/5, topHeight, kScreenWIDTH / 5 - 5, 44);
        }
        
    }
    return _popMoreBtnRect;
}


@end
