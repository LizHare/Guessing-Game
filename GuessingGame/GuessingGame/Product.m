//
//  GuessingObject.m
//  GuessingGame
//
//  Created by Bryan on 10/11/16.
//  Copyright © 2016 bryan. All rights reserved.
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
