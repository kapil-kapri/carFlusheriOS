#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^VisitSubviewBlock)(UIView *subview );

@interface UIView(HierarchyAdditions)

-(NSArray *) allSubviews;	// recursive

-(void) visitAllSubviewsWithBlock: (VisitSubviewBlock) visitSubviewBlock;

@end
