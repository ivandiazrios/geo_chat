//
//  DBManager.m
//  SQLite3DBSample
//
//  Created by Gabriel Theodoropoulos on 25/6/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>


@interface DBManager()

@property (nonatomic, strong) NSString *documentsDirectory;

@property (nonatomic, strong) NSString *databaseFilename;

@property (nonatomic, strong) NSMutableArray *arrResults;


-(void)copyDatabaseIntoDocumentsDirectory;

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

@end


@implementation DBManager

#pragma mark - Initialization

+ (id)getInstance {
    static DBManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
    if (self = [super init]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        
        // Keep the database filename.
        self.databaseFilename = @"ChatDB.sql";
        
        // Copy the database file into the documents directory if necessary.
        [self copyDatabaseIntoDocumentsDirectory];
    }
    return self;
}


#pragma mark - Private method implementation

-(void)copyDatabaseIntoDocumentsDirectory{
    // Check if the database file exists in the documents directory.
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        // The database file does not exist in the documents directory, so copy it from the main bundle now.
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        
        // Check if any error occurred during copying and display it.
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}



-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable{
    // Create a sqlite object.
    sqlite3 *sqlite3Database;
    
    // Set the database file path.
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    // Initialize the results array.
    if (self.arrResults != nil) {
        [self.arrResults removeAllObjects];
        self.arrResults = nil;
    }
    self.arrResults = [[NSMutableArray alloc] init];
    
    // Initialize the column names array.
    if (self.arrColumnNames != nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc] init];
    
    
    // Open the database.
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if(openDatabaseResult == SQLITE_OK) {
        // Declare a sqlite3_stmt object in which will be stored the query after having been compiled into a SQLite statement.
        sqlite3_stmt *compiledStatement;
        
        // Load all data from database to memory.
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        if(prepareStatementResult == SQLITE_OK) {
            // Check if the query is non-executable.
            if (!queryExecutable){
                // In this case data must be loaded from the database.
                
                // Declare an array to keep the data for each fetched row.
                NSMutableArray *arrDataRow;
                
                // Loop through the results and add them to the results array row by row.
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    // Initialize the mutable array that will contain the data of a fetched row.
                    arrDataRow = [[NSMutableArray alloc] init];
                    
                    // Get the total number of columns.
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    
                    // Go through all columns and fetch each column data.
                    for (int i=0; i<totalColumns; i++){
                        // Convert the column data to text (characters).
                        char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                        
                        // If there are contents in the currenct column (field) then add them to the current row array.
                        if (dbDataAsChars != NULL) {
                            // Convert the characters to string.
                            [arrDataRow addObject:[NSString  stringWithUTF8String:dbDataAsChars]];
                        }
                        
                        // Keep the current column name.
                        if (self.arrColumnNames.count != totalColumns) {
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
                    
                    // Store each fetched data row in the results array, but first check if there is actually data.
                    if (arrDataRow.count > 0) {
                        [self.arrResults addObject:arrDataRow];
                    }
                }
            }
            else {
                // This is the case of an executable query (insert, update, ...).
                
                // Execute the query.
                int executeQueryResults = sqlite3_step(compiledStatement);
                if (executeQueryResults == SQLITE_DONE) {
                    // Keep the affected rows.
                    self.affectedRows = sqlite3_changes(sqlite3Database);
                    
                    // Keep the last inserted row ID.
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                }
                else {
                    // If could not execute the query show the error message on the debugger.
                    NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
                }
            }
        }
        else {
            // In the database cannot be opened then show the error message on the debugger.
            NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
        }
        
        // Release the compiled statement from memory.
        sqlite3_finalize(compiledStatement);
        
    }
    
    // Close the database.
    sqlite3_close(sqlite3Database);
}


#pragma mark - Public method implementation

-(NSArray *)loadDataFromDB:(NSString *)query{
    // Run the query and indicate that is not executable.
    // The query string is converted to a char* object.
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    
    // Returned the loaded results.
    return [self.arrResults copy];
}


-(void)executeQuery:(NSString *)query{
    // Run the query and indicate that is executable.
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}


#pragma mark insert methods
-(BOOL)insertConversation:(NSUInteger)conID otherUserID:(NSUInteger)userID {
    
    if ([self doesContainConversationForID:(unsigned long) conID]) {
        return true;
    }
    
    NSString *query = [NSString stringWithFormat:@"insert into conversation values (%lu,%lu,1)", (unsigned long)conID, (unsigned long) userID];
    [self executeQuery:query];
    NSLog(@"succesful insertion");
    return true;
}

-(BOOL)insertMessage:(NSString *)message forConversationID:(NSUInteger)conID forAuthor:(unsigned long)author {
    
    NSString *query = [NSString stringWithFormat:@"insert into messages (ConID,MsgContent,Author) values (%lu,'%@', %lu)", (unsigned long)conID, message, author];
    [self executeQuery:query];
    return true;
}

