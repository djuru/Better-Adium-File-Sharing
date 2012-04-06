

#import "AISFPreferences.h"
#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <AIUtilities/AIDictionaryAdditions.h>
#import <Adium/AIPreferenceControllerProtocol.h>
#import <Adium/AIServiceIcons.h>
#import <Adium/ESDebugAILog.h>
#import <Adium/AIPlugin.h>



static BAFSPreferences	*sharedInstance = nil;

@implementation BAFSPreferences

@synthesize duid;
@synthesize path;


+ (BAFSPreferences *)sharedInstance
{	
	@synchronized(self) {
		if (!sharedInstance) {
			sharedInstance = [[self alloc] init];
		}
	}
	
	return sharedInstance;
}

- (AIPreferenceCategory)category
{
    return AIPref_Advanced;
}

- (NSString *)label
{
    return @"Better Adium Sharing";
}

- (NSString *)nibName
{
    return @"SFPreferences";
}

- (NSImage *)image
{

    NSString* imageName = [[NSBundle bundleForClass:[self class]] pathForResource:@"custom-emoticon2" ofType:@"png"];
	NSImage* imageObj = [[NSImage alloc] initWithContentsOfFile:imageName];
	[imageObj autorelease];
	return imageObj;

}


- (NSView *)view
{
	return [[super view] retain];
}

- (IBAction)setTextF:(id)sender {
    // Create a File Open Dialog class.
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Enable options in the dialog.
    [openDlg setCanChooseFiles:NO];
    [openDlg setAllowsMultipleSelection:NO];
	[openDlg setCanChooseDirectories:YES];
    
    if ( [openDlg runModal] == NSOKButton ) {
        [textPath setStringValue: [[[openDlg URLs] objectAtIndex:0] path] ];
    }
}


/*!
 * @brief The view loaded
 */
- (void)viewDidLoad
{
    
    duid = [[adium preferenceController] preferenceForKey: DROPBOX_USER_ID group:PREF_GROUP_BAS];
   [textPath setStringValue: [[adium preferenceController] preferenceForKey: DROPBOX_PATH group:PREF_GROUP_BAS]];
    
    
	[super viewDidLoad];
}

- (void)viewWillClose
{
    
    [[adium preferenceController] setPreference: duid 
                                         forKey: DROPBOX_USER_ID
                                          group: PREF_GROUP_BAS];
   
    [[adium preferenceController] setPreference: [textPath stringValue] 
                                         forKey: DROPBOX_PATH
                                          group: PREF_GROUP_BAS];
    
	[[super view] release];
	
	[super viewWillClose];
}


@end
