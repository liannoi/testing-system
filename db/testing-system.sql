-- Copyright 2019 Maksym Liannoi
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--    http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

USE master;
GO

IF (DB_ID('TestingSystem') IS NOT NULL)
DROP DATABASE TestingSystem;
GO

CREATE DATABASE TestingSystem;
GO

USE TestingSystem;
GO

/*
 *
 * Creating tables
 *
 */

-- Administrators

IF (OBJECT_ID('dbo.Administrators') IS NOT NULL)
DROP TABLE dbo.Administrators;
GO

CREATE TABLE dbo.Administrators
(
  AdministratorId INT NOT NULL IDENTITY,
  FirstName NVARCHAR(64) NOT NULL,
  LastName NVARCHAR(64) NOT NULL,
  MiddleName NVARCHAR(64) NOT NULL,
  Birthday DATE NOT NULL,
  Email NVARCHAR(128) NOT NULL,
  IsEmailVerified BIT NOT NULL CONSTRAINT DFT_Administrators_IsEmailVerified DEFAULT(0),
  PhoneNumber NCHAR(17),
  IsPhoneVerified BIT NOT NULL CONSTRAINT DFT_Administrators_IsPhoneVerified DEFAULT(0),
  IsRemoved BIT NOT NULL CONSTRAINT DFT_Administrators_IsRemoved DEFAULT(0),
  CONSTRAINT PK_Administartors PRIMARY KEY(AdministratorId),
  CONSTRAINT CHK_Administrators_FirstName CHECK(DATALENGTH(FirstName)>2),
  CONSTRAINT CHK_Administrators_LastName CHECK(DATALENGTH(LastName)>2),
  CONSTRAINT CHK_Administrators_MiddleName CHECK(DATALENGTH(MiddleName)>2),
  CONSTRAINT CHK_Administrators_Birthday CHECK(YEAR(Birthday)>=1960),
  CONSTRAINT CHK_Administrators_Email CHECK(DATALENGTH(Email)>2),
  CONSTRAINT UNQ_Administrators_Email UNIQUE(Email),
  CONSTRAINT CHK_Administrators_PhoneNumber CHECK(DATALENGTH(PhoneNumber)>2),
  CONSTRAINT UNQ_Administrators_PhoneNumber UNIQUE(PhoneNumber)
);
GO

-- Teachers

IF (OBJECT_ID('dbo.Teachers') IS NOT NULL)
DROP TABLE dbo.Teachers;
GO

CREATE TABLE dbo.Teachers
(
  TeacherId INT NOT NULL IDENTITY,
  FirstName NVARCHAR(64) NOT NULL,
  LastName NVARCHAR(64) NOT NULL,
  MiddleName NVARCHAR(64) NOT NULL,
  Birthday DATE,
  Email NVARCHAR(128) NOT NULL,
  IsEmailVerified BIT NOT NULL CONSTRAINT DFT_Teachers_IsEmailVerified DEFAULT(0),
  PhoneNumber NCHAR(17),
  IsPhoneVerified BIT NOT NULL CONSTRAINT DFT_Teachers_IsPhoneVerified DEFAULT(0),
  IsRemoved BIT NOT NULL CONSTRAINT DFT_Teachers_IsRemoved DEFAULT(0),
  CONSTRAINT PK_Teachers PRIMARY KEY(TeacherId),
  CONSTRAINT CHK_Teachers_FirstName CHECK(DATALENGTH(FirstName)>2),
  CONSTRAINT CHK_Teachers_LastName CHECK(DATALENGTH(LastName)>2),
  CONSTRAINT CHK_Teachers_MiddleName CHECK(DATALENGTH(MiddleName)>2),
  CONSTRAINT CHK_Teachers_Birthday CHECK(YEAR(Birthday)>=1960),
  CONSTRAINT CHK_Teachers_Email CHECK(DATALENGTH(Email)>2),
  CONSTRAINT UNQ_Teachers_Email UNIQUE(Email),
  CONSTRAINT CHK_Teachers_PhoneNumber CHECK(DATALENGTH(PhoneNumber)>2),
  CONSTRAINT UNQ_Teachers_PhoneNumber UNIQUE(PhoneNumber)
);
GO

-- Groups

IF (OBJECT_ID('dbo.Groups') IS NOT NULL)
DROP TABLE dbo.Groups;
GO

CREATE TABLE dbo.Groups
(
 GroupId INT NOT NULL IDENTITY,
 Name NCHAR(13) NOT NULL,
 IsRemoved BIT NOT NULL CONSTRAINT DFT_Groups_IsRemoved DEFAULT(0),
 CONSTRAINT PK_Groups PRIMARY KEY(GroupId),
 CONSTRAINT CHK_Groups_Name CHECK(DATALENGTH(Name)>2),
 CONSTRAINT UNQ_Groups_Name UNIQUE(Name)
);
GO

-- Students

IF (OBJECT_ID('dbo.Students') IS NOT NULL)
DROP TABLE dbo.Students;
GO

