//
//  GuessingObject.h
//  GuessingGame
//
//  Created by Bryan on 10/11/16.
//  Copyright © 2016 bryan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Product : NSManagedObject
{
    NSString* _productName;
    NSString* _manufacturerName;
    NSString* _sku;
    NSString* _price;
    NSData* _imageData;
}

@property (nonatomic, strong) NSString* name;
@property (nonatomic,retain) NSString* productName;
@property (nonatomic,retain) NSString* sku;
@property (nonatomic,retain) NSString* price;
@property (nonatomic,retain) NSString* manufacturerName;
@property (nonatomic,retain) NSData* imageData;
@end