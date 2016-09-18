
//  Created by Payal Patel on 13/08/15.
//  Copyright (c) 2015 Payal Patel. All rights reserved.
//

#import "PSDatabase.h"

@implementation PSDatabase

@synthesize delegate;
@synthesize dbh;
@synthesize dynamic;
@synthesize isWorking;
@synthesize docPath;

// Two ways to init: one if you're just SELECTing from a database, one if you're UPDATing
// and or INSERTing

- (id)initWithFile:(NSString *)dbFile {
	if ((self = [super init])) {
	
		NSString *paths = [[NSBundle mainBundle] resourcePath];
		self.docPath = [paths stringByAppendingPathComponent:dbFile];
		
		[self open];
		self.dynamic = NO;
	}
	
	return self;	
}

- (id)initWithDynamicFile:(NSString *)dbFile {
	if ((self = [super init])) {
		
		NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *docDir = [docPaths objectAtIndex:0];
		self.docPath = [docDir stringByAppendingPathComponent:dbFile];
		
		NSFileManager *fileManager = [NSFileManager defaultManager];
		
		if (![fileManager fileExistsAtPath:self.docPath]) {
            
          
			NSString *origPaths = [[NSBundle mainBundle] resourcePath];
			NSString *origPath = [origPaths stringByAppendingPathComponent:dbFile];
		
			NSError *error;
            [fileManager copyItemAtPath:origPath toPath:self.docPath error:&error];
			/*int success = [fileManager copyItemAtPath:origPath toPath:self.docPath error:&error];
			NSAssert1(success,[NSString stringWithString:@"Failed to copy database into dynamic location"],error);*/
		}

		[self open];		
		self.dynamic = YES;
	}
	return self;
}

-(void)createDynamicTable:(NSString *)tableName parameter:(NSString *)pam
{
    char *errMsg;
    
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ( %@ )",tableName,pam];
    //const char *sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)";
    
    [self checkLock];
    self.isWorking = TRUE;
    const char *utfsql = [sql UTF8String];
    
    if (sqlite3_exec([self dbh], utfsql, NULL, NULL, &errMsg) != SQLITE_OK)
    {
        //NSLog(@"Failed to create table");
    }
    else
    {
        self.isWorking = false;
    }
//    [self runDynamicSQL:sql forTable:tableName];
}



// Users should never need to call prepare

- (void) checkLock{
    while(self.isWorking){
        //Debug(@"\n\t waiting for DB : %@",self.docPath);
        [NSThread sleepForTimeInterval:1];
    }
}

- (void) lockDB:(BOOL)Lock {
	if (Lock) {
		while(self.isWorking){
			//Debug(@"\n\t waiting for DB : %@",self.docPath);
			[NSThread sleepForTimeInterval:1];
		}
	}
	@synchronized(self){
		self.isWorking = Lock;
	}
}
// Users should never need to call prepare

