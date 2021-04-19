//
//  SXValidLibrary.h
//  VSocial
//
//  Created by vince_wang on 2021/1/19.
//  Copyright © 2021 vince. All rights reserved.
//

#import <Foundation/Foundation.h>

////////////////////////////////////////////////////////////////////////////////////////////////////
// 安全取得对象的方法，不用再作Check
////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * 千位数转换
 */
NSString *sx_decimalStringWithObject(id object);
/// 转换数字显示方式（xxxK or  1,123,1）
NSString *sx_kbFormatStringWithObject(id object);

/**
 *  @brief 不知道是什么对象，转为NSString
 *
 *  @param object 对象
 *
 *  @return string
 */
NSString *sx_stringWithObject(id object);

/**
 *  @brief 不知道是什么对象，转为NSNumber
 *
 *  @param object 对象
 *
 *  @return number
 */
NSNumber *sx_numberWithObject(id object);

/**
 *  @brief 不知道是什么对象，转为NSDictionary
 *
 *  @param object 对象
 *
 *  @return dictionary
 */
NSDictionary *sx_dictionaryWithObject(id object);

/**
 *  @brief 不知道是什么对象，转为NSArray
 *
 *  @param object 对象
 *
 *  @return array
 */
NSArray *sx_arrayWithObject(id object);

/**
 *  @brief 不知道是否为NSDictionary对象，取得对应Key的Value
 *
 *  @param dictionary dictionary
 *  @param key        key
 *
 *  @return id
 */
id sx_objectInDictionaryForKey(NSDictionary *dictionary, id<NSCopying> key);

/**
 * 不知道是否为NSArray对象，是否越界，取得对应Index的对象
 */
/**
 *  @brief 不知道是否为NSArray对象，是否越界，取得对应Index的对象
 *
 *  @param array array
 *  @param index index
 *
 *  @return id
 */
id sx_objectInArrayAtIndex(NSArray *array, NSInteger index);

/**
 * 不知道是否为NSArray对象，是否越界，取得对应NSString的对象
 */
/**
 *  @brief 不知道是否为NSArray对象，是否越界，取得对应NSString的对象
 *
 *  @param array array
 *  @param index index
 *
 *  @return string
 */
NSString *sx_stringInArrayAtIndex(NSArray *array, NSUInteger index);


/**
 *  @brief 不知道是否为NSArray对象，是否越界，取得对应NSNumber的对象
 *
 *  @param array array
 *  @param index index
 *
 *  @return number
 */
NSNumber *sx_numberInArrayAtIndex(NSArray *array, NSUInteger index);

/**
 *  @brief 不知道是否为NSArray对象，是否越界，取得对应NSDictionary的对象
 *
 *  @param array array
 *  @param index index
 *
 *  @return dictionary
 */
NSDictionary *sx_dictionaryInArrayAtIndex(NSArray *array, NSUInteger index);

/**
 *  @brief 不知道是否为NSDictionary对象，取得对应Key的Value NSString
 *
 *  @param dictionary dictionary
 *  @param key        key
 *
 *  @return string
 */
NSString *sx_stringInDictionaryForKey(NSDictionary *dictionary, id<NSCopying> key);

/**
 * 不知道是否为NSDictionary对象，取得对应Key的Value NSNumber
 */
/**
 *  @brief 不知道是否为NSDictionary对象，取得对应Key的Value NSNumber
 *
 *  @param dictionary dictionary
 *  @param key        key
 *
 *  @return number
 */
NSNumber *sx_numberInDictionaryForKey(NSDictionary *dictionary, id<NSCopying> key);

/**
 *  @brief 不知道是否为NSDictionary对象，取得对应Key的Value NSArray
 *
 *  @param dictionary dictionary
 *  @param key        key
 *
 *  @return array
 */
NSArray *sx_arrayInDictionaryForKey(NSDictionary *dictionary, id<NSCopying> key);

/**
 *  @brief 不知道是否为NSDictionary对象，取得对应Key的Value NSArray
 *
 *  @param dictionary dictionary
 *  @param key        key
 *
 *  @return dictionary
 */
NSDictionary *sx_dictionaryInDictionaryForKey(NSDictionary *dictionary, id<NSCopying> key);

/**
 *  @brief 按range取出subArray
 *
 *  @param array array
 *  @param range range
 *
 *  @return array
 */
NSArray *sx_arrayInArrayForRange(NSArray *array, NSRange range);

/**
 *  @brief 从array中随机取出指定数量的list
 *
 *  @param array array
 *  @param count 获取的数量
 *
 *  @return array
 */
NSArray *sx_randomArrayInArrayForCount(NSArray *array, NSInteger count);

/// 复制文本
void sx_copyTxt(NSString *txt);

@interface NSMutableArray(SXSafeUtility)
- (void)sx_insertObject:(id)object index:(NSInteger)idx;

- (void)sx_addObject:(id)object;

- (void)sx_removeObjectIndex:(NSInteger)idx;
@end


