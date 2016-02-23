//
//  MJson.h
//
//  Created by Janky on 2/19/16.
//  Copyright © 2016 Janky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MJsonString)

- (NSArray*) toArray;
- (NSDictionary*) toDictionary;

@end

@interface NSDictionary (MJsonDictionary)
- (NSString*) toJsonStr;
@end


@interface NSArray (MJsonArray)
- (NSString*) toJsonStr;
@end
