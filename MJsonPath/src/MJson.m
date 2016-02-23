//
//  MJson.m
//
//  Created by Janky on 2/19/16.
//  Copyright © 2016 Janky. All rights reserved.
//

#import "MJson.h"

@implementation NSString (MJsonString)


- (NSArray*) toArray {
    
    NSError *error = [[NSError alloc]init];
    NSArray *array =
    [NSJSONSerialization JSONObjectWithData: [self dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: &error];
    return array;
}

- (NSDictionary*) toDictionary{
   
    NSArray      *array = [self toArray];
    NSDictionary *dic   = [array objectAtIndex:0];
    
    return dic;
}

@end

@implementation NSDictionary (MJsonDictionary)

- (NSString*) toJsonStr {
    
    NSData  *jsonResultData = nil;
    NSArray *resultArray    = [NSArray arrayWithObject:self];
    NSString*jsonStr;
    if (YES == [NSJSONSerialization isValidJSONObject:resultArray]) {
        jsonResultData = [NSJSONSerialization dataWithJSONObject:resultArray options:NSJSONWritingPrettyPrinted error:nil];
        jsonStr = [[NSString alloc] initWithData:jsonResultData encoding:NSUTF8StringEncoding];
    }
    return jsonStr;
}

@end


@implementation NSArray (MJsonArray)

- (NSString*) toJsonStr {
    NSData   *jsonResultData = nil;
    NSString *jsonStr;
    if (YES == [NSJSONSerialization isValidJSONObject:self]) {
        jsonResultData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
        jsonStr = [[NSString alloc] initWithData:jsonResultData encoding:NSUTF8StringEncoding];
    }
    return jsonStr;
}



@end

