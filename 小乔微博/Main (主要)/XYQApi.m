//
//  MXApi.m
//  ListedCompany
//
//  Created by IOS_HMX on 15/7/20.
//  Copyright (c) 2015年 Mitake Inc. All rights reserved.
//


#import "XYQApi.h"
#import "AFNetworking.h"
#import "XYQApiOperationManager.h"
#import "NSError+Additions.h"
#import "MBProgressHUD+MJ.h"

#define SERVER @"https://api.weibo.com"

@implementation XYQApi

/** 取消关注 */
+ (AFHTTPRequestOperation *)cancelAttentionWithAccessToken:(NSString *)accessToken
                                                       UID:(NSString *)UID
                                                      type:(NSString *)type
                                                   success:(void(^)(id json))success
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"access_token"] = accessToken;
    params[@"uid"] = UID;
    return [self sendRequest:[self urlStringWithPath:@"2/friendships/destroy.json"] parameters:params type:type success:^(id json) {
        success(json);
    }];
}

/** 添加关注 */
+ (AFHTTPRequestOperation *)addAttentionWithAccessToken:(NSString *)accessToken
                                                          UID:(NSString *)UID
                                                         type:(NSString *)type
                                                      success:(void(^)(id json))success
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"access_token"] = accessToken;
    params[@"uid"] = UID;
    return [self sendRequest:[self urlStringWithPath:@"2/friendships/create.json"] parameters:params type:type success:^(id json) {
        success(json);
    }];
}


/** 获取更多关注人列表 */
+ (AFHTTPRequestOperation *)getMoreMyFansListWithAccessToken:(NSString *)accessToken
                                                         UID:(NSString *)UID
                                                  TrimStatus:(NSNumber *)trimStatus
                                                      curson:(NSNumber *)curson
                                                       count:(NSNumber *)count
                                                        type:(NSString *)type
                                                     success:(void(^)(id json))success
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"access_token"] = accessToken;
    params[@"uid"] = UID;
    params[@"trim_status"] = trimStatus;
    params[@"cursor"] = curson;
    params[@"count"] = count;
    return [self sendRequest:[self urlStringWithPath:@"2/friendships/followers.json"] parameters:params type:type success:^(id json) {
        success(json);
    }];
}


/** 获取关注人列表 */
+ (AFHTTPRequestOperation *)getMyFansListWithAccessToken:(NSString *)accessToken
                                                     UID:(NSString *)UID
                                              TrimStatus:(NSNumber *)trimStatus
                                                   count:(NSNumber *)count
                                                    type:(NSString *)type
                                                 success:(void(^)(id json))success
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"access_token"] = accessToken;
    params[@"uid"] = UID;
    params[@"trim_status"] = trimStatus;
    params[@"count"] = count;
    return [self sendRequest:[self urlStringWithPath:@"2/friendships/followers.json"] parameters:params type:type success:^(id json) {
        success(json);
    }];
}


/** 获取更多关注人列表 */
+ (AFHTTPRequestOperation *)getMoreMyFriendsListWithAccessToken:(NSString *)accessToken
                                                        UID:(NSString *)UID
                                                 TrimStatus:(NSNumber *)trimStatus
                                                     curson:(NSString *)curson
                                                       type:(NSString *)type
                                                    success:(void(^)(id json))success
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"access_token"] = accessToken;
    params[@"uid"] = UID;
    params[@"trim_status"] = trimStatus;
    params[@"cursor"] = curson;
    return [self sendRequest:[self urlStringWithPath:@"2/friendships/friends.json"] parameters:params type:type success:^(id json) {
        success(json);
    }];
}


/** 获取关注人列表 */
+ (AFHTTPRequestOperation *)getMyFriendsListWithAccessToken:(NSString *)accessToken
                                                        UID:(NSString *)UID
                                                 TrimStatus:(NSNumber *)trimStatus
                                                       type:(NSString *)type
                                                    success:(void(^)(id json))success
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"access_token"] = accessToken;
    params[@"uid"] = UID;
    params[@"trim_status"] = trimStatus;
    return [self sendRequest:[self urlStringWithPath:@"2/friendships/friends.json"] parameters:params type:type success:^(id json) {
        success(json);
    }];
}