CREATE TABLE dbo.Students
(
  StudentId INT NOT NULL IDENTITY,
  GroupId INT NOT NULL,
  FirstName NVARCHAR(64) NOT NULL,
  LastName NVARCHAR(64) NOT NULL,
  MiddleName NVARCHAR(64) NOT NULL,
  Birthday DATE,
  Email NVARCHAR(128) NOT NULL,
  IsEmailVerified BIT NOT NULL CONSTRAINT DFT_Students_IsEmailVerified DEFAULT(0),
  PhoneNumber NCHAR(17),
  IsPhoneVerified BIT NOT NULL CONSTRAINT DFT_Students_IsPhoneVerified DEFAULT(0),
  IsRemoved BIT NOT NULL CONSTRAINT DFT_Students_IsRemoved DEFAULT(0),
  CONSTRAINT PK_Students PRIMARY KEY(StudentId),
  CONSTRAINT FK_Students_GroupId FOREIGN KEY(GroupId) REFERENCES dbo.Groups(GroupId),
  CONSTRAINT CHK_Students_FirstName CHECK(DATALENGTH(FirstName)>2),
  CONSTRAINT CHK_Students_LastName CHECK(DATALENGTH(LastName)>2),
  CONSTRAINT CHK_Students_MiddleName CHECK(DATALENGTH(MiddleName)>2),
  CONSTRAINT CHK_Students_Birthday CHECK(YEAR(Birthday)>=1960),
  CONSTRAINT CHK_Students_Email CHECK(DATALENGTH(Email)>2),
  CONSTRAINT UNQ_Students_Email UNIQUE(Email),
  CONSTRAINT CHK_Students_PhoneNumber CHECK(DATALENGTH(PhoneNumber)>2),
  CONSTRAINT UNQ_Students_PhoneNumber UNIQUE(PhoneNumber)
);
GO

-- AdministratorDetails

IF (OBJECT_ID('dbo.AdministratorDetails') IS NOT NULL)
DROP TABLE dbo.AdministratorDetails;
GO

CREATE TABLE dbo.AdministratorDetails
(
  AdministratorId INT NOT NULL,
  Login NVARCHAR(128) NOT NULL,
  Password NVARCHAR(128) NOT NULL,
  CONSTRAINT PK_AdministratorDetails PRIMARY KEY (AdministratorId),
  CONSTRAINT FK_AdministratorDetails FOREIGN KEY (AdministratorId) REFERENCES dbo.Administrators,
  CONSTRAINT CHK_AdministratorDetails_Login CHECK(DATALENGTH(Login)>2),
  CONSTRAINT UNQ_AdministratorDetails_Login UNIQUE(Login),
  CONSTRAINT CHK_AdministratorDetails_Password CHECK(DATALENGTH(Password)>2),
  CONSTRAINT UNQ_AdministratorDetails_Password UNIQUE(Password)
);
GO

-- TeacherDetails

IF (OBJECT_ID('dbo.TeacherDetails') IS NOT NULL)
DROP TABLE dbo.TeacherDetails;
GO

CREATE TABLE dbo.TeacherDetails
(
  TeacherId INT NOT NULL,
  Login NVARCHAR(128) NOT NULL,
  Password NVARCHAR(128) NOT NULL,
  CONSTRAINT PK_TeacherDetails PRIMARY KEY (TeacherId),
  CONSTRAINT FK_TeacherDetails FOREIGN KEY (TeacherId) REFERENCES dbo.Teachers,
  CONSTRAINT CHK_TeacherDetails_Login CHECK(DATALENGTH(Login)>2),
  CONSTRAINT UNQ_TeacherDetails_Login UNIQUE(Login),
  CONSTRAINT CHK_TeacherDetails_Password CHECK(DATALENGTH(Password)>2),
  CONSTRAINT UNQ_TeacherDetails_Password UNIQUE(Password)
);
GO

-- StudentDetails

IF (OBJECT_ID('dbo.StudentDetails') IS NOT NULL)
DROP TABLE dbo.StudentDetails;
GO

CREATE TABLE dbo.StudentDetails
(
  StudentId INT NOT NULL,
  Login NVARCHAR(128) NOT NULL,
  Password NVARCHAR(128) NOT NULL,
  CONSTRAINT PK_StudentDetails PRIMARY KEY (StudentId),
  CONSTRAINT FK_StudentDetails FOREIGN KEY (StudentId) REFERENCES dbo.Students,
  CONSTRAINT CHK_StudentDetails_Login CHECK(DATALENGTH(Login)>2),
  CONSTRAINT UNQ_StudentDetails_Login UNIQUE(Login),
  CONSTRAINT CHK_StudentDetails_Password CHECK(DATALENGTH(Password)>2),
  CONSTRAINT UNQ_StudentDetails_Password UNIQUE(Password)
);
GO

-- Tests

IF (OBJECT_ID('dbo.Tests') IS NOT NULL)
DROP TABLE dbo.Tests;
GO

CREATE TABLE dbo.Tests
(
  TestId INT NOT NULL IDENTITY,
  Title NVARCHAR(64) NOT NULL,
  Description NVARCHAR(4000),
  IsPassed BIT NOT NULL CONSTRAINT DFT_Tests_IsPassed DEFAULT(0),
  Start DATETIME NOT NULL,
  [End] DATETIME NOT NULL,
  IsRemoved BIT NOT NULL CONSTRAINT DFT_Tests_IsRemoved DEFAULT(0),
  CONSTRAINT PK_Tests PRIMARY KEY(TestId),
  CONSTRAINT CHK_Tests_Title CHECK(DATALENGTH(Title)>2),
  CONSTRAINT UNQ_Tests_Title UNIQUE(Title),
  CONSTRAINT CHK_Tests_Description CHECK(DATALENGTH(Description)>2),
  CONSTRAINT CHK_Tests_End CHECK([End] > Start)
);
GO

-- Questions

IF (OBJECT_ID('dbo.Questions') IS NOT NULL)
DROP TABLE dbo.Questions;
GO

CREATE TABLE dbo.Questions
(
  QuestionId INT NOT NULL IDENTITY,
  [Text] NVARCHAR(256) NOT NULL,
  TestId INT NOT NULL,
  IsRemoved BIT NOT NULL CONSTRAINT DFT_Questions_IsRemoved DEFAULT(0),
  CONSTRAINT PK_Questions PRIMARY KEY(QuestionId),
  CONSTRAINT CHK_Questions CHECK(DATALENGTH([Text])>2),
  CONSTRAINT FK_Questions_TestId FOREIGN KEY (TestId) REFERENCES dbo.Tests
);
GO

