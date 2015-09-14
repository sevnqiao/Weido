//
//  NSError+Additions.m
//  ListedCompany
//
//  Created by IOS_HMX on 15/7/27.
//  Copyright (c) 2015年 Mitake Inc. All rights reserved.
//

#import "NSError+Additions.h"

@implementation NSError (Additions)
-(NSString *)chineseDescription
{
    if (self.code == 400) {
        return @"请求无效";
    }else if(self.code == 401) {
        return @"访问拒绝";
    }else if(self.code == 403) {
        return @"请求被禁止";
    }else if(self.code == 404) {
        return @"无法找到文件";
    }else if(self.code == 405) {
        return @"资源被禁止";
    }else if(self.code == 406) {
        return @"客户端没有响应";
    }else if(self.code == 407) {
        return @"要求代理身份验证";
    }else if(self.code == 408) {
        return @"请求时服务器断开连接";
    }else if(self.code == 409) {
        return @"有冲突用户应该进行检查";
    }else if(self.code == 410) {
        return @"资源不可用";
    }else if(self.code == 411) {
        return @"服务器拒绝接受没有长度的请求";
    }else if(self.code == 412) {
        return @"先决条件失败";
    }else if(self.code == 413) {
        return @"请求太大";
    }else if(self.code == 414) {
        return @"请求URL太长";
    }else if(self.code == 415) {
        return @"不支持media类型";
    }else if(self.code == 449) {
        return @"在作了适当动作后重试";
    }else if(self.code == 500) {
        return @"服务器内部错误";
    }else if(self.code == 501) {
        return @"服务器不支持请求的功能";
    }else if(self.code == 502) {
        return @"网关错误";
    }else if(self.code == 503) {
        return @"过载";
    }else if(self.code == 504) {
        return @"连接超时";
    }else if(self.code == 505) {
        return @"不支持http的版本";
    }
    return @"";
}
@end
