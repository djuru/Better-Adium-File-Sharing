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

@interface BetterAdiumFileSharing() 

- (NSString *) unifyName: (NSString *)name : (NSString *)pathToDropboxPublicDirectory;
- (void) copyFiles: (NSArray *)files;
- (void) chooseFilesToSend:(id)sender;
- (void) sendMessage: (NSString *) message; 

@end

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
 Opens dialog for choosing files to send
 * * * * * * * * * * * * * * * * * * * * *
 */
- (void)chooseFilesToSend:(id)sender 
{
    
    NSString* dropboxPublicDirectory = [[adium preferenceController] preferenceForKey: DROPBOX_PATH group: PREF_GROUP_BAS]; 
    NSString *dropboxID =  [[adium preferenceController] preferenceForKey: DROPBOX_USER_ID group: PREF_GROUP_BAS];
    
    if( [dropboxID length] == 0 || [dropboxPublicDirectory length] == 0){
        NSString *question = @"Warning";
        NSString *info =  @"Please set plugin Better Adium File Sharing at Preferences > Advanced >  Better Adium File Sharing.";
        NSString *cancelButton = @"OK";
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:cancelButton];
        
        NSInteger answer = [alert runModal];
        [alert release];
        alert = nil;
        
        
        return;
    }
    
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
        [self copyFiles:files];
        
    }
    
}

/*
 * * * * * * * * * * * * * * * * * * * * * 
 Copy all files do Dropbox Public folder 
 * * * * * * * * * * * * * * * * * * * * *
 */
-(void) copyFiles: (NSArray *)files
{
    
    NSString* dropboxPublicDirectory = [[adium preferenceController] preferenceForKey: DROPBOX_PATH group: PREF_GROUP_BAS]; 
    NSString *dropboxID =  [[adium preferenceController] preferenceForKey: DROPBOX_USER_ID group: PREF_GROUP_BAS];
    
    //iterate over all files
    for( int i = 0; i < [files count]; i++ ) 
    {        
        
        NSString* fileToSendPath = [[files objectAtIndex:i] path]; 
        NSString* fileToSendName = [[fileToSendPath componentsSeparatedByString:@"/"] lastObject];
        NSString* fileToSendNewName = [self unifyName:fileToSendName :dropboxPublicDirectory];
        NSString* toCopy = [dropboxPublicDirectory stringByAppendingFormat:@"/%@", fileToSendNewName];
        
        NSError *error = nil;
        //error while copying
        if (![[NSFileManager defaultManager] copyItemAtPath:fileToSendPath toPath:toCopy error:&error])
        {
            
            NSString *question =error.localizedFailureReason;
            NSString *info = error.localizedDescription;
            NSString *cancelButton = NSLocalizedString(@"Cancel", 
                                                       @"Cancel button title");
            
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setMessageText:question];
            [alert setInformativeText:info];
            [alert addButtonWithTitle:cancelButton];
            
            NSInteger answer = [alert runModal];
            [alert release];
            alert = nil;
        }
        //copying succeeded    
        else
        {    
            //create link and send it to user
            NSString* msg = @"Link for download will be available soon: ";
            msg = [msg stringByAppendingFormat:@"%@", @"http://dl.dropbox.com/u/"];
            msg = [msg stringByAppendingFormat:@"%@", dropboxID];
            msg = [msg stringByAppendingFormat:@"%@", @"/"];
            msg = [msg stringByAppendingFormat:@"%@", fileToSendNewName];      
            
            [self sendMessage:msg];
        }
        
           
    }
}
/*
 * * * * * * * * * * * * * * * * * * * * * 
 Generate uniq name and removes white spaces
 * * * * * * * * * * * * * * * * * * * * *
 */
-(NSString *) unifyName: (NSString *)fileName : (NSString *)pathToDropboxPublicDirectory
{
    
    NSFileManager *fileManager =  fileManager = [NSFileManager defaultManager];
    
    NSString *newName = fileName;
    
    //remove white spaces
    newName = [newName stringByReplacingOccurrencesOfString:@" " withString:@""];  
    
    //if file exists rename
    while([fileManager fileExistsAtPath: [pathToDropboxPublicDirectory stringByAppendingFormat:@"/%@", newName]]){
        
        
        //create timestamp with random number
        NSDate *currDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        NSString *dateString = [dateFormatter stringFromDate:currDate];
        dateString = [dateString stringByAppendingFormat:@"%@", @"_"];
        dateString = [dateString stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%d", arc4random() % 1000000]];
        
        NSArray *chunks = [newName componentsSeparatedByString: @"."];
        NSString *name = [chunks objectAtIndex:0];
        NSString* ending = [chunks lastObject];
        
        //new name = <original_name_without_whitespaces>_<timestamp>_<rand_number>.<ending>
        newName = @"";
        newName = [newName stringByAppendingFormat:@"%@", name];        //<name>
        newName = [newName stringByAppendingFormat:@"%@", @"_"];        //<name>_
        newName = [newName stringByAppendingFormat:@"%@", dateString];  //<name>_<timeStamp>
        newName = [newName stringByAppendingFormat:@"%@", @"."];        //<name>_<timeStamp>.
        newName = [newName stringByAppendingFormat:@"%@", ending];      //<name>_<timeStamp>.<ending>
        
        
        
    }
        
    return newName;
    
}

@end
