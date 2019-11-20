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

-- Users

IF (OBJECT_ID('dbo.Users') IS NOT NULL)
DROP TABLE dbo.Users;
GO

CREATE TABLE dbo.Users
(
  UserId INT NOT NULL IDENTITY,
  GroupId INT,
  FirstName NVARCHAR(64) NOT NULL,
  LastName NVARCHAR(64) NOT NULL,
  MiddleName NVARCHAR(64) NOT NULL,
  Birthday DATE NOT NULL,
  Email NVARCHAR(128) NOT NULL,
  IsEmailVerified BIT NOT NULL CONSTRAINT DFT_Users_IsEmailVerified DEFAULT(0),
  PhoneNumber NCHAR(17),
  IsPhoneVerified BIT NOT NULL CONSTRAINT DFT_Users_IsPhoneVerified DEFAULT(0),
  Login NVARCHAR(128) NOT NULL,
  Password NVARCHAR(128) NOT NULL,
  IsRemoved BIT NOT NULL CONSTRAINT DFT_Users_IsRemoved DEFAULT(0),
  CONSTRAINT PK_Users_UserId PRIMARY KEY(UserId),
  CONSTRAINT FK_Users_GroupId FOREIGN KEY(GroupId) REFERENCES dbo.Groups(GroupId),
  CONSTRAINT CHK_Users_FirstName CHECK(DATALENGTH(FirstName)>2),
  CONSTRAINT CHK_Users_LastName CHECK(DATALENGTH(LastName)>2),
  CONSTRAINT CHK_Users_MiddleName CHECK(DATALENGTH(MiddleName)>2),
  CONSTRAINT CHK_Users_Birthday CHECK(YEAR(Birthday)>=1960),
  CONSTRAINT CHK_Users_Email CHECK(DATALENGTH(Email)>2),
  CONSTRAINT UNQ_Users_Email UNIQUE(Email),
  CONSTRAINT CHK_Users_PhoneNumber CHECK(DATALENGTH(PhoneNumber)>2),
  CONSTRAINT UNQ_Users_PhoneNumber UNIQUE(PhoneNumber),
  CONSTRAINT CHK_Users_Login CHECK(DATALENGTH(Login)>7),
  CONSTRAINT UNQ_Users_Login UNIQUE(Login),
  CONSTRAINT CHK_Users_Password CHECK(DATALENGTH(Password) >= 5)
);
GO

-- Roles

IF (OBJECT_ID('dbo.Roles') IS NOT NULL)
DROP TABLE dbo.Roles;
GO

CREATE TABLE dbo.Roles
(
  RoleId INT NOT NULL IDENTITY,
  Name NVARCHAR(128) NOT NULL,
  IsRemoved BIT NOT NULL CONSTRAINT DFT_Roles_IsRemoved DEFAULT(0),
  CONSTRAINT PK_Roles PRIMARY KEY(RoleId),
  CONSTRAINT CHK_Roles_Name CHECK(DATALENGTH(Name)>2),
  CONSTRAINT UNQ_Roles_Name UNIQUE(Name)
);
GO

-- UserRoles

IF (OBJECT_ID('dbo.UserRoles') IS NOT NULL)
DROP TABLE dbo.UserRoles;
GO

CREATE TABLE dbo.UserRoles
(
  UserId INT NOT NULL,
  RoleId INT NOT NULL,
  IsRemoved BIT NOT NULL CONSTRAINT DFT_UserRoles_IsRemoved DEFAULT(0),
  CONSTRAINT PK_UserRoles PRIMARY KEY(UserId, RoleId),
  CONSTRAINT FK_UserRoles_UserId FOREIGN KEY(UserId) REFERENCES dbo.Users,
  CONSTRAINT FK_UserRoles_RoleId FOREIGN KEY(RoleId) REFERENCES dbo.Roles
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
  IsRemoved BIT NOT NULL CONSTRAINT DFT_Tests_IsRemoved DEFAULT(0),
  CONSTRAINT PK_Tests PRIMARY KEY(TestId),
  CONSTRAINT CHK_Tests_Title CHECK(DATALENGTH(Title)>2),
  CONSTRAINT UNQ_Tests_Title UNIQUE(Title),
  CONSTRAINT CHK_Tests_Description CHECK(DATALENGTH(Description)>2)
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
RecordId INT NOT NULL IDENTITY,
GroupId INT NOT NULL,
TestId INT NOT NULL,
IsPassed BIT NOT NULL CONSTRAINT DFT_GroupTests_IsPassed DEFAULT(0),
Start DATETIME,
[End] DATETIME,
IsRemoved BIT NOT NULL CONSTRAINT DFT_GroupTests_IsRemoved DEFAULT(0),
CONSTRAINT PK_GroupTests PRIMARY KEY(RecordId),
CONSTRAINT FK_GroupTests_GroupId FOREIGN KEY(GroupId) REFERENCES dbo.Groups(GroupId),
CONSTRAINT FK_GroupTests_TestId FOREIGN KEY(TestId) REFERENCES dbo.Tests(TestId),
CONSTRAINT CHK_GroupTests_End CHECK ([End] > Start)
);
GO

-- StudentTests

IF (OBJECT_ID('dbo.StudentTests') IS NOT NULL)
DROP TABLE dbo.StudentTests;
GO

CREATE TABLE dbo.StudentTests
(
RecordId INT NOT NULL IDENTITY,
UserId INT NOT NULL,
 TestId INT NOT NULL,
 AllowToPass BIT NOT NULL CONSTRAINT DFT_StudentTests_AllowToPass DEFAULT(0),
 /* Percent correct answers */
 PCA FLOAT,
 IsPassed BIT NOT NULL CONSTRAINT DFT_StudentTests_IsPassed DEFAULT(0),
 Start DATETIME,
 [End] DATETIME,
 IsRemoved BIT NOT NULL CONSTRAINT DFT_StudentTests_IsRemoved DEFAULT(0),
 CONSTRAINT PK_StudentTests PRIMARY KEY(RecordId),
 CONSTRAINT FK_StudentTests_UserId FOREIGN KEY(UserId) REFERENCES dbo.Users(UserId),
 CONSTRAINT FK_StudentTests_TestId FOREIGN KEY(TestId) REFERENCES dbo.Tests(TestId),
 CONSTRAINT CHK_StudentTests_PCA CHECK ((PCA IS NULL AND IsPassed = 0) OR (PCA IS NOT NULL AND IsPassed = 1)),
 CONSTRAINT CHK_StudentTests_End CHECK ([End] > Start)
);
GO

/*
 *
 * Filling tables with fake data
 *
 */

SET DATEFORMAT DMY;
SET NOCOUNT ON;

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

--- Tests