-- Answers

IF (OBJECT_ID('dbo.Answers') IS NOT NULL)
DROP TABLE dbo.Answers;
GO

CREATE TABLE dbo.Answers
(
  AnswerId INT NOT NULL IDENTITY,
  QuestionId INT NOT NULL,
  [Text] NVARCHAR(256) NOT NULL,
  IsRemoved BIT NOT NULL CONSTRAINT DFT_Answers_IsRemoved DEFAULT(0),
  CONSTRAINT PK_Answers PRIMARY KEY(AnswerId),
  CONSTRAINT FK_Answers_QuestionId FOREIGN KEY(QuestionId) REFERENCES dbo.Questions(QuestionId),
  CONSTRAINT CHK_Answers CHECK(DATALENGTH([Text])>2),
);
GO

-- GroupTests

IF (OBJECT_ID('dbo.GroupTests') IS NOT NULL)
DROP TABLE dbo.GroupTests;
GO

CREATE TABLE dbo.GroupTests
(
GroupId INT NOT NULL,
TestId INT NOT NULL,
CONSTRAINT PK_GroupTests PRIMARY KEY(GroupId, TestId),
CONSTRAINT FK_GroupTests_GroupId FOREIGN KEY(GroupId) REFERENCES dbo.Groups(GroupId),
CONSTRAINT FK_GroupTests_TestId FOREIGN KEY(TestId) REFERENCES dbo.Tests(TestId)
);
GO

-- StudentTests

IF (OBJECT_ID('dbo.StudentTests') IS NOT NULL)
DROP TABLE dbo.StudentTests;
GO

CREATE TABLE dbo.StudentTests
(
 RecordId INT NOT NULL IDENTITY,
 StudentId INT NOT NULL,
 TestId INT NOT NULL,
 AllowToPass BIT NOT NULL CONSTRAINT DFT_StudentTests_AllowToPass DEFAULT(0),
 /* Percent correct answers */
 PCA FLOAT NOT NULL,
 IsRemoved BIT NOT NULL CONSTRAINT DFT_StudentTests_IsRemoved DEFAULT(0),
 CONSTRAINT PK_StudentTests PRIMARY KEY(RecordId),
 CONSTRAINT FK_StudentTests_StudentId FOREIGN KEY(StudentId) REFERENCES dbo.Students(StudentId),
 CONSTRAINT FK_StudentTests_TestId FOREIGN KEY(TestId) REFERENCES dbo.Tests(TestId),
 CONSTRAINT CHK_StudentTests_PCA CHECK(PCA BETWEEN 0 AND 100)
);
GO

/*
 *
 * Filling tables with fake data
 *
 */

SET DATEFORMAT DMY;
SET NOCOUNT ON;

-- Administrators

INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Annotés', 'Mc Meekan', 'Marylène', '15.06.1970', 'emcmeekan0@naver.com', 1, '+351-123-197-4170', 0, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Maïwenn', 'Fosken', 'Cécile', '25.08.1972', 'tfosken1@meetup.com', 1, '+57-725-731-5449', 1, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Kévina', 'Pybus', 'Daphnée', '02.11.1976', 'cpybus2@prweb.com', 0, '+86-383-335-6306', 1, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Börje', 'Dimitru', 'Yóu', '13.03.1974', 'gdimitru3@cdc.gov', 1, '+86-893-182-8125', 0, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Léa', 'Spurrier', 'Åke', '17.07.1971', 'bspurrier4@squidoo.com', 1, '+1-460-891-4324', 1, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Agnès', 'Philipart', 'Céline', '04.10.1976', 'aphilipart5@plala.or.jp', 0, '+98-468-664-1681', 0, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Mahélie', 'Morteo', 'Nadège', '30.06.1977', 'amorteo6@omniture.com', 0, '+63-753-519-5190', 0, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Anaé', 'Keer', 'Marie-josée', '24.02.1975', 'bkeer7@wikispaces.com', 1, '+33-241-583-1300', 1, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Noëlla', 'Seargeant', 'Lén', '31.03.1972', 'cseargeant8@auda.org.au', 0, '+86-252-202-4767', 0, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Gisèle', 'Kestell', 'Anaël', '19.04.1978', 'pkestell9@nasa.gov', 1, '+389-480-406-3360', 0, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Cinéma', 'Hadden', 'Mélina', '10.11.1975', 'ohaddena@istockphoto.com', 1, '+61-103-553-8776', 0, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Maëlys', 'Glasbey', 'Björn', '21.06.1975', 'kglasbeyb@nydailynews.com', 1, '+7-613-960-1800', 1, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Régine', 'Schwanden', 'Léone', '05.01.1974', 'dschwandenc@youku.com', 0, '+358-364-804-2474', 1, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Thérèse', 'Snasel', 'Maï', '04.07.1978', 'vsnaseld@wsj.com', 1, '+351-568-117-1553', 1, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Lài', 'Faraday', 'Maëline', '25.06.1970', 'pfaradaye@issuu.com', 1, '+92-528-196-4036', 1, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Léane', 'Fine', 'Aloïs', '09.10.1973', 'afinef@barnesandnoble.com', 1, '+1-850-595-3217', 1, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Ruì', 'Clutten', 'Maïlys', '13.12.1979', 'cclutteng@t.co', 0, '+86-472-213-4949', 1, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Gwenaëlle', 'Wormleighton', 'Örjan', '06.05.1976', 'swormleightonh@amazon.co.jp', 0, '+598-465-773-0336', 0, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Eloïse', 'Glasscoe', 'Laurélie', '23.08.1970', 'wglasscoei@youtu.be', 1, '+81-285-368-0608', 1, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Marie-françoise', 'Busswell', 'Zoé', '28.05.1974', 'kbusswellj@dyndns.org', 0, '+351-356-605-9296', 1, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Illustrée', 'Meller', 'Yóu', '24.01.1970', 'hmellerk@wikia.com', 0, '+62-972-821-1810', 1, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Séverine', 'Jaray', 'Bérengère', '26.09.1976', 'rjarayl@hud.gov', 1, '+7-888-364-4285', 0, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Estée', 'Ison', 'Thérèse', '18.06.1975', 'gisonm@networkadvertising.org', 1, '+66-605-180-7149', 0, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Zhì', 'Deeson', 'Loïs', '29.12.1973', 'mdeesonn@chronoengine.com', 1, '+62-554-778-4281', 0, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Eugénie', 'Pischel', 'Mélodie', '12.05.1976', 'kpischelo@g.co', 0, '+507-289-630-7023', 1, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Andrée', 'Baumann', 'Mélanie', '15.01.1978', 'kbaumannp@mapy.cz', 1, '+86-186-631-6455', 1, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Célia', 'Suttell', 'Görel', '15.03.1977', 'lsuttellq@fema.gov', 1, '+386-152-782-5970', 0, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Thérèse', 'Deely', 'Séverine', '01.06.1971', 'edeelyr@mail.ru', 1, '+240-689-375-7421', 1, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Estée', 'Faulkes', 'Méline', '17.04.1970', 'nfaulkess@dion.ne.jp', 1, '+1-881-255-1613', 1, 0);
INSERT INTO dbo.Administrators (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Lauréna', 'Swane', 'Tú', '18.10.1970', 'wswanet@ihg.com', 1, '+255-397-348-5411', 0, 0);

-- Teachers

INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Adélie', 'Lawden', 'Dà', '25.05.1974', 'clawden0@cnbc.com', 0, '+86-228-365-1958', 0, 1);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Anaïs', 'Staten', 'Maïlis', '10.01.1970', 'tstaten1@wp.com', 1, '+235-864-305-9685', 1, 0);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Eléonore', 'Rebeiro', 'Eloïse', '06.04.1974', 'prebeiro2@rambler.ru', 1, '+62-955-412-4068', 0, 1);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Ophélie', 'Cowl', 'Dà', '30.08.1972', 'kcowl3@theatlantic.com', 1, '+351-211-340-5684', 1, 0);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Åslög', 'Willox', 'Angèle', '02.09.1975', 'bwillox4@altervista.org', 1, '+503-892-371-9217', 0, 1);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Erwéi', 'Garnall', 'Ruì', '12.01.1979', 'bgarnall5@nyu.edu', 0, '+963-705-396-8706', 0, 0);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Åsa', 'Gauthorpp', 'Görel', '06.07.1970', 'hgauthorpp6@eepurl.com', 0, '+1-717-943-7854', 1, 0);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Estève', 'Endrizzi', 'Inès', '06.03.1976', 'sendrizzi7@rediff.com', 1, '+995-101-528-2146', 1, 1);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Zoé', 'Ruprechter', 'Maëlyss', '04.05.1974', 'mruprechter8@hibu.com', 0, '+86-529-362-1642', 0, 1);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Estée', 'Adlem', 'Personnalisée', '14.02.1976', 'radlem9@last.fm', 0, '+86-455-535-0663', 0, 0);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Maïlis', 'Dottridge', 'Gérald', '06.05.1978', 'cdottridgea@epa.gov', 1, '+234-603-897-9511', 0, 0);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Gwenaëlle', 'Ballantine', 'Ruò', '16.11.1976', 'bballantineb@yale.edu', 0, '+381-442-695-4076', 0, 1);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Salomé', 'Wiburn', 'Béatrice', '28.10.1971', 'swiburnc@weather.com', 0, '+86-916-925-6560', 1, 0);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Yóu', 'Goreway', 'Valérie', '14.05.1972', 'tgorewayd@purevolume.com', 0, '+386-195-142-3559', 0, 0);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Cécilia', 'Birkbeck', 'Börje', '25.01.1973', 'mbirkbecke@live.com', 0, '+380-709-164-9674', 0, 1);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Yénora', 'Petrovic', 'Anaé', '11.07.1976', 'gpetrovicf@java.com', 0, '+62-372-959-4547', 1, 0);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Aloïs', 'MacCleay', 'Lauréna', '20.07.1977', 'cmaccleayg@webs.com', 1, '+33-332-772-5841', 0, 1);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Cécile', 'Hrachovec', 'Mélia', '06.07.1973', 'dhrachovech@ocn.ne.jp', 0, '+63-608-830-9148', 0, 1);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Eloïse', 'Chataignier', 'Maïwenn', '24.05.1975', 'bchataignieri@cbsnews.com', 1, '+34-261-218-3828', 0, 1);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Athéna', 'Bruckenthal', 'Crééz', '19.12.1976', 'abruckenthalj@boston.com', 0, '+370-897-478-3042', 1, 0);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Rébecca', 'Ivanishin', 'Cécilia', '01.12.1970', 'civanishink@redcross.org', 1, '+7-518-731-1401', 1, 0);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Régine', 'Tregenna', 'Eugénie', '04.12.1972', 'jtregennal@amazon.co.jp', 1, '+86-664-730-8336', 1, 0);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Tú', 'Ducarel', 'Zhì', '23.06.1973', 'jducarelm@booking.com', 0, '+7-576-315-0164', 0, 0);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Bérengère', 'Tanner', 'Cléopatre', '22.09.1978', 'vtannern@typepad.com', 0, '+351-577-187-5704', 1, 0);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Yáo', 'Threadgill', 'Annotée', '18.12.1973', 'gthreadgillo@salon.com', 0, '+63-496-895-2785', 1, 1);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Anaé', 'Toward', 'Cloé', '11.09.1978', 'itowardp@last.fm', 0, '+48-369-857-4326', 0, 0);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Mélodie', 'Harlow', 'Maëly', '03.05.1976', 'yharlowq@artisteer.com', 0, '+86-996-992-6208', 0, 0);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Frédérique', 'Neames', 'Lén', '20.02.1977', 'cneamesr@virginia.edu', 1, '+48-678-771-8818', 0, 1);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Océane', 'Terbeck', 'Noëlla', '19.03.1970', 'aterbecks@mail.ru', 1, '+48-831-226-7544', 0, 0);
INSERT INTO dbo.Teachers (FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES ('Andréa', 'Jasiak', 'Jú', '09.02.1979', 'ajasiakt@hexun.com', 0, '+36-858-272-1715', 0, 0);

-- Groups

INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('6g_03', 0);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('6w_66', 1);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('6i_19', 1);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('4f_05', 0);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('8l_43', 0);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('2h_99', 0);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('4f_73', 0);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('1m_72', 0);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('9u_46', 1);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('9g_93', 0);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('7x_46', 0);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('4u_10', 1);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('3h_29', 0);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('3e_82', 1);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('6w_76', 1);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('2g_97', 1);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('0g_33', 0);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('2i_74', 0);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('8s_94', 0);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('2e_62', 1);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('5h_66', 0);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('8z_57', 1);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('3m_31', 0);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('8j_02', 0);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('6t_62', 0);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('3o_65', 1);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('8t_83', 1);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('8b_67', 1);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('2f_33', 1);
INSERT INTO dbo.Groups (Name, IsRemoved) VALUES ('6h_66', 0);

-- Students

INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (1, 'Pénélope', 'Gotmann', 'Léonore', '08.05.1994', 'egotmann0@spotify.com', 0, '+351-101-636-7242', 0, 0);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (2, 'Börje', 'Lindsay', 'Maïly', '21.08.1992', 'dlindsay1@ibm.com', 1, '+86-990-517-3189', 1, 1);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (3, 'Maëlla', 'Pickwell', 'Personnalisée', '15.11.1996', 'apickwell2@parallels.com', 0, '+1-797-413-1232', 1, 1);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (4, 'Pénélope', 'Winston', 'Táng', '14.03.1987', 'twinston3@creativecommons.org', 1, '+62-770-557-1876', 0, 0);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (5, 'Irène', 'Binestead', 'Aimée', '26.09.1993', 'gbinestead4@nationalgeographic.com', 1, '+63-500-288-6175', 1, 1);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (6, 'Cinéma', 'Teague', 'Daphnée', '25.08.1991', 'oteague5@newsvine.com', 0, '+63-631-451-2820', 0, 0);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (7, 'Börje', 'Braune', 'Judicaël', '08.03.1988', 'abraune6@gnu.org', 1, '+84-869-165-8017', 1, 0);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (8, 'Mårten', 'Abramchik', 'Åsa', '21.05.1998', 'aabramchik7@rediff.com', 0, '+86-499-122-2631', 1, 0);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (9, 'Naéva', 'Harle', 'Aí', '28.04.1992', 'sharle8@eepurl.com', 1, '+86-936-807-2122', 1, 1);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (10, 'Séréna', 'Lideard', 'Alizée', '09.08.1990', 'jlideard9@thetimes.co.uk', 1, '+56-305-365-6209', 1, 1);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (11, 'Maëlyss', 'Grave', 'Lucrèce', '04.05.1988', 'bgravea@taobao.com', 0, '+48-114-738-6168', 1, 1);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (12, 'Dafnée', 'Arend', 'Wá', '28.04.1992', 'harendb@scientificamerican.com', 0, '+55-764-170-8224', 0, 0);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (13, 'Géraldine', 'Sawley', 'Bénédicte', '17.08.1992', 'lsawleyc@rambler.ru', 0, '+46-441-196-8702', 1, 1);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (14, 'Séréna', 'Culbert', 'Liè', '05.02.1990', 'aculbertd@mail.ru', 0, '+51-833-313-3673', 1, 0);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (15, 'Magdalène', 'Bagshawe', 'Mylène', '28.07.1992', 'abagshawee@elegantthemes.com', 0, '+86-364-573-5445', 1, 0);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (16, 'Clélia', 'Rosenstein', 'Mylène', '03.11.1987', 'jrosensteinf@cpanel.net', 1, '+1-516-453-7815', 1, 1);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (17, 'Kévina', 'Jakubovski', 'Lyséa', '02.11.1995', 'sjakubovskig@lulu.com', 0, '+976-979-656-6865', 0, 0);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (18, 'Mahélie', 'Aspling', 'Annotés', '20.11.1995', 'easplingh@gnu.org', 1, '+7-290-422-3836', 1, 1);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (19, 'Garçon', 'Bernardelli', 'Maéna', '04.09.1999', 'sbernardellii@altervista.org', 1, '+351-992-454-3496', 1, 1);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (20, 'Lèi', 'Maden', 'Chloé', '09.03.1994', 'fmadenj@cpanel.net', 0, '+63-639-598-4842', 0, 0);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (21, 'Åslög', 'Frensche', 'Jú', '16.02.1990', 'dfrenschek@illinois.edu', 0, '+509-161-999-2812', 0, 1);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (22, 'Laurène', 'Goor', 'Aloïs', '16.05.1992', 'ogoorl@techcrunch.com', 1, '+86-163-366-9621', 0, 0);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (23, 'Aloïs', 'Willden', 'Joséphine', '28.08.1997', 'twilldenm@bluehost.com', 1, '+34-270-526-5923', 1, 1);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (24, 'Gisèle', 'Sambiedge', 'Thérèsa', '11.05.1990', 'rsambiedgen@shinystat.com', 0, '+86-242-314-9565', 1, 0);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (25, 'Maï', 'Drayton', 'Marie-noël', '28.01.1988', 'ddraytono@imdb.com', 1, '+48-908-416-9773', 1, 1);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (26, 'Simplifiés', 'Leser', 'Märta', '27.06.1989', 'fleserp@stumbleupon.com', 1, '+54-508-602-7805', 0, 1);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (27, 'Camélia', 'Shaxby', 'Jú', '21.07.1995', 'wshaxbyq@accuweather.com', 0, '+7-450-413-8507', 0, 0);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (28, 'Mahélie', 'Roadknight', 'Renée', '29.09.1999', 'rroadknightr@kickstarter.com', 1, '+93-383-208-7633', 1, 0);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (29, 'Judicaël', 'Templman', 'Bérengère', '20.06.1990', 'ltemplmans@csmonitor.com', 0, '+86-719-893-2776', 1, 0);
INSERT INTO dbo.Students (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, IsRemoved) VALUES (30, 'Yóu', 'Hattrick', 'Cléa', '23.10.1992', 'rhattrickt@shareasale.com', 0, '+62-301-803-7397', 1, 0);

-- AdministratorDetails

INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (1, 'dlound0', '8642da7d1bfcbfdaec030bb542349911');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (2, 'ldesorts1', 'f7d41e5fb85960f2dd4dd791df46a740');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (3, 'omctavy2', '4d82bf7a78d604c56bb54cfb686b5020');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (4, 'lankrett3', 'f7e5a34a8b72e9c8a812a9189d4d3b40');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (5, 'jlarkcum4', '54fbe8a2c3d3ec3d63559657605db8eb');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (6, 'ejaukovic5', '826710028f968e67bd0131e0a0136e93');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (7, 'kwingate6', '85c9b63f19a1a925cd29c50846a3621d');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (8, 'maggas7', 'a60333bcd29a9a3b8700ea3ff870be8d');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (9, 'owoloschinski8', '4a910a7b5b4c53577f5607d68da5b2d9');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (10, 'mslipper9', 'e014dd2ae00631d50ddf287ec8f1d5aa');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (11, 'lleopolda', 'dee950f0ea04161b2bcb9ab9c8792fe0');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (12, 'esumptonb', 'dd7141a326da86bd54450e5792b2628a');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (13, 'brimerc', 'b5b34d4ad375f70e8cb45f0c903753c0');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (14, 'ccourtd', 'f46e4236f337b04fa9a2452a616195a7');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (15, 'abarnbrooke', 'be070dd8993d7f14a1e03555fd2f2495');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (16, 'cwhiskinf', '256707c3af7ea7448b7a7f729a02bf03');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (17, 'hewingtong', '054605d40ece773be1df97368b003527');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (18, 'ceckleyh', '0488f8075a1acfda7dce70f50802cf52');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (19, 'lcracketti', '39d03170b691bc6e0b5715c366e9d710');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (20, 'amcnameej', '3a7db6a72f72b680906265b4908202e6');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (21, 'akellittk', 'a79df99c7b0cf90e14e419c83ab0cf13');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (22, 'icaberasl', '00a9c8d1a85b221e87f1b6fa28ed3b43');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (23, 'pkupecm', '7e772f35af9ff9038e0abe827a22676d');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (24, 'akiplingn', 'bea0a13edcccdfe4d44dcaebe6252ab2');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (25, 'bgrumbleo', '828475083f2f5369675747b9e03575a0');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (26, 'agirtonp', 'd37de4f73656e005c9fe3d88f85ecb89');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (27, 'dtefftq', '6f74a71093ab702a5894d9739846a01e');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (28, 'jbogr', 'ddbb29d848cfdff7fce6fe96a5ebca34');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (29, 'aflookss', '7693a3382e93e9382ead9fdf5eb4183b');
INSERT INTO dbo.AdministratorDetails (AdministratorId, Login, Password) VALUES (30, 'zwhitsunt', '0af0de75f768a893d647103e06f8efef');

-- TeacherDetails

INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (1, 'redgerly0', '47abdb0df7a31d51705f6f45247ba558');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (2, 'sdenmead1', '9e701f9c184ab805910cd3ed36c14772');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (3, 'gflintoffe2', 'da4f5d4611b6d675317a65296f938304');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (4, 'hgeggus3', 'abd132f633c92eccf81476f10dcd8095');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (5, 'epetters4', '41ac3aa754c37089e535979ef457d46f');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (6, 'rabbet5', '5ed27001612f9fe29bc9ecbf0e8d044e');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (7, 'kalker6', '8bbb9354e32a10c2a48ac813a05a3de2');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (8, 'tklimushev7', 'b37f8598d5a718bbcbd204619e4d9776');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (9, 'vnolleau8', 'ccdcb8ca66335c421c12fdfc9c7604f7');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (10, 'skeinrat9', '8387b536a55b56db17a7e7a2cc703268');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (11, 'rsangea', 'd203f3d92d5200cae970670eb668d3b6');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (12, 'jbrimmacombeb', 'b90f975a2a36ec3cc75eafea85db9be7');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (13, 'gschererc', '54f63eb35cd94620ec93c9ab061ce281');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (14, 'esidneyd', '6e4c3c8a3fd8646dd463181c563d8276');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (15, 'hginnanee', 'd85d1ea587829c96e5a3a753a913f309');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (16, 'rwrathallf', '7d99ed2b217d4ed153c782c6f318dbae');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (17, 'bmacrierieg', 'c93965c84ff1fdcd27b3c7aeb2ccd97b');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (18, 'cangierh', 'eddf7adcb6edb222832fc89c6a838e90');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (19, 'rirelandi', 'f09e90f1aa1e4a1ecefb6ce010c5957b');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (20, 'amintyj', 'fb8933caf439b533237d11f7479b43ba');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (21, 'ccloughtonk', 'eff8f5bf21e8c917cc9dc38940d80173');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (22, 'aberardtl', 'f66d6b26d29130794d6a27fa61c0fe1d');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (23, 'gdaybellm', '11334a4509cd745749024c8090a7e8d2');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (24, 'crozen', 'd723a2551df0b92cbd34cc59b4754647');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (25, 'lbraamo', '520e7dfddea1aeabeae65ed71af93c85');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (26, 'rmacdearmaidp', 'bbd216839084d159f0117e1fe7658e25');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (27, 'vlowthianq', '8529dbbf6f8823e7bb098bd3fab48db3');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (28, 'cfoxenr', 'fbf0874742701aa971825605bee6eef6');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (29, 'mpetrollos', '0bd696d595108a6c02b1d1bca9924563');
INSERT INTO dbo.TeacherDetails (TeacherId, Login, Password) VALUES (30, 'imathest', '8fd6d0d2faede1bd286df049bbdd98fd');

-- StudentDetails

INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (1, 'iroblin0', 'ba1fe39b903499cf2a9893dbea3d5b31');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (2, 'gwestwood1', '76d5db8a00ef43493d557d00c41eddad');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (3, 'bjurn2', '2ce7c246c5609b8201e61f21408f7064');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (4, 'rstiegers3', 'd4649a4f515cc2c3f611a070c7b7711e');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (5, 'cdewfall4', '3311e1e76fcb140fcfe51f5cc451ca7f');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (6, 'efitzgibbon5', '0ef8d0e05e63df1268dde89bcf736c6c');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (7, 'smorecomb6', 'c92cf25eb5ddb53ae5b92b6079b0fbff');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (8, 'gscadding7', 'dacf072cdcd3d2ac46bc50addef35ae9');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (9, 'aallsep8', '0fb3286bd2633e3903cad3fa505bbfcd');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (10, 'cfalkous9', 'eed94441f91218c7a456c2ae84963016');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (11, 'ahayseya', '9253acbe891f9334aee551be4c46f981');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (12, 'sblagburnb', '99ff35bc2e36040f967aac374f63a87d');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (13, 'dwitherbyc', '8f27f6e1b4ef9c8856ee8377d6e96627');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (14, 'kmantioned', '7aeb5fff3015a5420ba4cf8720f31f0d');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (15, 'bcorkee', '6346d4b81e643025808309bb68de2145');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (16, 'nguideraf', '8c836b0b7526ac18077457207c441756');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (17, 'jlightbowng', '277b8f82e76f1420bd79408ad373a5da');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (18, 'dbransdonh', '75a7f0ccaadf91a36dbd94faea789efe');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (19, 'stheunisseni', '634707b88b6d826399d8d516aee72e42');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (20, 'ekitteringhamj', 'c3bcb154505832df7457cb06879c44e0');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (21, 'smayfieldk', '2ebbe4bf6c9862c606d23b6666f06531');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (22, 'cdradeyl', 'd05d845e18160441ee588e217608503f');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (23, 'wrawlingsm', 'f125acc8401d6ecb16d58335ae3d5f7e');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (24, 'briggertn', '073b1985ff83c9a0fe1febce5f518167');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (25, 'deynaudo', 'e00ce4fde829d3b23db202e547e3e194');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (26, 'efavelp', '7ba2cdc5b94dbec77601b4947822d915');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (27, 'wbaurerichq', '85cf599e4ef0074d5c7486edead14f91');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (28, 'kleckeyr', '85a4291f62bc3dbc82724fe2dd19fddb');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (29, 'rsperwells', '59bd2ef0be83bc0800d47df1ef863e6f');
INSERT INTO dbo.StudentDetails (StudentId, Login, Password) VALUES (30, 'pmcduallt', '8dd1f5f94956b4c3c4e776343789fd6f');

--- Tests

insert into Tests (Title, Description, IsPassed, Start, [End], IsRemoved) values ('Marketing', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 0, '19.11.2018', '02.08.2019', 0);
insert into Tests (Title, Description, IsPassed, Start, [End], IsRemoved) values ('Legal', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 1, '06.11.2018', '08.01.2019', 1);
insert into Tests (Title, Description, IsPassed, Start, [End], IsRemoved) values ('Support', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 1, '01.07.2019', '19.08.2019', 1);
insert into Tests (Title, Description, IsPassed, Start, [End], IsRemoved) values ('Sales', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 0, '18.06.2018', '07.08.2019', 0);
insert into Tests (Title, Description, IsPassed, Start, [End], IsRemoved) values ('Human Resources', null, 0, '08.04.2018', '22.08.2018', 0);
insert into Tests (Title, Description, IsPassed, Start, [End], IsRemoved) values ('Research and Development', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 1, '04.09.2018', '15.06.2019', 0);
insert into Tests (Title, Description, IsPassed, Start, [End], IsRemoved) values ('Engineering', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.

Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 0, '19.04.2018', '21.07.2018', 0);
insert into Tests (Title, Description, IsPassed, Start, [End], IsRemoved) values ('Accounting', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 1, '26.01.2018', '02.05.2018', 0);

-- Questions

INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.', 6, 0);
INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus.', 2, 1);
INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('Morbi non lectus.', 1, 0);
INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('Phasellus in felis. Donec semper sapien a libero.', 4, 0);
INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('Aliquam non mauris.', 3, 1);
INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('Nullam sit amet turpis elementum ligula vehicula consequat.', 8, 0);
INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('Nunc purus. Phasellus in felis.', 6, 1);
INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 8, 0);
INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('Integer a nibh.', 4, 0);
INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 8, 0);
INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('Etiam faucibus cursus urna.', 6, 1);
INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 7, 0);
INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue.', 5, 1);
INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('Curabitur gravida nisi at nibh. In hac habitasse platea dictumst.', 5, 0);
INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 7, 0);
INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('Vivamus tortor.', 7, 1);
INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('Duis bibendum. Morbi non quam nec dui luctus rutrum.', 3, 1);
INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 7, 1);
INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('Pellentesque at nulla. Suspendisse potenti.', 2, 1);
INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('Donec vitae nisi.', 6, 0);
INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('Aenean fermentum.', 7, 0);
INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('Praesent id massa id nisl venenatis lacinia.', 4, 1);
INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('Suspendisse ornare consequat lectus.', 3, 0);
INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 1, 1);
INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.', 6, 0);
INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('Nullam molestie nibh in lectus.', 5, 1);
INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('In eleifend quam a odio.', 4, 1);
INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('Donec posuere metus vitae ipsum. Aliquam non mauris.', 4, 1);
INSERT INTO dbo.Questions ([Text], TestId, IsRemoved) VALUES ('Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue.', 6, 1);

