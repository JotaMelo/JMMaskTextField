//
//  JMMaskTextField.m
//  JMMaskTextField
//
//  Created by Jota Melo on 02/01/17.
//  Copyright © 2017 Jota. All rights reserved.
//

#import "JMMaskTextField.h"

#import "JMStringMask.h"

@interface JMMaskTextField () <UITextFieldDelegate>

@property (weak, nonatomic) id<UITextFieldDelegate> realDelegate;
@property (strong, nonatomic, readwrite) JMStringMask *mask;

@end

@implementation JMMaskTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commomInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self commomInit];
}

- (void)commomInit
{
    [super setDelegate:self];
}

- (void)setDelegate:(id<UITextFieldDelegate>)delegate
{
    self.realDelegate = delegate;
}

- (void)setMaskString:(NSString *)maskString
{
    _maskString = maskString;
    
    self.mask = [JMStringMask initWithMask:maskString];
}

- (NSString *)unmaskedText
{
    return [self.mask unmaskString:self.text];
}

#pragma mark - Text Field delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.realDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [self.realDelegate textFieldShouldBeginEditing:textField];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.realDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.realDelegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([self.realDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [self.realDelegate textFieldShouldEndEditing:textField];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.realDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.realDelegate textFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    JMStringMask *previousMask = self.mask;
    NSString *currentText = textField.text;
    
    if ([self.realDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        BOOL delegateResponse = [self.realDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
        
        if (!delegateResponse) {
            return NO;
        }
    }
    
    if (!self.mask) {
        return YES;
    }
    
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *formattedString = [self.mask maskString:newText];
    
    // if the mask changed or if the text couldn't be formatted,
    // unmask the newText and mask it again
    if (![self.mask.mask isEqualToString:previousMask.mask] || !formattedString) {
        NSString *unmaskedString = [self.mask unmaskString:newText];
        formattedString = [self.mask maskString:unmaskedString];
    }
    
    if (!formattedString) {
        return NO;
    }
    
    // if the cursor is not at the end and the string hasn't changed
    // it means the user tried to delete a mask character, so we'll
    // change the range to include the character right before it
    if ([formattedString isEqualToString:currentText] && range.location < currentText.length && range.location > 0) {
        return [self textField:textField shouldChangeCharactersInRange:NSMakeRange(range.location - 1, range.length + 1) replacementString:string];
    }
    
    if (![formattedString isEqualToString:currentText]) {
        textField.text = formattedString;
        
        // the user is trying to delete something so we need to
        // move the cursor accordingly
        if (range.location < currentText.length) {
            NSUInteger cursorLocation = 0;
            
            if (range.location > formattedString.length) {
                cursorLocation = formattedString.length;
            } else if (currentText.length > formattedString.length) {
                cursorLocation = range.location;
            } else {
                cursorLocation = range.location + 1;
            }
            
            UITextPosition *startPosition = [textField positionFromPosition:textField.beginningOfDocument offset:cursorLocation];
            UITextPosition *endPosition = [textField positionFromPosition:startPosition offset:0];
            textField.selectedTextRange = [textField textRangeFromPosition:startPosition toPosition:endPosition];
        }
        
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if ([self.realDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [self.realDelegate textFieldShouldClear:textField];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.realDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.realDelegate textFieldShouldReturn:textField];
    }
    
    return YES;
}

@end
