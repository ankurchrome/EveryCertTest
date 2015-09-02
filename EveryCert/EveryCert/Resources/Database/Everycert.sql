DROP TABLE IF EXISTS "android_metadata";
CREATE TABLE android_metadata (locale TEXT);
INSERT INTO "android_metadata" VALUES('en_US');
DROP TABLE IF EXISTS "certificate";
CREATE TABLE certificate( cert_id_app INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, cert_id INTEGER NOT NULL DEFAULT 0,   form_id INTEGER NOT NULL DEFAULT 0,  name TEXT NOT NULL DEFAULT '',  issued_app TEXT NOT NULL DEFAULT '' ,  date  TEXT NOT NULL DEFAULT '', pdf TEXT NOT NULL DEFAULT '',
modified_timestamp_app TEXT NOT NULL  DEFAULT ('') ,modified_timestamp TEXT NOT NULL  DEFAULT ('') ,"archive" INTEGER NOT NULL  DEFAULT 0, uuid TEXT NOT NULL  DEFAULT ('') ,  is_dirty INTEGER NOT NULL  DEFAULT 0 , "company_id" TEXT NOT NULL  DEFAULT 0);
DROP TABLE IF EXISTS "company_user";
CREATE TABLE "company_user" ("company_user_id_app" INTEGER PRIMARY KEY  NOT NULL ,
"company_user_id" INTEGER  NOT NULL DEFAULT (0), "company_id" INTEGER DEFAULT (0) ,"user_id" INTEGER NOT NULL  DEFAULT (0) ,"field_name" TEXT NOT NULL  DEFAULT ('') ,"data" TEXT NOT NULL  DEFAULT ('') ,"modified_timestamp_app" TEXT NOT NULL  DEFAULT ('') ,"modified_timestamp" TEXT NOT NULL  DEFAULT ('') ,"archive" INTEGER NOT NULL  DEFAULT (0) ,"is_dirty" INTEGER NOT NULL  DEFAULT (0) ,"uuid" TEXT NOT NULL  DEFAULT ('') );
DROP TABLE IF EXISTS "data";
CREATE TABLE "data" ("data_id_app" INTEGER PRIMARY KEY  NOT NULL ,"data_id" INTEGER NOT NULL  DEFAULT (0) ,"cert_id_app" INTEGER NOT NULL  DEFAULT (0) ,"element_id" INTEGER NOT NULL  DEFAULT (0) ,"record_id_app" INTEGER NOT NULL  DEFAULT (0) ,"data" TEXT NOT NULL  DEFAULT ('') ,"modified_timestamp_app" TEXT NOT NULL  DEFAULT ('') ,"modified_timestamp" TEXT NOT NULL  DEFAULT ('') ,"archive" INTEGER NOT NULL  DEFAULT (0) ,"uuid" TEXT NOT NULL  DEFAULT ('') ,"is_dirty" INTEGER NOT NULL  DEFAULT (0) ,"company_id" INTEGER NOT NULL  DEFAULT (0) );
DROP TABLE IF EXISTS "data_binary";
CREATE TABLE "data_binary" ("data_binary_id_app" INTEGER PRIMARY KEY  NOT NULL ,"data_binary_id" INTEGER NOT NULL  DEFAULT (0) ,"cert_id_app" INTEGER DEFAULT (0) ,"element_id" INTEGER NOT NULL  DEFAULT (0) ,"data_binary" BLOB NOT NULL  DEFAULT ('') ,"modified_timestamp_app" TEXT NOT NULL  DEFAULT ('') ,"modified_timestamp" TEXT NOT NULL  DEFAULT ('') ,"archive" INTEGER NOT NULL  DEFAULT (0) ,"uuid" TEXT NOT NULL  DEFAULT ('') ,"is_dirty" INTEGER NOT NULL  DEFAULT (0) ,"company_id" INTEGER NOT NULL  DEFAULT (0) );
DROP TABLE IF EXISTS "element";
CREATE TABLE "element" ("element_id" INTEGER PRIMARY KEY  NOT NULL ,"section_id" INTEGER NOT NULL  DEFAULT (0) ,"form_id" INTEGER NOT NULL  DEFAULT (0) ,"field_type" TEXT NOT NULL  DEFAULT ('') ,"field_name" TEXT NOT NULL  DEFAULT ('') ,"sequence_order" INTEGER NOT NULL  DEFAULT (0) ,"element_label" TEXT NOT NULL  DEFAULT ('') ,"element_origin_x" INTEGER NOT NULL  DEFAULT (0) ,"element_origin_y" INTEGER NOT NULL  DEFAULT (0) ,"element_height" INTEGER NOT NULL  DEFAULT (0) ,"element_width" INTEGER NOT NULL  DEFAULT (0) ,"element_page_number" INTEGER NOT NULL  DEFAULT (1) ,"min_char_limit" INTEGER NOT NULL  DEFAULT (0) ,"max_char_limit" INTEGER NOT NULL  DEFAULT (0) ,"printed_text_format" TEXT NOT NULL  DEFAULT ('') ,"linked_element_id" INTEGER NOT NULL  DEFAULT (0) ,"modified_timestamp" TEXT NOT NULL  DEFAULT ('') ,"archive" INTEGER NOT NULL  DEFAULT (0) ,"pop_up_message" TEXT NOT NULL  DEFAULT ('') , lookup_list_id_new INTEGER NOT NULL DEFAULT (0), field_no_new INTEGER NOT NULL DEFAULT (0), lookup_list_id_existing INTEGER NOT NULL DEFAULT (0), field_no_existing INTEGER NOT NULL DEFAULT (0));
INSERT INTO "element" VALUES(1,-2,0,'1','user_first_name',8,'First Name',0,0,0,0,0,0,50,'',0,'0000-00-00 00:00:00',1,'',0,0,0,0);
INSERT INTO "element" VALUES(2,-2,0,'1','user_last_name',9,'Last Name',0,0,0,0,0,0,50,'',0,'0000-00-00 00:00:00',1,'',0,0,0,0);
INSERT INTO "element" VALUES(3,-2,0,'1','user_email',11,'Email Address',0,0,0,0,0,0,50,'',0,'0000-00-00 00:00:00',0,'',0,0,0,0);
INSERT INTO "element" VALUES(4,-2,0,'1','user_password',12,'Password',0,0,0,0,0,0,50,'{"ElementCaps":"password"}',0,'0000-00-00 00:00:00',1,'',0,0,0,0);
INSERT INTO "element" VALUES(5,-2,0,'1','user_full_name',10,'Name',0,0,0,0,0,0,50,'',0,'0000-00-00 00:00:00',0,'',0,0,0,0);
INSERT INTO "element" VALUES(6,-2,0,'5','user_signature',13,'Signature',0,0,0,0,0,0,0,'',0,'0000-00-00 00:00:00',0,'',0,0,0,0);
INSERT INTO "element" VALUES(7,-1,0,'1','company_name',1,'Company Name',0,0,0,0,0,0,34,'',0,'0000-00-00 00:00:00',0,'',0,0,0,0);
INSERT INTO "element" VALUES(8,-1,0,'1','company_address_line_1',2,'Address Line 1',0,0,0,0,0,0,34,'',0,'0000-00-00 00:00:00',0,'',0,0,0,0);
INSERT INTO "element" VALUES(9,-1,0,'1','company_address_line_2',3,'Address Line 2',0,0,0,0,0,0,34,'',0,'0000-00-00 00:00:00',0,'',0,0,0,0);
INSERT INTO "element" VALUES(10,-1,0,'1','company_address_line_3',4,'Address Line 3',0,0,0,0,0,0,34,'',0,'0000-00-00 00:00:00',0,'',0,0,0,0);
INSERT INTO "element" VALUES(11,-1,0,'1','company_address_line_4',5,'Address Line 4',0,0,0,0,0,0,34,'',0,'0000-00-00 00:00:00',0,'',0,0,0,0);
INSERT INTO "element" VALUES(12,-1,0,'1','company_post_code',6,'Postcode',0,0,0,0,0,0,34,'',0,'0000-00-00 00:00:00',0,'',0,0,0,0);
INSERT INTO "element" VALUES(13,-1,0,'1','company_phone',7,'Phone Number',0,0,0,0,0,0,34,'',0,'0000-00-00 00:00:00',0,'',0,0,0,0);
INSERT INTO "element" VALUES(14,-3,0,'1','user_email',1,'Email Address',0,0,0,0,0,0,50,'',0,'0000-00-00 00:00:00',0,'',0,0,0,0);
INSERT INTO "element" VALUES(15,-3,0,'1','user_password',2,'Password',0,0,0,0,0,0,50,'{"ElementCaps":"password"}',0,'0000-00-00 00:00:00',0,'',0,0,0,0);
INSERT INTO "element" VALUES(16,-4,0,'1','user_full_name',1,'Name',0,0,0,0,0,0,50,'',0,'0000-00-00 00:00:00',0,'',0,0,0,0);
INSERT INTO "element" VALUES(17,-4,0,'1','user_email',2,'Email Address',0,0,0,0,0,0,50,'',0,'0000-00-00 00:00:00',0,'',0,0,0,0);
INSERT INTO "element" VALUES(18,-4,0,'1','user_password',3,'Password',0,0,0,0,0,0,50,'{"ElementCaps":"password"}',0,'0000-00-00 00:00:00',0,'',0,0,0,0);
DROP TABLE IF EXISTS "form";
CREATE TABLE "form" ("form_id" INTEGER PRIMARY KEY NOT NULL, "category_id" INTEGER NOT NULL  DEFAULT 0, "form_name" TEXT NOT NULL  DEFAULT '', "form_title" TEXT NOT NULL  DEFAULT '', "background_layout" TEXT NOT NULL  DEFAULT '',  modified_timestamp_app TEXT NOT NULL  DEFAULT ('') ,
    modified_timestamp TEXT NOT NULL  DEFAULT ('') ,"archive" INTEGER NOT NULL  DEFAULT 0, "form_status" TEXT NOT NULL  DEFAULT '', "company_format" TEXT NOT NULL  DEFAULT '', "sequence_order" INTEGER NOT NULL  DEFAULT 0);
