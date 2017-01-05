//
//  JMViewController.m
//  JMMaskTextField
//
//  Created by Jota Melo on 01/05/2017.
//  Copyright (c) 2017 Jota Melo. All rights reserved.
//

#import "JMViewController.h"

#import <JMMaskTextField/JMMaskTextField.h>

@interface JMViewController () <UITextFieldDelegate>

@end

@implementation JMViewController

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    JMMaskTextField *maskTextField = (JMMaskTextField *)textField;
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([maskTextField.mask unmaskString:newText].length >= 11) {
        maskTextField.maskString = @"(00) 0 0000-0000";
    } else {
        maskTextField.maskString = @"(00) 0000-0000";
    }
    
    return YES;
}

@end
