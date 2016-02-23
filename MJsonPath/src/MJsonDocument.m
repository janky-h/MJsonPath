//
//  MJsonDocument.m
//
//  Created by Janky on 2/22/16.
//  Copyright © 2016 Janky. All rights reserved.
//

#import "MJsonDocument.h"

@implementation MJsonDocument
{
    MJsonNodeType *_root;
}

- (id) initWithJsonString:(NSString *)jsonStr {
    self = [super init];
    if (self) {
        id jsonObject =
        [NSJSONSerialization JSONObjectWithData: [jsonStr dataUsingEncoding:NSUTF8StringEncoding]
                                        options: NSJSONReadingMutableContainers
                                          error: nil];
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            jsonObject = [jsonObject objectAtIndex:0];
        }
        _root = [[MJsonNodeType alloc]initWithObj:jsonObject];
    }
    return self;
}

- (id) getUpdated {
    return [_root composeChildren];
}

//- (MJsonNodeType*) getNodeByPath:(NSString*)path {
//    
//    // Split jsonPath
//    NSArray    *nodes    = [path componentsSeparatedByString:@"."];
//    NSUInteger nodeCount = [nodes count];
//    NSUInteger nodeIndex = 1;
//    
//    MJsonNodeType *currentNode = _root;
//    
//    for (NSString *nodeKey in nodes) {
//        
//        if (!currentNode) break;
//        
//        NSString   *condition = @"";
//        NSString   *key = nodeKey;
//        if ([nodeKey containsString:@"["]) {
//            
//            NSRange    conRange  = [nodeKey rangeOfString:@"["];
//            NSUInteger offset    = conRange.location;
//                       key       = [nodeKey substringToIndex:offset];
//                       condition = [nodeKey substringWithRange:NSMakeRange(offset+1, nodeKey.length - offset - 2)];
//        }
//        currentNode = [currentNode getNodeWithKey:key andCondition:condition];
//    }
//
//    return currentNode;
//}


//@{@"root":@{@"employees":@[@{@"firstname":@"janky",@"lastname":@"hu"},
//                           @{@"firstname":@"man",@"lastname":@"xu"},
//                           @{@"firstname":@"ccb",@"lastname":@"cheng"}
//                          ],
//           @"manager":@{@"name":@"janky",
//                      @"age":@18}
//           },
//  @"brother":@"baobao",
//  @"pet":@"kila",
// };

//@"root.employees[firstname=\"janky\"].lastname"

- (void) updateJsonWithPath:(NSString*)jsonPath andHandler:(MJsonReplaceHandler)handler {
    // Split jsonPath
    NSArray         *nodeKeys       = [jsonPath componentsSeparatedByString:@"."];
    NSMutableArray  *currentNodes   = [[NSMutableArray alloc]initWithObjects:_root, nil];
    
    for (NSString *nodeKey in nodeKeys) {
        
        if (0 == [currentNodes count]) break;
        
        NSString   *condition = @"";
        NSString   *key = nodeKey;
        if ([nodeKey containsString:@"["]) {
            
            NSRange    conRange  = [nodeKey rangeOfString:@"["];
            NSUInteger offset    = conRange.location;
                       key       = [nodeKey substringToIndex:offset];
                       condition = [nodeKey substringWithRange:NSMakeRange(offset+1, nodeKey.length - offset - 2)];
        }
        
        NSMutableArray *newCurrentNodes = [[NSMutableArray alloc]init];
        for (MJsonNodeType *node in currentNodes) {
            NSArray *matchNodes = [node getNodeWithKey:key andCondition:condition];
            if ([matchNodes count] > 0) [newCurrentNodes addObjectsFromArray:matchNodes];
        }
        [currentNodes removeAllObjects];
        [currentNodes addObjectsFromArray:newCurrentNodes];
    }
    
    // Update matched node field
    for (MJsonNodeType *node in currentNodes) {
        NSString *lastKey = [[nodeKeys lastObject]description];
        NSString *lastVal = [[node getNodeDictionary] objectForKey:lastKey];
        [node updateNodeWithKey:lastKey andObj:handler(lastKey,lastVal)];
    }
}

@end