- (sqlite3_stmt *)preparedSt:(NSString *)sql dictonary:(NSDictionary *)dbData key:(NSArray *)dataKeys{
    @synchronized(self){
        [self checkLock];
        self.isWorking = TRUE;
        
        
        const char *utfsql = [sql UTF8String];
        
        sqlite3_stmt *statement;
        //	int cou = sqlite3_prepare([self dbh],utfsql,-1,&statement,NULL);
        NSString *errMSG = [NSString stringWithFormat:@"%s",sqlite3_errmsg(dbh)];
        Err(@"Prepare ERR -> %s",sqlite3_errmsg(dbh));
        if ([errMSG isEqualToString:@"database disk image is malformed"]) {
            //NSLog(@"Something is wrong with Database !!!");
        }
        
        
        if(sqlite3_prepare_v2([self dbh],utfsql , -1, &statement, NULL)==SQLITE_OK)
        {
            if (dbData != nil) {
                for (int i = 0 ; i < [dataKeys count] ; i++) {
                    
                    if ([[dbData objectForKey:[dataKeys objectAtIndex:i]] isKindOfClass:[NSString class]]) {
                        NSString *strValue = [dbData objectForKey:[dataKeys objectAtIndex:i]];
                        strValue = [strValue stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                        //            strValue = [strValue stringByReplacingOccurrencesOfString:@"\"" withString:@"\"\""];
                        sqlite3_bind_text(statement, i+1, [strValue UTF8String], -1, SQLITE_TRANSIENT);
                    }
                    else if ([[dbData objectForKey:[dataKeys objectAtIndex:i]] isKindOfClass:[NSNumber class]])
                    {
                        //[sql appendFormat:@"'%@'",];
                        //sqlite3_bind_int(statement, i+1, [[dbData objectForKey:[dataKeys objectAtIndex:i]] intValue]);
                        id param = [dbData objectForKey:[dataKeys objectAtIndex:i]];
                        int count = i+1;
                        if (strcmp([param objCType], @encode(BOOL)) == 0) {
                            sqlite3_bind_int(statement, count, ([param boolValue] ? 1 : 0));
                        }
                        else if (strcmp([param objCType], @encode(int)) == 0) {
                            sqlite3_bind_int64(statement, count, [param longValue]);
                        }
                        else if (strcmp([param objCType], @encode(long)) == 0) {
                            sqlite3_bind_int64(statement, count, [param longValue]);
                        }
                        else if (strcmp([param objCType], @encode(long long)) == 0) {
                            sqlite3_bind_int64(statement, count, [param longLongValue]);
                        }
                        else if (strcmp([param objCType], @encode(unsigned long long)) == 0) {
                            sqlite3_bind_int64(statement, count, (long long)[param unsignedLongLongValue]);
                        }
                        else if (strcmp([param objCType], @encode(float)) == 0) {
                            sqlite3_bind_double(statement, count, [param floatValue]);
                        }
                        else if (strcmp([param objCType], @encode(double)) == 0) {
                            sqlite3_bind_double(statement, count, [param doubleValue]);
                        }else {
                            sqlite3_bind_text(statement, count, [[param description] UTF8String], -1, SQLITE_STATIC);
                        }
                    }
                    else if ([[dbData objectForKey:[dataKeys objectAtIndex:i]] isKindOfClass:[NSDate class]]) {
                        sqlite3_bind_double(statement, i+1, [[dbData objectForKey:[dataKeys objectAtIndex:i]] timeIntervalSince1970]);
                        
                    }
                    else if ([[dbData objectForKey:[dataKeys objectAtIndex:i]] isKindOfClass:[NSData class]]) {
                        id param = [dbData objectForKey:[dataKeys objectAtIndex:i]];
                        const void *bytes = [param bytes];
                        if (!bytes) {
                            // it’s an empty NSData object, aka [NSData data].
                            // Don’t pass a NULL pointer, or sqlite will bind a SQL null instead of a blob.
                            bytes = "";
                        }
                        sqlite3_bind_blob(statement, i+1, bytes, (int)[param length], SQLITE_STATIC);
                    }
                    else if ([[dbData objectForKey:[dataKeys objectAtIndex:i]] isKindOfClass:[NSNull class]])
                    {
                        //[sql appendFormat:@"\" \""];
                        NSString *strValue = @"";
                        sqlite3_bind_text(statement, i+1, [strValue UTF8String], -1, SQLITE_TRANSIENT);
                    }
                    else
                    {
                        NSString *strValue = @"";
                        sqlite3_bind_text(statement, i+1, [strValue UTF8String], -1, SQLITE_TRANSIENT);
                        
                    }
                    
                }
            }
            
            self.isWorking = FALSE;
            return statement;
            
        }
        else {
            printf( "Database Error : %s", sqlite3_errmsg(dbh) );
            self.isWorking = FALSE;
            return 0;
        }
        

        
    }
}




// Three ways to lookup results: for a variable number of responses, for a full row
// of responses, or for a singular bit of data
#pragma mark - Select

- (NSMutableArray *) fetchAllRows:(NSString *)sql withObject:(id)myObj {
    sqlite3_stmt *statement;
    id result;
    NSMutableArray *thisArray = [NSMutableArray arrayWithCapacity:0];
    
    if ((statement = [self preparedSt:sql dictonary:nil key:nil])) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *thisDict = [NSMutableDictionary dictionaryWithCapacity:4];
            for (int i = 0 ; i < sqlite3_column_count(statement) ; i++) {
                //NSLog(@"%@",[NSString stringWithUTF8String:sqlite3_column_name(statement,i)]);
                
                if (sqlite3_column_decltype(statement,i) != NULL &&
                    strcasecmp(sqlite3_column_decltype(statement,i),"Boolean") == 0) {
                    result = [NSNumber numberWithBool:(BOOL)sqlite3_column_int(statement,i)];
                    result = String(@"%@",result);
                } else if (sqlite3_column_decltype(statement,i) != NULL &&
                           strcasecmp(sqlite3_column_decltype(statement,i),"DATE") == 0) {
                    /*NSInteger length  = sqlite3_column_bytes(statement, i);
                    const void *bytes = sqlite3_column_blob(statement, i);
                    result = [NSData dataWithBytes:bytes length:length];*/
                    NSTimeInterval interval = sqlite3_column_bytes(statement, i);
                    result = [NSDate dateWithTimeIntervalSince1970:interval];
                    //result = [NSNumber numberWithFloat:(float)sqlite3_column_double(statement,i)];
                } else if (sqlite3_column_type(statement, i) == SQLITE_TEXT) {
                    result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,i)];
                } else if (sqlite3_column_type(statement,i) == SQLITE_INTEGER) {
                    int val = (int)sqlite3_column_int(statement,i);
                    result = String(@"%d",val);
                    
                } else if (sqlite3_column_type(statement,i) == SQLITE_FLOAT) {
                    result = [NSNumber numberWithFloat:(float)sqlite3_column_double(statement,i)];
                } else {
                    char *isNil;
                    isNil = (char *)sqlite3_column_text(statement,i);
                    if (isNil != nil) {
                        result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,i)];
                        
                    }else{
                        result = nil;
                    }
                }
                if (result) {
                    [thisDict setObject:result
                                 forKey:[NSString stringWithUTF8String:sqlite3_column_name(statement,i)]];
                }
            }
            [thisArray addObject:[Functions Dict_TO_Object:thisDict withObject:myObj]];
        }
        
    }
    sqlite3_reset(statement);
    return thisArray;
}

