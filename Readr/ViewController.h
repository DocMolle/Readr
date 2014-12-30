//
//  ViewController.h
//  Readr
//
//  Created by Sven-Eric on 12/26/14.
//  Copyright (c) 2014 Molzahn Consulting. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MWFeedParser.h"

@interface ViewController : NSViewController <MWFeedParserDelegate, NSTableViewDataSource, NSTableViewDelegate> {
    
    //Parsing
    MWFeedParser *feedParser;
    NSMutableArray *parsedItems;
    
    // Displaying
    NSArray *itemsToDisplay;
    NSDateFormatter *formatter;
}

@property (nonatomic, strong) NSArray *itemsToDisplay;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTextField *lblTitle;
@property (weak) IBOutlet NSTextField *lblContent;

-(IBAction)toolbarItem:(id)sender;


@end

