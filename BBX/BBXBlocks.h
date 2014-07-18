//
//  BBXBlocks.h
//  BBX
//
//  Created by Roman Khan on 04/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#ifndef BBX_BBXBlocks_h
#define BBX_BBXBlocks_h

//! Block for completion of multiple tasks
typedef void (^CompletionBlock)(BOOL result, id resultObject);

//! Block for Core Data Operations
typedef void (^DataBlock)(BOOL success, NSError *error);

#endif