- (NSMutableArray *) fetchAllRows:(NSString *)sql withObject:(id)myObj whereValue:(NSArray *)value {
    sqlite3_stmt *statement;
    id result;
    NSMutableArray *thisArray = [NSMutableArray arrayWithCapacity:4];
    
    NSMutableArray *arrKey = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if (value != nil) {
        for (int i = 0; i<[value count]; i++) {
            if ([value[i] isKindOfClass:[NSString class]]) {
                [dic setValue:value[i] forKey:value[i]];
                [arrKey addObject:value[i]];
            }else if ([value[i] isKindOfClass:[NSNumber class]])
            {
                NSString *str;
                if (strcmp([value[i] objCType], @encode(float)) == 0) {
                  str = [NSString stringWithFormat:@"%f",[value[i] floatValue]];
                } /*else if (strcmp([n objCType], @encode(int)) == 0) {
                    NSLog(@"this is an int");
                }*/
                else{
                str = [NSString stringWithFormat:@"%d",[value[i] intValue]];
                }
                [dic setValue:value[i] forKey:str];
                [arrKey addObject:str];
            }
        }
    }
    if ((statement = [self preparedSt:sql dictonary:dic key:arrKey])) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *thisDict = [NSMutableDictionary dictionaryWithCapacity:4];
            for (int i = 0 ; i < sqlite3_column_count(statement) ; i++) {
                if (sqlite3_column_decltype(statement,i) != NULL &&
                    strcasecmp(sqlite3_column_decltype(statement,i),"Boolean") == 0) {
                    result = [NSNumber numberWithBool:(BOOL)sqlite3_column_int(statement,i)];
                    result = String(@"%@",result);
                } else if (sqlite3_column_type(statement, i) == SQLITE_TEXT) {
                    result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,i)];
                } else if (sqlite3_column_type(statement,i) == SQLITE_INTEGER) {
                    int val = (int)sqlite3_column_int(statement,i);
                    result = String(@"%d",val);
                    
                } else if (sqlite3_column_type(statement,i) == SQLITE_FLOAT) {
                    result = [NSNumber numberWithFloat:(float)sqlite3_column_double(statement,i)];
                } else {
                    char *isNil;
                    isNil = (char *)sqlite3_column_text(statement,i);
                    if (isNil != nil) {
                        result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,i)];
                        
                    }else{
                        result = nil;
                    }
                }
                if (result) {
                    [thisDict setObject:result
                                 forKey:[NSString stringWithUTF8String:sqlite3_column_name(statement,i)]];
                }
            }
            [thisArray addObject:[Functions Dict_TO_Object:thisDict withObject:myObj]];
        }
        
    }
    sqlite3_reset(statement);
    return thisArray;
}

