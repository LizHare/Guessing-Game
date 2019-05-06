//
//  GuessingObject.m
//  GuessingGame
//
//  Created by Liz on 10/11/16.
//  Copyright © 2016 Liz. All rights reserved.
//

#import "Product.h"
#import <CoreData/CoreData.h>

@implementation Product

@dynamic name;
@synthesize productName = _productName;
@synthesize manufacturerName = _manufacturerName;
@synthesize imageData = _imageData;
@synthesize sku= _sku;
@synthesize price = _price;
@end
