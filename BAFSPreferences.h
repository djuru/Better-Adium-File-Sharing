

#import <Cocoa/Cocoa.h>

#import <Adium/AIPreferenceControllerProtocol.h>
#import <Adium/AIAdvancedPreferencePane.h>

#define PREF_GROUP_BAS	@"Better Adium Sharing"
#define DROPBOX_USER_ID	@"Dropbox User ID"
#define DROPBOX_PATH	@"Path to Dropbox Public directory"

@interface BAFSPreferences : AIAdvancedPreferencePane {
		    
    NSString    *duid;   //Dropbox user ID
    NSString    *path;  //path to public folder

    
    IBOutlet NSTextField *textPath;
    
}

+ (BAFSPreferences *)sharedInstance;

@property (copy) NSString *duid;

@property (copy) NSString *path;

@end
