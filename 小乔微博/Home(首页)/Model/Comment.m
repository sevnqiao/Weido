//
//  Status.m
//  小乔微博
//
//  Created by 熊云桥 on 15/6/4.
//  Copyright (c) 2015年 Mr.X. All rights reserved.
//

#import "Comment.h"
#import "User.h"
#import "MJExtension.h"
#import "Photo.h"
@implementation Comment

- (NSString *)created_at
{
    // 刚刚 (1分钟内)
    // XX 分钟前 (1~59分钟内)
    // XX 小时前 (1~24小时内)
    // 昨天 XX-XX
    // XX:XX
    // XXXX-XX-XX XX:XX
    
    NSDateFormatter * fmt = [[NSDateFormatter alloc]init];
    fmt.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    
    
    // 微博的创建日期
    NSDate * createDate = [fmt dateFromString:_created_at];
    // 创建一个日历对象 (方便比较两个日期之间的差距)
    NSCalendar * calendar = [NSCalendar currentCalendar];
    // 代表想获得哪些差距
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算两个日期之间的差距
    NSDateComponents * components = [calendar components:unit fromDate:createDate toDate:[NSDate date] options:0];
    
    
    if (components.year == 0)
    {
        if (components.day <= 1)
        {
            if (components.hour >= 1) { // 多少小时前发得
                
                return [NSString stringWithFormat:@"%d小时前",components.hour];
            }
            else if (components.minute >= 1)
            {
                return [NSString stringWithFormat:@"%d分钟前",components.minute];
            }
            else
            {
                return @"刚刚";
            }
        }
        else if (components.day <= 2)
        {
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createDate];
        }
        else // 以前的
        {
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
        }
    }
    else
    { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd";
        return [fmt stringFromDate:createDate];
    }
}



@end
