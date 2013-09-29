//  SpeechConfig.m
//
// Implements customization parameters for this application's use of
// AT&T Speech SDK.
//
// Customize the functions declared here with the parameters of your application.

#import "SpeechConfig.h"
NSString *const speechKey = @"3dstngsks7jwmae1xwto2ymgtk29ere5";
NSString *const speechSecret = @"e40rzmuvu5lfpl3cffoekkcbpnirps6h";

/** The URL of AT&T Speech API. **/
NSURL* SpeechServiceUrl(void)
{
    return [NSURL URLWithString: @"https://api.att.com/speech/v3/speechToText"];
}

/** The URL of AT&T Speech API OAuth service. **/
NSURL* SpeechOAuthUrl(void)
{
    return [NSURL URLWithString: @"https://api.att.com/oauth/token"];
}

/** Unobfuscates the OAuth client_id credential for the application. **/
NSString* SpeechOAuthKey(void)
{
        //error Add code to unobfuscate your Speech API credentials, then delete this line.
    return speechKey;
}

/** Unobfuscates the OAuth client_secret credential for the application. **/
NSString* SpeechOAuthSecret(void)
{
        //error Add code to unobfuscate your Speech API credentials, then delete this line.
    return speechSecret;
}

/** The OAuth scope for the Speech API requests. **/
NSString* SpeechOAuthScope(void)
{
    return @"SPEECH";
}
