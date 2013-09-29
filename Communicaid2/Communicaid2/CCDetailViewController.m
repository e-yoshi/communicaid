//
//  CCDetailViewController.m
//  Communicaid
//
//  Created by Lee Yu Zhou on 29/9/13.
//  Copyright (c) 2013 Lee Yu Zhou. All rights reserved.
//

#import "CCDetailViewController.h"

@interface CCDetailViewController ()

@end

@implementation CCDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.currentChannel = nil;
    self.messages = [NSMutableDictionary dictionary];
    self.configuration = [PNConfiguration defaultConfiguration];
    
    
    
    
    
    CCDetailViewController *weakSelf = self;
    
    [[PNObservationCenter defaultCenter] addClientConnectionStateObserver:self
                                                        withCallbackBlock:^(NSString *origin,
                                                                            BOOL connected,
                                                                            PNError *connectionError) {
                                                            PNLog(PNLogGeneralLevel, self, @"{BLOCK} client identifier %@", [PubNub clientIdentifier]);
                                                            
                                                        }];
    //
    [[PNObservationCenter defaultCenter] addMessageReceiveObserver:self
                                                         withBlock:^(PNMessage *message) {
                                                             
                                                             if (![[message.message substringToIndex:1] isEqualToString:@"*"]) {
                                                                 NSDateFormatter *dateFormatter = [NSDateFormatter new];
                                                                 dateFormatter.dateFormat = @"HH:mm:ss MM/dd/yy";
                                                                 
                                                                 PNChannel *channel = message.channel;
                                                                 NSString *messages = [weakSelf.messages valueForKey:channel.name];
                                                                 if (messages == nil) {
                                                                     
                                                                     messages = @"";
                                                                 }
                                                                 messages = [messages stringByAppendingFormat:@"%@\n",
                                                                             message.message];
                                                                 [weakSelf.messages setValue:messages forKey:channel.name];
                                                                 
                                                                 [self.messageTextField setText:messages];
                                                                 
                                                                 NSRange range = NSMakeRange(self.messageTextField.text.length - 1, 1);
                                                                 [self.messageTextField scrollRangeToVisible:range];//weakSelf.currentChannelChat = [weakSelf.messages valueForKey:weakSelf.currentChannel.name];
                                                             }
                                                         }];
    
    
    [self connectToChannel];
}

-(void) connectToChannel{
    // set up channel
    
    [PubNub setConfiguration:[PNConfiguration configurationForOrigin:@"pubsub.pubnub.com" publishKey:@"demo" subscribeKey:@"demo" secretKey:@"mySecret"]];
    [PubNub connect];
    
    PNChannel *channel_1 = [PNChannel channelWithName:@"a" shouldObservePresence:YES];
    self.currentChannel = channel_1;
    NSLog(@"%p", self.currentChannel);
    
    [PubNub subscribeOnChannel:self.currentChannel withCompletionHandlingBlock:^(PNSubscriptionProcessState state,
                                                                                 NSArray *channels,
                                                                                 PNError *subscriptionError) {
        
        NSString *alertMessage = [NSString stringWithFormat:@"Subscribed on channel: %@\nTo be able to send messages, select channel from righthand list",
                                  self.currentChannel.name];
        if (state == PNSubscriptionProcessNotSubscribedState) {
            
            alertMessage = [NSString stringWithFormat:@"Failed to subscribe on: %@", self.currentChannel.name];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Subscribe"
                                                                message:alertMessage
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        } else if (state == PNSubscriptionProcessSubscribedState) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Connected!"
                                                                message:@"You are connected to CommunicAid"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        
    }];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self prepareForSpeech];
}

