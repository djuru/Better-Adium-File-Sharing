//
//  BetterAdiumFileSharing.m
//  Better-Adium-File-Sharing
//
//  Created by Jan Murin on 4/2/12.
//  Copyright (c) 2012 cz.murin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

#import <Adium/ESFileTransfer.h>
#import <AIUtilities/AIToolbarUtilities.h>
#import <AIUtilities/AIStringUtilities.h>
#import <Adium/AIPreferenceControllerProtocol.h>

#import "BetterAdiumFileSharing.h"



#define	TOOLBAR_ICON_IDENTIFIER		@"Better Adium File Sharing"
#define	ICON_TITLE                      AILocalizedString(@"Better Adium File Sharing",nil)
#define	ICON_TOOLTIP			AILocalizedString(@"Share via Dropbox",nil)

@implementation BetterAdiumFileSharing

/*
 * * * * * * * * * * * * * * * * * * * * * 
    Returns Plugin Author
 * * * * * * * * * * * * * * * * * * * * *
 */
- (NSString *)pluginAuthor {
	return @"Jan Murin";
}
/*
 * * * * * * * * * * * * * * * * * * * * * 
    Returns webpages about plugin
 * * * * * * * * * * * * * * * * * * * * *
 */
- (NSString *)pluginURL {
	return @"http://betteradiumfiles.murin.cz";
}

/*
 * * * * * * * * * * * * * * * * * * * * * 
    Returns plugin version
 * * * * * * * * * * * * * * * * * * * * *
 */
- (NSString *)pluginVersion {
	return @"0.01";
}

/*
 * * * * * * * * * * * * * * * * * * * * * 
    Returns plugin description
 * * * * * * * * * * * * * * * * * * * * *
 */
- (NSString *)pluginDescription {
	return @"Adium plugin for sharing files via Dropbox Public Links."; 
}

/*
 * * * * * * * * * * * * * * * * * * * * * 
    Do during installing plugin
 * * * * * * * * * * * * * * * * * * * * *
 */
- (void) installPlugin
{
    
    
    NSToolbarItem	*chatItem = [AIToolbarUtilities toolbarItemWithIdentifier: TOOLBAR_ICON_IDENTIFIER
                                                                        label: ICON_TITLE
                                                                 paletteLabel: ICON_TOOLTIP
                                                                      toolTip: ICON_TOOLTIP
                                                                       target:self
                                                             settingSelector:@selector(setImage:)
                                                                itemContent:[NSImage imageNamed:@"icon" forClass:[self class] loadLazily:YES]
                                                                     action:@selector(chooseFilesToSend:)
                                                                       menu:nil];
    
    [[adium toolbarController] registerToolbarItem:chatItem forToolbarType:@"ListObject"];

}

/*
 * * * * * * * * * * * * * * * * * * * * * 
  Opens dialog for choosing files to send
 * * * * * * * * * * * * * * * * * * * * *
 */
- (void)chooseFilesToSend:(id)sender 
{
    // Create a File Open Dialog
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    // Enable options in the dialog.
    [openDlg setCanChooseFiles:YES];
    [openDlg setAllowsMultipleSelection:YES];
    [openDlg setPrompt: AILocalizedStringFromTable(@"Send", @"Buttons", nil)];
	

    // If the SEND pressed, process the files
    if ( [openDlg runModal] == NSOKButton ) {
        // Gets list of all files selected
        NSArray *files = [openDlg URLs];
        //copy files
        //send messages
    }
    
}
/*
 * * * * * * * * * * * * * * * * * * * * * 
  Copy all files do Dropbox Public folder
 * * * * * * * * * * * * * * * * * * * * *
 */
-(void) copyFiles: (NSArray *)files
{
    //iterate over all files
    for( int i = 0; i < [files count]; i++ ) 
    {
        NSString* filePath = [[files objectAtIndex:i] path];
    }
}

- (void) uninstallPlugin
{
}

@end
