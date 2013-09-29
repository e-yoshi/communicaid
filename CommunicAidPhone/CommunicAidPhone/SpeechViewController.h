//
//  SpeechViewController.h
//  CommunicAidPhone
//
//  Created by Lee Yu Zhou on 29/9/13.
//  Copyright (c) 2013 Lee Yu Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATTSpeechKit.h"
#import "SpeechAuth.h"
#import "SpeechConfig.h"
@interface SpeechViewController : UIViewController <ATTSpeechServiceDelegate>
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end
