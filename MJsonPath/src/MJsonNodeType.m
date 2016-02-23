//
//  MJsonNodeType.m
//
//  Created by Janky on 2/22/16.
//  Copyright © 2016 Janky. All rights reserved.
//

#import "MJsonNodeType.h"

@implementation MJsonNodeType
{
    NSMutableDictionary   *_childrenDic; // Contains MJsonNodeType*
    NSMutableArray        *_childrenArray;
    lktJsonNodeType       _nodeType;
}

@synthesize _nodeValue;

/**
 *  Init
 *
 *  @param obj Json object (NSDictionary or NSArray)
 *
 *  @return MJsonNodeType
 */
- (id) initWithObj:(id)obj {
    
    self = [super init];
    if (self) {
        _nodeValue     = obj;
        _nodeType      = [self getType:obj];
        _childrenDic   = [[NSMutableDictionary alloc]init];
        _childrenArray = [[NSMutableArray alloc]init];
        [self parseChild];
    }
    return self;
}


/**
 *  Retrieve current node type
 *
 *  @return  lktJsonNodeType
 */
- (lktJsonNodeType) getNodeType {
    return _nodeType;
}


/**
 *  Retrieve current node's array value
 *
 *  @return NSArray
 */
- (NSArray*) getNodeArray {
    return _childrenArray;
}

/**
 *  Parse the current node's child
 */
- (void) parseChild {
    
    switch (_nodeType) {
        case lktDictionary:
            [self parseDictionary];
            break;
        case lktArray:
            [self parseArray];
            break;
        default:
            break;
    }
}


/**
 *  If current is a dictionary, enumerate its keys and parse them into MJsonNodeType
 */
- (void) parseDictionary {
    NSDictionary *objDic = (NSDictionary*)_nodeValue;
    [objDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id childObj = obj;
        if (lktArray == [self getType:obj] || lktDictionary == [self getType:obj]) {
            childObj = [[MJsonNodeType alloc]initWithObj:obj];
        }
        [_childrenDic setObject:childObj forKey:key];
    }];
}

/**
 *  If current node is an array
 */
- (void) parseArray {
    for (id obj in _nodeValue) {
        [_childrenArray addObject:[[MJsonNodeType alloc]initWithObj:obj]];
    }
}


- (lktJsonNodeType) getType:(id)obj {
    
    lktJsonNodeType type = lktString;
    
    if ([obj isKindOfClass:[NSArray class]]) {
        type = lktArray;
    }
    else if ([obj isKindOfClass:[NSDictionary class]]) {
        type = lktDictionary;
    }
    else if ([obj isKindOfClass:[NSString class]]) {
        type = lktString;
    }
    else if ([obj isKindOfClass:[NSNumber class]]) {
        type = lktInt;
    }

    return type;
}

- (id) composeDictionary {
    NSMutableDictionary *composed = [[NSMutableDictionary alloc]init];
    [_childrenDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id childObj = obj;
        if ([obj isKindOfClass:[MJsonNodeType class]]) {
            MJsonNodeType *nodeType = (MJsonNodeType*)obj;
            childObj = [nodeType composeChildren];
        }
        
        [composed setObject:childObj forKey:key];
    }];
    return composed;
}

- (id) composeArray {
    NSMutableArray *composed = [[NSMutableArray alloc]init];
    for (MJsonNodeType *nodeType in _childrenArray) {
        [composed addObject:[nodeType composeChildren]];
    }
    return composed;
}


/**
 *  Compose current node's children into a single object (NSDictionary or NSArray)
 *
 *  @return Composed single json object
 */
- (id) composeChildren {
    
    id result = nil;
    switch (_nodeType) {
        case lktDictionary:
            result = [self composeDictionary];
            break;
        case lktArray:
            result = [self composeArray];
            break;
            
        default:
            break;
    }
    return result;
}


- (BOOL) validateCondition:(NSString*)condition onNode:(MJsonNodeType*) node {

    BOOL isValide = YES;
    if ([condition containsString:@"="]) {
        NSRange  condRange       = [condition rangeOfString:@"="];
        NSString *conditionField = [condition substringToIndex:condRange.location];
        NSString *conditionValue = [condition substringWithRange:NSMakeRange(condRange.location + 1, condition.length - condRange.location - 1)];
                 conditionValue  = [conditionValue stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        if (lktDictionary == [node getNodeType]) {
            NSDictionary *nodeDic = [node getNodeDictionary];
            if (NSOrderedSame != [conditionValue compare:[nodeDic objectForKey:conditionField]
                                                 options:NSCaseInsensitiveSearch])
                isValide = NO;
        }
    }
    
    return isValide;
}


/**
 *  Retrieve node with condition
 *
 *  @param key       Node name
 *  @param condition Node value condition
 *
 *  @return All match nodes under specific condition
 */
- (NSArray*) getNodeWithKey:(NSString*)key andCondition:(NSString*)condition {
    
    NSMutableArray *matchNodes = [[NSMutableArray alloc]init];
    
    
    switch ([self getNodeType]) {
            
        case lktDictionary: {
            
            id matchNode = [_childrenDic objectForKey:key];
            if (nil != matchNode) {
                if (NO == [matchNode isKindOfClass:[MJsonNodeType class]])
                    matchNode = self;
            }
            [matchNodes addObject:matchNode];
            break;
        }
        case lktArray: {
            for (MJsonNodeType *childNode in [self getNodeArray]) {
                if (lktDictionary != [childNode getNodeType]) continue;
                NSDictionary *childDic = [childNode getNodeDictionary];
                id matchNode = [childDic objectForKey:key];
                if (matchNode) {
                    if (NO == [matchNode isKindOfClass:[MJsonNodeType class]]){
                        matchNode = childNode;
                    }
                    [matchNodes addObject:matchNode];
                }
            }
            break;
        }
            
        default:
            break;
    }
    
    // Validate Conditions
    NSMutableArray *fitConditionNodes = [[NSMutableArray alloc]init];
    for (MJsonNodeType *matchNode in matchNodes) {
        
        switch ([matchNode getNodeType]) {
            case lktDictionary:
                [self validateCondition:condition onNode:matchNode] ? [fitConditionNodes addObject:matchNode] : YES;
                
                break;
            case lktArray:{
                NSArray *childDicNodes = [matchNode getNodeArray];
                for (MJsonNodeType *childNode in childDicNodes) {
                    [self validateCondition:condition onNode:childNode] ? [fitConditionNodes addObject:childNode] : YES;
                }
                break;
            }
            default:
                break;
        }
    }
    
    return [fitConditionNodes copy];
}


/**
 *  Update node value
 *
 *  @param key Node name
 *  @param obj Node value
 */
- (void) updateNodeWithKey:(NSString*)key andObj:(id)obj {
    if ([_childrenDic objectForKey:key]) {
        [_childrenDic setObject:obj forKey:key];
    }
}


/**
 *  Retrieve current node's dictionary value
 *
 *  @return NSDictionary
 */
- (NSDictionary*) getNodeDictionary {
    return _childrenDic;
}


@end
