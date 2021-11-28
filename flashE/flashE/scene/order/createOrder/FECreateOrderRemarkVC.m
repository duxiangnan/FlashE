//
//  FECreateOrderRemarkVC.m
//  flashE
//
//  Created by duxiangnan on 2021/11/28.
//

#import "FECreateOrderRemarkVC.h"
#import "FEDefineModule.h"
NSInteger FECreateOrderRemarkMax = 120;
@interface FECreateOrderRemarkVC ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *leftNumLB;



@end

@implementation FECreateOrderRemarkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"备注";
    self.fd_prefersNavigationBarHidden = NO;
    self.textView.placeholder = @"请备注物品的名称及大小。例：一个30X3";
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewDidChangeText:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (IBAction)submitAction:(id)sender {
    [self.view endEditing:YES];
    !self.remarkAction?:self.remarkAction(self.textView.text);
    
}
-(void) setRemark:(NSString *)remark {
    _remark = remark;
    self.textView.text = remark;
    self.leftNumLB.text = [NSString stringWithFormat:@"%lu",FECreateOrderRemarkMax - remark.length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return [FEPublicMethods limitTextView:textView replacementText:text max:FECreateOrderRemarkMax];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    self.leftNumLB.text = [NSString stringWithFormat:@"%lu", (unsigned long)textView.text.length];
}

- (void)textViewDidChangeText:(NSNotification *)notification {

    UITextView  *textView = (UITextView *)notification.object;
    NSString    *toBeString = textView.text;
    // 获取键盘输入模式
    NSString *lang = [textView.textInputMode primaryLanguage];

    // 中文输入的时候,可能有markedText(高亮选择的文字),需要判断这种状态
    // zh-Hans表示简体中文输入, 包括简体拼音，健体五笔，简体手写
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textView markedTextRange];
        // 获取高亮选择部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];

        // 没有高亮选择的字，表明输入结束,则对已输入的文字进行字数统计和限制
        if (!position &&toBeString.length > FECreateOrderRemarkMax) {
            // 截取子串
            textView.text = [toBeString substringToIndex:FECreateOrderRemarkMax];
            
        }
    } else {
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > FECreateOrderRemarkMax) {
            // 截取子串
            textView.text = [toBeString substringToIndex:FECreateOrderRemarkMax];
        }
    }

    self.leftNumLB.text = [NSString stringWithFormat:@"%lu",FECreateOrderRemarkMax-textView.text.length];
}


@end