- (id)fetchRow:(NSString *)sql withObject:(id)myObj whereValue:(NSArray *)value {
    sqlite3_stmt *statement;
    id result;
    NSMutableDictionary *thisDict = [NSMutableDictionary dictionaryWithCapacity:4];
    @synchronized(self){
        //       [self checkLock];
        //     self.isWorking = TRUE;
        
        NSMutableArray *arrKey = [[NSMutableArray alloc] init];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        if (value != nil) { 
            for (int i = 0; i<[value count]; i++) {
                if ([value[i] isKindOfClass:[NSString class]]) {
                    [dic setValue:value[i] forKey:value[i]];
                    [arrKey addObject:value[i]];
                }else if ([value[i] isKindOfClass:[NSNumber class]])
                {
                    NSString *str = [NSString stringWithFormat:@"%d",[value[i] intValue]];
                    [dic setValue:value[i] forKey:str];
                    [arrKey addObject:str];
                }
            }
        }
        
        if ((statement = [self preparedSt:sql dictonary:dic key:arrKey])) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                for (int i = 0 ; i < sqlite3_column_count(statement) ; i++) {
                    if (strcasecmp(sqlite3_column_decltype(statement,i),"Boolean") == 0) {
                        result = [NSNumber numberWithBool:(BOOL)sqlite3_column_int(statement,i)];
                    } else if (sqlite3_column_type(statement, i) == SQLITE_TEXT) {
                        result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,i)];
                    } else if (sqlite3_column_type(statement,i) == SQLITE_INTEGER) {
                        result = [NSNumber numberWithInt:(int)sqlite3_column_int(statement,i)];
                    } else if (sqlite3_column_type(statement,i) == SQLITE_FLOAT) {
                        result = [NSNumber numberWithFloat:(float)sqlite3_column_double(statement,i)];
                    } else {
                        char *isNil;
                        isNil = (char *)sqlite3_column_text(statement,i);
                        if (isNil != nil) {
                            result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,i)];
                        }else{
                            result = nil;
                        }
                    }
                    if (result) {
                        [thisDict setObject:result
                                     forKey:[NSString stringWithUTF8String:sqlite3_column_name(statement,i)]];
                    }
                    
                    ////NSLog(@"fetchRow result :- %@",result);
                }
            }
        }
        sqlite3_reset(statement);
        
        myObj = [Functions Dict_TO_Object:thisDict withObject:myObj];
        //  self.isWorking = FALSE;
        
    }    
    return myObj;
}



