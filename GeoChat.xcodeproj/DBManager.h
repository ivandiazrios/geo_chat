//
//  DBManager.h
//  GeoChat
//
//  Created by Ivan Diaz on 6/5/15.
//  Copyright (c) 2015 Ivan Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Conversation.h"

@interface DBManager : NSObject
@property (nonatomic, strong) NSMutableArray *arrColumnNames;
@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;
@property Boolean dataHasChanged;


-(NSArray *)loadDataFromDB:(NSString *)query;

-(void)executeQuery:(NSString *)query;

-(BOOL)insertMessage:(NSString *)message forConversationID:(NSUInteger)conID forAuthor:(unsigned long)author;
-(BOOL)insertConversation:(NSUInteger)conID otherUserID:(NSUInteger)userID;

-(Conversation *)getConversationForID:(NSUInteger)conversationID;

-(NSString *)getLastMessageForConversationID:(NSUInteger)conversationID;

-(int)getNumberOfConversations;

-(NSArray*)getConvoIDs;

-(void)processPeerToPeerDataReturnedByServer:(NSData *)data;

+ (id)getInstance;

-(BOOL)insertMessage:(NSString *)message forConversationID:(NSUInteger)conID forAuthor:(unsigned long)author withServerID:(unsigned long)serverID;

-(void)setConversationToUnseen:(NSUInteger)conID;
-(void)setConversationToSeen:(NSUInteger)conID;
-(BOOL)isConversationUnseen:(NSUInteger)conID;

-(void)deleteEverythingInDatabase;

-(void)deleteConversationForID:(NSUInteger)conID;

@end