-- Answers

INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Vivamus in felis eu sapien cursus vestibulum.', 1, 0);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Morbi a ipsum.', 2, 1);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', 3, 0);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Phasellus id sapien in sapien iaculis congue.', 4, 1);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Suspendisse accumsan tortor quis turpis.', 5, 1);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Pellentesque at nulla.', 6, 1);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Nunc nisl.', 7, 0);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Cras non velit nec nisi vulputate nonummy.', 8, 0);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Sed sagittis.', 9, 0);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Integer ac neque.', 10, 0);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Sed vel enim sit amet nunc viverra dapibus.', 11, 1);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Duis mattis egestas metus.', 12, 0);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Proin leo odio, porttitor id, consequat in, consequat ut, nulla.', 13, 0);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Phasellus in felis.', 14, 0);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Nulla nisl.', 15, 0);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Vestibulum ac est lacinia nisi venenatis tristique.', 16, 1);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Etiam faucibus cursus urna.', 17, 1);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Vivamus vel nulla eget eros elementum pellentesque.', 18, 0);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('In hac habitasse platea dictumst.', 19, 0);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Aenean fermentum.', 20, 0);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Proin risus.', 21, 1);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Maecenas tincidunt lacus at velit.', 22, 0);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 23, 1);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Nulla ac enim.', 24, 1);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Phasellus sit amet erat.', 25, 0);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 26, 0);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Mauris sit amet eros.', 27, 0);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci.', 28, 1);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 29, 0);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Morbi ut odio.', 20, 1);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Phasellus id sapien in sapien iaculis congue.', 21, 0);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Vivamus vel nulla eget eros elementum pellentesque.', 22, 1);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 23, 0);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Nulla ut erat id mauris vulputate elementum.', 24, 0);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Integer ac leo.', 25, 1);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Ut at dolor quis odio consequat varius.', 26, 1);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Donec semper sapien a libero.', 27, 1);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Curabitur in libero ut massa volutpat convallis.', 28, 1);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Donec ut mauris eget massa tempor convallis.', 29, 1);
INSERT INTO dbo.Answers ([Text], QuestionId, IsRemoved) VALUES ('Integer ac neque.', 29, 1);