- (NSDictionary *)lookupRowForSQL:(NSString *)sql {
	sqlite3_stmt *statement;
	id result;
	NSMutableDictionary *thisDict = [NSMutableDictionary dictionaryWithCapacity:4];
    @synchronized(self){
 //       [self checkLock];
  //      self.isWorking = TRUE;
        
	if ((statement = [self preparedSt:sql dictonary:nil key:nil])) {
		if (sqlite3_step(statement) == SQLITE_ROW) {	
			for (int i = 0 ; i < sqlite3_column_count(statement) ; i++) {
				if (strcasecmp(sqlite3_column_decltype(statement,i),"Boolean") == 0) {
					result = [NSNumber numberWithBool:(BOOL)sqlite3_column_int(statement,i)];
				} else if (sqlite3_column_type(statement, i) == SQLITE_TEXT) {
					result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,i)];
				} else if (sqlite3_column_type(statement,i) == SQLITE_INTEGER) {
					result = [NSNumber numberWithInt:(int)sqlite3_column_int(statement,i)];
				} else if (sqlite3_column_type(statement,i) == SQLITE_FLOAT) {
					result = [NSNumber numberWithFloat:(float)sqlite3_column_double(statement,i)];					
				} else {
					result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,i)];
				}
				if (result) {
					[thisDict setObject:result
								 forKey:[NSString stringWithUTF8String:sqlite3_column_name(statement,i)]];
				}
			}
		}
	}
	sqlite3_reset(statement);
      //  self.isWorking = FALSE;        
    }
	return thisDict;
}
	
- (id)lookupColForSQL:(NSString *)sql {
	
	sqlite3_stmt *statement;
	id result;
    @synchronized(self){
  //      [self checkLock];
  //      self.isWorking = TRUE;
        
	if ((statement = [self preparedSt:sql dictonary:nil key:nil])) {
		if (sqlite3_step(statement) == SQLITE_ROW) {		
			if (strcasecmp(sqlite3_column_decltype(statement,0),"Boolean") == 0) {
				result = [NSNumber numberWithBool:(BOOL)sqlite3_column_int(statement,0)];
			} else if (sqlite3_column_type(statement, 0) == SQLITE_TEXT) {
				result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
			} else if (sqlite3_column_type(statement,0) == SQLITE_INTEGER) {
				result = [NSNumber numberWithInt:(int)sqlite3_column_int(statement,0)];
			} else if (sqlite3_column_type(statement,0) == SQLITE_FLOAT) {
				result = [NSNumber numberWithDouble:(double)sqlite3_column_double(statement,0)];					
			} else {
				result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
			}
		}
	}
	sqlite3_reset(statement);

       // self.isWorking = FALSE;
        
    }
	return result;
	
}

// Simple use of COUNTS, MAX, etc.
- (int)lookupCount:(NSString *)table {
    
	int tableCount = 0;
	NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@",
					 table];
    @synchronized(self){
        sqlite3_stmt *statement;
        
        if ((statement = [self preparedSt:sql dictonary:nil key:nil])) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                tableCount = sqlite3_column_int(statement,0);
            }
        }
        sqlite3_reset(statement);
    }
	return tableCount;
    
}

- (int)lookupCountWhere:(NSString *)where whereValue:(NSArray *)value forTable:(NSString *)table {

    
    NSMutableArray *arrKey = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if (value != nil) {
        for (int i = 0; i<[value count]; i++) {
            if ([value[i] isKindOfClass:[NSString class]]) {
                [dic setValue:value[i] forKey:value[i]];
                [arrKey addObject:value[i]];
            }else if ([value[i] isKindOfClass:[NSNumber class]])
            {
                NSString *str = [NSString stringWithFormat:@"%d",[value[i] intValue]];
                [dic setValue:value[i] forKey:str];
                [arrKey addObject:str];
            }
        }
    }
    
	int tableCount = 0;
	NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE %@",
					 table,where];    	
    @synchronized(self){
	sqlite3_stmt *statement;

	if ((statement = [self preparedSt:sql dictonary:dic key:arrKey])) {
		if (sqlite3_step(statement) == SQLITE_ROW) {		
			tableCount = sqlite3_column_int(statement,0);
		}
	}
	sqlite3_reset(statement);
    }
	return tableCount;
				
}