/** 获取最新有关我的评论 */
+ (AFHTTPRequestOperation *)getMoreMyCommentWithAccessToken:(NSString *)accessToken
                                                      maxID:(NSNumber *)maxID
                                                      count:(NSNumber *)count
                                                       type:(NSString *)type
                                                    success:(void(^)(id json))success
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"access_token"] = accessToken;
    if (maxID) {
        params[@"max_id"] = maxID;
    }
    params[@"count"] = count;
    return [self sendRequest:[self urlStringWithPath:@"2/comments/timeline.json"] parameters:params type:type success:^(id json) {
        success(json);
    }];
}

/** 获取最新有关我的评论 */
+ (AFHTTPRequestOperation *)getNewMyCommentWithAccessToken:(NSString *)accessToken
                                                sinceID:(NSNumber *)sinceID
                                                  count:(NSNumber *)count
                                                   type:(NSString *)type
                                                success:(void(^)(id json))success
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"access_token"] = accessToken;
    if (sinceID) {
        params[@"since_id"] = sinceID;
    }
    params[@"count"] = count;
    return [self sendRequest:[self urlStringWithPath:@"2/comments/timeline.json"] parameters:params type:type success:^(id json) {
        success(json);
    }];
}

/** 转发一条微博 */
+ (AFHTTPRequestOperation *)repostStatusWithAccessToken:(NSString *)accessToken
                                                status:(NSString *)status
                                               statusID:(NSNumber *)statusID
                                                   type:(NSString *)type
                                                success:(void(^)(id json))success
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"access_token"] = accessToken;
    params[@"status"] = status;
    params[@"id"] = statusID;
    return [self sendRequest:@"https://api.weibo.com/2/statuses/repost.json" parameters:params type:type success:^(id json) {
        success(json);
    }];
}


/** 回复一条评论 */
+ (AFHTTPRequestOperation *)replyCommentWithAccessToken:(NSString *)accessToken
                                                    comment:(NSString *)comment
                                                   statusID:(NSNumber *)statusID
                                                  commentID:(NSNumber *)commentID
                                                       type:(NSString *)type
                                                    success:(void(^)(id json))success
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"access_token"] = accessToken;
    params[@"comment"] = comment;
    params[@"cid"] = commentID;
    params[@"id"] = statusID;
    return [self sendRequest:[self urlStringWithPath:@"2/comments/reply.json"] parameters:params type:type success:^(id json) {
        success(json);
    }];
}

/** 评论一条微博 */
+ (AFHTTPRequestOperation *)addCommentWithAccessToken:(NSString *)accessToken
                                              comment:(NSString *)comment
                                            commentID:(NSNumber *)commentID
                                                 type:(NSString *)type
                                              success:(void(^)(id json))success
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"access_token"] = accessToken;
    params[@"comment"] = comment;
    params[@"id"] = commentID;
    return [self sendRequest:[self urlStringWithPath:@"2/comments/create.json"] parameters:params type:type success:^(id json) {
        success(json);
    }];
}


/** 删除微博评论 */
+ (AFHTTPRequestOperation *)destoryCommentWithAccessToken:(NSString *)accessToken
                                                 commentID:(NSString *)commentID
                                                     type:(NSString *)type
                                                  success:(void(^)(id json))success
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = accessToken;
    params[@"id"] = commentID;
    return [self sendRequest:[self urlStringWithPath:@"2/comments/destroy.json"] parameters:params type:type success:^(id json) {
        success(json);
    }];
}

/** 加载更多评论 */
+ (AFHTTPRequestOperation *)getMoreCommentsWithAccessToken:(NSString *)accessToken
                                                 statusID:(NSString *)statusID
                                                    count:(NSString *)count
                                                  maxID:(NSNumber *)maxID
                                                      type:(NSString *)type
                                                  success:(void(^)(id json))success
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = accessToken;
    params[@"id"] = statusID;
    params[@"count"] = count;
    if (maxID) {
        params[@"max_id"] = maxID;
    }
    return [self sendRequest:[self urlStringWithPath:@"2/comments/show.json"] parameters:params type:type success:^(id json) {
        success(json);
    }];
}

