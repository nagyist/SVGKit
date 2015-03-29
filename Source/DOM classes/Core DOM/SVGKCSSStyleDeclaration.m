#import "SVGKCSSStyleDeclaration.h"

#import "SVGKCSSValue.h"
#import "SVGKCSSValueList.h"
#import "SVGKCSSPrimitiveValue.h"
#import <CocoaLumberjack/DDFileLogger.h>

@interface SVGKCSSStyleDeclaration()

@property(nonatomic,strong) NSMutableDictionary* internalDictionaryOfStylesByCSSClass;

@end

@implementation SVGKCSSStyleDeclaration

@synthesize internalDictionaryOfStylesByCSSClass;

@synthesize cssText = _cssText;
@synthesize length;
@synthesize parentRule;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.internalDictionaryOfStylesByCSSClass = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#define MAX_ACCUM 256
#define MAX_NAME 256

/** From spec:
 
 "The parsable textual representation of the declaration block (excluding the surrounding curly braces). Setting this attribute will result in the parsing of the new value and resetting of all the properties in the declaration block including the removal or addition of properties."
 */
-(void)setCssText:(NSString *)newCSSText
{
	_cssText = newCSSText;
	
	/** and now post-process it, *as required by* the CSS/DOM spec... */
	NSMutableDictionary* processedStyles = [self NSDictionaryFromCSSAttributes:_cssText];
	
	self.internalDictionaryOfStylesByCSSClass = processedStyles;
	
}

-(NSMutableDictionary *) NSDictionaryFromCSSAttributes: (NSString *)css {
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	NSCharacterSet* trimChars = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	
	const char *cstr = [css UTF8String];
	size_t len = strlen(cstr);
	
	char name[MAX_NAME];
	bzero(name, MAX_NAME);
	
	char accum[MAX_ACCUM];
	bzero(accum, MAX_ACCUM);
	
	size_t accumIdx = 0;
	
	for (size_t n = 0; n <= len; n++) {
		char c = cstr[n];
		
		if (c == ':') {
			strncpy(name, accum, MAX_NAME);
			name[accumIdx] = '\0';
			
			bzero(accum, MAX_ACCUM);
			accumIdx = 0;
			
			continue;
		}
		else if (c == ';' || c == '\0') {
            if( accumIdx > 0 ) //if there is a ';' and '\0' to end the style, avoid adding an empty key-value pair
            {
                accum[accumIdx] = '\0';
                
                NSString *keyString = [@(name)
									   stringByTrimmingCharactersInSet:trimChars];
				NSString *cssValueString = [@(accum)
											stringByTrimmingCharactersInSet:trimChars];
				
				SVGKCSSValue *cssValue;
				if( [cssValueString rangeOfString:@" "].length > 0 )
					cssValue = [[SVGKCSSValueList alloc] init];
				else
					cssValue = [[SVGKCSSPrimitiveValue alloc] init];
				cssValue.cssText = cssValueString; // has the side-effect of parsing, if required
				
                dict[keyString] = cssValue;
                
                bzero(name, MAX_NAME);
				
                bzero(accum, MAX_ACCUM);
                accumIdx = 0;
            }
			
			continue;
		}
		
		accum[accumIdx++] = c;
		if (accumIdx >= MAX_ACCUM) {
			DDLogWarn(@"Buffer ovverun while parsing style sheet - skipping");
			return dict;
		}
	}
	
	return dict;
}

-(NSString*) getPropertyValue:(NSString*) propertyName
{
	SVGKCSSValue* v = [self getPropertyCSSValue:propertyName];
	
	if( v == nil )
		return nil;
	else
		return v.cssText;
}

-(SVGKCSSValue*) getPropertyCSSValue:(NSString*) propertyName
{
	return (self.internalDictionaryOfStylesByCSSClass)[propertyName];
}

-(NSString*) removeProperty:(NSString*) propertyName
{
	NSString* oldValue = [self getPropertyValue:propertyName];
	[self.internalDictionaryOfStylesByCSSClass removeObjectForKey:propertyName];
	return oldValue;
}

-(NSString*) getPropertyPriority:(NSString*) propertyName
{
	NSAssert(FALSE, @"CSS 'property priorities' - Not supported");
	
	return nil;
}

-(void) setProperty:(NSString*) propertyName value:(NSString*) value priority:(NSString*) priority
{
	NSAssert(FALSE, @"CSS 'property priorities' - Not supported");
}

-(NSString*) item:(long) index
{
	/** this is stupid slow, but until Apple *can be bothered* to add a "stable-order" dictionary to their libraries, this is the only sensibly easy way of implementing this method */
	NSArray* sortedKeys = [[self.internalDictionaryOfStylesByCSSClass allKeys] sortedArrayUsingSelector:@selector(compare:)];
	SVGKCSSValue* v = sortedKeys[index];
	return v.cssText;
}

-(NSString *)description
{
	return [NSString stringWithFormat:@"CSSStyleDeclaration: dictionary(%@)", self.internalDictionaryOfStylesByCSSClass];
}

@end
