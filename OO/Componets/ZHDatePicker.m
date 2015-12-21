//
//  ZHDatePicker.m
//  OO
//
//  Created by ovfun on 15/12/21.
//  Copyright © 2015年 @天意. All rights reserved.
//

#import "ZHDatePicker.h"

@implementation ZHDatePicker
@synthesize selectedObj;
@synthesize myDatePicker;
@synthesize stateBlock;

+ (void)showDatePicker:(NSDate*)now
      pickerStateBlock:(void(^)(NSInteger state))pickerStateBlock
         selectedBlock:(void(^)(NSDate *date))selectedBlock{

    if (pickerStateBlock) {
        pickerStateBlock(1);
    }
    
    ZHDatePicker *pk = [[ZHDatePicker alloc]initWithDate:now];
    pk.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [pk setStateBlock:^(NSInteger state){
        
        if (pickerStateBlock) {
            pickerStateBlock(state);
        }
    }];
    [pk setSelectedObj:^(NSDate *dd){
        
        if (selectedBlock) {
            selectedBlock(dd);
        }
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:pk];
}

- (id)initWithDate:(NSDate*)now{
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"ZHDatePicker" owner:self options:nil] objectAtIndex:0];
    if (self) {
        
//        self.myDatePicker.date = now;
//        self.myDatePicker.minimumDate = [NSDate date];

    }
    return self;
}

- (IBAction)dateChanges:(id)sender{
    
//    if (self.selectedObj) {
//        self.selectedObj(self.myDatePicker.date);
//    }
}

- (IBAction)didOkAction:(id)sender{

    if (self.selectedObj) {
        self.selectedObj(self.myDatePicker.date);
    }
    [self cancel];
}

- (IBAction)didCancelAction:(id)sender{

    [self cancel];
}

- (IBAction)tapGestureAction:(UITapGestureRecognizer*)gesture{
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        [self cancel];
    }
}

- (void)cancel{
    
    if (self.stateBlock) {
        self.stateBlock(0);
    }
    
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.4 animations:^{
        
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

@end