INSERT INTO dbo.Tests (Title, Description, IsRemoved) VALUES ('Human Resources', 'Nunc rhoncus dui vel sem. Sed sagittis.', 1);
INSERT INTO dbo.Tests (Title, Description, IsRemoved) VALUES ('Accounting', 'Duis aliquam convallis nunc.', 1);
INSERT INTO dbo.Tests (Title, Description, IsRemoved) VALUES ('Business Development', 'Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 0);
INSERT INTO dbo.Tests (Title, Description, IsRemoved) VALUES ('Marketing', 'Aliquam erat volutpat.', 0);
INSERT INTO dbo.Tests (Title, Description, IsRemoved) VALUES ('Sales', 'Nullam varius.', 0);
INSERT INTO dbo.Tests (Title, Description, IsRemoved) VALUES ('Research and Development', 'Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 1);
INSERT INTO dbo.Tests (Title, Description, IsRemoved) VALUES ('Training', 'Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 0);
INSERT INTO dbo.Tests (Title, Description, IsRemoved) VALUES ('Business Development #2', 'In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 0);
INSERT INTO dbo.Tests (Title, Description, IsRemoved) VALUES ('Training #2', 'Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 0);
INSERT INTO dbo.Tests (Title, Description, IsRemoved) VALUES ('Support', 'Curabitur convallis.', 0);
INSERT INTO dbo.Tests (Title, Description, IsRemoved) VALUES ('Support #2', 'Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend.', 0);
INSERT INTO dbo.Tests (Title, Description, IsRemoved) VALUES ('Human Resources #2', 'Morbi quis tortor id nulla ultrices aliquet.', 0);
INSERT INTO dbo.Tests (Title, Description, IsRemoved) VALUES ('Sales #2', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum.', 1);
INSERT INTO dbo.Tests (Title, Description, IsRemoved) VALUES ('Marketing #2', 'Quisque ut erat.', 0);
INSERT INTO dbo.Tests (Title, Description, IsRemoved) VALUES ('Accounting #2', 'Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam. Nam tristique tortor eu pede.', 0);
INSERT INTO dbo.Tests (Title, Description, IsRemoved) VALUES ('Legal', 'Nunc rhoncus dui vel sem.', 1);
INSERT INTO dbo.Tests (Title, Description, IsRemoved) VALUES ('Product Management', 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 0);
INSERT INTO dbo.Tests (Title, Description, IsRemoved) VALUES ('Support #3', 'Etiam faucibus cursus urna.', 0);
INSERT INTO dbo.Tests (Title, Description, IsRemoved) VALUES ('Support #4', 'Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 0);

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

INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (13, 7, 0, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (26, 16, 0, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (12, 14, 0, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (25, 8, 1, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (24, 17, 1, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (19, 5, 0, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (5, 8, 1, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (29, 15, 1, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (26, 5, 0, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (21, 2, 1, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (6, 14, 1, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (16, 15, 0, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (4, 3, 1, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (10, 15, 0, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (2, 1, 1, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (20, 3, 0, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (9, 2, 1, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (5, 14, 1, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (16, 10, 0, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (11, 17, 1, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (7, 16, 1, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (1, 13, 0, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (29, 5, 1, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (13, 5, 1, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (7, 7, 1, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (29, 7, 1, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (10, 18, 1, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (27, 9, 1, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (10, 12, 1, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (19, 4, 0, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (16, 7, 0, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (24, 11, 0, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (8, 10, 0, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (26, 18, 0, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (30, 12, 0, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (7, 14, 0, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (13, 4, 0, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (23, 2, 0, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (5, 18, 0, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (18, 9, 0, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (20, 4, 1, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (25, 15, 0, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (7, 10, 0, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (8, 18, 0, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (21, 12, 0, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (13, 1, 1, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (12, 2, 1, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (22, 2, 1, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (22, 7, 1, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (13, 12, 1, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (12, 7, 0, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (21, 9, 1, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (16, 19, 0, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (17, 9, 0, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (17, 6, 1, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (29, 9, 0, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (6, 9, 0, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (21, 16, 1, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (15, 2, 0, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (19, 18, 1, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (24, 9, 1, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (30, 13, 0, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (14, 4, 0, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (21, 18, 0, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (22, 16, 0, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (28, 14, 1, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (6, 16, 1, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (29, 17, 1, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (26, 15, 0, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (29, 3, 1, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (24, 13, 1, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (18, 13, 1, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (11, 9, 1, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (11, 10, 0, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (20, 6, 1, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (16, 8, 0, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (28, 3, 1, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (26, 14, 1, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (12, 8, 1, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (13, 3, 1, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (8, 13, 0, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (2, 10, 1, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (18, 17, 0, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (11, 13, 1, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (1, 15, 0, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (23, 19, 1, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (5, 6, 0, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (24, 14, 0, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (26, 9, 1, 0);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (3, 14, 0, 1);
INSERT INTO dbo.GroupTests (GroupId, TestId, IsPassed, IsRemoved) VALUES (4, 5, 1, 0);

-- Users

INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (7, 'Laurélie', 'Marrow', 'Adèle', '22.06.1989', 'smarrow0@amazonaws.com', 0, '+62 827 693 3313', 1, 'kmarrow0', '2c7c81148d70f6e3bd47c8b21ed7d8ef', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Gisèle', 'Kirimaa', 'Pélagie', '11.11.1991', 'lkirimaa1@artisteer.com', 0, '+62 946 730 4813', 1, 'bkirimaa1', '18c5a2f9753ec1eea1c1bdf9257349dc', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (10, 'Erwéi', 'Corington', 'Aí', '14.01.1974', 'hcorington2@nih.gov', 0, '+216 991 313 1355', 0, 'qcorington2', 'a9923bdea4b4d197e034488ae4344643', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Desirée', 'Bamlett', 'Maéna', '26.04.1970', 'mbamlett3@issuu.com', 1, '+86 336 605 2039', 1, 'mbamlett3', 'b0be03f3adcfeb46dc3f315927ef40bc', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Åslög', 'Wynes', 'Anaïs', '12.12.1965', 'mwynes4@goo.gl', 1, '+221 544 198 2800', 0, 'fwynes4', 'b4330d51981595ebd941ad89a4386f61', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Andréa', 'Bennike', 'Táng', '05.11.1990', 'tbennike5@hud.gov', 1, '+51 533 693 5717', 0, 'cbennike5', 'd47037ee5dab76db369c319354660bf6', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (19, 'Angèle', 'Coonan', 'Ophélie', '04.03.1980', 'fcoonan6@cmu.edu', 1, '+351 489 343 8625', 0, 'mcoonan6', '7c0477ad52f3d044dea70f6d9838f02f', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (4, 'Bénédicte', 'Sandifer', 'Naëlle', '15.07.1998', 'nsandifer7@free.fr', 1, '+351 447 531 2672', 1, 'psandifer7', '20624abdfbd08c6dd930be7ba57bd177', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (6, 'Jú', 'Poinsett', 'Maïwenn', '24.02.2002', 'hpoinsett8@cisco.com', 1, '+351 963 351 3294', 1, 'mpoinsett8', 'e37edac0851bf2d556259d0f8db3e87f', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (3, 'Fèi', 'Strase', 'Maëlann', '14.02.1998', 'astrase9@exblog.jp', 1, '+504 220 640 5400', 1, 'jstrase9', '555335ef42170948d4dc20599dd555e6', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Kallisté', 'Wigfield', 'Gwenaëlle', '20.11.1988', 'gwigfielda@yandex.ru', 1, '+57 152 957 2385', 0, 'jwigfielda', '76f889f7401d423de3f5ff1abf2e5f12', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (1, 'Lyséa', 'McGuinley', 'Örjan', '14.06.1988', 'smcguinleyb@google.ru', 0, '+86 230 831 1762', 1, 'mmcguinleyb', '3e244ebfe67e477bfdcfd8d6fd957aa1', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Dafnée', 'Brogioni', 'Méghane', '13.07.1977', 'lbrogionic@sciencedirect.com', 1, '+265 110 657 3029', 1, 'lbrogionic', 'd4bd96fcf5bee16529ac3c6ffdc30ed1', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Lén', 'Manders', 'Lài', '12.05.1970', 'rmandersd@opensource.org', 1, '+62 630 939 6925', 0, 'fmandersd', '5248a97be3fa6a7f003b4ce774abcd4e', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (2, 'Bérangère', 'Hulcoop', 'Annotés', '07.06.1973', 'ehulcoope@biglobe.ne.jp', 0, '+86 901 151 5279', 0, 'shulcoope', '44690c4882b91d51c3bcbec36c822515', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (1, 'Célestine', 'Stonhard', 'Mélodie', '23.03.1984', 'bstonhardf@wikispaces.com', 1, '+62 620 685 6363', 1, 'jstonhardf', '4c9c9f84ef218dff996fedc3a8c2d7f2', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Mélia', 'Danielian', 'Camélia', '19.09.1967', 'cdanieliang@com.com', 0, '+51 583 625 3100', 1, 'idanieliang', '4a544067ac8cb915c061ee2eda19a9a9', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (7, 'Ophélie', 'Betonia', 'Maïlys', '21.05.1984', 'bbetoniah@instagram.com', 0, '+52 511 642 0814', 1, 'abetoniah', '071929ca050768aa40b91e6fa07fc6a2', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Méryl', 'Gateshill', 'Réjane', '04.11.1982', 'bgateshilli@angelfire.com', 0, '+81 365 403 6653', 1, 'cgateshilli', 'd66b9f680014c056ee1ec14159c89b08', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Maëlyss', 'Mizzen', 'Ruò', '24.04.1980', 'ymizzenj@youku.com', 0, '+51 278 162 3872', 1, 'cmizzenj', '35bbdd09f59a58ddb3c5832faaac740f', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (11, 'Mà', 'Linneman', 'Aurélie', '15.12.1982', 'glinnemank@php.net', 1, '+358 953 311 4827', 1, 'plinnemank', '7854ce0f0c4ec4c0c8da88a4cce3b6d0', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (13, 'Maëlla', 'Wiggin', 'Mélissandre', '02.11.2002', 'cwigginl@si.edu', 0, '+351 687 888 8674', 0, 'cwigginl', '5f365466ed1315f383d092caaae09660', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Gaïa', 'Latehouse', 'Andréa', '01.08.1986', 'platehousem@cornell.edu', 0, '+63 685 142 0581', 1, 'nlatehousem', 'ace1bb1b3d61235bb77b26afcaeac985', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (28, 'Björn', 'Nelsey', 'Chloé', '10.03.1979', 'rnelseyn@dell.com', 1, '+46 568 898 5945', 0, 'lnelseyn', '5c883b80a29257ea0ac7365acad409a3', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Léana', 'Frizzell', 'Dà', '11.05.1977', 'hfrizzello@tumblr.com', 0, '+86 981 705 3128', 1, 'hfrizzello', '2dd503721e75e3b4213b2339cbbdf0ec', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (17, 'Sélène', 'Fisbey', 'Marie-josée', '28.03.1997', 'ffisbeyp@godaddy.com', 1, '+505 836 340 9670', 0, 'ffisbeyp', '8e393cd948e419ea2bb51f6841970e6d', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (19, 'Magdalène', 'MacTrustram', 'Andréa', '14.08.1991', 'amactrustramq@alexa.com', 0, '+62 388 946 3325', 1, 'hmactrustramq', '8d2bfeac994e6381398ebbf4bf206ccb', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (25, 'Edmée', 'Sibyllina', 'Adélie', '08.06.1962', 'rsibyllinar@goodreads.com', 0, '+507 371 677 2819', 0, 'csibyllinar', 'e3fafd22755b16fbb9751fbeac3eb2fd', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (2, 'Bénédicte', 'Wickerson', 'Örjan', '27.05.2001', 'cwickersons@theatlantic.com', 1, '+51 425 383 0006', 1, 'lwickersons', '0265883cc2e88ed7ec725e8426364033', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (28, 'Athéna', 'Wither', 'Naëlle', '30.12.1973', 'ewithert@wiley.com', 1, '+351 852 956 6092', 0, 'iwithert', '8f03966b0d371b4b6711c03de22e3308', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (20, 'Nadège', 'Langham', 'Håkan', '26.11.1978', 'rlanghamu@t.co', 0, '+63 610 930 3058', 1, 'clanghamu', 'a1b44da15d7796765dcdfd222f7fa3f2', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (15, 'Mélina', 'Greggersen', 'Mélanie', '17.08.1978', 'sgreggersenv@princeton.edu', 1, '+351 123 785 7229', 1, 'cgreggersenv', '13f837e6a5ecd9ba5c54132b4b062550', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (3, 'Bécassine', 'Boshier', 'Réservés', '17.02.1985', 'vboshierw@tmall.com', 1, '+47 527 177 8306', 0, 'oboshierw', '26cb27565af106607bc8c91c0b61e530', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (17, 'Zhì', 'Crocker', 'Mylène', '18.09.1989', 'kcrockerx@cisco.com', 1, '+86 678 551 0367', 1, 'ecrockerx', '0e3d3c3f9a8819cc03d0fa2a8faf3f5a', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (12, 'Eugénie', 'Murray', 'Almérinda', '17.04.1961', 'nmurrayy@shop-pro.jp', 0, '+55 291 698 8335', 0, 'imurrayy', '2a13e1d996722a6edc271ec4d03f6e71', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (3, 'Béatrice', 'Koch', 'Torbjörn', '26.03.1961', 'skochz@drupal.org', 1, '+63 729 426 4007', 1, 'ckochz', '8b0f99bda141260f9a5f82d5a3c2ae4c', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (4, 'Eugénie', 'Lemin', 'Marie-ève', '11.01.1964', 'flemin10@woothemes.com', 1, '+389 833 424 5915', 0, 'mlemin10', 'aa78c18886d82fe46a177c3ea51266bf', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Dafnée', 'Langmaid', 'Publicité', '05.05.1963', 'rlangmaid11@ovh.net', 0, '+86 765 507 4002', 0, 'dlangmaid11', '0dfdb22c41ddd09f0c370675bddee7bd', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (3, 'Mén', 'Weinberg', 'Märta', '25.03.1997', 'hweinberg12@bloglovin.com', 1, '+62 717 201 9285', 1, 'zweinberg12', 'd46c06b8455d14bb39c49b7d66916800', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (3, 'Véronique', 'Shewry', 'Bérengère', '19.08.1976', 'hshewry13@simplemachines.org', 0, '+63 203 847 9027', 1, 'hshewry13', '315dae2d0cdda8dc9b305b1de0a89d10', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (18, 'Maïté', 'Lovie', 'Maëlla', '24.11.1972', 'clovie14@photobucket.com', 0, '+51 865 935 9156', 1, 'blovie14', 'aee58950b076d834a3a7bbb0bacd87cc', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Lucrèce', 'Millis', 'Andréanne', '06.12.1981', 'mmillis15@vimeo.com', 1, '+689 577 282 1485', 0, 'cmillis15', '3599396bdfc9a3101ca1c5580a2c24da', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (14, 'Mélia', 'Van der Hoeven', 'Andréa', '22.03.1989', 'lvanderhoeven16@washington.edu', 0, '+86 358 893 8443', 0, 'svanderhoeven16', 'f5657ff73dec322536f3809cd1445c76', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (2, 'Yénora', 'Privett', 'Måns', '07.01.1991', 'lprivett17@tamu.edu', 1, '+55 696 447 3963', 1, 'hprivett17', '90cecb27c4093edb36a13f43b448c881', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (2, 'Måns', 'Scown', 'Noëlla', '09.02.1989', 'escown18@biglobe.ne.jp', 0, '+55 174 534 9068', 1, 'jscown18', '12429bf6c525d5c51cbb02c26e15175b', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (23, 'Frédérique', 'Ecclesall', 'Gisèle', '16.08.1991', 'decclesall19@umn.edu', 1, '+63 874 550 0231', 0, 'recclesall19', 'f69b96a9b5486c6679156df0a67980d0', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Maëlle', 'Brahm', 'Maëline', '31.08.1991', 'gbrahm1a@issuu.com', 0, '+62 640 584 5352', 0, 'hbrahm1a', '47acc3878e52f106b77dcd912ec6e645', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (4, 'Simplifiés', 'Tharme', 'Lén', '21.04.1978', 'htharme1b@last.fm', 0, '+593 533 431 2933', 1, 'ltharme1b', 'a6e59d843c7b185f2818df97c58484e9', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (10, 'Adélaïde', 'Ruffle', 'Lóng', '23.10.1976', 'iruffle1c@guardian.co.uk', 1, '+86 957 547 0935', 0, 'pruffle1c', '429c3284075ae664a716089858233590', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (15, 'Méghane', 'Andrzejczak', 'Åslög', '01.11.1960', 'candrzejczak1d@gov.uk', 0, '+33 361 499 8461', 1, 'pandrzejczak1d', '3698050bd198124d82b9eb36d3764e97', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (17, 'Bérengère', 'Serginson', 'Mà', '04.11.1990', 'hserginson1e@paginegialle.it', 1, '+234 675 375 2745', 0, 'jserginson1e', 'cc56926f567e83651dc7f48e5a96e338', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (12, 'Naëlle', 'Wiltshier', 'Cécilia', '06.07.1964', 'awiltshier1f@state.gov', 0, '+86 489 841 0429', 0, 'mwiltshier1f', '9805d7c62c1825f6e676cce63a29cdb7', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (16, 'Pål', 'Springtorp', 'Gaëlle', '22.10.1968', 'vspringtorp1g@ebay.com', 1, '+47 963 338 4042', 1, 'nspringtorp1g', 'f9816937245002ac74d3bbe94a33f933', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (11, 'Béatrice', 'Rau', 'Véronique', '14.10.1982', 'drau1h@chronoengine.com', 0, '+46 867 606 1911', 1, 'zrau1h', 'b2477f2abe197974a21bebd27b2c7fca', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (22, 'Maëlys', 'Cassam', 'Simplifiés', '19.03.1961', 'ycassam1i@apple.com', 0, '+86 676 180 9003', 1, 'scassam1i', '088f5c17cb5171102b2777317d387c85', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (3, 'Mégane', 'Dummett', 'Åke', '05.07.1987', 'ldummett1j@bizjournals.com', 1, '+86 725 616 4349', 0, 'jdummett1j', 'beefd9cbaecf5df4f68007cc4cd5463c', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (4, 'Tán', 'Hearnah', 'Dafnée', '16.06.1998', 'ahearnah1k@shop-pro.jp', 0, '+62 749 983 4511', 1, 'nhearnah1k', 'c030cebaec13cb53cc36801b0c0ef7f0', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Lauréna', 'Asel', 'Maï', '13.07.1970', 'casel1l@marketwatch.com', 0, '+55 117 888 3511', 0, 'yasel1l', 'cb1aa3217202d68153bf5c3dcb7b8411', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (15, 'Torbjörn', 'Werrett', 'Clémentine', '31.03.2002', 'ywerrett1m@istockphoto.com', 1, '+55 387 851 8682', 1, 'kwerrett1m', '20ca8900acfdde2007c8f8f9e13693fd', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (26, 'Maëlann', 'Vella', 'Céline', '02.03.1988', 'cvella1n@youku.com', 0, '+86 950 364 0288', 0, 'avella1n', 'c67c7f3861d645faaa1fbefc0435ffa5', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Styrbjörn', 'Turland', 'Mylène', '26.03.1977', 'cturland1o@w3.org', 0, '+55 722 860 6841', 0, 'eturland1o', '460d97c64e809af7da7406f88ce8f092', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (27, 'Clémence', 'Boncore', 'Kévina', '20.02.1968', 'bboncore1p@miitbeian.gov.cn', 0, '+358 820 208 7633', 0, 'kboncore1p', 'a9b1b72e876e593ebea9aba800142a7b', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (29, 'Maïlis', 'Corney', 'Bérengère', '11.04.1985', 'ecorney1q@webs.com', 1, '+86 745 249 3653', 0, 'mcorney1q', '03fcf93970e9d5d609ff782185035b5d', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Naëlle', 'Pindar', 'Marie-françoise', '17.07.1988', 'cpindar1r@elpais.com', 0, '+51 800 345 0236', 1, 'npindar1r', 'ac52389cafb590f9d777647871d99c07', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Laïla', 'Tomaschke', 'Vénus', '24.05.1971', 'jtomaschke1s@paypal.com', 0, '+51 724 359 3570', 1, 'dtomaschke1s', 'c334e2e15ac0474ee9f1790c22e96d1f', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (4, 'Yóu', 'Bafford', 'Eloïse', '28.07.2000', 'mbafford1t@linkedin.com', 0, '+86 412 442 6465', 1, 'dbafford1t', '8a6d18ebbcac8faf18efb8bf1e2cd671', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (4, 'Yáo', 'Tennick', 'Clélia', '05.06.2000', 'ltennick1u@reference.com', 1, '+33 892 301 8386', 0, 'stennick1u', '5de2167ccd7be8c3d9db4e0bef6a51b0', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (27, 'Erwéi', 'Bulgen', 'Yè', '08.12.1992', 'ebulgen1v@hexun.com', 1, '+62 549 865 3694', 1, 'cbulgen1v', '3d5b5643f972b8f3d1491d48b5b6b63c', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (26, 'Liè', 'Chezelle', 'Ráo', '28.02.1977', 'vchezelle1w@who.int', 1, '+63 892 492 1114', 1, 'ochezelle1w', '3bd89516bd97fee36f3a790f60a6547e', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Lèi', 'Matzaitis', 'Cécile', '30.11.1975', 'bmatzaitis1x@uiuc.edu', 1, '+49 704 186 3089', 1, 'nmatzaitis1x', 'dd2aead8bf1c4a83320eddbed82b8630', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (9, 'Inès', 'Macilhench', 'Garçon', '25.10.1969', 'amacilhench1y@va.gov', 1, '+47 171 203 6522', 0, 'mmacilhench1y', 'f4ffb6b08860cdbad5b2146cd15b3801', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Yáo', 'MacCague', 'Inès', '31.01.1965', 'amaccague1z@ustream.tv', 1, '+504 236 609 8440', 0, 'hmaccague1z', 'f2c53dbd7bb9761ef2dcd392880dec83', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (22, 'Réjane', 'Mauro', 'Cécile', '15.10.1977', 'dmauro20@wp.com', 1, '+57 635 816 4048', 1, 'bmauro20', '8e24642159145e003d0ae29e31ee67ed', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Chloé', 'Avery', 'Crééz', '22.06.1976', 'savery21@miibeian.gov.cn', 0, '+46 312 731 7334', 0, 'favery21', 'b6157f6e541576954159fef80376e4fb', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (16, 'Marylène', 'Greguol', 'Céline', '20.03.1978', 'tgreguol22@whitehouse.gov', 1, '+33 630 150 7719', 0, 'jgreguol22', 'c454ea87885b088dc544b241859bc82e', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (1, 'Cunégonde', 'Allanson', 'Adèle', '22.09.1966', 'fallanson23@yelp.com', 1, '+33 343 528 8561', 0, 'hallanson23', '318b82dc836591b8ad9b537c673f3360', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (13, 'Bécassine', 'Kliemchen', 'Marlène', '14.02.1978', 'dkliemchen24@canalblog.com', 1, '+212 576 301 1501', 1, 'gkliemchen24', '6bd9cc9a4938c9e5843fd44d29c1b3dd', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (20, 'Naëlle', 'Clutterham', 'Valérie', '09.09.2000', 'mclutterham25@wikipedia.org', 1, '+55 892 678 0466', 0, 'mclutterham25', '521eba5a039b665f5b09aac8d8928704', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Yénora', 'Burnapp', 'Eugénie', '27.10.1990', 'dburnapp26@instagram.com', 1, '+86 186 217 9444', 0, 'aburnapp26', '8b994e94a8101d7a775edf027b6f2b90', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Daphnée', 'Filipson', 'Dorothée', '14.10.1968', 'pfilipson27@mediafire.com', 1, '+51 750 211 5235', 1, 'dfilipson27', 'd716cce33a3a5e672d3069f786f1bdec', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (25, 'Maëlyss', 'Gwilt', 'Mélinda', '18.10.1977', 'jgwilt28@sakura.ne.jp', 0, '+62 644 456 5050', 0, 'fgwilt28', 'cec271bea4e60534505dfe81e7a4c2eb', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (28, 'Desirée', 'Dallender', 'Méline', '11.06.1960', 'bdallender29@redcross.org', 1, '+86 769 405 2197', 0, 'sdallender29', '1e5b59ff711d11677a2c06aff940bffd', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (3, 'Ophélie', 'Cousins', 'Irène', '24.11.1962', 'acousins2a@skyrock.com', 0, '+504 496 625 2173', 1, 'wcousins2a', 'af2cb5d28a381bb54ff6a6fffdcc1c17', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (19, 'Ruò', 'Buxton', 'Méryl', '24.02.1991', 'abuxton2b@cyberchimps.com', 1, '+420 851 358 3740', 1, 'jbuxton2b', '44191b5106ac71a781df4f9742693c1f', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (21, 'Håkan', 'Lightowler', 'Mélia', '10.08.1978', 'mlightowler2c@baidu.com', 0, '+62 930 907 4708', 1, 'clightowler2c', 'ff798a3cb1d409c9285aee99ca376140', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Publicité', 'Tilson', 'Maëline', '28.03.1997', 'mtilson2d@redcross.org', 0, '+66 786 495 4120', 1, 'otilson2d', 'e38e4434c159481c2846179e71e66827', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (17, 'Néhémie', 'Kerbey', 'Lyséa', '19.12.1991', 'jkerbey2e@oracle.com', 1, '+266 618 259 6068', 0, 'lkerbey2e', '980047274da9c9ea72dbacd1441354d8', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (30, 'Eloïse', 'Batrick', 'Esbjörn', '16.07.1980', 'jbatrick2f@feedburner.com', 0, '+263 500 908 3433', 0, 'tbatrick2f', '8b8f654adf58d5e1ddad9e1bec07b9c3', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Marie-hélène', 'Brasner', 'Pò', '22.04.1993', 'kbrasner2g@alibaba.com', 0, '+52 638 272 7113', 1, 'gbrasner2g', 'c854b3d482c5b861b980b309922b5ec7', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Thérèsa', 'Wick', 'Maëlyss', '22.08.1990', 'jwick2h@pbs.org', 0, '+86 327 411 5519', 0, 'mwick2h', '421801cf886a81a72d79e751d2f59054', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Léonore', 'Quinane', 'Géraldine', '25.07.1981', 'squinane2i@japanpost.jp', 0, '+48 196 811 5432', 0, 'cquinane2i', '3a012fb6174e28d86f4a9161c29764ef', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (4, 'Gisèle', 'Peacham', 'Vérane', '13.11.1996', 'cpeacham2j@google.pl', 0, '+63 271 725 6141', 1, 'kpeacham2j', '5ad9c4f32f502be71da3a374f10a9a78', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (13, 'Torbjörn', 'Pilger', 'Naëlle', '05.03.1982', 'apilger2k@cam.ac.uk', 0, '+49 604 120 7776', 0, 'rpilger2k', 'c77643c22160ec8ec1526a27213405cc', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Dù', 'Osler', 'Yóu', '14.02.1980', 'rosler2l@state.tx.us', 0, '+54 884 871 0202', 1, 'mosler2l', 'd6ab883ee39385a4e0f0374106f4a624', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Réservés', 'Hayhow', 'Gisèle', '14.06.1992', 'bhayhow2m@51.la', 1, '+7 827 941 9673', 1, 'ghayhow2m', '5d698bcc88a745afe2ab44c490a4584f', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (4, 'Mélina', 'Leggatt', 'Anaël', '15.10.1972', 'rleggatt2n@e-recht24.de', 0, '+216 117 369 3615', 0, 'rleggatt2n', 'dc36c0bb101f97acd85c937da6363723', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Maïwenn', 'Attarge', 'Anaël', '30.10.1988', 'lattarge2o@xrea.com', 0, '+48 588 157 5703', 0, 'sattarge2o', 'ceba7cab34a2bff0483140e07d16afec', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (4, 'Dà', 'McIlhatton', 'Marylène', '18.11.1992', 'gmcilhatton2p@princeton.edu', 0, '+62 427 845 6904', 0, 'gmcilhatton2p', '7e6153f2e873d336109050872a1e73ee', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Renée', 'Lahrs', 'Renée', '12.04.1963', 'mlahrs2q@csmonitor.com', 1, '+86 955 657 6807', 0, 'clahrs2q', 'd256e033b406877a5e7e08db17fade9a', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Geneviève', 'Sandercroft', 'Östen', '05.03.1978', 'lsandercroft2r@sfgate.com', 1, '+86 623 831 7242', 1, 'dsandercroft2r', 'd3b4c61439d785aef6347b9d9ef27da1', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (13, 'Irène', 'Yanin', 'Örjan', '18.09.1968', 'uyanin2s@redcross.org', 0, '+351 594 603 8229', 0, 'wyanin2s', 'ee711115859146c26d9ecd4cb8aee9c1', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (19, 'Marie-thérèse', 'Haire', 'Alizée', '05.12.1975', 'rhaire2t@aol.com', 0, '+46 409 751 4229', 1, 'hhaire2t', 'aba93a77ef4d3493c7a2699f19324591', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (9, 'Camélia', 'Rowston', 'Mélia', '29.11.1985', 'growston2u@salon.com', 1, '+98 906 592 4166', 1, 'rrowston2u', '4ad1945ff2d04c8c58c15db0c3dfa4b6', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (12, 'Méng', 'Kilbee', 'Hélèna', '07.04.1974', 'skilbee2v@icio.us', 0, '+54 486 584 1026', 0, 'wkilbee2v', '782d5dfcd8d92debdfcd6dcd0ec37d1e', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Nélie', 'Barukh', 'Thérèse', '18.05.1984', 'ebarukh2w@wp.com', 0, '+504 547 792 5141', 0, 'mbarukh2w', '69053c7e678bf4651698a20bd43033b6', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (1, 'Göran', 'Gosson', 'Gösta', '25.06.1964', 'egosson2x@wikipedia.org', 0, '+55 543 911 9654', 1, 'ggosson2x', 'ed26a0a49c59201c3c742476c55e2c67', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (25, 'Méline', 'Puttnam', 'Lén', '17.10.1971', 'cputtnam2y@gmpg.org', 1, '+81 676 953 1050', 1, 'pputtnam2y', '2cd214f5489c1bfbd52ba5bb16941819', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (5, 'Célestine', 'Fathers', 'Angèle', '13.11.1976', 'jfathers2z@wordpress.com', 0, '+55 124 231 2723', 1, 'dfathers2z', 'b7b7cc91c9fc84695e2f25bc729b682f', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (8, 'Célestine', 'Nappin', 'Clélia', '27.05.2000', 'dnappin30@hatena.ne.jp', 1, '+86 896 419 7652', 0, 'mnappin30', '5d5af1fd37cc9b2fbacabd986c7ddf5e', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (10, 'Hélèna', 'De Biasio', 'Josée', '25.01.1994', 'mdebiasio31@wufoo.com', 1, '+62 380 782 1083', 0, 'jdebiasio31', 'a30172f755c1865e864bcb595845bb67', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (29, 'Judicaël', 'Falcus', 'Thérèse', '23.04.1971', 'sfalcus32@drupal.org', 0, '+351 885 762 1759', 0, 'cfalcus32', 'a7650dcc9cc535632b51471437689be9', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Lorène', 'Sheather', 'Annotée', '20.10.1983', 'isheather33@youku.com', 0, '+63 138 357 7483', 0, 'csheather33', 'b01c8aef28dfc59f4548dae8d050f480', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (9, 'Eugénie', 'Braunston', 'Zoé', '02.09.1984', 'nbraunston34@youku.com', 1, '+81 261 928 8203', 0, 'rbraunston34', '573a479103a1c848afc5f938b4433577', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (6, 'André', 'Hagstone', 'Léonie', '06.08.1965', 'thagstone35@comcast.net', 0, '+232 807 411 3983', 0, 'vhagstone35', '7ff23bd24e231c5091912035946cc2c9', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Maëlys', 'Whatsize', 'Gaétane', '05.10.1965', 'hwhatsize36@canalblog.com', 1, '+62 104 701 5878', 0, 'awhatsize36', '33e88bb8bb0eb9e05d7dfb77740a3cd8', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (1, 'Geneviève', 'Cully', 'Eugénie', '01.12.1985', 'ecully37@hhs.gov', 1, '+242 783 641 1894', 0, 'ecully37', '0aa5f8db96f6dbe6b4aa659cb20c4f8f', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (12, 'Måns', 'McCulloch', 'Håkan', '03.04.1982', 'smcculloch38@cmu.edu', 1, '+66 485 486 1186', 1, 'cmcculloch38', 'eb8a68eaa0553a2564df45f2e0979be6', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (7, 'Pénélope', 'Brachell', 'Océanne', '04.02.1963', 'bbrachell39@walmart.com', 1, '+86 751 813 2690', 0, 'tbrachell39', '66b568b8e939300dbce9315786f81bce', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Eugénie', 'Cowhig', 'Daphnée', '26.11.2002', 'kcowhig3a@upenn.edu', 0, '+86 252 172 6645', 0, 'ccowhig3a', '7f64ffd781a7f9a14f49835d07ffdc8f', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (11, 'Maéna', 'O''Bradane', 'Léandre', '10.07.1964', 'lobradane3b@wp.com', 1, '+62 475 761 8822', 1, 'eobradane3b', '52384461de1fd2a6757cacd8551aa175', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (18, 'Simplifiés', 'Kahen', 'Aloïs', '28.05.1992', 'vkahen3c@parallels.com', 1, '+86 241 145 5141', 0, 'nkahen3c', 'bf5c9758bef337939c30509ae56a7dd3', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (19, 'Bérangère', 'Kaminski', 'Andréanne', '20.10.2000', 'rkaminski3d@rambler.ru', 0, '+385 999 229 8637', 1, 'nkaminski3d', '4bd07898566d12f47ba30439b7a61680', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (19, 'Mélina', 'Caukill', 'Lauréna', '22.09.1983', 'gcaukill3e@google.de', 1, '+86 724 838 5210', 0, 'acaukill3e', 'db77a097e8b41d35242a6a0596494078', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (17, 'Andréanne', 'Vogl', 'Bécassine', '31.03.1974', 'lvogl3f@studiopress.com', 1, '+56 252 406 8327', 0, 'svogl3f', 'ea822793967e13e2dca1d9d9f8003814', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (11, 'Desirée', 'Filchagin', 'Camélia', '16.12.1960', 'nfilchagin3g@mashable.com', 1, '+63 552 393 8829', 1, 'bfilchagin3g', '0c2b4d4d9f95dcea91d2ed87d51a5abd', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (1, 'Thérèsa', 'Boffin', 'Adélie', '27.08.1973', 'bboffin3h@fc2.com', 1, '+358 601 371 3712', 1, 'vboffin3h', 'db7d20b56123d39218432bdf527fa676', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (16, 'Lucrèce', 'Royal', 'Frédérique', '28.08.1972', 'croyal3i@dell.com', 0, '+54 484 497 6495', 1, 'droyal3i', 'ec4636a3bb3b075b93cecd171f37b57a', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (6, 'Méghane', 'Delete', 'Illustrée', '12.07.1986', 'ydelete3j@ucsd.edu', 0, '+33 102 490 2450', 0, 'bdelete3j', 'f5084e4c448966d3bda0c030cba1328d', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Léana', 'MacLise', 'Audréanne', '06.01.1998', 'emaclise3k@admin.ch', 0, '+7 715 267 7355', 1, 'mmaclise3k', '45582ee942a8147eb26841f41a901140', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Loïc', 'Craske', 'Lorène', '31.12.1966', 'ccraske3l@t-online.de', 0, '+86 592 727 2457', 0, 'ocraske3l', '58cf1965d7b8dc971f918805072bf6a3', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (22, 'Marie-ève', 'Evelyn', 'Håkan', '26.01.1969', 'gevelyn3m@ihg.com', 0, '+63 173 725 4323', 1, 'levelyn3m', 'cb99a930ac34fddd87333694479d9b14', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Léa', 'Burkert', 'Aí', '29.04.1971', 'cburkert3n@illinois.edu', 0, '+54 270 708 7706', 0, 'eburkert3n', '787231e8f570f131472e71a4dfa83bcd', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (12, 'Laïla', 'Abercrombie', 'Mårten', '30.08.2001', 'rabercrombie3o@lulu.com', 1, '+62 984 632 7225', 1, 'oabercrombie3o', '8e94b5e1d3e46f5e3987ed3ed916add1', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (27, 'André', 'Parrish', 'Rébecca', '08.09.1983', 'mparrish3p@alexa.com', 0, '+81 729 593 4923', 0, 'aparrish3p', 'b3fd6e775f90e17ad1db37e9428a71f6', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Stévina', 'Newall', 'Anaëlle', '25.08.1980', 'fnewall3q@so-net.ne.jp', 0, '+86 989 626 9919', 0, 'snewall3q', '1a49bbf501108593d7d09c6653533d12', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (12, 'Aí', 'McFee', 'Hélèna', '19.04.1976', 'gmcfee3r@friendfeed.com', 0, '+49 489 114 0994', 0, 'jmcfee3r', '5e27ec174717683fab36cfe1c3896cf5', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (5, 'Célia', 'Geerling', 'Régine', '25.09.1987', 'fgeerling3s@jimdo.com', 1, '+62 440 315 7744', 1, 'cgeerling3s', '5eb7e034fc4e60afb0073c8e9e4cea78', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (26, 'Joséphine', 'Pretor', 'Almérinda', '22.04.1971', 'cpretor3t@etsy.com', 0, '+63 129 246 0582', 0, 'rpretor3t', 'd1bd18021b01c353f99f56b65da55b3b', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (16, 'Loïs', 'Sandes', 'Erwéi', '21.06.1978', 'csandes3u@howstuffworks.com', 1, '+57 992 811 3691', 0, 'bsandes3u', '50266f678eb0bc8bc6b3b3b3167e343d', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Wá', 'Crombie', 'Zhì', '02.09.1975', 'ccrombie3v@oracle.com', 0, '+380 285 196 2605', 1, 'ccrombie3v', '73a3dd45b7f109d31bf8699d74e96f48', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (14, 'Annotée', 'Keilty', 'Nuó', '27.02.1991', 'skeilty3w@bbb.org', 0, '+375 935 866 0901', 0, 'akeilty3w', '8180e70f027c3e45a7967dd2ca587432', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Sélène', 'Willoway', 'Gaïa', '06.11.1977', 'dwilloway3x@desdev.cn', 1, '+382 725 561 2182', 1, 'kwilloway3x', '7d218e1db1587c62b07e38e9872e4280', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (9, 'Angèle', 'Redpath', 'Mårten', '28.02.1989', 'eredpath3y@livejournal.com', 1, '+31 788 349 4923', 1, 'eredpath3y', '8d941a31c71897df94553d29adc0a4a7', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (10, 'Noëlla', 'Childe', 'Mélanie', '14.08.1973', 'mchilde3z@comsenz.com', 1, '+81 735 766 0706', 0, 'cchilde3z', '0770f991e1d420b710f645e4c5e56d51', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (15, 'Maëline', 'Jenkyn', 'Eugénie', '02.10.1971', 'xjenkyn40@globo.com', 1, '+51 918 249 4253', 1, 'kjenkyn40', 'b5bff28d39da6875786cb8f33508e6af', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Bénédicte', 'De Beauchamp', 'Thérèsa', '21.01.1977', 'fdebeauchamp41@blogger.com', 0, '+63 885 550 6597', 0, 'sdebeauchamp41', 'f9f5d97cebe082f909eee817f9aac0ed', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (28, 'Océanne', 'Carder', 'Vérane', '16.04.1969', 'acarder42@census.gov', 0, '+258 190 386 6221', 0, 'tcarder42', 'ccc3f13ba025b037b9982fc922cb5f05', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (24, 'Zhì', 'Ewebank', 'Anaé', '11.07.1978', 'kewebank43@dell.com', 1, '+31 564 241 1075', 0, 'pewebank43', '1ed20f62c6259a65faa92418e1e92616', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Vénus', 'Antonognoli', 'Miléna', '15.11.1986', 'aantonognoli44@goo.gl', 0, '+46 413 718 9564', 0, 'aantonognoli44', 'd4464af65106f4bd1b0b2045711e14d7', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (10, 'Stévina', 'Yearnsley', 'Dù', '19.02.1962', 'syearnsley45@foxnews.com', 0, '+7 867 731 0918', 0, 'byearnsley45', '2aa893bb9d0c75af0e6fff84f6ea039c', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (10, 'Nélie', 'Charrington', 'Méline', '02.02.1985', 'mcharrington46@twitpic.com', 1, '+86 642 421 4669', 1, 'hcharrington46', '465a7a6e47f798394b6cf56f2346fc8d', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (19, 'Anaëlle', 'Coldtart', 'Personnalisée', '10.03.1992', 'dcoldtart47@i2i.jp', 0, '+55 676 409 5739', 1, 'gcoldtart47', 'a1e71a56dcd8f2350670b0a72fbd4357', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (1, 'André', 'Skase', 'Bérengère', '17.02.1987', 'lskase48@example.com', 1, '+86 418 970 8534', 0, 'gskase48', '00c04bbbaa9bb64a67dc9d9e39291a6e', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (27, 'Estée', 'Slograve', 'Daphnée', '11.04.1986', 'eslograve49@altervista.org', 1, '+86 856 145 3876', 1, 'jslograve49', '56906105c3e1022dbfce370217ed025f', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (5, 'Åsa', 'Benit', 'Marie-hélène', '22.12.1967', 'abenit4a@etsy.com', 1, '+86 359 352 1143', 1, 'lbenit4a', '852601250406587136a603ee84049b99', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Océanne', 'Copplestone', 'Céline', '06.11.1977', 'ccopplestone4b@europa.eu', 1, '+63 447 219 3757', 0, 'bcopplestone4b', '6076a3e800066c5acacfca0b55255125', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (19, 'Léandre', 'Bonnett', 'Renée', '11.11.1960', 'jbonnett4c@shutterfly.com', 0, '+86 716 846 7871', 0, 'fbonnett4c', 'cd4232cc96d088fce489fcbf1e1d30a7', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Mélissandre', 'Helsdon', 'Marie-josée', '23.04.1985', 'dhelsdon4d@squidoo.com', 0, '+86 880 345 8192', 0, 'shelsdon4d', 'c901119a2c786a715b5ecc2819d923c2', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Eliès', 'Labba', 'Örjan', '16.03.1972', 'flabba4e@mediafire.com', 0, '+51 526 475 3091', 1, 'slabba4e', '47c51e09d267329c38fddc3f258955e9', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Nadège', 'Tetla', 'Estée', '08.03.1990', 'rtetla4f@redcross.org', 0, '+385 893 908 9126', 1, 'etetla4f', '8761b094e748b9d8f70b87d4edb8829b', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Maëly', 'Rouf', 'Océanne', '06.02.2002', 'brouf4g@msn.com', 0, '+55 428 107 9784', 1, 'srouf4g', 'e98e2607e096282f85e92b7ee9c9c744', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Miléna', 'Fenna', 'Marie-noël', '10.02.1971', 'cfenna4h@mlb.com', 1, '+420 243 181 6461', 0, 'efenna4h', 'e8ccb482815379af32b71720c2d674b7', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Aí', 'Haining', 'Lucrèce', '01.11.1997', 'thaining4i@npr.org', 1, '+86 241 989 6401', 1, 'khaining4i', 'f205a7f881b3690d7178517c81bf1372', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (5, 'Anaïs', 'Verbruggen', 'Maï', '17.01.1977', 'vverbruggen4j@php.net', 0, '+54 253 616 4719', 1, 'tverbruggen4j', '2db523f2c433f35adcdc76ee8204af2b', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (21, 'Hélèna', 'Hek', 'Rébecca', '01.05.1968', 'khek4k@is.gd', 0, '+595 707 278 7146', 0, 'yhek4k', 'dbb234fb1dedd7658df01c7643d9b379', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (30, 'Maëline', 'Brand-Hardy', 'Chloé', '03.04.1960', 'mbrandhardy4l@ucla.edu', 1, '+62 131 872 5502', 1, 'cbrandhardy4l', 'a34bbe75037836732fbec0b308a223f4', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (10, 'Maëlla', 'Sancroft', 'Alizée', '20.01.1996', 'ssancroft4m@mail.ru', 1, '+351 215 964 2885', 1, 'bsancroft4m', 'e9bb4ebee509b938fc611dfb2086015b', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (27, 'Annotée', 'Line', 'Michèle', '05.09.1982', 'mline4n@whitehouse.gov', 0, '+46 913 521 5684', 0, 'bline4n', '9be807d012a7c49c4f5dd3fbe2e0fbea', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (13, 'Loïca', 'Charlo', 'Marie-ève', '07.06.1964', 'lcharlo4o@about.com', 1, '+962 380 245 5123', 1, 'tcharlo4o', '12ff95c8c81b657cfa8b6a22aac956b1', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (20, 'Yénora', 'Mustoo', 'Loïc', '23.10.1975', 'ymustoo4p@shinystat.com', 0, '+86 365 468 9181', 1, 'gmustoo4p', 'dc5b47e95a92c2f3d483652dc327af22', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (20, 'Åslög', 'Gratland', 'Mélodie', '27.12.1975', 'jgratland4q@unblog.fr', 1, '+48 491 390 1172', 0, 'tgratland4q', '187926c2c4d3edbe5dfb2c7a9ce44112', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Faîtes', 'Cowderoy', 'Yóu', '05.08.1975', 'kcowderoy4r@mayoclinic.com', 1, '+351 283 466 9024', 0, 'jcowderoy4r', '2fc429e5d1b5ef4a46f9f6f336f9e089', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Garçon', 'Dilleway', 'Aí', '17.09.2002', 'kdilleway4s@businesswire.com', 1, '+54 902 944 7034', 0, 'fdilleway4s', '5e1bc1c08e5fadcd3cf5f594855be3c8', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (10, 'Wá', 'Fresson', 'Célestine', '20.04.1999', 'rfresson4t@constantcontact.com', 0, '+63 980 224 9966', 0, 'sfresson4t', 'b154af3f9074644a353218f7924dcad4', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (13, 'Miléna', 'Franks', 'Östen', '16.02.1978', 'hfranks4u@furl.net', 0, '+55 438 942 1989', 1, 'dfranks4u', 'c0f7470e9f8beb56431cdc4eeadc8969', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (26, 'Börje', 'Beckensall', 'Eloïse', '18.05.1960', 'hbeckensall4v@bizjournals.com', 1, '+86 299 752 3397', 1, 'pbeckensall4v', '527b22f44ec6c33f388f04f0335d72d4', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (20, 'Anaël', 'Perocci', 'Fèi', '18.04.1985', 'rperocci4w@intel.com', 1, '+86 346 630 4521', 0, 'pperocci4w', 'd206bcc56343ccd56a6c0c252df8dddd', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (17, 'Laurène', 'Wadeling', 'Daphnée', '12.05.1993', 'awadeling4x@addtoany.com', 0, '+62 761 163 8073', 1, 'kwadeling4x', '0f690c1c3e6c8b2294caf846f4effc06', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (5, 'Örjan', 'McCosker', 'Ráo', '09.04.1965', 'fmccosker4y@themeforest.net', 0, '+976 960 141 6704', 0, 'lmccosker4y', 'f6133774d89a4dc559ecdb96b0a06756', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (22, 'Ráo', 'Mayo', 'Eloïse', '28.12.1982', 'jmayo4z@dailymail.co.uk', 0, '+372 306 183 9557', 0, 'amayo4z', 'b1538ad14db47296cb16479fbcf6955b', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Eléonore', 'Nesby', 'Béatrice', '02.02.1966', 'cnesby50@cnet.com', 0, '+420 809 196 8605', 0, 'dnesby50', 'ec2b54c5433fad5e2bef772378dd5a28', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (5, 'Mélys', 'Fazakerley', 'Gaïa', '22.01.1961', 'cfazakerley51@abc.net.au', 0, '+86 896 510 2624', 1, 'cfazakerley51', '7e780b865bdfc6065b7fad1bbcfb3809', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (25, 'Léonore', 'Kinrade', 'Eléa', '25.11.1987', 'ckinrade52@answers.com', 1, '+62 602 644 1179', 1, 'akinrade52', '0c16bac6b385a8729f1e0b0255be8a2c', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Loïs', 'Eacott', 'Illustrée', '08.02.1981', 'eeacott53@apple.com', 1, '+86 382 717 8317', 1, 'reacott53', '138ef902ab9118e0c05e7490f32cba90', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (22, 'Daphnée', 'Billin', 'Léandre', '14.09.1981', 'gbillin54@cdbaby.com', 0, '+63 921 609 2108', 1, 'sbillin54', '24e8c9114941856dd553455f66bccc64', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (25, 'Åslög', 'Challes', 'Méghane', '26.01.1985', 'cchalles55@printfriendly.com', 0, '+234 412 664 8349', 0, 'dchalles55', '157e2ae5661a537332128e62411e24c2', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (30, 'Lucrèce', 'Garfit', 'Clémentine', '10.08.1962', 'ggarfit56@deliciousdays.com', 0, '+33 859 579 9268', 0, 'rgarfit56', '8faea325ae20874272ba2c98a5cecfa6', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (19, 'Renée', 'Feather', 'Ruì', '06.10.1992', 'bfeather57@who.int', 0, '+86 411 892 2343', 0, 'gfeather57', '1c9e6c74214a6c50f5097e267006dce0', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (1, 'Björn', 'Kohn', 'Eugénie', '27.07.1963', 'rkohn58@google.it', 1, '+34 461 107 4349', 0, 'dkohn58', '22d935b454d6a46bc29dd8e5cc3a8331', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (2, 'Josée', 'Caley', 'Solène', '20.10.2001', 'acaley59@google.co.jp', 0, '+420 799 372 1614', 0, 'jcaley59', 'ddcd629baa845eb2abccaaa789d91236', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (20, 'Bécassine', 'Bolding', 'Maïly', '30.08.1981', 'abolding5a@forbes.com', 1, '+7 407 523 2677', 1, 'dbolding5a', 'e2efbc2e0699e520f19193bc9ae5b0ab', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (19, 'Styrbjörn', 'Fripps', 'Maëlys', '27.07.1986', 'efripps5b@cloudflare.com', 0, '+86 782 719 4925', 0, 'mfripps5b', '45926f3c90a18c01f876ee29cf3698b6', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (3, 'Geneviève', 'Medmore', 'Åke', '03.02.1965', 'emedmore5c@shop-pro.jp', 0, '+967 368 755 9188', 0, 'omedmore5c', 'a746fbf49a40b74acda3edf471b00313', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (18, 'Håkan', 'Barlass', 'Eléa', '09.10.1986', 'dbarlass5d@archive.org', 0, '+351 424 830 4002', 1, 'cbarlass5d', '9b058fb20afc25e57231ef108e752138', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Rébecca', 'Jendrys', 'Esbjörn', '17.04.2002', 'ljendrys5e@facebook.com', 0, '+970 249 853 8203', 1, 'mjendrys5e', '73051206986f23c5407414b0c6055c8e', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (3, 'Maïly', 'Kenion', 'Cinéma', '19.11.1999', 'bkenion5f@wufoo.com', 0, '+48 345 240 4924', 1, 'bkenion5f', 'a0b7bf12f0d1c3b50ada1350f4c5b1dd', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (24, 'Médiamass', 'Lachaize', 'Göran', '23.10.1994', 'rlachaize5g@nih.gov', 0, '+967 407 189 7762', 0, 'glachaize5g', '5a3a70f48af3609569dbd510be34c617', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (14, 'Séverine', 'Durrell', 'Maïlis', '20.10.1964', 'rdurrell5h@irs.gov', 0, '+86 130 772 8953', 0, 'ldurrell5h', '645b458b1676bdd9f08ccafe371b44fc', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Maëlyss', 'Dumbelton', 'Néhémie', '22.08.1960', 'wdumbelton5i@umn.edu', 1, '+7 569 850 5129', 0, 'wdumbelton5i', '77c73e5f6cf29bc804e2cee68c75badc', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (null, 'Edmée', 'Schultheiss', 'Néhémie', '26.09.1963', 'aschultheiss5j@arstechnica.com', 1, '+86 109 128 5144', 1, 'cschultheiss5j', '9705f68dc4740c16dd5ee3684d9f592c', 1);

-- StudentTests

INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (28, 9, 0, null, 0, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (96, 8, 1, 2, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (28, 9, 0, 82, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (87, 7, 0, 29, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (62, 12, 0, 87, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (84, 12, 0, 43, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (13, 6, 1, 37, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (34, 8, 0, 76, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (85, 4, 1, null, 0, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (15, 17, 1, 13, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (39, 9, 0, null, 0, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (85, 15, 1, 77, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (56, 3, 0, 54, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (38, 4, 1, 40, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (24, 10, 0, 36, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (34, 12, 0, 17, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (95, 11, 0, 43, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (66, 5, 1, 58, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (37, 8, 1, null, 0, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (80, 8, 1, 92, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (90, 2, 1, null, 0, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (46, 6, 0, 40, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (73, 3, 1, 10, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (4, 2, 0, 44, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (21, 2, 1, 6, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (3, 8, 1, 13, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (65, 13, 1, 88, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (80, 16, 0, 45, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (11, 16, 1, 36, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (74, 16, 1, 11, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (53, 8, 0, 22, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (53, 12, 0, 76, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (26, 16, 1, 55, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (73, 6, 0, 19, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (89, 9, 0, 46, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (7, 6, 0, 45, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (17, 17, 1, 99, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (57, 15, 1, 48, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (89, 19, 0, 77, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (67, 17, 0, null, 0, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (87, 16, 1, 79, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (90, 15, 1, 88, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (16, 6, 0, 30, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (33, 6, 0, null, 0, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (3, 1, 0, 84, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (7, 17, 0, null, 0, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (9, 9, 1, 79, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (10, 12, 1, 90, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (17, 16, 0, 81, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (70, 13, 1, 73, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (37, 18, 0, 78, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (95, 11, 0, null, 0, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (12, 16, 0, 77, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (65, 5, 0, 27, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (30, 18, 1, 80, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (4, 9, 1, 5, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (8, 16, 0, 64, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (7, 19, 1, 43, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (87, 12, 0, null, 0, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (30, 2, 1, null, 0, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (55, 19, 0, 90, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (16, 15, 0, null, 0, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (66, 17, 1, 66, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (24, 6, 1, 32, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (13, 1, 1, 47, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (66, 11, 1, null, 0, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (18, 3, 0, 68, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (99, 12, 0, 21, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (64, 1, 1, 23, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (71, 9, 0, 29, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (18, 14, 0, 17, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (82, 4, 1, 36, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (63, 19, 0, 18, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (39, 16, 1, 78, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (28, 16, 1, 15, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (71, 10, 0, 60, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (70, 13, 1, 72, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (78, 12, 1, 88, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (63, 4, 1, 77, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (2, 1, 0, 53, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (29, 18, 0, 14, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (85, 14, 1, 20, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (73, 7, 1, null, 0, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (84, 8, 0, null, 0, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (74, 16, 1, null, 0, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (39, 8, 0, null, 0, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (63, 16, 1, 87, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (72, 3, 0, null, 0, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (23, 13, 0, 47, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (3, 15, 0, 22, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (93, 10, 1, null, 0, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (78, 19, 1, null, 0, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (22, 10, 1, 74, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (95, 18, 0, 77, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (23, 2, 0, 23, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (79, 4, 0, 37, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (99, 10, 0, 99, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (6, 18, 1, 76, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (66, 5, 1, 41, 1, 1);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (68, 11, 1, 16, 1, 0);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsPassed, IsRemoved) VALUES (22, 10, 0, null, 0, 1);

-- Roles

INSERT INTO dbo.Roles (Name) VALUES ('Administrator'), ('Student'), ('Teacher');

-- UserRoles

INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (87, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (48, 1);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (18, 1);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (87, 1);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (91, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (72, 3);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (68, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (16, 3);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (47, 1);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (90, 1);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (85, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (78, 3);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (65, 3);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (51, 1);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (55, 1);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (95, 1);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (24, 3);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (61, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (34, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (30, 3);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (90, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (66, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (27, 3);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (24, 1);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (6, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (65, 1);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (62, 3);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (43, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (67, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (78, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (100, 1);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (31, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (58, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (74, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (19, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (85, 3);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (67, 1);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (50, 3);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (49, 3);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (43, 1);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (25, 3);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (63, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (40, 1);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (69, 1);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (35, 3);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (41, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (36, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (94, 1);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (95, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (81, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (51, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (43, 3);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (5, 3);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (75, 3);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (70, 3);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (72, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (47, 3);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (61, 3);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (21, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (89, 1);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (8, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (72, 1);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (99, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (94, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (23, 1);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (54, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (91, 3);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (25, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (57, 3);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (3, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (96, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (53, 3);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (17, 3);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (76, 3);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (55, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (75, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (80, 3);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (35, 2);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (63, 3);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (29, 1);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (16, 1);
INSERT INTO dbo.UserRoles (UserId, RoleId) VALUES (11, 3);

SET NOCOUNT OFF;
GO