- (int)lookupMax:(NSString *)key Where:(NSString *)where whereValue:(NSArray *)value forTable:(NSString *)table {
	
    NSMutableArray *arrKey = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if (value != nil) {
        for (int i = 0; i<[value count]; i++) {
            if ([value[i] isKindOfClass:[NSString class]]) {
                [dic setValue:value[i] forKey:value[i]];
                [arrKey addObject:value[i]];
            }else if ([value[i] isKindOfClass:[NSNumber class]])
            {
                NSString *str = [NSString stringWithFormat:@"%d",[value[i] intValue]];
                [dic setValue:value[i] forKey:str];
                [arrKey addObject:str];
            }
        }
    }
	int tableMax = 0;
	NSString *sql = [NSString stringWithFormat:@"SELECT MAX(%@) FROM %@ WHERE %@",
					 key,table,where];    	
	sqlite3_stmt *statement;
	if ((statement = [self preparedSt:sql dictonary:dic key:arrKey])) {
		if (sqlite3_step(statement) == SQLITE_ROW) {		
			tableMax = sqlite3_column_int(statement,0);
		}
	}
	sqlite3_reset(statement);
	return tableMax;
	
}

- (double)lookupMin:(NSString *)key Where:(NSString *)where whereValue:(NSArray *)value forTable:(NSString *)table {
    
    NSMutableArray *arrKey = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if (value != nil) {
        for (int i = 0; i<[value count]; i++) {
            if ([value[i] isKindOfClass:[NSString class]]) {
                [dic setValue:value[i] forKey:value[i]];
                [arrKey addObject:value[i]];
            }else if ([value[i] isKindOfClass:[NSNumber class]])
            {
                NSString *str = [NSString stringWithFormat:@"%d",[value[i] intValue]];
                [dic setValue:value[i] forKey:str];
                [arrKey addObject:str];
            }
        }
    }
    double tableMax = 0;
    NSString *sql = [NSString stringWithFormat:@"SELECT MIN(%@) FROM %@ WHERE %@",
                     key,table,where];
    sqlite3_stmt *statement;
    if ((statement = [self preparedSt:sql dictonary:dic key:arrKey])) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            tableMax = sqlite3_column_double(statement,0);
        }
    }
    sqlite3_reset(statement);
    return tableMax;
    
}

- (int)lookupSum:(NSString *)key Where:(NSString *)where whereValue:(NSArray *)value forTable:(NSString *)table {
    NSMutableArray *arrKey = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if (value != nil) {
        for (int i = 0; i<[value count]; i++) {
            if ([value[i] isKindOfClass:[NSString class]]) {
                [dic setValue:value[i] forKey:value[i]];
                [arrKey addObject:value[i]];
            }else if ([value[i] isKindOfClass:[NSNumber class]])
            {
                NSString *str = [NSString stringWithFormat:@"%d",[value[i] intValue]];
                [dic setValue:value[i] forKey:str];
                [arrKey addObject:str];
            }
        }
    }
	int tableSum = 0;
	NSString *sql = [NSString stringWithFormat:@"SELECT SUM(%@) FROM %@ WHERE %@",
					 key,table,where];    	
	sqlite3_stmt *statement;
	if ((statement = [self preparedSt:sql dictonary:dic key:arrKey])) {
		if (sqlite3_step(statement) == SQLITE_ROW) {		
			tableSum = sqlite3_column_int(statement,0);
		}
	}
	sqlite3_reset(statement);
	return tableSum;
	
}
- (float)lookupSumValueFloat:(NSString *)key Where:(NSString *)where whereValue:(NSArray *)value forTable:(NSString *)table {
    NSMutableArray *arrKey = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if (value != nil) {
        for (int i = 0; i<[value count]; i++) {
            if ([value[i] isKindOfClass:[NSString class]]) {
                [dic setValue:value[i] forKey:value[i]];
                [arrKey addObject:value[i]];
            }else if ([value[i] isKindOfClass:[NSNumber class]])
            {
                NSString *str = [NSString stringWithFormat:@"%d",[value[i] intValue]];
                [dic setValue:value[i] forKey:str];
                [arrKey addObject:str];
            }
        }
    }
    
	float tableSum = 0;
	NSString *sql = [NSString stringWithFormat:@"SELECT SUM(%@) FROM %@ WHERE %@",
					 key,table,where];
	sqlite3_stmt *statement;
	if ((statement = [self preparedSt:sql dictonary:dic key:arrKey])) {
		if (sqlite3_step(statement) == SQLITE_ROW) {
			tableSum = sqlite3_column_double(statement,0);
		}
	}
	sqlite3_reset(statement);
	return tableSum;
	
}

