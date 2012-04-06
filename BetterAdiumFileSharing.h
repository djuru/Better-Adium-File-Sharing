//
//  BetterAdiumFileSharing.h
//  Better-Adium-File-Sharing
//
//  Created by Jan Murin on 4/2/12.
//  Copyright (c) 2012 cz.murin. All rights reserved.
//

#import <Adium/AIPlugin.h>
#import "SFPreferences.h"

#define PREF_GROUP_BAS	@"Better Adium Sharing"
#define DROPBOX_USER_ID	@"Dropbox User ID"
#define DROPBOX_PATH	@"Path to Dropbox Public directory"

@interface BetterAdiumFileSharing : NSObject <AIPlugin>
{
    SFPreferences *preferences;
}
@end
