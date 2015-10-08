//
//  MXApi.h
//  ListedCompany
//
//  Created by IOS_HMX on 15/7/20.
//  Copyright (c) 2015年 Mitake Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#define JOE_TEST

typedef void(^completionHandler)(AFHTTPRequestOperation *operation, id responseObject , NSString *errorMessage);


@interface XYQApi : NSObject
+ (void)cancelAllOperation;

+ (void)cancelOperation:(AFHTTPRequestOperation *)operation;

/** 获取accessToken */
+ (AFHTTPRequestOperation *)getAccessTokenWithCode:(NSString *)code
                                          ClientID:(NSString *)clientID
                                      CilentSecret:(NSString *)clientSecret
                                         GrantType:(NSString *)grantType
                                       RedirectURL:(NSString *)redirectURL
                                              type:(NSString *)type
                                           success:(void(^)(id json))success;
/** 发微博(不带照片) */
+ (AFHTTPRequestOperation *)ComposeWithOutImageStatus:(NSString *)status
                                                 type:(NSString *)type
                                          accessToken:(NSString *)accessToken
                                              success:(void(^)(id json))success;

/** 获取微博未读数 */
+ (AFHTTPRequestOperation *)getUnReadCountWithAccesstoken:(NSString *)accessToken
                                                      UID:(NSString *)UID
                                                     type:(NSString *)type
                                                  success:(void(^)(id json))success;

/** 上啦加载更多微博 */
+ (AFHTTPRequestOperation *)getMoreStatusWithAccessToken:(NSString *)accessToken
                                                   maxID:(NSNumber *)maxID
                                                    type:(NSString *)type
                                                 success:(void(^)(id json))success;

/** 加载最新更多 */
+ (AFHTTPRequestOperation *)getNewStatusWithAccessToken:(NSString *)accessToken
                                                 sinceID:(NSNumber *)sinceID
                                                    type:(NSString *)type
                                                 success:(void(^)(id json))success;

/** 根据id获得用户信息 (昵称) */
+ (AFHTTPRequestOperation *)getUserInfoWithAccessToken:(NSString *)accessToken
                                                   UID:(NSString *)UID
                                                  type:(NSString *)type
                                               success:(void(^)(id json))success;

/** 根据screenName获得用户信息 (昵称) */
+ (AFHTTPRequestOperation *)getUserInfoWithAccessToken:(NSString *)accessToken
                                            screenName:(NSString *)screenName
                                                  type:(NSString *)type
                                               success:(void(^)(id json))success;

/** 加载最新评论 */
+ (AFHTTPRequestOperation *)getNewCommentsWithAccessToken:(NSString *)accessToken
                                                 statusID:(NSString *)statusID
                                                    count:(NSString *)count
                                                  sinceID:(NSNumber *)sinceID
                                                     type:(NSString *)type
                                                  success:(void(^)(id json))success;
/** 加载更多评论 */
+ (AFHTTPRequestOperation *)getMoreCommentsWithAccessToken:(NSString *)accessToken
                                                  statusID:(NSString *)statusID
                                                     count:(NSString *)count
                                                   maxID:(NSNumber *)maxID
                                                      type:(NSString *)type
                                                   success:(void(^)(id json))success;

/** 删除微博评论 */
+ (AFHTTPRequestOperation *)destoryCommentWithAccessToken:(NSString *)accessToken
                                                commentID:(NSString *)commentID
                                                     type:(NSString *)type
                                                  success:(void(^)(id json))success;

/** 评论一条微博 */
+ (AFHTTPRequestOperation *)addCommentWithAccessToken:(NSString *)accessToken
                                              comment:(NSString *)comment
                                            commentID:(NSNumber *)commentID
                                                 type:(NSString *)type
                                              success:(void(^)(id json))success;

/** 回复一条评论 */
+(AFHTTPRequestOperation *)replyCommentWithAccessToken:(NSString *)accessToken
                                               comment:(NSString *)comment
                                              statusID:(NSNumber *)statusID
                                             commentID:(NSNumber *)commentID
                                                  type:(NSString *)type
                                               success:(void(^)(id json))success;

/** 转发一条微博 */
+ (AFHTTPRequestOperation *)repostStatusWithAccessToken:(NSString *)accessToken
                                                 status:(NSString *)status
                                               statusID:(NSNumber *)statusID
                                                   type:(NSString *)type
                                                success:(void(^)(id json))success;

/** 获取最新有关我的评论 */
+ (AFHTTPRequestOperation *)getMoreMyCommentWithAccessToken:(NSString *)accessToken
                                                      maxID:(NSNumber *)maxID
                                                      count:(NSNumber *)count
                                                       type:(NSString *)type
                                                    success:(void(^)(id json))success;


/** 获取最新有关我的评论 */
+ (AFHTTPRequestOperation *)getNewMyCommentWithAccessToken:(NSString *)accessToken
                                                   sinceID:(NSNumber *)sinceID
                                                     count:(NSNumber *)count
                                                      type:(NSString *)type
                                                   success:(void(^)(id json))success;

/** 获取更多关注人列表 */
+ (AFHTTPRequestOperation *)getMoreMyFriendsListWithAccessToken:(NSString *)accessToken
                                                        UID:(NSString *)UID
                                                 TrimStatus:(NSNumber *)trimStatus
                                                     curson:(NSString *)curson
                                                       type:(NSString *)type
                                                    success:(void(^)(id json))success;


/** 获取关注人列表 */
+ (AFHTTPRequestOperation *)getMyFriendsListWithAccessToken:(NSString *)accessToken
                                                        UID:(NSString *)UID
                                                 TrimStatus:(NSNumber *)trimStatus
                                                       type:(NSString *)type
                                                    success:(void(^)(id json))success;

/** 获取更多关注人列表 */
+ (AFHTTPRequestOperation *)getMoreMyFansListWithAccessToken:(NSString *)accessToken
                                                         UID:(NSString *)UID
                                                  TrimStatus:(NSNumber *)trimStatus
                                                      curson:(int)curson
                                                       count:(NSNumber *)count
                                                        type:(NSString *)type
                                                     success:(void(^)(id json))success;

/** 获取关注人列表 */
+ (AFHTTPRequestOperation *)getMyFansListWithAccessToken:(NSString *)accessToken
                                                     UID:(NSString *)UID
                                              TrimStatus:(NSNumber *)trimStatus
                                                   count:(NSNumber *)count
                                                    type:(NSString *)type
                                                 success:(void(^)(id json))success;

/** 取消关注 */
+ (AFHTTPRequestOperation *)cancelAttentionWithAccessToken:(NSString *)accessToken
                                                       UID:(NSString *)UID
                                                      type:(NSString *)type
                                                   success:(void(^)(id json))success;

/** 添加关注 */
+ (AFHTTPRequestOperation *)addAttentionWithAccessToken:(NSString *)accessToken
                                                    UID:(NSString *)UID
                                                   type:(NSString *)type
                                                success:(void(^)(id json))success;

/** 获取用户的照片列表 */
+ (AFHTTPRequestOperation *)getUserPhotosListWithAccessToken:(NSString *)accessToken
                                                         UID:(NSString *)UID
                                                        type:(NSString *)type
                                                     success:(void(^)(id json))success;

@end