/** 加载最新评论 */
+ (AFHTTPRequestOperation *)getNewCommentsWithAccessToken:(NSString *)accessToken
                                                 statusID:(NSString *)statusID
                                                    count:(NSString *)count
                                                  sinceID:(NSNumber *)sinceID
                                                     type:(NSString *)type
                                                  success:(void(^)(id json))success
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = accessToken;
    params[@"id"] = statusID;
    params[@"count"] = count;
    if (sinceID) {
        params[@"since_id"] = sinceID;
    }
    return [self sendRequest:[self urlStringWithPath:@"2/comments/show.json"] parameters:params type:type success:^(id json) {
        success(json);
    }];
}


/** 根据screenName获得用户信息 (昵称) */
+ (AFHTTPRequestOperation *)getUserInfoWithAccessToken:(NSString *)accessToken
                                            screenName:(NSString *)screenName
                                                  type:(NSString *)type
                                               success:(void(^)(id json))success
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = accessToken;
    params[@"screen_name"] = screenName;
    return [self sendRequest:[self urlStringWithPath:@"2/users/show.json"] parameters:params type:type success:^(id json) {
        success(json);
    }];
}

/** 根据id获得用户信息 (昵称) */
+ (AFHTTPRequestOperation *)getUserInfoWithAccessToken:(NSString *)accessToken
                                                   UID:(NSString *)UID
                                                  type:(NSString *)type
                                               success:(void(^)(id json))success
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = accessToken;
    params[@"uid"] = UID;
    return [self sendRequest:[self urlStringWithPath:@"2/users/show.json"] parameters:params type:type success:^(id json) {
        success(json);
    }];
}


/**  加载最新更多 */
+ (AFHTTPRequestOperation *)getNewStatusWithAccessToken:(NSString *)accessToken
                                                sinceID:(NSNumber *)sinceID
                                                   type:(NSString *)type
                                                success:(void(^)(id json))success
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = accessToken;
    if (sinceID) {
        params[@"since_id"] = sinceID;
    }
    return [self sendRequest:[self urlStringWithPath:@"2/statuses/friends_timeline.json"] parameters:params type:type success:^(id json) {
        success(json);
    }];
}

/** 上拉加载更多 */
+ (AFHTTPRequestOperation *)getMoreStatusWithAccessToken:(NSString *)accessToken
                                                   maxID:(NSNumber *)maxID
                                                    type:(NSString *)type
                                                 success:(void(^)(id json))success
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = accessToken;
    if (maxID) {
        params[@"max_id"] = maxID;

    }
    return [self sendRequest:[self urlStringWithPath:@"2/statuses/friends_timeline.json"] parameters:params type:type success:^(id json) {
        success(json);
    }];
}



/** 获取微博未读数 */
+ (AFHTTPRequestOperation *)getUnReadCountWithAccesstoken:(NSString *)accessToken
                                                      UID:(NSString *)UID
                                                     type:(NSString *)type
                                                  success:(void(^)(id json))success
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"access_token"] = accessToken;
    params[@"uid"] = UID;
    return [self sendRequest:[self urlStringWithPath:@"2/remind/unread_count.json"] parameters:params type:@"GET" success:^(id json) {
        if (success) {
            success(json);
        }
    }];
}


/**
 *  根据code获取access_token
 *
 *  @param code
 *  @param clientID     AppKey
 *  @param clientSecret AppSecret
 *  @param grantType    @"authorization_code"
 *  @param redirectURL  回调地址
 *  @param type         请求方式
 */
+ (AFHTTPRequestOperation *)getAccessTokenWithCode:(NSString *)code
                                          ClientID:(NSString *)clientID
                                      CilentSecret:(NSString *)clientSecret
                                         GrantType:(NSString *)grantType
                                       RedirectURL:(NSString *)redirectURL
                                              type:(NSString *)type
                                           success:(void(^)(id json))success
{
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    parms[@"client_id"] = clientID;
    parms[@"client_secret"] = clientSecret;
    parms[@"grant_type"] = grantType;
    parms[@"code"] = code;
    parms[@"redirect_uri"] = redirectURL;
    return [self sendRequest:[self urlStringWithPath:@"oauth2/access_token"]
                  parameters:parms type:type success:^(id json) {
                      if (success) {
                          success(json);
                      }
                  }];
}