#pragma mark - insert

- (BOOL)insertDictionary:(NSDictionary *)dbData forTable:(NSString *)table {
    
    BOOL insert = NO;
    
    
    NSMutableString *sql = [NSMutableString stringWithCapacity:16];
    [sql appendFormat:@"INSERT INTO %@ (",table];
    if ([dbData isKindOfClass:[NSDictionary class]]) {
        
        NSArray *dataKeys = [dbData allKeys];
        for (int i = 0 ; i < [dataKeys count] ; i++) {
            [sql appendFormat:@"%@",[dataKeys objectAtIndex:i]];
            if (i + 1 < [dbData count]) {
                [sql appendFormat:@", "];
            }
        }
        
        [sql appendFormat:@") VALUES("];
        for (int i = 0 ; i < [dataKeys count] ; i++) {
            [sql appendFormat:@"?"];
            if (i + 1 < [dbData count]) {
                [sql appendFormat:@", "];
            }
        }
        [sql appendFormat:@")"];
        insert = [self runDynamicPreparedSQL:sql forTable:table dictonary:dbData key:dataKeys];
        
        
    }
    
    
    return insert;
}



#pragma mark - update

- (BOOL)updateDictionary:(NSDictionary *)dbData forTable:(NSString *)table where:(NSString *)where whereValue:(NSArray *)value{
    @try {
        
        NSMutableString *sql = [NSMutableString stringWithCapacity:16];
        [sql appendFormat:@"UPDATE %@ SET ",table];
        if ([dbData isKindOfClass:[NSDictionary class]]) {
            
            NSArray *dataKeys = [dbData allKeys];
            for (int i = 0 ; i < [dataKeys count] ; i++) {
                //[sql appendFormat:@"%@=\"%@\"",
                //[dataKeys objectAtIndex:i],
                //[dbData objectForKey:[dataKeys objectAtIndex:i]]];
                [sql appendFormat:@"%@ = ?",[dataKeys objectAtIndex:i]];
                
                if (i + 1 < [dbData count]) {
                    [sql appendFormat:@", "];
                }
            }
            if (where != NULL) {
                [sql appendFormat:@" WHERE %@",where];
            }
            
            NSMutableArray *arrKey = [[NSMutableArray alloc] init];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            
            [dic addEntriesFromDictionary:dbData];
            [arrKey addObjectsFromArray:dataKeys];
            
            if (value != nil) {
                for (int i = 0; i<[value count]; i++) {
                    if ([value[i] isKindOfClass:[NSString class]]) {
                        [dic setValue:value[i] forKey:value[i]];
                        [arrKey addObject:value[i]];
                    }else if ([value[i] isKindOfClass:[NSNumber class]])
                    {
                        NSString *str = [NSString stringWithFormat:@"%d",[value[i] intValue]];
                        [dic setValue:value[i] forKey:str];
                        [arrKey addObject:str];
                    }
                }
            }
            
            
            ////NSLog(@"UPDATE ****************** %@",sql);
            //Debug(@"UPDATE ****************** %@",sql);
            return [self runDynamicPreparedSQL:sql forTable:table dictonary:dic key:arrKey];
        }
    }
    @catch (NSException *exception) {
        // //NSLog(@"\n\n\t\tERROR - UPDATE %@ \n%@\n\n",table,exception);
    }
    
}
 
