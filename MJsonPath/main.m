//
//  main.m
//  MJsonPath
//
//  Created by Janky on 2/23/16.
//  Copyright © 2016 janky.xm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJsonDocument.h"
#import "MJson.h"


int main(int argc, const char * argv[]) {
    
    NSDictionary *jsonObj =
    
    //    @[@{@"firstname":@"janky",@"lastname":@"hu"},
    //      @{@"firstname":@"man",@"lastname":@"xu"},
    //      @{@"firstname":@"ccb",@"lastname":@"cheng"}
    //      ];
    
    //  @{@"root":@{@"employees":@[@[@{@"firstname":@"janky",@"lastname":@"hu"}
    //                                                             ],
    //                                                           @[@{@"firstname":@"man",@"lastname":@"xu"}
    //                                                             ],
    //                                                           @[@{@"firstname":@"ccb",@"lastname":@"cheng"}
    //                                                             ]
    //                                                           ],
    //                                            @"manager":@{@"name":@"janky",@"age":@18}
    //                                            },
    //                                  @"brother":@"baobao",
    //                                  @"pet":@"kila",
    //                                  };
    //
    
    //  @[@{@"firstname":@"janky",@"lastname":@"hu"},
    //                              @{@"firstname":@"man",@"lastname":@"xu"},
    //                              @{@"firstname":@"ccb",@"lastname":@"cheng"}
    //                              ];
    
    @{@"root":@{@"employees":@[@{@"firstname":@"janky",@"lastname":@"hu"},
                               @{@"firstname":@"man",@"lastname":@"xu"},
                               @{@"firstname":@"kila",@"lastname":@"hu"}
                               ],
                @"manager":@{@"name":@"janky",
                             @"age":@18}
                },
      @"brother":@"baobao",
      @"pet":@"kila",
      };

    NSString        *jsonStr  = [jsonObj toJsonStr];
    MJsonDocument   *doc      = [[MJsonDocument alloc]initWithJsonString:jsonStr];
    NSDictionary    *composed = (NSDictionary*)[doc getUpdated];
    NSLog(@"%@",[composed toJsonStr]);
    
    //@"root.employees[firstname=\"ccb\"].lastname"
    [doc updateJsonWithPath:@"root.employees[firstname=\"man\"].lastname"
                 andHandler:^NSString*(NSString *nodeName, NSString *nodeValue) {
                     return @"%lkt$0001|dsjlkf=|sdfjs=|dfjslf=";
                 }];
    composed = (NSDictionary*)[doc getUpdated];
    NSLog(@"%@",[composed toJsonStr]);
    return 0;
}