/**
 *  发微博(不带图片)
 *
 *  @param status  微博文字
 *  @param type    请求方式
 *  @param success 成功返回参数
 *  @param failure 失败返回参数
 */
+ (AFHTTPRequestOperation *)ComposeWithOutImageStatus:(NSString *)status
                                                 type:(NSString *)type
                                          accessToken:(NSString *)accessToken
                                              success:(void(^)(id json))success
{
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setObject:accessToken forKey:@"access_token"];
    [parms setObject:status forKey:@"status"];
    return [self sendRequest:[self urlStringWithPath:@"statuses/update.json"]
                  parameters:parms type:type success:^(id json) {
                      if (success) {
                          success(json);
                      }
                  }];
}

+(AFHTTPRequestOperation*)sendRequest:(NSString *)urlString parameters:(NSDictionary *)parameters type:(NSString *)type success:(void(^)(id json))success
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

#ifdef JOE_TEST
    NSTimeInterval ti = [[NSDate date] timeIntervalSince1970];
#endif
    AFHTTPRequestOperation *operation;
    if ([type isEqualToString:@"POST"]) {
        operation = [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
#ifdef JOE_TEST
            NSTimeInterval diff = [[NSDate date] timeIntervalSince1970] - ti;
            NSLog(@"耗时:%f秒", diff);
#endif
            if (success) {
                success(responseObject);
            }
            [[XYQApiOperationManager defaultManager]removeOperation:operation];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#ifdef JOE_TEST
            NSTimeInterval diff = [[NSDate date] timeIntervalSince1970] - ti;
            NSLog(@"耗时:%f秒", diff);
            NSLog(@"Error: %@  ==%@", error.description,error.chineseDescription);
#endif      
            NSString *errorDesc = [self getErrorDescWithErrorCode:[operation.responseObject[@"error_code"] intValue]];
            [MBProgressHUD showError:errorDesc];
            [[XYQApiOperationManager defaultManager]removeOperation:operation];
        }];
    }else if([type isEqualToString:@"GET"]){
        operation = [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
#ifdef JOE_TEST
            NSTimeInterval diff = [[NSDate date] timeIntervalSince1970] - ti;
            NSLog(@"耗时:%f秒", diff);
#endif
            if (success) {
                success(responseObject);
            }
            [[XYQApiOperationManager defaultManager]removeOperation:operation];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#ifdef JOE_TEST
            NSTimeInterval diff = [[NSDate date] timeIntervalSince1970] - ti;
            NSLog(@"耗时:%f秒", diff);
            NSLog(@"Error: %@  ==%@", error.description,error.chineseDescription);
#endif
            NSString *errorDesc = [self getErrorDescWithErrorCode:[operation.responseObject[@"error_code"] intValue]];
            [MBProgressHUD showError:errorDesc];
            [[XYQApiOperationManager defaultManager]removeOperation:operation];
        }];
    }

    [[XYQApiOperationManager defaultManager] addOperation:operation];
    NSLog(@"bady:%@",parameters);
    return operation;
}

+(NSString *)urlStringWithPath:(NSString *)path
{
    return [SERVER stringByAppendingPathComponent:path];
}

+(void)cancelAllOperation
{
    [[XYQApiOperationManager defaultManager] removeAllOperation];
}
+(void)cancelOperation:(AFHTTPRequestOperation *)operation
{
    [[XYQApiOperationManager defaultManager] removeOperation:operation];
}


