//
//  MJsonNodeType.h
//
//  Created by Janky on 2/22/16.
//  Copyright © 2016 Janky. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    lktDictionary = 0,
    lktArray      = 1,
    lktString     = 2,
    lktBool       = 3,
    lktInt        = 4,
    lktFloat      = 5
}lktJsonNodeType;


@interface MJsonNodeType : NSObject
@property id _nodeValue;

/**
 *  Init
 *
 *  @param obj Json object (NSDictionary or NSArray)
 *
 *  @return MJsonNodeType
 */
- (id) initWithObj:(id)obj;


/**
 *  Compose current node's children into a single object (NSDictionary or NSArray)
 *
 *  @return Composed single json object
 */
- (id) composeChildren;

/**
 *  Retrieve node with condition
 *
 *  @param key       Node name
 *  @param condition Node value condition
 *
 *  @return All match nodes under specific condition
 */
- (NSArray*) getNodeWithKey:(NSString*)key andCondition:(NSString*)condition;

/**
 *  Update node value
 *
 *  @param key Node name
 *  @param obj Node value
 */
- (void) updateNodeWithKey:(NSString*)key andObj:(id)obj;

/**
 *  Retrieve current node's dictionary value
 *
 *  @return NSDictionary
 */
- (NSDictionary*) getNodeDictionary;

/**
 *  Retrieve current node's array value
 *
 *  @return NSArray
 */
- (NSArray*) getNodeArray;

/**
 *  Retrieve current node type
 *
 *  @return  lktJsonNodeType
 */
- (lktJsonNodeType) getNodeType;


@end
