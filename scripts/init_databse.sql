--  Creating Database
--  WARNING: This script will drop any database having name Datawarehouse. 
IF OBJECT_ID('Datawarehouse') IS NOT NULL
	DROP DATABASE Datawarehouse
CREATE DATABASE Datawarehouse;
-- Creating Schemas
USE Datawarehouse;
CREATE SCHEMA Bronze;
CREATE SCHEMA Silver;
CREATE SCHEMA Gold;

