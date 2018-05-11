//
//  UIButton+ADSAdd.m
//  tools
//
//  Created by wcc on 2018/4/17.
//  Copyright © 2018年 ads. All rights reserved.
//

#import "UIButton+ADSAdd.h"



static const char *aKey;

@implementation UIButton (ADSAdd)

- (instancetype)initWithEventBlock:(ClickBlock)eventBlock
{
if (self = [super init]) {
    if (self.clickblock != eventBlock) {
        objc_setAssociatedObject(self, @selector(clickblock), eventBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
        
        [self addTarget:self
                 action:@selector(clickEvent:)
       forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self removeTarget:self
                    action:@selector(clickEvent:)
          forControlEvents:UIControlEventTouchUpInside];
    }
}
return self;
}

- (void)clickEvent:(UIButton *)button
{
if (self.clickblock) {
    self.clickblock(button);
}
}

- (void)setClickblock:(ClickBlock)clickblock
{
objc_setAssociatedObject(self, aKey, self.clickblock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ClickBlock)clickblock
{
return objc_getAssociatedObject(self, _cmd)  ;
}

@end
