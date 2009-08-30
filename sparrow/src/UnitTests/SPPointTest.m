//
//  SPPointTest.m
//  Sparrow
//
//  Created by Daniel Sperl on 25.03.09.
//  Copyright 2009 Incognitek. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>

#import "SPPoint.h"
#import "SPMakros.h"

// -------------------------------------------------------------------------------------------------

@interface SPPointTest :  SenTestCase  
{
    SPPoint *p1;
    SPPoint *p2;
}

@end

// -------------------------------------------------------------------------------------------------

@implementation SPPointTest

- (void) setUp
{
    p1 = [[SPPoint alloc] initWithX:2 y:3];
    p2 = [[SPPoint alloc] initWithX:4 y:1];    
}

- (void) tearDown
{
    [p1 release];
    [p2 release];
}

- (void)testInit
{
    SPPoint *point = [[SPPoint alloc] init];
    STAssertEquals(0.0f, point.x, @"x is not zero");
    STAssertEquals(0.0f, point.y, @"y is not zero");
    [point release];
}

- (void)testInitWithXandY
{
    SPPoint *point = [[SPPoint alloc] initWithX:3 y:4];
    STAssertEquals(3.0f, point.x, @"wrong x value");
    STAssertEquals(4.0f, point.y, @"wrong y value");
}

- (void)testLength
{
    SPPoint *point = [[SPPoint alloc] initWithX:-4 y:3];
    STAssertTrue(SP_IS_FLOAT_EQUAL(5.0f, point.length), @"wrong length");
    point.x = 0;
    point.y = 0;
    STAssertEquals(0.0f, point.length, @"wrong length");
    [point release];    
}

- (void)testAngle
{    
    SPPoint *point = [[SPPoint alloc] initWithX:10 y:0];
    STAssertTrue(SP_IS_FLOAT_EQUAL(0.0f, point.angle), @"wrong angle: %f", point.angle);
    point.y = 10;
    STAssertTrue(SP_IS_FLOAT_EQUAL(PI/4.0f, point.angle), @"wrong angle: %f", point.angle);
    point.x = 0;
    STAssertTrue(SP_IS_FLOAT_EQUAL(PI/2.0f, point.angle), @"wrong angle: %f", point.angle);
    point.x = -10;
    STAssertTrue(SP_IS_FLOAT_EQUAL(3*PI/4.0f, point.angle), @"wrong angle: %f", point.angle);
    point.y = 0;
    STAssertTrue(SP_IS_FLOAT_EQUAL(PI, point.angle), @"wrong angle: %f", point.angle);
    point.y = -10;
    STAssertTrue(SP_IS_FLOAT_EQUAL(-3*PI/4.0f, point.angle), @"wrong angle: %f", point.angle);
    point.x = 0;
    STAssertTrue(SP_IS_FLOAT_EQUAL(-PI/2.0f, point.angle), @"wrong angle: %f", point.angle);
    point.x = 10;
    STAssertTrue(SP_IS_FLOAT_EQUAL(-PI/4.0f, point.angle), @"wrong angle: %f", point.angle);
    [point release];    
}

- (void)testAddPoint
{
    SPPoint *result = [p1 addPoint:p2];
    STAssertTrue(SP_IS_FLOAT_EQUAL(6.0f, result.x), @"wrong x value");
    STAssertTrue(SP_IS_FLOAT_EQUAL(4.0f, result.y), @"wrong y value");
}

- (void)testSubtractPoint
{
    SPPoint *result = [p1 subtractPoint:p2];
    STAssertTrue(SP_IS_FLOAT_EQUAL(-2.0f, result.x), @"wrong x value");
    STAssertTrue(SP_IS_FLOAT_EQUAL(2.0f, result.y), @"wrong y value");
}

- (void)testNormalize
{
    SPPoint *result = [p1 normalize];
    STAssertTrue(SP_IS_FLOAT_EQUAL(1.0f, result.length), @"wrong length");
    STAssertTrue(SP_IS_FLOAT_EQUAL(p1.angle, result.angle), @"wrong angle");
    SPPoint *origin = [[SPPoint alloc] init];
    STAssertThrows([origin normalize], @"origin cannot be normalized!");
    [origin release];
}

- (void)testClone
{
    SPPoint *result = [p1 copy];
    STAssertEquals(p1.x, result.x, @"wrong x value");
    STAssertEquals(p1.y, result.y, @"wrong y value");
    STAssertFalse(result == p1, @"object should not be identical");
    STAssertEqualObjects(p1, result, @"objects should be equal");
    [result release];
}

- (void)testIsEqual
{
    STAssertFalse([p1 isEqual:p2], @"should not be equal");    
    SPPoint *p3 = [[SPPoint alloc] initWithX:p1.x y:p1.y];
    STAssertTrue([p1 isEqual:p3], @"should be equal");
    p3.x += 0.0000001;
    p3.y -= 0.0000001;
    STAssertTrue([p1 isEqual:p3], @"should be equal, as difference is smaller than epsilon");
    [p3 release];
}

- (void)testDistance
{
    SPPoint *p3 = [[SPPoint alloc] initWithX:5 y:0];
    SPPoint *p4 = [[SPPoint alloc] initWithX:5 y:5];
    float distance = [SPPoint distanceFromPoint:p3 toPoint:p4];
    STAssertTrue(SP_IS_FLOAT_EQUAL(5.0f, distance), @"wrong distance");
    p3.y = -5;
    distance = [SPPoint distanceFromPoint:p3 toPoint:p4];
    STAssertTrue(SP_IS_FLOAT_EQUAL(10.0f, distance), @"wrong distance");
    [p3 release];
    [p4 release];
}

- (void)testPolarPoint
{
    float angle = 5.0 * PI / 4.0;
    float negAngle = -(2*PI - angle);
    float length = 2.0f;
    SPPoint *p3 = [SPPoint pointWithPolarLength:length angle:angle];
    STAssertTrue(SP_IS_FLOAT_EQUAL(length, p3.length), @"wrong length");
    STAssertTrue(SP_IS_FLOAT_EQUAL(negAngle, p3.angle), @"wrong angle");
    STAssertTrue(SP_IS_FLOAT_EQUAL(-cosf(angle-PI)*length, p3.x), @"wrong x");
    STAssertTrue(SP_IS_FLOAT_EQUAL(-sinf(angle-PI)*length, p3.y), @"wrong y");    
}

// STAssertEquals(value, value, message, ...)
// STAssertEqualObjects(object, object, message, ...)
// STAssertNotNil(object, message, ...)
// STAssertTrue(expression, message, ...)
// STAssertFalse(expression, message, ...)
// STAssertThrows(expression, message, ...) 
// STAssertThrowsSpecific(expression, exception, message, ...)
// STAssertNoThrow(expression, message, ...)
// STFail(message, ...)

@end