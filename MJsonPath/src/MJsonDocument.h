//
//  MJsonDocument.h
//
//  Created by Janky on 2/22/16.
//  Copyright © 2016 Janky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJsonNodeType.h"

@interface MJsonDocument : NSObject

- (id) initWithJsonString:(NSString*)jsonStr;
- (id) getUpdated;

typedef NSString* (^MJsonReplaceHandler)(NSString *nodeName, NSString *nodeValue);

- (void) updateJsonWithPath:(NSString*)jsonPath andHandler:(MJsonReplaceHandler)handler;

@end
