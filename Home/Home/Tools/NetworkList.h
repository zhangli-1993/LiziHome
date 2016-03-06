//
//  NetworkList.h
//  Home
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 scjy. All rights reserved.
//

#ifndef NetworkList_h
#define NetworkList_h
//首页轮播图接口
#define kCyclePictures @"http://api.bohejiaju.com/v2/banners"
//首页每日更新接口
#define kUpdate @"http://api.bohejiaju.com/v2/channels/5/items?limit=20&gender=2&generation=1"
//单品接口
#define kItem @"http://api.bohejiaju.com/v2/items?limit=20&gender=2&generation=1"
//分类页面接口
#define kClassify @"http://api.bohejiaju.com/v2/channel_groups/all"
//每一类接口
#define kKind @"http://api.bohejiaju.com/v2/channels/"
//首页轮播图详情接口
#define kCycleContent @"http://api.bohejiaju.com/v2/collections/"
//主题详情
#define kThemeContent @"http://api.bohejiaju.com/v1/posts/"
#define kGoodsContent @"http://api.bohejiaju.com/v2/items/"
#endif /* NetworkList_h */
