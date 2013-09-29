//
//  CCDetailViewController.h
//  Communicaid
//
//  Created by Lee Yu Zhou on 29/9/13.
//  Copyright (c) 2013 Lee Yu Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATTSpeechKit.h"
#import "SpeechConfig.h"
#import "SpeechAuth.h"
@interface CCDetailViewController : UIViewController <UISplitViewControllerDelegate, ATTSpeechServiceDelegate>
- (void) handleRecognition: (NSString*) recognizedText;
- (void) prepareForSpeech;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@end
