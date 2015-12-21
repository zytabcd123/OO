//
//  ZHDatePicker.h
//  OO
//
//  Created by ovfun on 15/12/21.
//  Copyright © 2015年 @天意. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PickerSelectedBlock)(NSDate *date);
typedef void(^pickerStateBlock)(NSInteger state);

@interface ZHDatePicker : UIView

@property(copy, nonatomic) PickerSelectedBlock selectedObj;
@property(copy, nonatomic) pickerStateBlock stateBlock;

@property(strong, nonatomic) IBOutlet UIDatePicker *myDatePicker;

+ (void)showDatePicker:(NSDate*)now
      pickerStateBlock:(void(^)(NSInteger state))pickerStateBlock
         selectedBlock:(void(^)(NSDate *date))selectedBlock;


@end
