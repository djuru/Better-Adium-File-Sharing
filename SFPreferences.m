/**  
 *  Copyright (C) 2012 Jan Murin <http://www.murin.cz>
 *
 *
 *  This file is part of the Better Adium Sharing plugin for Adium.
 *  
 *  Better Adium Sharing is free software: you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License as
 *  published by the Free Software Foundation, either version 2 of the
 *  License, or (at your option) any later version.
 *
 *  Better Adium Sharing is distributed in the hope that it will be useful, but
 *  WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 *  General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Better Adium Sharing. If not, see http://www.gnu.org/licenses/.
 *
 **/

#import "SFPreferences.h"
#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <AIUtilities/AIDictionaryAdditions.h>
#import <Adium/AIPreferenceControllerProtocol.h>
#import <Adium/AIServiceIcons.h>
#import <Adium/ESDebugAILog.h>
#import <Adium/AIPlugin.h>

#import "BetterAdiumFileSharing.h"


static SFPreferences	*sharedInstance = nil;

@implementation SFPreferences

@synthesize duid;
@synthesize path;


/*
 * * * * * * * * * * * * * * * * * * * * * 
 Return shared instance
 * * * * * * * * * * * * * * * * * * * * *
 */
+ (SFPreferences *)sharedInstance
{	
	@synchronized(self) {
		if (!sharedInstance) {
			sharedInstance = [[self alloc] init];
		}
	}
	
	return sharedInstance;
}

/*
 * * * * * * * * * * * * * * * * * * * * * 
 Returns plugin category
 * * * * * * * * * * * * * * * * * * * * *
 */
- (AIPreferenceCategory)category
{
    return AIPref_Advanced;
}

/*
 * * * * * * * * * * * * * * * * * * * * * 
 Returns plugin label
 * * * * * * * * * * * * * * * * * * * * *
 */
- (NSString *)label
{
    return @"Better Adium Sharing";
}

/*
 * * * * * * * * * * * * * * * * * * * * * 
 Return
 * * * * * * * * * * * * * * * * * * * * *
 */
- (NSString *)nibName
{
    return @"SFPreferences";
}

/*
 * * * * * * * * * * * * * * * * * * * * * 
 Returns plugin icon
 * * * * * * * * * * * * * * * * * * * * *
 */
- (NSImage *)image
{
    
    NSString* imageName = [[NSBundle bundleForClass:[self class]] pathForResource:@"icon" ofType:@"png"];
	NSImage* imageObj = [[NSImage alloc] initWithContentsOfFile:imageName];
	[imageObj autorelease];
	return imageObj;
    
}

/*
 * * * * * * * * * * * * * * * * * * * * * 
 Returns plugin category
 * * * * * * * * * * * * * * * * * * * * *
 */
- (NSView *)view
{
	return [[super view] retain];
}

/*
 * * * * * * * * * * * * * * * * * * * * * 
 Open Dialog to choose folder
 * * * * * * * * * * * * * * * * * * * * *
 */
- (IBAction)setTextF:(id)sender {
    
    // Create a File Open Dialog 
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Enable options in the dialog.
    [openDlg setCanChooseFiles:NO];
    [openDlg setAllowsMultipleSelection:NO];
	[openDlg setCanChooseDirectories:YES];
    
    if ( [openDlg runModal] == NSOKButton ) {
        [textPath setStringValue: [[[openDlg URLs] objectAtIndex:0] path] ];
    }
}


/*
 * * * * * * * * * * * * * * * * * * * * * 
 After the is view loaded
 * * * * * * * * * * * * * * * * * * * * *
 */
- (void)viewDidLoad
{
    
    
    //load Dropbox User ID
    [dropboxUIDTextField setStringValue: [[adium preferenceController] preferenceForKey: DROPBOX_USER_ID group: PREF_GROUP_BAS]];
    
    //Load path to Dropbox public folder
    [textPath setStringValue: [[adium preferenceController] preferenceForKey: DROPBOX_PATH group: PREF_GROUP_BAS]]; 
    
    
	[super viewDidLoad];
}
/*
 * * * * * * * * * * * * * * * * * * * * * 
    Open webpages with guide
 * * * * * * * * * * * * * * * * * * * * *
 */
- (IBAction)openPage:(id)sender 
{
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"http://betteradiumfiles.murin.cz/index.html#SettingBAS"]];
}
/*
 * * * * * * * * * * * * * * * * * * * * * 
 Before the is view loaded
 * * * * * * * * * * * * * * * * * * * * *
 */
- (void)viewWillClose
{
    //save Dropbox User ID
    [[adium preferenceController] setPreference: [dropboxUIDTextField stringValue] 
                                         forKey: DROPBOX_USER_ID
                                          group: PREF_GROUP_BAS];
    //save path to Dropbox public folder
    [[adium preferenceController] setPreference: [textPath stringValue] 
                                         forKey: DROPBOX_PATH
                                          group: PREF_GROUP_BAS];
    
	[[super view] release];
	
	[super viewWillClose];
}


@end
