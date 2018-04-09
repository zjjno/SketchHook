//  HookIE.m
//  HookIE
//
//  Created by in8 on 2018/3/22.
//  Copyright © 2018年 in8. All rights reserved.
//

#import "HookIE.h"
#import <objc/runtime.h>
#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

void exchangeInstanceMethod(Class class, SEL originalSelector, SEL newSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method newMethod = class_getInstanceMethod(class, newSelector);
    method_exchangeImplementations(originalMethod, newMethod);
}

void exchangeClassMethod(Class class, SEL originalSelector, SEL newSelector) {
    Method originalMethod = class_getClassMethod(class, originalSelector);
    Method newMethod = class_getClassMethod(class, newSelector);
    method_exchangeImplementations(originalMethod, newMethod);
}

static void __attribute__((constructor)) initialize(void) {
    @autoreleasepool {
        
        exchangeInstanceMethod(NSClassFromString(@"BCLicenseManager"), NSSelectorFromString(@"currentLicenseType"), NSSelectorFromString(@"zjcurrentLicenseType"));

        exchangeInstanceMethod(NSClassFromString(@"BCLicense"), NSSelectorFromString(@"expiryDate"), NSSelectorFromString(@"zjexpiryDate"));

        exchangeInstanceMethod(NSClassFromString(@"BCLicenseManager"), NSSelectorFromString(@"registerWithLicenseKey:handler:"), NSSelectorFromString(@"zjregisterWithLicenseKey:handler:"));

        exchangeInstanceMethod(NSClassFromString(@"NSCell"), NSSelectorFromString(@"setStringValue:"), NSSelectorFromString(@"zjsetStringValue:"));

    }
}

@implementation NSObject (some)

- (int)zjcurrentLicenseType {
    return 2;
}

- (NSDate *)zjexpiryDate {
    return [NSDate dateWithTimeIntervalSinceNow:60*60*24*100];
}

- (void)zjregisterWithLicenseKey:(id)arg1 handler:(void(^)(long long,NSDictionary *,NSError *))arg2 {
    id block = ^(long long code,NSDictionary *dic,NSError *error) {
        if (arg2) {
            arg2(0,dic,error);
        }
    };
    [self zjregisterWithLicenseKey:arg1 handler:block];
}

- (void)zjsetStringValue:(id)arg1 {
    if (arg1) {
        return [self zjsetStringValue:arg1];
    }
    return [self zjsetStringValue:@""];
}
@end

