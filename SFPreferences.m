

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
    
    NSString* dropboxPublicDirectory = [[adium preferenceController] preferenceForKey: DROPBOX_PATH group: PREF_GROUP_BAS]; 
    NSString *dropboxID =  [[adium preferenceController] preferenceForKey: DROPBOX_USER_ID group: PREF_GROUP_BAS];
    
    if( [dropboxID length] == 0 || [dropboxPublicDirectory length] == 0){
    
        //load Dropbox User ID
        duid = dropboxID;
   
        //Load path to Dropbox public folder
        [textPath setStringValue: dropboxPublicDirectory];
    
    }
	[super viewDidLoad];
}
- (IBAction)openPage:(id)sender 
{
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"http://betteradiumfiles.murin.cz"]];
}
/*
 * * * * * * * * * * * * * * * * * * * * * 
    Before the is view loaded
 * * * * * * * * * * * * * * * * * * * * *
 */
- (void)viewWillClose
{
    //save Dropbox User ID
    [[adium preferenceController] setPreference: duid 
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