#pragma  mark - Alter DB
-(BOOL)alterDB:(NSString *)sql table:(NSString *)table{
   /* sqlite3 *database;
    sqlite3_stmt *statement;
    if(sqlite3_open([self.docPath UTF8String], &database) == SQLITE_OK)
    {
        
        NSString *updateSQL = [NSString stringWithFormat: @"ALTER TABLE FinalMatches ADD COLUMN testColumn TEXT"];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(database, update_stmt, -1, &statement, NULL);
        
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DB altered" message:@"Success" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
         
            alert=nil;
            NSLog(@"CREATED");
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DB Updation" message:@"DB not Altered" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
         
            alert=nil;
            NSLog(@"NOT CREATED");

        }
        // Release the compiled statement from memory
        sqlite3_finalize(statement);
        sqlite3_close(database);
        
    
    }*/
    
    NSString *updateSQL = [NSString stringWithFormat:@"ALTER TABLE %@ %@",
                     table,sql];
    
    return [self runDynamicPreparedSQL:updateSQL forTable:table dictonary:nil key:nil];
}
#pragma mark - delete

- (BOOL)deleteWhere:(NSString *)where values:(NSArray *)value forTable:(NSString *)table {
    
    if (value != nil) {
        NSMutableArray *arrKey = [[NSMutableArray alloc] init];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        for (int i = 0; i<[value count]; i++) {
            if ([value[i] isKindOfClass:[NSString class]]) {
                [dic setValue:value[i] forKey:value[i]];
                [arrKey addObject:value[i]];
            }else if ([value[i] isKindOfClass:[NSNumber class]])
            {
                NSString *str = [NSString stringWithFormat:@"%d",[value[i] intValue]];
                [dic setValue:value[i] forKey:str];
                [arrKey addObject:str];
            }
        }
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ where %@",
                         table,where];
        //Debug(@"Delete Query : - %@", sql);
        
        return [self runDynamicPreparedSQL:sql forTable:table dictonary:dic key:arrKey];
        
    }
    else
    {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ where %@",
                         table,where];
        //Debug(@"Delete Query : - %@", sql);
        
        return [self runDynamicPreparedSQL:sql forTable:table dictonary:nil key:nil];
    }
    
    
}
- (BOOL)deleteAll:(NSString *)table {
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",
                     table];
    //Debug(@"Delete Query : - %@", sql);
    
    return [self runDynamicPreparedSQL:sql forTable:table dictonary:nil key:nil];
}


// INSERT/UPDATE/DELETE Subroutines
- (BOOL)runDynamicPreparedSQL:(NSString *)sql forTable:(NSString *)table dictonary:(NSDictionary *)dic key:(NSArray *)key {
    @synchronized(self){
        //       [self checkLock];
        //      self.isWorking = TRUE;
        int result;
        NSAssert1(self.dynamic == 1,@"Tried to use a dynamic function on a static database",NULL);
        sqlite3_stmt *statement;
        if ((statement = [self preparedSt:sql dictonary:dic key:key])) {
            result = sqlite3_step(statement);
        }
        /*if(sqlite3_step(statement)==SQLITE_DONE)
        {
            //NSLog(@"done");
            insert = true;
        }
        else {//NSLog(@"ERROR");
            insert = false;
        }*/
        sqlite3_reset(statement);
        
        //sqlite3_finalize(statement);
        if (result) {
            if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(databaseTableWasUpdated:)]) {
                [delegate databaseTableWasUpdated:table];
            }	
            return YES;
        } else {
            return NO;
        }
        // self.isWorking = FALSE;
    }
}


- (void)dealloc {
	[self close];
	//[delegate release];
	//[super dealloc];
}

- (void)open {
	
	int result = sqlite3_open([self.docPath UTF8String], &dbh);
	NSAssert1(SQLITE_OK == result, NSLocalizedStringFromTable(@"Unable to open the sqlite database (%@).", @"Database", @""), [NSString stringWithUTF8String:sqlite3_errmsg(dbh)]);	
    NSLog(@"Database : \n %@",self.docPath);
   

}
- (void)close {
	
	if (dbh) {
		sqlite3_close(dbh);
	}
}

@end
