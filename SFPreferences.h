

#import <Cocoa/Cocoa.h>

#import <Adium/AIPreferenceControllerProtocol.h>
#import <Adium/AIAdvancedPreferencePane.h>

@interface SFPreferences : AIAdvancedPreferencePane {
		    
    NSString    *duid;   //Dropbox user ID
    NSString    *path;  //path to public folder

    
    IBOutlet NSTextField *textPath;
    
}

+ (SFPreferences *)sharedInstance;

@property (copy) NSString *duid;
@property (copy) NSString *path;

@end
