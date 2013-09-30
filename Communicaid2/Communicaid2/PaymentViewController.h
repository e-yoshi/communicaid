//
//  PaymentViewController.h
//  Communicaid2
//
//  Created by Lee Yu Zhou on 29/9/13.
//  Copyright (c) 2013 Lee Yu Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATTSpeechKit.h"
#import "SpeechConfig.h"
#import "SpeechAuth.h"

@interface PaymentViewController : UIViewController<ATTSpeechServiceDelegate, PNDelegate>

@property (nonatomic, strong) PNConfiguration *configuration;

// Stores reference on current channel
@property (nonatomic, strong) PNChannel *currentChannel;

// Stores reference on dictionary which stores messages for each of channels
@property (nonatomic, strong) NSMutableDictionary *messages;
@property (strong, nonatomic) IBOutlet UITextField *typeText;
- (void) handleRecognition: (NSString*) recognizedText;
@property (strong, nonatomic) IBOutlet UITextView *messageTextField;
- (void) prepareForSpeech;
@end
