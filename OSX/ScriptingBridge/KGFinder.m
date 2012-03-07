//
//  KGFinder.h
//  KGLib
//
//  Created by David Keegan on 5/23/09.
//  Copyright 2009-2011 InScopeApps{+}. All rights reserved.
//

#import "KGFinder.h"

@implementation KGFinder

+ (FinderApplication *)finder{
    static FinderApplication *finderApp = nil;
    if(finderApp == nil){
        finderApp = [SBApplication applicationWithBundleIdentifier:@"com.apple.finder"];
    }
    return finderApp;
}

+ (NSString *)activeFinderWindowURL{
    //the front window looks like it is always the first in the array
    //if this is not the case we will need to loop over the windows
    //and inspect their indices, the windows count from front to back
    FinderWindow *frontWindow = [[[KGFinder finder] windows] objectAtIndex:0];
    FinderFolder *folder = [[frontWindow properties] objectForKey:@"target"];
    if([folder respondsToSelector:@selector(URL)]){
        NSURL *url = [NSURL URLWithString:[folder URL]];
        NSString *scheme = [url scheme];
        NSString *path = [url path];
        return [NSString stringWithFormat:@"%@://%@", scheme, path];
    }
    return nil;
}

+ (NSArray *)selectedFinderURLs{
    NSMutableArray *selected = [[NSMutableArray alloc] init];
    @autoreleasepool{
        for(FinderItem *item in [[[KGFinder finder] selection] get]){
            if([item respondsToSelector:@selector(URL)]){
                NSURL *url = [NSURL URLWithString:[item URL]];
                NSString *scheme = [url scheme];
                NSString *path = [url path];                
                [selected addObject:[NSString stringWithFormat:@"%@://%@", scheme, path]];
            }
        }
    }
    return selected;
}

@end