-- GroupTests

INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (1, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (2, 7);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (3, 7);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (4, 5);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (5, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (6, 2);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (7, 2);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (8, 4);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (9, 2);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (10, 3);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (11, 7);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (12, 8);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (13, 6);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (14, 4);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (15, 5);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (16, 8);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (17, 4);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (18, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (19, 5);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (20, 7);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (21, 2);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (22, 8);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (23, 7);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (24, 6);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (25, 2);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (26, 7);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (27, 7);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (28, 6);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (29, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId) VALUES (30, 2);

-- StudentTests

INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (4, 2, 1, 98.16, 1);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (5, 1, 0, 91.99, 1);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (24, 1, 0, 80.53, 0);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (10, 2, 0, 17.45, 0);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (14, 1, 0, 65.07, 0);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (26, 2, 0, 98.07, 1);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (9, 5, 0, 25.67, 1);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (10, 2, 0, 86.39, 1);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (3, 4, 0, 42.76, 0);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (25, 2, 0, 86.87, 1);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (19, 2, 0, 44.96, 0);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (28, 1, 1, 97.32, 1);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (14, 2, 1, 75.87, 0);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (25, 6, 0, 22.12, 0);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (2, 4, 1, 68.61, 0);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (26, 4, 1, 45.61, 0);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (8, 6, 1, 61.33, 0);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (18, 7, 1, 81.42, 0);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (12, 3, 1, 79.44, 1);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (24, 2, 0, 44.07, 0);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (29, 5, 1, 68.01, 0);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (18, 1, 0, 78.18, 1);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (1, 6, 0, 21.5, 0);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (23, 5, 0, 82.03, 0);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (20, 1, 0, 79.87, 1);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (5, 1, 1, 4.17, 1);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (23, 2, 0, 36.75, 0);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (15, 1, 1, 87.71, 0);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (27, 7, 1, 64.88, 1);
INSERT INTO dbo.StudentTests (StudentId, TestId, AllowToPass, PCA, IsRemoved) VALUES (26, 7, 0, 46.1, 0);

SET NOCOUNT OFF;
GO
