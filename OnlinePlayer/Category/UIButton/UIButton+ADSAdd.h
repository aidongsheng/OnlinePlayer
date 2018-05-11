//
//  UIButton+ADSAdd.h
//  tools
//
//  Created by wcc on 2018/4/17.
//  Copyright © 2018年 ads. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(UIButton *button);

@interface UIButton (ADSAdd)
@property (nonatomic,copy) ClickBlock clickblock;

- (instancetype)initWithEventBlock:(ClickBlock)eventBlock;

@end
