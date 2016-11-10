//
//  ViewController.m
//  KYSCoreText
//
//  Created by 康永帅 on 16/6/19.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import "ViewController.h"
#import "KYSCoreTextView.h"
#import "KYSCoreTextStorage.h"
#import "KYSCoreTextLink.h"
#import "UIView+KYSCategory.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet KYSCoreTextView *coreTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coreTextViewHeight;

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TemplateFile" ofType:@"json"];
    KYSCoreTextStorage *storage = [[KYSCoreTextStorage alloc] init];
    [storage parseTemplateWithFilePath:path width:self.coreTextView.width];
    self.coreTextView.coreTextData=storage;
    self.coreTextViewHeight.constant=self.coreTextView.coreTextHeight;
    self.coreTextView.backgroundColor = [UIColor whiteColor];
}

@end
