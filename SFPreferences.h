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

#import <Adium/AIPreferenceControllerProtocol.h>
#import <Adium/AIAdvancedPreferencePane.h>

@interface SFPreferences : AIAdvancedPreferencePane {
		    
    NSString    *duid;   //Dropbox user ID
    NSString    *path;  //path to public folder

    
    IBOutlet NSTextField *textPath;
    IBOutlet NSTextField *dropboxUIDTextField;
    
}

+ (SFPreferences *)sharedInstance;

@property (copy) NSString *duid;
@property (copy) NSString *path;

@end
