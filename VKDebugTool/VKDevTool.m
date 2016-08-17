//
//  VKDebugTool.m
//  VKDebugToolDemo
//
//  Created by Awhisper on 16/8/17.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "VKDevTool.h"
#import "VKShakeCommand.h"
#import "VKKeyCommands.h"
#import "VKDevToolDefine.h"
#import "VKDevMainModule.h"
#import "VKDevScriptModule.h"

@interface VKDevTool ()

@property (nonatomic,strong) id<VKDevModuleProtocol> currentModule;

@property (nonatomic,strong) VKDevMainModule *mainModule;

@property (nonatomic,strong) VKDevScriptModule *scriptModule;

@end

@implementation VKDevTool
VK_DEF_SINGLETON



-(instancetype)init
{
    self = [super init];
    if (self) {
//#ifdef VKDevMode
        
        _mainModule = [[VKDevMainModule alloc]init];
        _scriptModule = [[VKDevScriptModule alloc]init];
//#endif
    }
    return self;
}

+(void)enableDebugMode
{
    [[VKDevTool singleton]enableDebugMode];
}

-(void)enableDebugMode
{
//#ifdef VKDevMode
    
    [self goMainModule];
    [[VKKeyCommands sharedInstance]registerKeyCommandWithInput:@"x" modifierFlags:UIKeyModifierCommand action:^(UIKeyCommand * key) {
        [self showModuleMenu];
    }];
    
    [[VKShakeCommand sharedInstance]registerShakeCommandWithAction:^{
        [self showModuleMenu];
    }];
//#endif
}

+(void)disableDebugMode{
    [[VKDevTool singleton]disableDebugMode];
}

-(void)disableDebugMode
{
//#ifdef VKDevMode
    [self leaveCurrentModule];
    
    [[VKKeyCommands sharedInstance]unregisterKeyCommandWithInput:@"x" modifierFlags:UIKeyModifierCommand];
    [[VKShakeCommand sharedInstance]unregisterKeyShakeCommand];
//#endif
}

-(void)showModuleMenu{
    [self.mainModule showModuleMenu];
}

-(void)leaveCurrentModule
{
    if (self.currentModule) {
        [[self.currentModule moduleView] removeFromSuperview];
        [self.currentModule hideModuleMenu];
        self.currentModule = nil;
    }
}

-(void)goMainModule{
    [self leaveCurrentModule];
    self.currentModule = self.mainModule;
}

+(void)gotoScriptModule
{
    [[self singleton]goScriptModule];
}
-(void)goScriptModule{
    [self leaveCurrentModule];
    self.currentModule = self.scriptModule;
    [self.scriptModule startScriptDebug];
    
}

@end