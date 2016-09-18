//https://sankarvln.wordpress.com/2014/05/27/guide-to-use-sqlite-in-ios-prepared-statements/

//  Created by Payal Patel on 13/08/15.
//  Copyright (c) 2015 Payal Patel. All rights reserved.
//

#import "AppDelegate.h"


@protocol PSDatabaseDelegate <NSObject>
@optional
- (void)databaseTableWasUpdated:(NSString *)table;
@end

@interface PSDatabase : NSObject {
	
	//id<SKDatabaseDelegate> delegate;
	sqlite3 *dbh;
	NSString *docPath;
	BOOL dynamic;
	BOOL isWorking;

}

@property (assign) id<PSDatabaseDelegate> delegate;
@property sqlite3 *dbh;
@property BOOL dynamic;
@property BOOL isWorking;
@property (nonatomic,retain) NSString *docPath;



- (id)initWithFile:(NSString *)dbFile;
- (id)initWithDynamicFile:(NSString *)dbFile;
-(void)createDynamicTable:(NSString *)tableName parameter:(NSString *)pam;

- (void)open;
- (void)close;
- (void) lockDB:(BOOL)Lock;
-(BOOL)alterDB:(NSString *)sql table:(NSString *)table;

- (id)lookupColForSQL:(NSString *)sql;
- (NSDictionary *)lookupRowForSQL:(NSString *)sql;

- (int)lookupCount:(NSString *)table;
- (int)lookupCountWhere:(NSString *)where whereValue:(NSArray *)value forTable:(NSString *)table;
- (int)lookupMax:(NSString *)key Where:(NSString *)where whereValue:(NSArray *)value forTable:(NSString *)table;
- (double)lookupMin:(NSString *)key Where:(NSString *)where whereValue:(NSArray *)value forTable:(NSString *)table;
- (int)lookupSum:(NSString *)key Where:(NSString *)where whereValue:(NSArray *)value forTable:(NSString *)table;
- (float)lookupSumValueFloat:(NSString *)key Where:(NSString *)where whereValue:(NSArray *)value forTable:(NSString *)table;

- (BOOL)insertDictionary:(NSDictionary *)dbData forTable:(NSString *)table;

- (BOOL)updateDictionary:(NSDictionary *)dbData forTable:(NSString *)table where:(NSString *)where whereValue:(NSArray *)value;

- (BOOL)deleteWhere:(NSString *)where values:(NSArray *)value forTable:(NSString *)table;
- (BOOL)deleteAll:(NSString *)table;


- (NSMutableArray *) fetchAllRows:(NSString *)sql withObject:(id)myObj;
- (id)fetchRow:(NSString *)sql withObject:(id)myObj whereValue:(NSArray *)value;
- (NSMutableArray *) fetchAllRows:(NSString *)sql withObject:(id)myObj whereValue:(NSArray *)value;
- (void) checkLock;
@end