+ (NSString *)getErrorDescWithErrorCode:(int)code
{
    NSString *errorDesc;
    switch (code) {
        case 10001:
            errorDesc = @"错误代码:10001 \n  错误信息:System error \n 详细描述:系统错误";
            break;
        case 10002:
            errorDesc = @"错误代码:10002 \n  错误信息:Service unavailable \n 详细描述:服务暂停";
            break;
        case 10003:
            errorDesc = @"10003 	Remote service error 	远程服务错误";
            break;
        case 10004:
            errorDesc = @"10004 	IP limit 	IP限制不能请求该资源";
            break;
        case 10005:
            errorDesc = @"10005 	Permission denied, need a high level appkey 	该资源需要appkey拥有授权";
            break;
        case 10006:
            errorDesc = @"10006 	Source paramter (appkey) is missing 	缺少source (appkey) 参数";
            break;
        case 10007:
            errorDesc = @"10007 	Unsupport mediatype (%s) 	不支持的MediaType (%s)";
            break;
        case 10008:
            errorDesc = @"10008 	Param error, see doc for more info 	参数错误，请参考API文档";
            break;
        case 10009:
            errorDesc = @"10009 	Too many pending tasks, system is busy 	任务过多，系统繁忙";
            break;
        case 10010:
            errorDesc = @"10010 	Job expired 	任务超时";
            break;
        case 10011:
            errorDesc = @"10011 	RPC error 	RPC错误";
            break;
        case 10012:
            errorDesc = @"10012 	Illegal request 	非法请求";
            break;
        case 10013:
            errorDesc = @"10013 	Invalid weibo user 	不合法的微博用户";
            break;
        case 10014:
            errorDesc = @"10014 	Insufficient app permissions 	应用的接口访问权限受限";
            break;
        case 10016:
            errorDesc = @"10016 	Miss required parameter (%s) , see doc for more info 	缺失必选参数 (%s)，请参考API文档";
            break;
        case 10017:
            errorDesc = @"10017 	Parameter (%s)'s value invalid, expect (%s) , but get (%s) , see doc for more info 	参数值非法，需为 (%s)，实际为 (%s)，请参考API文档";
            break;
        case 10018:
            errorDesc = @"10018 	Request body length over limit 	请求长度超过限制";
            break;
        case 10020:
            errorDesc = @"10020 	Request api not found 	接口不存在";
            break;
        case 10021:
            errorDesc = @"10021 	HTTP method is not suported for this request 	请求的HTTP METHOD不支持，请检查是否选择了正确的POST/GET方式";
            break;
        case 10022:
            errorDesc = @"10022 	IP requests out of rate limit 	IP请求频次超过上限";
            break;
        case 10023:
            errorDesc = @"10023 	User requests out of rate limit 	用户请求频次超过上限";
            break;
        case 10024:
            errorDesc = @"10024 	User requests for (%s) out of rate limit 	用户请求特殊接口 (%s) 频次超过上限";
            break;
            
        case 20001:
            errorDesc = @"20001 	IDs is null 	IDs参数为空";
            break;
        case 20002:
            errorDesc = @"20002 	Uid parameter is null 	Uid参数为空";
            break;
        case 20003:
            errorDesc = @"20003 	User does not exists 	用户不存在";
            break;
        case 20005:
            errorDesc = @"20005 	Unsupported image type, only suport JPG, GIF, PNG 	不支持的图片类型，仅仅支持JPG、GIF、PNG";
            break;
        case 20006:
            errorDesc = @"20006 	Image size too large 	图片太大";
            break;
        case 20007:
            errorDesc = @"20007 	Does multipart has image 	请确保使用multpart上传图片";
            break;
        case 20008:
            errorDesc = @"20008 	Content is null 	内容为空";
            break;
        case 20009:
            errorDesc = @"20009 	IDs is too many 	IDs参数太长了";
            break;
        case 20012:
            errorDesc = @"20012 	Text too long, please input text less than 140 characters 	输入文字太长，请确认不超过140个字符";
            break;
        case 20013:
            errorDesc = @"20013 	Text too long, please input text less than 300 characters 	输入文字太长，请确认不超过300个字符";
            break;
        case 20014:
            errorDesc = @"20014 	Param is error, please try again 	安全检查参数有误，请再调用一次";
            break;
        case 20015:
            errorDesc = @"20015 	Account or ip or app is illgal, can not continue 	账号、IP或应用非法，暂时无法完成此操作";
            break;
        case 20016:
            errorDesc = @"20016 	Out of limit 	发布内容过于频繁";
            break;
        case 20017:
            errorDesc = @"20017 	Repeat content 	提交相似的信息";
            break;
        case 20018:
            errorDesc = @"20018 	Contain illegal website 	包含非法网址";
            break;
        case 20019:
            errorDesc = @"20019 	Repeat conetnt 	提交相同的信息";
            break;
        case 20020:
            errorDesc = @"20020 	Contain advertising 	包含广告信息";
            break;
        case 20021:
            errorDesc = @"20021 	Content is illegal 	包含非法内容";
            break;
        case 20022:
            errorDesc = @"20022 	Your ip's behave in a comic boisterous or unruly manner 	此IP地址上的行为异常";
            break;
        case 20031:
            errorDesc = @"20031 	Test and verify 	需要验证码";
            break;
        case 20032:
            errorDesc = @"20032 	Update success, while server slow now, please wait 1-2 minutes 	发布成功，目前服务器可能会有延迟，请耐心等待1-2分钟";
            break;
        case 20101:
            errorDesc = @"20101 	Target weibo does not exist 	不存在的微博";
            break;
        case 20102:
            errorDesc = @"20102 	Not your own weibo 	不是你发布的微博";
            break;
        case 20103:
            errorDesc = @"20103 	Can't repost yourself weibo 	不能转发自己的微博";
            break;
        case 20104:
            errorDesc = @"20104 	Illegal weibo 	不合法的微博";
            break;
        case 20109:
            errorDesc = @"20109 	Weibo id is null 	微博ID为空";
            break;
        case 20111:
            errorDesc = @"20111 	Repeated weibo text 	不能发布相同的微博";
            break;
        case 20201:
            errorDesc = @"20201 	Target weibo comment does not exist 	不存在的微博评论";
            break;
        case 20202:
            errorDesc = @"20202 	Illegal comment 	不合法的评论";
            break;
        case 20203:
            errorDesc = @"20203 	Not your own comment 	不是你发布的评论";
            break;
        case 20204:
            errorDesc = @"20204 	Comment id is null 	评论ID为空";
            break;
        case 20301:
            errorDesc = @"20301 	Can't send direct message to user who is not your follower 	不能给不是你粉丝的人发私信";
            break;
        case 20302:
            errorDesc = @"20302 	Illegal direct message 	不合法的私信";
            break;
        case 20303:
            errorDesc = @"20303 	Not your own direct message 	不是属于你的私信";
            break;
        case 20305:
            errorDesc = @"20305 	Direct message does not exist 	不存在的私信";
            break;
        case 20306:
            errorDesc = @"20306 	Repeated direct message text 	不能发布相同的私信";
            break;
        case 20307:
            errorDesc = @"20307 	Illegal direct message id 	非法的私信ID";
            break;
        case 20401:
            errorDesc = @"20401 	Domain not exist 	域名不存在";
            break;
        case 20402:
            errorDesc = @"20402 	Wrong verifier 	Verifier错误";
            break;
        case 20501:
            errorDesc = @"20501 	Source_user or target_user does not exists 	参数source_user或者target_user的用户不存在";
            break;
        case 20502:
            errorDesc = @"20502 	Please input right target user id or screen_name 	必须输入目标用户id或者screen_name";
            break;
        case 20503:
            errorDesc = @"20503 	Need you follow user_id 	参数user_id必须是你关注的用户";
            break;
        case 20504:
            errorDesc = @"20504 	Can not follow yourself 	你不能关注自己";
            break;
        case 20505:
            errorDesc = @"20505 	Social graph updates out of rate limit 	加关注请求超过上限";
            break;
        case 20506:
            errorDesc = @"20506 	Already followed 	已经关注此用户";
            break;
        case 20507:
            errorDesc = @"20507 	Verification code is needed 	需要输入验证码";
            break;
        case 20508:
            errorDesc = @"20508 	According to user privacy settings,you can not do this 	根据对方的设置，你不能进行此操作";
            break;
        case 20509:
            errorDesc = @"20509 	Private friend count is out of limit 	悄悄关注个数到达上限";
            break;
        case 20510:
            errorDesc = @"20510 	Not private friend 	不是悄悄关注人";
            break;
        case 20511:
            errorDesc = @"20511 	Already followed privately 	已经悄悄关注此用户";
            break;
        case 20512:
            errorDesc = @"20512 	Please delete the user from you blacklist before you follow the user 	你已经把此用户加入黑名单，加关注前请先解除";
            break;
        case 20513:
            errorDesc = @" 20513 	Friend count is out of limit! 	你的关注人数已达上限";
            break;
        case 20521:
            errorDesc = @"20521 	Hi Superman, you have concerned a lot of people, have a think of how to make other people concern about you! ! If you have any questions, please contact Sina customer ";
            break;
        case 20522:
            errorDesc = @"20522 	Not followed 	还未关注此用户";
            break;
        case 20523:
            errorDesc = @"20523 	Not followers 	还不是粉丝";
            break;
        case 20524:
            errorDesc = @"20524 	Hi Superman, you have cancelled concerning a lot of people, have a think of how to make other people concern about you! ! If you have any questions, please contact Sina customer service: 400 690 0000 	hi 超人，你今天已经取消关注很多喽，接下来的时间想想如何让大家都来关注你吧！如有问题，请联系新浪客服：400 690 0000";
            break;
        case 20601:
            errorDesc = @"20601 	List name too long, please input text less than 10 characters 	列表名太长，请确保输入的文本不超过10个字符";
            break;
        case 20602:
            errorDesc = @"20602 	List description too long, please input text less than 70 characters 	列表描叙太长，请确保输入的文本不超过70个字符";
            break;
        case 20603:
            errorDesc = @"20603 	List does not exists 	列表不存在";
            break;
        case 20604:
            errorDesc = @"20604 	Only the owner has the authority 	不是列表的所属者";
            break;
        case 20605:
            errorDesc = @"20605 	Illegal list name or list description 	列表名或描叙不合法";
            break;
        case 20606:
            errorDesc = @"20606 	Object already exists 	记录已存在";
            break;
        case 20607:
            errorDesc = @"20607 	DB error, please contact the administator 	数据库错误，请联系系统管理员";
            break;
        case 20608:
            errorDesc = @"20608 	List name duplicate 	列表名冲突";
            break;
        case 20610:
            errorDesc = @"20610 	Does not support private list 	目前不支持私有分组";
            break;
        case 20611:
            errorDesc = @"20611 	Create list error 	创建列表失败";
            break;
        case 20612:
            errorDesc = @"20612 	Only support private list 	目前只支持私有分组";
            break;
        case 20613:
            errorDesc = @"20613 	You hava subscriber too many lists 	订阅列表达到上限";
            break;
        case 20614:
            errorDesc = @"20614 	Too many lists, see doc for more info 	创建列表达到上限，请参考API文档";
            break;
        case 20615:
            errorDesc = @"20615 	Too many members, see doc for more info 	列表成员上限，请参考API文档";
            break;
        case 20701:
            errorDesc = @"20701 	Repeated tag text 	不能提交相同的收藏标签";
            break;
        case 20702:
            errorDesc = @"20702 	Tags is too many 	最多两个收藏标签";
            break;
        case 20703:
            errorDesc = @"20703 	Illegal tag name 	收藏标签名不合法";
            break;
        case 20801:
            errorDesc = @"20801 	Trend_name is null 	参数trend_name是空值";
            break;
        case 20802:
            errorDesc = @"20802 	Trend_id is null 	参数trend_id是空值";
            break;
        case 20901:
            errorDesc = @" 20901 	Error: in blacklist 	错误:已经添加了黑名单";
            break;
        case 20902:
            errorDesc = @"20902 	Error: Blacklist limit has been reached. 	错误:已达到黑名单上限";
            break;
        case 20903:
            errorDesc = @"20903 	Error: System administrators can not be added to the blacklist. 	错误:不能添加系统管理员为黑名单";
            break;
        case 20904:
            errorDesc = @"20904 	Error: Can not add yourself to the blacklist. 	错误:不能添加自己为黑名单";
            break;
        case 20905:
            errorDesc = @"20905 	Error: not in blacklist 	错误:不在黑名单中";
            break;
        case 21001:
            errorDesc = @"21001 	Tags parameter is null 	标签参数为空";
            break;
        case 21002:
            errorDesc = @"21002 	Tags name too long 	标签名太长，请确保每个标签名不超过14个字符";
            break;
        case 21101:
            errorDesc = @"21101 	Domain parameter is error 	参数domain错误";
            break;
        case 21102:
            errorDesc = @"21102 	The phone number has been used 	该手机号已经被使用";
            break;
        case 21103:
            errorDesc = @"21103 	The account has bean bind phone 	该用户已经绑定手机";
            break;
        case 21104:
            errorDesc = @"21104 	Wrong verifier 	Verifier错误";
            break;
        case 21301:
            errorDesc = @"21301 	Auth faild 	认证失败";
            break;
        case 21302:
            errorDesc = @"21302 	Username or password error 	用户名或密码不正确";
            break;
        case 21303:
            errorDesc = @"21303 	Username and pwd auth out of rate limit 	用户名密码认证超过请求限制";
            break;
        case 21304:
            errorDesc = @"21304 	Version rejected 	版本号错误";
            break;
        case 21305:
            errorDesc = @"21305 	Parameter absent 	缺少必要的参数";
            break;
        case 21306:
            errorDesc = @"21306 	Parameter rejected 	OAuth参数被拒绝";
            break;
        case 21307:
            errorDesc = @"21307 	Timestamp refused 	时间戳不正确";
            break;
        case 21308:
            errorDesc = @"21308 	Nonce used 	参数nonce已经被使用";
            break;
        case 21309:
            errorDesc = @"21309 	Signature method rejected 	签名算法不支持";
            break;
        case 21310:
            errorDesc = @"21310 	Signature invalid 	签名值不合法";
            break;
        case 21311:
            errorDesc = @"21311 	Consumer key unknown 	参数consumer_key不存在";
            break;
        case 21312:
            errorDesc = @"21312 	Consumer key refused 	参数consumer_key不合法";
            break;
        case 21313:
            errorDesc = @"21313 	Miss consumer key 	参数consumer_key缺失";
            break;
        case 21314:
            errorDesc = @"21314 	Token used 	Token已经被使用";
            break;
        case 21315:
            errorDesc = @"21315 	Token expired 	Token已经过期";
            break;
        case 21316:
            errorDesc = @"21316 	Token revoked 	Token不合法";
            break;
        case 21317:
            errorDesc = @"21317 	Token rejected 	Token不合法";
            break;
        case 21318:
            errorDesc = @"21318 	Verifier fail 	Pin码认证失败";
            break;
        case 21319:
            errorDesc = @"21319 	Accessor was revoked 	授权关系已经被解除";
            break;
        case 21320:
            errorDesc = @"21320 	OAuth2 must use https 	使用OAuth2必须使用https";
            break;
        case 21321:
            errorDesc = @"21321 	Applications over the unaudited use restrictions 	未审核的应用使用人数超过限制";
            break;
        case 21327:
            errorDesc = @"21327 	Expired token 	token过期";
            break;
        case 21335:
            errorDesc = @"21335 	Request uid's value must be the current user 	uid参数仅允许传入当前授权用户uid";
            break;
        case 21501:
            errorDesc = @"21501 	Urls is null 	参数urls是空的";
            break;
        case 21502:
            errorDesc = @"21502 	Urls is too many 	参数urls太多了";
            break;
        case 21503:
            errorDesc = @"21503 	IP is null 	IP是空值";
            break;
        case 21504:
            errorDesc = @"21504 	Url is null 	参数url是空值";
            break;
        case 21601:
            errorDesc = @"21601 	Manage notice error, need auth 	需要系统管理员的权限";
            break;
        case 21602:
            errorDesc = @"21602 	Contains forbid world 	含有敏感词";
            break;
        case 21603:
            errorDesc = @"21603 	Applications send notice over the restrictions 	通知发送达到限制";
            break;
        case 21701:
            errorDesc = @"21701 	Manage remind error, need auth 	提醒失败，需要权限";
            break;
        case 21702:
            errorDesc = @"21702 	Invalid category 	无效分类";
            break;
        case 21703:
            errorDesc = @"21703 	Invalid status 	无效状态码";
            break;
        case 21901:
            errorDesc = @"21901 	Geo code input error 	地理信息输入错误";
            break;
        default:
            break;
    }
    return errorDesc;
}
@end
