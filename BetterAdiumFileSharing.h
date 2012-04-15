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
