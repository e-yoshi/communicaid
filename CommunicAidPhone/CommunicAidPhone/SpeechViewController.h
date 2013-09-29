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
@interface SpeechViewController : UIViewController <ATTSpeechServiceDelegate, PNDelegate>
@property (strong, nonatomic) IBOutlet UITextView *messageTextField;
@property ( pn_desired_weak, nonatomic) IBOutlet UITextView *textView;
// Stores reference on PubNub client configuration
@property (nonatomic, strong) PNConfiguration *configuration;

// Stores reference on current channel
@property (nonatomic, strong) PNChannel *currentChannel;

// Stores reference on dictionary which stores messages for each of channels
@property (nonatomic, strong) NSMutableDictionary *messages;
@end
