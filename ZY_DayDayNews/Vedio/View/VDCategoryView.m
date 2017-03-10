//
//  VDCategoryView.m
//  ZY_DayDayNews
//
//  Created by guozengying on 2017/3/6.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import "VDCategoryView.h"

@implementation VDCategoryView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_WIDTH * 0.25);
        [self layoutView];
    }
    return self;
}
- (void)layoutView{
    
    NSArray * arr = @[@"奇葩",
                      @"萌宠",
                      @"美女",
                      @"精品"];
    NSArray *images = @[[UIImage imageNamed:@"qipa"],
                        [UIImage imageNamed:@"mengchong"],
                        [UIImage imageNamed:@"meinv"],
                        [UIImage imageNamed:@"jingpin"]
                        ];
    for (NSInteger i = 0; i < arr.count; i ++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setImage:images[i] forState:UIControlStateNormal];
        btn.tag = ZYTag;
        CGFloat btnW = KSCREEN_WIDTH/4;
        btn.titleLabel.font = [UIFont systemFontOfSize:15.f*Scale_Width];
        btn.frame = CGRectMake((btnW +1) * i, 0, btnW, self.height-5);
        [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:20.f];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height-1, KSCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    line.alpha = 0.8;
    [self addSubview:line];
}

- (void)buttonClick:(UIButton *)button{
    if (self.SelectBlock) {
        self.SelectBlock(button.tag - ZYTag, button.titleLabel.text);
    }
}

@end
