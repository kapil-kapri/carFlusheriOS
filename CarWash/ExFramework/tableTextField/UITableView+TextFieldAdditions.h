#import <UIKit/UIKit.h>

@interface UITableView (TextFieldAdditions)

// query
-(NSIndexPath *) indexPathForFirstResponder;
-(UITextField *) currentFirstResponderTextField;

// change first responder
-(void) makeNextCellWithTextFieldFirstResponder;
-(void) makeFirstResponderForIndexPath: (NSIndexPath *) indexPath;
-(void) makeFirstResponderForIndexPath: (NSIndexPath *) indexPath scrollPosition: (UITableViewScrollPosition) scrollPosition;

// watch for keyboard presentation/dismissal [if you call beginXXX, you must call endXXX]
-(void) beginWatchingForKeyboardStateChanges;
-(void) endWatchingForKeyboardStateChanges;

//change 21_Nov_2013 by payal
-(NSMutableArray *) notificationObservers;
-(UITextField *) textFieldForCell: (UITableViewCell *) cell;
-(BOOL) indexPath: (NSIndexPath *) indexPath isInRangeFromIndexPath: (NSIndexPath *) fromIndexPath  toIndexPath: (NSIndexPath *) toIndexPath;
-(BOOL) makeNextCellWithTextFieldFirstResponderFromIndexPath: (NSIndexPath *) fromIndexPath
												 toIndexPath: (NSIndexPath *) toIndexPath;

@end
