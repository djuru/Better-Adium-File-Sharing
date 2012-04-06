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
#import <Adium/AIPreferenceControllerProtocol.h>
#import <Adium/AIPreferenceControllerProtocol.h>

#import "BetterAdiumFileSharing.h"



#define	TOOLBAR_ICON_IDENTIFIER		@"Better Adium File Sharing"
#define	ICON_TITLE                  @"Better Adium File Sharing"
#define	ICON_TOOLTIP                @"Share via Dropbox"

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
    //Preferences view
    preferences = [[SFPreferences sharedInstance] retain];
    
    //Set icon for plugin
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
 Before uninstall
 * * * * * * * * * * * * * * * * * * * * *
 */
- (void) uninstallPlugin
{
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
    [openDlg setPrompt:  @"Send"];
     

    // If the SEND pressed, process the files
    if ( [openDlg runModal] == NSOKButton ) {
        
        // Gets list of all files selected
        NSArray *files = [openDlg URLs];
        
        // ========== copy files ==========

        //send all links to user
        for( int i = 0; i < [files count]; i++ ) 
        {
            NSString  *message; //[[files objectAtIndex:i] path]
            //create message
            //send message
        }
    }
    
}

/*
 * * * * * * * * * * * * * * * * * * * * * 
  Sends message to current user in dialog
 * * * * * * * * * * * * * * * * * * * * *
 */
-(void) sendMessage: (NSString *) message 
{

    AIListContact *contact = [[[adium interfaceController] activeChat] listObject]; 
    NSAttributedString *messageAttrStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:message]];
    AIAccount *account = [[adium accountController] preferredAccountForSendingContentType:CONTENT_MESSAGE_TYPE toContact:contact];
    AIChat *chat = [[adium chatController] chatWithContact:contact];
    AIContentMessage *message2 = [[AIContentMessage alloc] initWithChat:chat source:account destination:contact date:[NSDate date] message:messageAttrStr];
    
    [[adium contentController] sendContentObject:message2];


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
        // ==========  copy them  ========== 
        
    }
}


@end