-(BOOL)insertMessage:(NSString *)message forConversationID:(NSUInteger)conID forAuthor:(unsigned long)author withServerID:(unsigned long)serverID {
    
    NSString *query = [NSString stringWithFormat:@"insert into messages (ConID,MsgContent,Author,ServerMsgID) values (%lu,'%@', %lu, %lu)", (unsigned long)conID, message, author, serverID];
    [self executeQuery:query];
    return true;
}

#pragma mark get methods
-(Conversation *)getConversationForID:(NSUInteger)conversationID {
    NSArray *results = [self loadDataFromDB:[NSString stringWithFormat:@"select MsgContent, Author, MsgID from messages where ConID = %lu order by MsgID asc", conversationID]];
    NSUInteger userID = [[[results objectAtIndex:0] objectAtIndex:1] intValue];
    if (results == nil) {
        return nil;
    }
    Conversation *conversation = [[Conversation alloc] initWithUserId:userID];    
    for (NSArray *msg in results){
        Message *newMsg = [[Message alloc] init];
        newMsg.message = [msg objectAtIndex:0];
        newMsg.userID = (unsigned long)[[msg objectAtIndex:1] intValue];
        newMsg.messageID = (unsigned long)[[msg objectAtIndex:2] intValue];
        [conversation.messages addObject:newMsg];
    }
    return conversation;
}

-(NSArray*)getConvoIDs {
    return [self loadDataFromDB:@"select conid from messages group by conid order by msgid desc"];    
}

-(NSString *)getLastMessageForConversationID:(NSUInteger)conversationID {
    NSArray *results = [self loadDataFromDB:[NSString stringWithFormat:@"select MsgContent, MAX(MsgID) from messages where ConID = %lu", conversationID]];
    return [[results objectAtIndex:0] objectAtIndex:0];
}

#pragma mark query methods

-(BOOL)doesContainConversationForID:(long)conID {
    NSArray *results = [self loadDataFromDB:[NSString stringWithFormat:@"select ConID from conversation where ConID = %ld", conID]];
    return ([results count] != 0);
}
-(BOOL)doesContainMessageForServerID:(long)messageID {
    NSArray *results = [self loadDataFromDB:[NSString stringWithFormat:@"select ServerMsgID from messages where ServerMsgID = %ld", messageID]];
    return ([results count] != 0);
}

#pragma mark processing data
-(void)processPeerToPeerDataReturnedByServer:(NSData *)data {
    /*
     *  Convert the data into JSON format
     *  For each message
     *  see if a relavant conversation already exists
     *  if no create conversation and add message
     *  if yes check message not already in database
     *  if not in database add to database
     *
     */
    if (data == nil) {
        NSLog(@"Message error");
        return;
    }
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    // we need to return something
    NSArray *messagesArray = [json objectForKey:@"Messages"];
    for (NSDictionary *msgArray in messagesArray) {
        long conID = [[msgArray objectForKey:@"SenderId"] longValue];
        if (![self doesContainConversationForID:conID]) {
            [self insertConversation:(NSUInteger)conID otherUserID:(NSUInteger)conID];
            [self setConversationToUnseen:conID];
            [self insertMessage:[msgArray objectForKey:@"Msg"] forConversationID:(NSUInteger)conID forAuthor:(NSUInteger)conID withServerID:[[msgArray objectForKey:@"MsgId"] unsignedLongValue]];
        }
        else if (![self doesContainMessageForServerID:[[msgArray objectForKey:@"MsgId"] longValue]]) {
            [self setConversationToUnseen:conID];
            [self insertMessage:[msgArray objectForKey:@"Msg"] forConversationID:(NSUInteger)conID forAuthor:(NSUInteger)conID withServerID:[[msgArray objectForKey:@"MsgId"] unsignedLongValue]];
        }
    }
    NSLog(@"done processing data");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Reload" object:nil];
    return;
}

#pragma mark unseen methods
-(void)setConversationToUnseen:(NSUInteger)conID {
    [self executeQuery:[NSString stringWithFormat:@"update conversation set Seen=0 where ConID = %ld", conID]];
}
-(void)setConversationToSeen:(NSUInteger)conID {
    [self executeQuery:[NSString stringWithFormat:@"update conversation set Seen=1 where ConID = %ld", conID]];
}

-(BOOL)isConversationUnseen:(NSUInteger)conID {
    NSArray *results = [self loadDataFromDB:[NSString stringWithFormat:@"select conid from conversation where ConID = %ld and seen = 0", conID]];
    return [results count] != 0;
}


#pragma mark delete methods
-(void)deleteEverythingInDatabase {
    [self executeQuery:[NSString stringWithFormat:@"delete from messages"]];
    [self executeQuery:[NSString stringWithFormat:@"delete from conversation"]];
}

-(void)deleteConversationForID:(NSUInteger)conID {
    [self executeQuery:[NSString stringWithFormat:@"delete from messages where ConID = %ld", conID]];
    [self executeQuery:[NSString stringWithFormat:@"delete from conversation where ConID = %ld", conID]];
}

@end
