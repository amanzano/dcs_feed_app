//
//  ACMShareKitConfigurator.m
//  MyApplication
//
//  Created by Audrey Manzano on 2/3/14.
//  Copyright (c) 2014 Audrey Manzano. All rights reserved.
//

#import "ACMShareKitConfigurator.h"

@implementation ACMShareKitConfigurator
/*
 App Description
 ---------------
 These values are used by any service that shows 'shared from XYZ'
 */
- (NSString*)appName {
	return @"Learfield Sports";
}

- (NSString*)appURL {
	return @"";
}

// Facebook - https://developers.facebook.com/apps
// SHKFacebookAppID is the Application ID provided by Facebook
// SHKFacebookLocalAppID is used if you need to differentiate between several iOS apps running against a single Facebook app. Useful, if you have full and lite versions of the same app,
// and wish sharing from both will appear on facebook as sharing from one main app. You have to add different suffix to each version. Do not forget to fill both suffixes on facebook developer ("URL Scheme Suffix"). Leave it blank unless you are sure of what you are doing.
// The CFBundleURLSchemes in your App-Info.plist should be "fb" + the concatenation of these two IDs.
// Example:
//    SHKFacebookAppID = 555
//    SHKFacebookLocalAppID = lite
//
//    Your CFBundleURLSchemes entry: fb555lite
- (NSString*)facebookAppId {
	return @"669574756438254";
}

- (NSString*)facebookLocalAppId {
	return @"";
}

- (NSNumber*)forcePreIOS6FacebookPosting {
	return [NSNumber numberWithBool:false];
}

// Twitter - http://dev.twitter.com/apps/new
/*
 Important Twitter settings to get right:
 
 Differences between OAuth and xAuth
 --
 There are two types of authentication provided for Twitter, OAuth and xAuth.  OAuth is the default and will
 present a web view to log the user in.  xAuth presents a native entry form but requires Twitter to add xAuth to your app (you have to request it from them).
 If your app has been approved for xAuth, set SHKTwitterUseXAuth to 1.
 
 Callback URL (important to get right for OAuth users)
 --
 1. Open your application settings at http://dev.twitter.com/apps/
 2. 'Application Type' should be set to BROWSER (not client)
 3. 'Callback URL' should match whatever you enter in SHKTwitterCallbackUrl.  The callback url doesn't have to be an actual existing url.  The user will never get to it because ShareKit intercepts it before the user is redirected.  It just needs to match.
 */

- (NSString*)twitterConsumerKey {
	return @"48Ii81VO5NtDKIsQDZ3Ggw";
}

- (NSString*)twitterSecret {
	return @"WYc2HSatOQGXlUCsYnuW3UjrlqQj0xvkvvOIsKek32g";
}
// You need to set this if using OAuth, see note above (xAuth users can skip it)
- (NSString*)twitterCallbackUrl {
	return @"http://twitter.sharekit.com";
}
// To use xAuth, set to 1
- (NSNumber*)twitterUseXAuth {
	return [NSNumber numberWithInt:0];
}
// Enter your app's twitter account if you'd like to ask the user to follow it when logging in. (Only for xAuth)
- (NSString*)twitterUsername {
	return @"";
}

- (NSNumber *)showActionSheetMoreButton{
  	return [NSNumber numberWithBool:false];
}

@end
