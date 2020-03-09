//
//  HWSpeechManage.m
//  Oc-Dome
//
//  Created by 李含文 on 2019/4/13.
//  Copyright © 2019年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "HWSpeechManage.h"
#import <AVFoundation/AVFoundation.h>

@interface HWSpeechManage() <AVSpeechSynthesizerDelegate>
{
//    AVSpeechSynthesizer      *av;
    NSString                 *_languageStr;
}
/** <#注释#> */
@property(nonatomic, strong) AVSpeechSynthesizer *av;
@end

@implementation HWSpeechManage

+ (instancetype)sharedManage {
    static HWSpeechManage *single = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single = [[HWSpeechManage alloc] init];
    });
    return single;
}
- (void)setContent:(NSString *)content {
    _content = content;
}
- (void)start{
    NSArray *_languageArr = @[@"en-US",@"zh-CN",@"en-GB",@"zh-HK"];
    _languageStr = _languageArr [1];
    if([self.av isPaused]) {
        //如果暂停则恢复，会从暂停的地方继续
        [self.av continueSpeaking];
    }else{
        //初始化对象
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:self.content];//需要转换的文字
        utterance.rate = 0.5;// 设置语速，范围0-1，注意0最慢，1最快；AVSpeechUtteranceMinimumSpeechRate最慢，AVSpeechUtteranceMaximumSpeechRate最快
        AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:_languageStr];//设置发音，这是中文普通话
        utterance.voice = voice;
        [self.av speakUtterance:utterance];//开始
    }
}
- (AVSpeechSynthesizer *)av {
    if (!_av) {
        _av = [[AVSpeechSynthesizer alloc]init];
        _av.delegate = self;//挂上代理
    }
    return _av;
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didStartSpeechUtterance:(AVSpeechUtterance*)utterance{
    NSLog(@"---开始播放");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance*)utterance{
    NSLog(@"---完成播放");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance*)utterance{
    NSLog(@"---播放中止");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance*)utterance{
    NSLog(@"---恢复播放");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance*)utterance{
    NSLog(@"---播放取消");
}
@end
