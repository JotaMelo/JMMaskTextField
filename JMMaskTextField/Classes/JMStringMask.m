//
//  JMStringMask.m
//  JMMaskTextField
//
//  Created by Jota Melo on 02/01/17.
//  Copyright © 2017 Jota. All rights reserved.
//

#import "JMStringMask.h"

static NSString * const JMLetterMaskString = @"A";
static NSString * const JMNumberMaskString = @"0";

@implementation JMStringMask

+ (instancetype)initWithMask:(NSString *)mask
{
    JMStringMask *stringMask = [JMStringMask new];
    stringMask.mask = mask;
    
    return stringMask;
}

- (NSString *)maskString:(NSString *)string
{
    if (!string) {
        return nil;
    }
    
    if (string.length > self.mask.length) {
        return nil;
    }
    
    NSMutableString *formattedString = @"".mutableCopy;
    
    NSUInteger currentMaskIndex = 0;
    for (int i = 0; i < string.length; i++) {
        if (currentMaskIndex >= self.mask.length) {
            return nil;
        }
        
        NSString *currentCharacter = [string substringWithRange:NSMakeRange(i, 1)];
        NSString *maskCharacter = [self.mask substringWithRange:NSMakeRange(currentMaskIndex, 1)];
        
        if ([currentCharacter isEqualToString:maskCharacter]) {
            [formattedString appendString:currentCharacter];
        } else {
            while (![maskCharacter isEqualToString:JMLetterMaskString] && ![maskCharacter isEqualToString:JMNumberMaskString]) {
                [formattedString appendString:maskCharacter];
                
                currentMaskIndex++;
                maskCharacter = [self.mask substringWithRange:NSMakeRange(currentMaskIndex, 1)];
            }
            
            BOOL isValidLetter = [maskCharacter isEqualToString:JMLetterMaskString] && [self isValidLetterString:currentCharacter];
            BOOL isValidNumber = [maskCharacter isEqualToString:JMNumberMaskString] && [self isValidNumberString:currentCharacter];
            
            if (isValidLetter || isValidNumber) {
                [formattedString appendString:currentCharacter];
            } else {
                return nil;
            }
        }
        
        currentMaskIndex++;
    }
    
    return formattedString;
}

- (NSString *)unmaskString:(NSString *)string
{
    NSMutableString *unmaskedValue = @"".mutableCopy;
    
    for (int i = 0; i < string.length; i++) {
        NSString *characterString = [string substringWithRange:NSMakeRange(i, 1)];
        
        if ([self isValidLetterString:characterString] || [self isValidNumberString:characterString]) {
            [unmaskedValue appendString:characterString];
        }
    }
    
    return unmaskedValue;
}

- (BOOL)isValidLetterString:(NSString *)characterString
{
    NSCharacterSet *lettersSet = NSCharacterSet.letterCharacterSet;
    return [lettersSet characterIsMember:[characterString characterAtIndex:0]];
}

- (BOOL)isValidNumberString:(NSString *)characterString
{
    NSCharacterSet *numbersSet = NSCharacterSet.decimalDigitCharacterSet;
    return [numbersSet characterIsMember:[characterString characterAtIndex:0]];
}


@end
