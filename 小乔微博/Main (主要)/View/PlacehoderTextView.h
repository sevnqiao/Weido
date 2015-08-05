//
//  PlacehoderTextView.h
//  小乔微博
//
//  Created by 熊云桥 on 15/6/9.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlacehoderTextView : UITextView
/**
 *  占位文字
 */
@property (nonatomic , copy) NSString * placehoder;
/**
 *  占位文字的颜色
 */
@property (nonatomic , strong) UIColor * placehoderColor;
@end
