//
//  JMMaskTextFieldTests.m
//  JMMaskTextFieldTests
//
//  Created by Jota Melo on 01/05/2017.
//  Copyright (c) 2017 Jota Melo. All rights reserved.
//

@import XCTest;

#import <JMMaskTextField/JMStringMask.h>
#import <JMMaskTextField/JMMaskTextField.h>

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)testStringMask
{
    JMStringMask *mask = [JMStringMask initWithMask:@"00000-000"];
    
    XCTAssertEqualObjects([mask maskString:@"abcbe-343"], nil);
    XCTAssertEqualObjects([mask maskString:@"30310360"], @"30310-360");
    XCTAssertEqualObjects([mask maskString:@"30310-360"], @"30310-360");
    XCTAssertEqualObjects([mask maskString:@"303103600"], nil);
    XCTAssertEqualObjects([mask maskString:nil], nil);
    
    mask = [JMStringMask initWithMask:@"AAA-0000"];
    XCTAssertEqualObjects([mask maskString:@"123-EIEIEEIE"], nil);
    XCTAssertEqualObjects([mask maskString:@"ETO1192"], @"ETO-1192");
    XCTAssertEqualObjects([mask maskString:@"ETO-1192"], @"ETO-1192");
    XCTAssertEqualObjects([mask maskString:@"ETO11922"], nil);
}

- (void)testTextFieldMask
{
    JMMaskTextField<UITextFieldDelegate> *textField = (JMMaskTextField<UITextFieldDelegate> *)[JMMaskTextField new];
    [textField becomeFirstResponder];
    textField.selectedTextRange = [textField textRangeFromPosition:textField.beginningOfDocument toPosition:textField.beginningOfDocument];
    textField.maskString = @"00000-000";
    
    // pasting
    [textField textField:textField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@"30310-360"];
    XCTAssertEqualObjects(textField.text, @"30310-360");
    
    textField.text = @"";
    
    // pasting unformatted
    [textField textField:textField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@"30310360"];
    XCTAssertEqualObjects(textField.text, @"30310-360");
    
    textField.text = @"";
    
    // pasting invalid
    [textField textField:textField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@"30310-3600"];
    XCTAssertEqual(textField.text.length, 0);
    
    textField.text = @"30310-360";
    
    // deleting from middle
    [textField textField:textField shouldChangeCharactersInRange:NSMakeRange(2, 1) replacementString:@""];
    XCTAssertEqualObjects(textField.text, @"30103-60");
}

@end

