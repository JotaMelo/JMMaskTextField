//
//  JMStringMask.h
//  JMMaskTextField
//
//  Created by Jota Melo on 02/01/17.
//  Copyright © 2017 Jota. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMStringMask : NSObject

@property (strong, nonatomic) NSString *mask;

+ (instancetype)initWithMask:(NSString *)mask;

- (NSString *)maskString:(NSString *)string;
- (NSString *)unmaskString:(NSString *)unmaskString;

@end