DROP TABLE IF EXISTS "lookup";
CREATE TABLE "lookup"
(
    lookup_id_app INTEGER PRIMARY KEY NOT NULL,
    lookup_id INTEGER NOT NULL DEFAULT 0,
    lookup_list_id INTEGER NOT NULL DEFAULT 0,
    record_id_app INTEGER NOT NULL  DEFAULT (0),
    linked_record_id_app INTEGER NOT NULL DEFAULT (0),
    field_no INTEGER NOT NULL DEFAULT (0) ,
    option TEXT NOT NULL DEFAULT '',
    data TEXT NOT NULL DEFAULT  '',
    sequence_order INTEGER NOT NULL DEFAULT (0) ,modified_timestamp_app TEXT NOT NULL  DEFAULT ('') ,modified_timestamp TEXT NOT NULL  DEFAULT ('') ,"archive" INTEGER NOT NULL  DEFAULT 0, uuid TEXT NOT NULL  DEFAULT ('') ,  is_dirty INTEGER NOT NULL  DEFAULT 0 
, "company_id" INTEGER NOT NULL  DEFAULT 0);
DROP TABLE IF EXISTS "record";
CREATE TABLE "record"
(
    record_id_app INTEGER PRIMARY KEY NOT NULL,
    record_id INTEGER NOT NULL DEFAULT 0,modified_timestamp_app TEXT NOT NULL  DEFAULT ('') ,modified_timestamp TEXT NOT NULL  DEFAULT ('') ,"archive" INTEGER NOT NULL  DEFAULT 0, uuid TEXT NOT NULL  DEFAULT ('') ,  is_dirty INTEGER NOT NULL  DEFAULT 0 
, "company_id" INTEGER NOT NULL  DEFAULT 0);
DROP TABLE IF EXISTS "section";
CREATE TABLE "section" ("section_id" INTEGER PRIMARY KEY  NOT NULL  DEFAULT (0) ,"form_id" INTEGER NOT NULL  DEFAULT (0) ,"section_label" TEXT NOT NULL  DEFAULT ('') ,"sequence_order" INTEGER NOT NULL  DEFAULT (0) ,"section_header" TEXT NOT NULL  DEFAULT ('') ,"section_footer" TEXT NOT NULL  DEFAULT ('') ,"section_title" TEXT NOT NULL  DEFAULT ('') ,"modified_timestamp" TEXT NOT NULL  DEFAULT ('') ,"archive" INTEGER NOT NULL  DEFAULT (0) );
INSERT INTO "section" VALUES(-7,'','Password Change',1,'Password Change','','Password Change','','');
INSERT INTO "section" VALUES(-6,'','Password Reset',1,'Password Reset','','Password Reset','','');
INSERT INTO "section" VALUES(-5,'','user_signup',1,'User','','User','','');
INSERT INTO "section" VALUES(-4,'','Company_signup',1,'Company','','Company','','');
INSERT INTO "section" VALUES(-3,'','Login',1,'Login','','Login','','');
INSERT INTO "section" VALUES(-2,'','Company',1,'Company','','Company','','');
INSERT INTO "section" VALUES(-1,'','User',1,'User','','User','','');
DROP TABLE IF EXISTS "sub_element";
CREATE TABLE "sub_element" ("sub_element_id" INTEGER PRIMARY KEY  NOT NULL  DEFAULT (0) ,"element_id" INTEGER NOT NULL  DEFAULT (0) ,"field_type" TEXT NOT NULL  DEFAULT ('') ,"field_name" TEXT NOT NULL  DEFAULT ('') ,"sequence_order" INTEGER NOT NULL  DEFAULT (0) ,"element_label" TEXT NOT NULL  DEFAULT ('') ,"element_origin_x" INTEGER NOT NULL  DEFAULT (0) ,"element_origin_y" INTEGER NOT NULL  DEFAULT (0) ,"element_height" INTEGER NOT NULL  DEFAULT (0) ,"element_width" INTEGER NOT NULL  DEFAULT (0) ,"element_page_number" INTEGER NOT NULL  DEFAULT (1) ,"min_char_limit" INTEGER NOT NULL  DEFAULT (0) ,"max_char_limit" INTEGER NOT NULL  DEFAULT (0) ,"printed_text_format" TEXT NOT NULL  DEFAULT ('') ,"modified_timestamp" TEXT NOT NULL  DEFAULT ('') ,"archive" INTEGER NOT NULL  DEFAULT (0) ,"pop_up_message" TEXT NOT NULL  DEFAULT ('') ,"field_no_existing" INTEGER NOT NULL  DEFAULT (0) ,"lookup_list_id_existing" INTEGER NOT NULL  DEFAULT (0) ,"field_no_new" INTEGER NOT NULL  DEFAULT (0) ,"lookup_list_id_new" INTEGER NOT NULL  DEFAULT (0) );
DROP TABLE IF EXISTS "sync_timestamp";
CREATE TABLE "sync_timestamp" ("timestamp_id_app" INTEGER PRIMARY KEY  NOT NULL  DEFAULT (0) ,"company_id" INTEGER NOT NULL  DEFAULT (0) ,"table_name" TEXT NOT NULL  DEFAULT ('') ,"get_timestamp" TEXT NOT NULL  DEFAULT (0) );