- (void)prepareForSpeech {
    // Access the SpeechKit singleton.
    ATTSpeechService* speechService = [ATTSpeechService sharedSpeechService];
    
    // Point to the SpeechToText API.
    speechService.recognitionURL = SpeechServiceUrl();
    
    // Hook ourselves up as a delegate so we can get called back with the response.
    speechService.delegate = self;
    
    // Use default speech UI.
    speechService.showUI = YES;
    
    // Choose the speech recognition package.
    speechService.speechContext = @"WebSearch";
    
    // Enable the Speex codec, which provides better speech recognition accuracy.
    speechService.audioFormat = ATTSKAudioFormatSpeex_WB;
    
    // Start the OAuth background operation
    [[SpeechAuth authenticatorForService: SpeechOAuthUrl()
                                  withId: SpeechOAuthKey()
                                  secret: SpeechOAuthSecret()
                                   scope: SpeechOAuthScope()]
     fetchTo: ^(NSString* token, NSError* error) {
         if (token) {
             speechService.bearerAuthToken = token;
         }
         else
             [self speechAuthFailed: error];
     }];
    
    // Wake the audio components so there is minimal delay on the first request.
    [speechService prepare];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - control turning

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation{
    return NO;
}
- (IBAction)talkButton:(id)sender {
    NSLog(@"Starting speech request");
    
    // Start listening via the microphone.
    ATTSpeechService* speechService = [ATTSpeechService sharedSpeechService];
    
    // Add extra arguments for speech recogniton.
    // The parameter is the name of the current screen within this app.
    speechService.xArgs =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @"main", @"ClientScreen", nil];
    
    [speechService startListening];
}

#pragma mark -
#pragma mark Speech Service Delegate Methods

- (void) speechServiceSucceeded: (ATTSpeechService*) speechService
{
    NSLog(@"Speech service succeeded");
    
    // Extract the needed data from the SpeechService object:
    // For raw bytes, read speechService.responseData.
    // For a JSON tree, read speechService.responseDictionary.
    // For the n-best ASR strings, use speechService.responseStrings.
    
    // In this example, use the ASR strings.
    // There can be 0 strings, 1 empty string, or 1 non-empty string.
    // Display the recognized text in the interface is it's non-empty,
    // otherwise have the user try again.
    NSArray* nbest = speechService.responseStrings;
    NSLog(@"%@",[nbest description]);
    NSString* recognizedText = @"";
    if (nbest != nil && nbest.count > 0)
        recognizedText = [nbest objectAtIndex: 0];
    if (recognizedText.length) { // non-empty?
        
        [self handleRecognition: recognizedText];
    }
    else {
        UIAlertView* alert =
        [[UIAlertView alloc] initWithTitle: @"Didn't recognize speech"
                                   message: @"Please try again."
                                  delegate: self
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
    }
}

- (void) handleRecognition: (NSString*) recognizedText
{
    // Display the recognized text.
    [self.textView setText: recognizedText];
    NSLog(@"%@",recognizedText);
    // Load a website using the recognized text.
    // First make the recognizedText safe for use as a search term in a URL.
    if (self.currentChannel != nil) {
        [PubNub sendMessage:[NSString stringWithFormat:@"\"%@\"", recognizedText]
                  toChannel:self.currentChannel];
    }
}

- (void) speechService: (ATTSpeechService*) speechService
       failedWithError: (NSError*) error
{
    if ([error.domain isEqualToString: ATTSpeechServiceErrorDomain]
        && (error.code == ATTSpeechServiceErrorCodeCanceledByUser)) {
        NSLog(@"Speech service canceled");
        // Nothing to do in this case
        return;
    }
    NSLog(@"Speech service had an error: %@", error);
    
    UIAlertView* alert =
    [[UIAlertView alloc] initWithTitle: @"An error occurred"
                               message: @"Please try again later."
                              delegate: self
                     cancelButtonTitle: @"OK"
                     otherButtonTitles: nil];
    [alert show];
}

#pragma mark -
#pragma mark OAuth

/* The SpeechAuth authentication failed. */
- (void) speechAuthFailed: (NSError*) error
{
    NSLog(@"OAuth error: %@", error);
    UIAlertView* alert =
    [[UIAlertView alloc] initWithTitle: @"Speech Unavailable"
                               message: @"This app was rejected by the speech service.  Contact the developer for an update."
                              delegate: self
                     cancelButtonTitle: @"OK"
                     otherButtonTitles: nil];
    [alert show];
}



@end
