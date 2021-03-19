//
//  AppDelegate.m
//  label
//
//  Created by CheeHwa.Leong on 17/3/21.
//

#import "AppDelegate.h"

#define LogRect(RECT) NSLog(@"%s: pos(%0.0f, %0.0f) [%0.0f x %0.0f]", \
    #RECT, RECT.origin.x, RECT.origin.y, RECT.size.width, RECT.size.height)
#define LogSize(SIZE) NSLog(@"%s: [width:%0.0f height:%0.0f]", \
    #SIZE, SIZE.width, SIZE.height)

@interface AppDelegate ()

// UI.
@property (strong) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *topLabel;
@property (weak) IBOutlet NSTextField *searchResultLabel;
@property (weak) IBOutlet NSTextField *searchTextField;
@property (weak) IBOutlet NSButton *searchButton;

// Functions.
- (void)setSubStringPosition;
- (NSRect)findSubStringRect:(NSTextField*)textField urlString:(NSString*)subString;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  // Insert code here to initialize your application
  [self setSubStringPosition];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
  // Insert code here to tear down your application
}
- (void)setSubStringPosition
{
  NSRect resultRect = [self findSubStringRect:
                       self.topLabel
                       urlString:[self.searchTextField stringValue]];

  [self.searchResultLabel setFrame:resultRect];
  [self.searchResultLabel setStringValue:[self.searchTextField stringValue]];
  [self.searchResultLabel sizeToFit];
  LogRect(resultRect);
}

- (IBAction)searchOnPressed:(id)sender
{
  [self setSubStringPosition];
}

- (NSRect)findSubStringRect:(NSTextField*)textField urlString:(NSString*)subString
{
  NSRange matchRange = [[textField stringValue] rangeOfString:subString];
  NSRect rect;
  // The string's 'space' in xib.
  NSRect textBound = [textField.cell titleRectForBounds:textField.bounds];

  // Setting up the string's 'space' in code.
  NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:textField.attributedStringValue];
  [textStorage setFont:[textField font]];
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  [paragraphStyle setLineSpacing:[[NSParagraphStyle defaultParagraphStyle] lineSpacing]];
  [textStorage addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [[textField.attributedStringValue string] length])];

  // Get the glyph range of the substring and later, the position and size of the substring.
  NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
  [textStorage addLayoutManager:layoutManager];
  NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:textBound.size];
  [textContainer setLineFragmentPadding:0];
  [layoutManager addTextContainer:textContainer];
  NSRange glyphRange;
  [layoutManager characterRangeForGlyphRange:matchRange actualGlyphRange:&glyphRange];

  // TextField's coordinate space to Window's coordinate space.
  rect = [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
  rect = NSOffsetRect(rect, textBound.origin.x, textBound.origin.y);
  rect = [textField convertRect:rect toView:[self.window contentView]];

  return rect;
}

@end
