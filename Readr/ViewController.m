//
//  ViewController.m
//  Readr
//
//  Created by Sven-Eric on 12/26/14.
//  Copyright (c) 2014 Molzahn Consulting. All rights reserved.
//

#import "ViewController.h"
#import "NSString+HTML.h"
#import "MWFeedParser.h"
#import "ItemCellView.h"

@implementation ViewController {
    
}

@synthesize itemsToDisplay;

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    self.title = @"Loading...";
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    parsedItems = [[NSMutableArray alloc] init];
    self.itemsToDisplay = [NSArray array];
    
    
    // Parse
//    NSURL *feedURL = [NSURL URLWithString:@"http://www.iwi.hs-karlsruhe.de/Intranetaccess/REST/rssfeed/newsbulletinboard/INFM"];
    NSURL *feedURL = [NSURL URLWithString:@"http://feeds.wired.com/wired/index"];
    feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
    feedParser.delegate = self;
    feedParser.feedParseType = ParseTypeFull;
    feedParser.connectionType = ConnectionTypeAsynchronously;
    [feedParser parse];
    
}


- (void)loadFeedFromURL:(NSString*)url{
    parsedItems = [[NSMutableArray alloc] init];
    NSURL *feedURL = [NSURL URLWithString:url];
    feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
    feedParser.delegate = self;
    feedParser.feedParseType = ParseTypeFull;
    feedParser.connectionType = ConnectionTypeAsynchronously;
    [feedParser parse];
}


-(IBAction)toolbarItem:(id)sender {
    if([sender tag] == 0){
        [self loadFeedFromURL:@"http://www.iwi.hs-karlsruhe.de/Intranetaccess/REST/rssfeed/newsbulletinboard/INFM"];
    }else if ([sender tag] == 1){
        [self loadFeedFromURL:@"http://feeds.wired.com/wired/index"];
    }
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSInteger selected = [self.tableView selectedRow];
    
    MWFeedItem *item = parsedItems[selected];
    
    NSString *summary = [item.summary stringByConvertingHTMLToPlainText];
    [self.lblTitle setStringValue:item.title];
    [self.lblContent setStringValue:summary];
    
    NSLog(@"changed %ld",(long)selected);
}



- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 64;
}

- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView {
    return [parsedItems count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *identifier = [tableColumn identifier];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"dd.MM.yyyy | hh.mm"];
    
    
    if ([identifier isEqualToString:@"MainCell"]){
        ItemCellView *cellView = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
        NSString *title = [parsedItems[row] title];
        NSDate *date =  [parsedItems[row] date];
        NSString *stringFromDate = [formatter2 stringFromDate:date];
        
        [cellView.textField setStringValue:title];
        [cellView.dateTextField setStringValue:stringFromDate];
        return cellView;
    }
    return nil;
}


#pragma mark -
#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
    NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
    NSLog(@"Parsed Feed Info: “%@”", info.title);
    self.title = info.title;
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    NSLog(@"Parsed Feed Item: “%@”", item.title);
    if (item) [parsedItems addObject:item];
    [self.tableView reloadData];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
    NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    [self.tableView reloadData];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
    NSLog(@"Finished Parsing With Error: %@", error);
    [self.tableView reloadData];
}

@end
