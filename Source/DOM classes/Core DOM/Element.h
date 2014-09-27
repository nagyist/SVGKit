/*
 From SVG-DOM, via Core-DOM:
 
 http://www.w3.org/TR/DOM-Level-2-Core/core.html#ID-745549614
 
 interface Element : Node {
 readonly attribute DOMString        tagName;
 DOMString          getAttribute(in DOMString name);
 void               setAttribute(in DOMString name, 
 in DOMString value)
 raises(DOMException);
 void               removeAttribute(in DOMString name)
 raises(DOMException);
 Attr               getAttributeNode(in DOMString name);
 Attr               setAttributeNode(in Attr newAttr)
 raises(DOMException);
 Attr               removeAttributeNode(in Attr oldAttr)
 raises(DOMException);
 NodeList           getElementsByTagName(in DOMString name);
 // Introduced in DOM Level 2:
 DOMString          getAttributeNS(in DOMString namespaceURI, 
 in DOMString localName);
 // Introduced in DOM Level 2:
 void               setAttributeNS(in DOMString namespaceURI, 
 in DOMString qualifiedName, 
 in DOMString value)
 raises(DOMException);
 // Introduced in DOM Level 2:
 void               removeAttributeNS(in DOMString namespaceURI, 
 in DOMString localName)
 raises(DOMException);
 // Introduced in DOM Level 2:
 Attr               getAttributeNodeNS(in DOMString namespaceURI, 
 in DOMString localName);
 // Introduced in DOM Level 2:
 Attr               setAttributeNodeNS(in Attr newAttr)
 raises(DOMException);
 // Introduced in DOM Level 2:
 NodeList           getElementsByTagNameNS(in DOMString namespaceURI, 
 in DOMString localName);
 // Introduced in DOM Level 2:
 boolean            hasAttribute(in DOMString name);
 // Introduced in DOM Level 2:
 boolean            hasAttributeNS(in DOMString namespaceURI, 
 in DOMString localName);
 };
 */

#import <Foundation/Foundation.h>

#import "Node.h"
#import "Attr.h"
#import "NodeList.h"

@interface Element : Node

@property(nonatomic,strong,readonly) NSString* tagName;

-(NSString*) getAttribute:(NSString*) name;
-(void) setAttribute:(NSString*) name value:(NSString*) value;
-(void) removeAttribute:(NSString*) name;
-(Attr*) getAttributeNode:(NSString*) name;
-(Attr*) setAttributeNode:(Attr*) newAttr;
-(Attr*) removeAttributeNode:(Attr*) oldAttr;
-(NodeList*) getElementsByTagName:(NSString*) name;

// Introduced in DOM Level 2:
-(NSString*) getAttributeNS:(NSString*) namespaceURI localName:(NSString*) localName;

// Introduced in DOM Level 2:
-(void) setAttributeNS:(NSString*) namespaceURI qualifiedName:(NSString*) qualifiedName value:(NSString*) value;

// Introduced in DOM Level 2:
-(void) removeAttributeNS:(NSString*) namespaceURI localName:(NSString*) localName;

// Introduced in DOM Level 2:
-(Attr*) getAttributeNodeNS:(NSString*) namespaceURI localName:(NSString*) localName;

// Introduced in DOM Level 2:
-(Attr*) setAttributeNodeNS:(Attr*) newAttr;

// Introduced in DOM Level 2:
-(NodeList*) getElementsByTagNameNS:(NSString*) namespaceURI localName:(NSString*) localName;

// Introduced in DOM Level 2:
-(BOOL) hasAttribute:(NSString*) name;

// Introduced in DOM Level 2:
-(BOOL) hasAttributeNS:(NSString*) namespaceURI localName:(NSString*) localName;

#pragma mark - Objective-C init methods (not in SVG Spec - you're supposed to use SVGDocument's createXXX methods instead)

- (instancetype)initWithLocalName:(NSString*) n attributes:(NSMutableDictionary*) attributes NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithQualifiedName:(NSString*) n inNameSpaceURI:(NSString*) nsURI attributes:(NSMutableDictionary*) attributes NS_DESIGNATED_INITIALIZER;
	
@end
