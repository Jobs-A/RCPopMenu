//
//  RCPopMenu.h
//  RCDownSheet
//
//  Created by razeen on 1/4/16.
//  Copyright © 2016 razeen. All rights reserved.
//
#import "RCHeader.h"


@interface RCMenuModel : NSObject

@property (readwrite, nonatomic, assign)id data;
@property (readwrite, nonatomic, strong)NSString *title;
@property (readwrite, nonatomic, strong)UIImage *icon;
@property (readwrite, nonatomic, assign) BOOL selected;
@property (readwrite, nonatomic, weak) id target;
@property (readwrite, nonatomic) SEL action;



+ (instancetype)MenuTitle:(NSString *)title
                 IconName:(NSString *)iconName
                 Selected:(BOOL)selected
                   Target:(id)target
                   Action:(SEL)action
                     Data:(id)data;

- (instancetype) initTitle:(NSString *)title
                  IconName:(NSString *)iconName
                  Selected:(BOOL)selected
                    Target:(id)target
                    Action:(SEL)action
                      Data:(id)data;

@end


@interface RCPopMenu : NSObject

+ (void) showMenuInView:(UIView *)view
               fromRect:(CGRect)rect
              menuItems:(NSArray *)menuItems;


@end
