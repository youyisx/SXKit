//
//  SXValidLibrary.m
//  VSocial
//
//  Created by vince_wang on 2021/1/19.
//  Copyright © 2021 vince. All rights reserved.
//

#import "SXValidLibrary.h"
@interface NSString (SXDataUtility)
- (BOOL)sx_utility_isNumeric;
@end
@interface NSNumber (SXDataUtility)
+ (NSNumber *)sx_utility_numberWithString:(NSString *)string;
@end
@implementation NSString (SXDataUtility)
- (BOOL)sx_utility_isNumeric{
    if ([self length] == 0) return NO;
    
    NSScanner *sc = [NSScanner scannerWithString:self];
    if ([sc scanFloat:NULL]) return [sc isAtEnd];
    return NO;
}
@end
@implementation NSNumber (SXDataUtility)
+ (NSNumber *)sx_utility_numberWithString:(NSString *)string {
    if (string && [string sx_utility_isNumeric] ) {
        return [[self class] numberWithDouble:[string doubleValue]];
    } else {
        return [[self class] numberWithFloat:0.0f];
    }
}
@end


/**
 * 千位数转换
 */
NSString *sx_decimalStringWithObject(id object){
    NSString *numStr = sx_stringWithObject(object);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    NSNumber *number = [formatter numberFromString:numStr];
    NSString *string = [formatter stringFromNumber:number];
    string = sx_stringWithObject(string);
    if (!string.length) return numStr;
    return string;
}
/// 转换数字显示方式（xxxK or  1,123,1）
NSString *sx_kbFormatStringWithObject(id object){
    NSNumber *number_ = sx_numberWithObject(object);
    double value = [number_ doubleValue];
    if (value >= 10000) {
        value =  value/1000;
        NSDecimalNumber *decimalNum_ = [[NSDecimalNumber alloc] initWithString:@(value).stringValue];
        NSDecimalNumberHandler *handle = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:1 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        decimalNum_ = [decimalNum_ decimalNumberByRoundingAccordingToBehavior:handle];
        return [decimalNum_.stringValue stringByAppendingString:@"K"];
    }
    return sx_decimalStringWithObject(object);
}

/**
 *    Object转String
 *
 *    @param    object    Dictionary中的对象
 *
 *    @return    NSString
 */
NSString *sx_stringWithObject(id object) {
    
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    } else if ([object isKindOfClass:[NSNumber class]]) {
        return [object stringValue];
    } else {
        return @"";
    }
}

NSNumber *sx_numberWithObject(id object) {
    
    if ([object isKindOfClass:[NSNumber class]]) {
        return object;
    } else if ([object isKindOfClass:[NSString class]]) {
        return [NSNumber sx_utility_numberWithString:object];
    } else {
        return nil;
    }
}

NSDictionary *sx_dictionaryWithObject(id object) {
    if ([object isKindOfClass:[NSDictionary class]]) {
        return object;
    } else {
        return @{};
    }
}

NSArray *sx_arrayWithObject(id object) {
    if ([object isKindOfClass:[NSArray class]]) {
        return object;
    } else {
        return @[];
    }
}

id sx_objectInDictionaryForKey(NSDictionary *dictionary, id<NSCopying> key) {
    
    NSDictionary *_dictionary = sx_dictionaryWithObject(dictionary);
    
    return [_dictionary objectForKey:key];
}

id sx_objectInArrayAtIndex(NSArray *array, NSInteger index) {
    if (index < 0) return nil;
    NSArray *array_ = sx_arrayWithObject(array);
    
    if ([array_ count] > index) {
        return [array_ objectAtIndex:index];
    } else {
        return nil;
    }
}

NSString *sx_stringInArrayAtIndex(NSArray *array, NSUInteger index) {
    
    id object_ = sx_objectInArrayAtIndex(array, index);
    return sx_stringWithObject(object_);
}

NSNumber *sx_numberInArrayAtIndex(NSArray *array, NSUInteger index) {
    
    id object_ = sx_objectInArrayAtIndex(array, index);
    return sx_numberWithObject(object_);
}

NSDictionary *sx_dictionaryInArrayAtIndex(NSArray *array, NSUInteger index) {
    
    id object_ = sx_objectInArrayAtIndex(array, index);
    return sx_dictionaryWithObject(object_);
}

NSString *sx_stringInDictionaryForKey(NSDictionary *dictionary, id<NSCopying> key) {
    
    id object_ = sx_objectInDictionaryForKey(dictionary, key);
    return sx_stringWithObject(object_);
}

NSNumber *sx_numberInDictionaryForKey(NSDictionary *dictionary, id<NSCopying> key) {
    
    id object_ = sx_objectInDictionaryForKey(dictionary, key);
    return sx_numberWithObject(object_);
}

NSArray *sx_arrayInDictionaryForKey(NSDictionary *dictionary, id<NSCopying> key) {
    
    id object_ = sx_objectInDictionaryForKey(dictionary, key);
    return sx_arrayWithObject(object_);
}

NSDictionary *sx_dictionaryInDictionaryForKey(NSDictionary *dictionary, id<NSCopying> key) {
    
    id object_ = sx_objectInDictionaryForKey(dictionary, key);
    return sx_dictionaryWithObject(object_);
}

NSArray *sx_arrayInArrayForRange(NSArray *array, NSRange range) {
    NSArray * tempList_ = sx_arrayWithObject(array);
    if (tempList_.count == 0) return @[];
    if (tempList_.count >= range.location + range.length) return [tempList_ subarrayWithRange:range];
    if (range.location >= tempList_.count) return @[];
    return [tempList_ subarrayWithRange:NSMakeRange(range.location, tempList_.count - range.location)];
}

NSArray *sx_randomArrayInArrayForCount(NSArray *array, NSInteger count) {
    if (sx_arrayWithObject(array).count <= count) return sx_arrayWithObject(array);
    NSMutableArray *sources = sx_arrayWithObject(array).mutableCopy;
    NSMutableArray *result = @[].mutableCopy;
    for (int i = 0; i < count; i ++) {
        int randomIdx = arc4random_uniform((int)(sources.count));
        id object = sources[randomIdx];
        [result addObject:object];
        [sources removeObject:object];
        if (sources.count == 0) break;
    }
    return result;
}

/// 复制文本
void sx_copyTxt(NSString *txt) {
    [UIPasteboard generalPasteboard].string = sx_stringWithObject(txt);
}

@implementation NSMutableArray(SXSafeUtility)
- (void)sx_insertObject:(id)object index:(NSInteger)idx {
    if (object == nil || [object isKindOfClass:[NSNull class]]) return;
    if (idx >= self.count) {
        [self addObject:object];
    } else {
        [self insertObject:object atIndex:idx < 0 ? 0 : idx];
    }
}

- (void)sx_addObject:(id)object {
    if (object == nil || [object isKindOfClass:[NSNull class]]) return;
    [self addObject:object];
}
- (void)sx_removeObjectIndex:(NSInteger)idx {
    if (idx < 0 || idx >= self.count) return;
    [self removeObjectAtIndex:idx];
}
@end
