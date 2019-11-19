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
UserId INT NOT NULL,
 TestId INT NOT NULL,
 AllowToPass BIT NOT NULL CONSTRAINT DFT_StudentTests_AllowToPass DEFAULT(0),
 /* Percent correct answers */
 PCA FLOAT NOT NULL,
 IsRemoved BIT NOT NULL CONSTRAINT DFT_StudentTests_IsRemoved DEFAULT(0),
 CONSTRAINT PK_StudentTests PRIMARY KEY(RecordId),
 CONSTRAINT FK_StudentTests_UserId FOREIGN KEY(UserId) REFERENCES dbo.Users(UserId),
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

-- Users

INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (22, 'Eliès', 'Melior', 'Dà', '25.09.2002', 'dmelior0@over-blog.com', 0, '+55 676 302 3357', 0, 'mmelior0', '5Rfcnj0Q', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (3, 'Örjan', 'Hoffmann', 'Daphnée', '24.10.1995', 'qhoffmann1@thetimes.co.uk', 1, '+386 384 412 1522', 1, 'rhoffmann1', '7d4Mvy', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (4, 'Véronique', 'Tyre', 'Maïly', '15.03.1965', 'styre2@digg.com', 1, '+63 617 164 2676', 1, 'atyre2', 'MwAqCkXs', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (6, 'Gösta', 'Dottridge', 'Marie-françoise', '13.10.1994', 'sdottridge3@aol.com', 1, '+62 342 899 1463', 1, 'bdottridge3', '8BoOOMumNVz', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (13, 'Ophélie', 'Quincee', 'Gaïa', '06.11.1972', 'gquincee4@usnews.com', 1, '+224 559 845 1511', 1, 'cquincee4', 'ofgaeVx', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (25, 'Maïté', 'Moloney', 'Danièle', '17.06.1982', 'imoloney5@google.es', 1, '+33 162 294 1228', 1, 'rmoloney5', '7W3o1Ms8Zd', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (24, 'Mélina', 'Wilcockes', 'Lucrèce', '19.06.1978', 'rwilcockes6@nsw.gov.au', 0, '+47 153 850 3056', 0, 'lwilcockes6', 'i6yNDfk', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (22, 'Agnès', 'Garriock', 'Ráo', '11.01.1980', 'tgarriock7@bbc.co.uk', 1, '+86 947 985 4042', 1, 'cgarriock7', 'CTi6WGkMtqva', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (4, 'Simplifiés', 'Abercromby', 'Görel', '18.10.1962', 'labercromby8@nifty.com', 0, '+62 677 134 9399', 0, 'dabercromby8', 'K7vUUG', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (30, 'Anaïs', 'Lamming', 'Réservés', '28.05.1983', 'dlamming9@zdnet.com', 0, '+57 476 505 4727', 0, 'dlamming9', 'IYjv6tEEB', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (2, 'Sélène', 'Cassie', 'Åke', '07.01.1993', 'ccassiea@reddit.com', 1, '+48 403 642 4515', 0, 'lcassiea', 'pqC1EXRP', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (24, 'Anaïs', 'Beesey', 'Océanne', '17.12.1995', 'kbeeseyb@cbc.ca', 1, '+86 770 181 4275', 1, 'mbeeseyb', 'HLdhYEXECN', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (13, 'Aimée', 'Riccione', 'Salomé', '04.07.1994', 'jriccionec@amazon.de', 0, '+389 601 466 1316', 0, 'sriccionec', 'fVVuYw', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (21, 'Léandre', 'Pauluzzi', 'Björn', '25.06.1967', 'tpauluzzid@hibu.com', 1, '+81 155 393 6631', 1, 'rpauluzzid', '8RpNEX', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (12, 'Hélène', 'Strodder', 'Agnès', '17.10.1981', 'mstroddere@ustream.tv', 0, '+81 402 533 0013', 1, 'estroddere', 'JtElVujsf', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (12, 'Märta', 'Akram', 'Tú', '28.06.1968', 'takramf@meetup.com', 0, '+84 100 383 6549', 0, 'hakramf', 'uiUGWdzi', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (1, 'Rachèle', 'Marl', 'Marie-josée', '07.03.1999', 'dmarlg@blogspot.com', 1, '+62 741 327 8075', 1, 'smarlg', 'ViOZuMW20D', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (28, 'Pélagie', 'Hannay', 'Noémie', '06.05.1968', 'bhannayh@unblog.fr', 1, '+48 121 102 8798', 1, 'ihannayh', 'GFKg07hbau', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (6, 'Marie-noël', 'Salmoni', 'Mårten', '06.08.1992', 'csalmonii@scribd.com', 1, '+998 494 901 9046', 1, 'csalmonii', 'YzH0M557', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (23, 'Marie-ève', 'Simonite', 'Noëlla', '09.10.1982', 'fsimonitej@sbwire.com', 1, '+86 502 844 7363', 1, 'asimonitej', 'BFyEHTJaM', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (30, 'Réjane', 'Garcia', 'Cinéma', '06.05.1988', 'kgarciak@dailymail.co.uk', 1, '+7 625 717 6824', 1, 'jgarciak', 'krJZ56H', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (20, 'Cléa', 'Kimbrey', 'Marie-hélène', '27.06.1982', 'akimbreyl@hatena.ne.jp', 1, '+62 540 462 3599', 1, 'ekimbreyl', 'sjReRC', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (22, 'Pål', 'Caulfield', 'Anaëlle', '06.02.1996', 'mcaulfieldm@noaa.gov', 0, '+62 843 337 5565', 0, 'fcaulfieldm', 'twFKBvwMJ8V', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (27, 'Béatrice', 'Querrard', 'Géraldine', '26.06.1969', 'bquerrardn@epa.gov', 1, '+355 298 990 7969', 0, 'oquerrardn', 'pyVgRC5NF6', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (15, 'Lyséa', 'McGuirk', 'Vérane', '11.08.1968', 'lmcguirko@opera.com', 1, '+967 433 568 6308', 1, 'dmcguirko', 'GZ10cyV', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (16, 'Cécilia', 'Puckrin', 'Mélodie', '03.08.1968', 'npuckrinp@nbcnews.com', 0, '+86 637 584 8858', 1, 'dpuckrinp', 'SizrkJ', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (21, 'Lauréna', 'Nurny', 'Maïlys', '29.09.1965', 'mnurnyq@hhs.gov', 0, '+46 535 891 3657', 1, 'bnurnyq', 'RhKJ4G5', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (8, 'Andrée', 'Thorby', 'Régine', '07.01.1965', 'ethorbyr@nhs.uk', 1, '+62 441 171 1757', 0, 'dthorbyr', 'KllrFWB7S9', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (16, 'Léonore', 'Flounders', 'Mén', '18.06.1992', 'lflounderss@amazon.co.uk', 0, '+52 137 261 5411', 0, 'oflounderss', 'NtamJZ0l', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (19, 'Vénus', 'Camoys', 'Pål', '13.03.1969', 'ecamoyst@pinterest.com', 0, '+86 115 128 9529', 0, 'mcamoyst', 'hiiz8tu', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (10, 'Nuó', 'Lidierth', 'Angèle', '29.06.1996', 'glidierthu@columbia.edu', 1, '+86 269 406 1314', 0, 'jlidierthu', 'YdAOfDJ3KcVV', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (26, 'Sélène', 'Drinnan', 'Cloé', '30.05.1981', 'adrinnanv@disqus.com', 1, '+58 499 945 2659', 1, 'wdrinnanv', 'PbeWBRiC', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (23, 'Aloïs', 'Piborn', 'Renée', '15.06.1985', 'spibornw@house.gov', 1, '+63 737 364 2260', 0, 'zpibornw', 'hWF5UJjyC', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (4, 'Kallisté', 'Saphin', 'Börje', '13.03.1973', 'nsaphinx@goo.ne.jp', 0, '+81 698 388 8535', 1, 'bsaphinx', '2spgdP0MIzMq', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (27, 'Inès', 'Lordon', 'Méline', '16.11.2002', 'mlordony@canalblog.com', 1, '+92 985 990 8554', 0, 'jlordony', 'H9GQABTvStM', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (13, 'Judicaël', 'Lamborne', 'Göran', '22.05.1969', 'blambornez@earthlink.net', 1, '+1 812 814 3257', 0, 'glambornez', 'C0qqHPWC', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (29, 'Céline', 'Earley', 'Mégane', '05.03.1990', 'searley10@mashable.com', 0, '+48 201 143 2218', 0, 'searley10', 'IWhZQW', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (21, 'Ophélie', 'Sille', 'Geneviève', '13.06.1976', 'jsille11@barnesandnoble.com', 1, '+63 542 910 7623', 0, 'msille11', 'Ds7VsWGZy', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (25, 'Mélissandre', 'Baillie', 'Dù', '04.09.1985', 'cbaillie12@slideshare.net', 1, '+62 919 188 2580', 0, 'gbaillie12', 'AIQxS7JYF1K', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (8, 'Léone', 'Blaxland', 'Célestine', '14.03.1969', 'dblaxland13@ucla.edu', 0, '+46 879 504 0245', 1, 'bblaxland13', 'Wz8ltEX', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (27, 'Stévina', 'Pittaway', 'Léa', '31.08.1963', 'dpittaway14@loc.gov', 0, '+591 724 419 5207', 1, 'lpittaway14', 'aeeeuN5Z', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (10, 'Léa', 'Burch', 'André', '19.03.1989', 'mburch15@irs.gov', 0, '+81 518 605 2392', 1, 'dburch15', 'WMFY4i0n', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (1, 'Vérane', 'Bonde', 'Loïca', '20.09.1993', 'tbonde16@umn.edu', 0, '+62 780 917 6301', 0, 'kbonde16', '14n4Wyco', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (26, 'Faîtes', 'Breming', 'Mélissandre', '05.01.1978', 'dbreming17@ft.com', 1, '+54 461 363 8846', 0, 'abreming17', 'tgA7ewlG5xs', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (8, 'Marylène', 'Lorking', 'Yè', '17.10.1962', 'alorking18@blog.com', 1, '+84 958 696 3536', 0, 'mlorking18', 'pcVgma', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (27, 'Maïly', 'Riggeard', 'Esbjörn', '21.03.1993', 'lriggeard19@linkedin.com', 1, '+1 399 979 8431', 0, 'kriggeard19', 'mIotuUj3', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (19, 'Görel', 'Gaize', 'Judicaël', '09.10.1991', 'agaize1a@alexa.com', 1, '+55 487 321 9407', 1, 'lgaize1a', 'TPSWP70', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (22, 'Marylène', 'Curnow', 'Miléna', '26.09.2000', 'mcurnow1b@geocities.jp', 0, '+389 397 188 2413', 1, 'scurnow1b', 'nTfHGAkC0', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (13, 'Vérane', 'Kuhndel', 'Léandre', '26.02.2001', 'mkuhndel1c@vimeo.com', 0, '+62 691 306 4606', 0, 'nkuhndel1c', 'HuJOw6l', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (19, 'Chloé', 'McCaffrey', 'Bécassine', '04.03.1972', 'fmccaffrey1d@hao123.com', 1, '+62 461 417 5092', 1, 'tmccaffrey1d', 'im8ZLIuk1a', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (5, 'Bécassine', 'Ostrich', 'Måns', '23.10.2000', 'tostrich1e@nba.com', 1, '+61 912 434 1655', 1, 'tostrich1e', 'sU2LivhH', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (29, 'Zoé', 'Pattesall', 'Méng', '26.03.2000', 'gpattesall1f@stanford.edu', 1, '+27 439 876 1788', 0, 'lpattesall1f', 'i3giEIG', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (24, 'Adélie', 'Adger', 'Mylène', '19.12.1968', 'tadger1g@usgs.gov', 1, '+27 959 988 1193', 1, 'madger1g', 'CtUsOiQDN', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (16, 'Yóu', 'MacGruer', 'Séverine', '25.01.1988', 'rmacgruer1h@theguardian.com', 0, '+62 840 291 7198', 0, 'zmacgruer1h', 'k4jjbVhxS', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (3, 'Cléopatre', 'Stickles', 'Almérinda', '02.08.1996', 'fstickles1i@harvard.edu', 0, '+86 496 638 0755', 1, 'fstickles1i', 'fGPNRhqkw4pn', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (27, 'Lucrèce', 'Sellan', 'Maëlle', '08.07.1989', 'fsellan1j@joomla.org', 1, '+976 926 177 8667', 0, 'rsellan1j', '8BgHYNnk', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (27, 'Audréanne', 'Kleinstein', 'Måns', '24.07.1981', 'pkleinstein1k@psu.edu', 1, '+7 578 331 7605', 0, 'ckleinstein1k', 'u8mCKj4W', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (19, 'Nélie', 'Pallis', 'Angèle', '22.10.1980', 'dpallis1l@vinaora.com', 1, '+86 789 322 4618', 0, 'jpallis1l', 'zvFsu3Zb1a', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (4, 'Vénus', 'Alwen', 'Méghane', '30.04.1962', 'ralwen1m@china.com.cn', 1, '+64 841 208 3315', 1, 'palwen1m', 'bIXyyuIDIj', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (28, 'Dù', 'Udden', 'Maëlys', '26.07.1971', 'ludden1n@cpanel.net', 0, '+57 578 982 2918', 1, 'budden1n', 'CwrcC8aiSW', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (29, 'Cinéma', 'Giblett', 'Audréanne', '14.12.1967', 'lgiblett1o@bizjournals.com', 1, '+30 333 245 7908', 0, 'fgiblett1o', '4vOBdLfvBEM', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (23, 'Mén', 'Issacson', 'Zhì', '27.02.1998', 'bissacson1p@elegantthemes.com', 0, '+57 837 706 7692', 1, 'sissacson1p', '8UnxYr0St8ZR', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (2, 'Bérénice', 'Oxtarby', 'Maëlle', '29.04.1961', 'boxtarby1q@gravatar.com', 0, '+86 107 877 0914', 1, 'hoxtarby1q', 'Glve7St', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (14, 'Yú', 'Larchier', 'Angélique', '14.08.1982', 'mlarchier1r@mysql.com', 0, '+51 417 710 1170', 1, 'elarchier1r', 'dSKsSK7j2', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (2, 'Jú', 'Georgel', 'Maéna', '27.11.1982', 'dgeorgel1s@smugmug.com', 0, '+372 674 786 8950', 0, 'cgeorgel1s', '0BO83Rs', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (24, 'Félicie', 'Davidove', 'Lauréna', '03.07.1996', 'jdavidove1t@surveymonkey.com', 0, '+62 558 700 1881', 0, 'adavidove1t', '6nfaiGo2qql', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (7, 'Esbjörn', 'Gerram', 'Geneviève', '23.10.1990', 'fgerram1u@rakuten.co.jp', 1, '+62 176 717 7862', 0, 'jgerram1u', 'LCe1NSHTKpL', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (12, 'Bérengère', 'Jose', 'Kévina', '22.01.1994', 'ajose1v@dion.ne.jp', 0, '+51 675 762 3368', 1, 'ojose1v', 'O76lNMXS1A', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (14, 'Ruì', 'Semiras', 'Crééz', '30.04.1974', 'jsemiras1w@hao123.com', 0, '+55 554 614 0276', 0, 'ssemiras1w', 'ot0BZ0', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (4, 'Cléa', 'Burberye', 'Maëlys', '06.11.1992', 'aburberye1x@ucoz.com', 1, '+86 878 557 3425', 1, 'dburberye1x', 'IupWeKbqutS3', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (4, 'Åke', 'Cottam', 'Chloé', '11.02.1978', 'rcottam1y@acquirethisname.com', 0, '+46 361 206 8571', 0, 'scottam1y', 'bSvGlN', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (11, 'Kévina', 'Lavigne', 'Hélèna', '03.01.2001', 'jlavigne1z@joomla.org', 1, '+92 346 262 4029', 0, 'alavigne1z', 'jFXjxV', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (18, 'Pò', 'Finders', 'Mén', '02.12.1994', 'efinders20@paypal.com', 1, '+351 916 284 6064', 1, 'ofinders20', 'cRuedec2yw', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (16, 'Eloïse', 'Frances', 'Yénora', '13.05.1969', 'sfrances21@mozilla.com', 1, '+62 133 556 6048', 1, 'jfrances21', 'eYfbGRZli', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (6, 'Mahélie', 'Veevers', 'Geneviève', '19.03.1963', 'rveevers22@hhs.gov', 0, '+995 357 393 6374', 1, 'oveevers22', 'jPOVnjPq', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (19, 'Måns', 'Laydon', 'Ráo', '13.05.1995', 'slaydon23@theguardian.com', 0, '+30 821 704 3053', 0, 'flaydon23', 'aDpRZG3etjJ', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (18, 'Maëlyss', 'Espin', 'Maëlyss', '06.05.1989', 'respin24@xing.com', 0, '+55 242 746 1867', 1, 'lespin24', 'UKYAGvAgW', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (27, 'Maëline', 'Comello', 'Irène', '16.08.1966', 'ocomello25@icio.us', 1, '+996 782 789 3746', 0, 'scomello25', 'FZQFL9Fic', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (26, 'Estée', 'Larrosa', 'Maïlys', '19.04.1993', 'jlarrosa26@businesswire.com', 0, '+505 556 728 7857', 0, 'slarrosa26', 'qNKnpks', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (27, 'Mégane', 'Vinden', 'Angèle', '17.06.1968', 'nvinden27@fotki.com', 1, '+30 455 380 7570', 0, 'avinden27', 'H0lxgH', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (30, 'Maëlle', 'Bain', 'Magdalène', '08.07.1980', 'obain28@nih.gov', 1, '+48 291 861 4055', 0, 'abain28', 'uByB1s0', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (12, 'Esbjörn', 'Renard', 'Maëline', '23.11.1976', 'lrenard29@ihg.com', 1, '+34 710 376 0731', 0, 'krenard29', '6v4xYr9bU', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (17, 'Tán', 'Jimpson', 'Estée', '04.05.1989', 'ljimpson2a@dmoz.org', 1, '+98 391 782 5171', 1, 'sjimpson2a', 'pYpOapSrOV', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (5, 'Thérèsa', 'Meikle', 'Angélique', '05.10.1974', 'mmeikle2b@omniture.com', 1, '+33 114 235 3948', 1, 'hmeikle2b', 'VV3y9QQHt', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (14, 'Camélia', 'Clutheram', 'Agnès', '10.03.1971', 'aclutheram2c@chronoengine.com', 0, '+7 479 723 6947', 0, 'jclutheram2c', '414PRmcy', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (15, 'Véronique', 'Brocket', 'Dorothée', '12.07.1965', 'qbrocket2d@nbcnews.com', 1, '+351 463 815 3256', 1, 'nbrocket2d', '45DqtUO4sOZ', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (2, 'Agnès', 'Anthonsen', 'Méthode', '08.01.2001', 'oanthonsen2e@elegantthemes.com', 0, '+7 180 171 0175', 1, 'santhonsen2e', 'Ku0GurDI', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (6, 'Mahélie', 'McRobert', 'Angèle', '09.02.1967', 'jmcrobert2f@ucsd.edu', 0, '+7 734 544 8599', 0, 'wmcrobert2f', 'FY0VLoPIZgQo', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (5, 'Eloïse', 'Arias', 'Mélys', '27.10.1969', 'marias2g@github.io', 0, '+212 665 768 1637', 0, 'aarias2g', 'eelOWtfu', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (30, 'Rachèle', 'Pitt', 'Clémence', '28.11.1994', 'spitt2h@hexun.com', 0, '+86 963 412 0000', 1, 'npitt2h', 'XkAD1vxPTThq', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (19, 'Félicie', 'Reoch', 'Thérèse', '28.05.1965', 'mreoch2i@loc.gov', 0, '+20 172 681 2360', 0, 'creoch2i', 'TNrCoDYO4', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (21, 'Aí', 'Menichi', 'Åsa', '28.12.1962', 'mmenichi2j@360.cn', 0, '+86 319 289 5579', 0, 'smenichi2j', 'QLhurX', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (30, 'Marylène', 'Hurche', 'Kuí', '20.03.1999', 'dhurche2k@1688.com', 0, '+86 165 665 9911', 0, 'ahurche2k', 'luUUZLfMSfCU', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (15, 'Salomé', 'Grouvel', 'Eugénie', '29.12.2000', 'wgrouvel2l@goo.ne.jp', 1, '+62 403 359 6649', 0, 'zgrouvel2l', '1Csa6Z', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (16, 'Aloïs', 'Bateup', 'Gaétane', '22.10.1964', 'ibateup2m@cbslocal.com', 0, '+62 985 415 6326', 0, 'kbateup2m', 'tt0gUnd', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (6, 'Médiamass', 'Rozalski', 'Alizée', '26.06.1988', 'erozalski2n@goo.ne.jp', 0, '+62 298 828 7563', 0, 'mrozalski2n', 'Fd25Um', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (24, 'Hélène', 'Whittlesea', 'Irène', '03.10.2000', 'ewhittlesea2o@dedecms.com', 1, '+33 521 236 6215', 1, 'awhittlesea2o', '4pKUVGKfbAbb', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (1, 'Annotés', 'Shuard', 'Aimée', '12.01.1998', 'nshuard2p@cbslocal.com', 1, '+62 500 282 9696', 0, 'cshuard2p', 'gf5A5co7O', 1);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (9, 'Ophélie', 'Durban', 'Crééz', '13.04.2002', 'mdurban2q@tripadvisor.com', 1, '+55 470 571 3328', 1, 'gdurban2q', 'MiwO2b', 0);
INSERT INTO dbo.Users (GroupId, FirstName, LastName, MiddleName, Birthday, Email, IsEmailVerified, PhoneNumber, IsPhoneVerified, Login, Password, IsRemoved) VALUES (13, 'Liè', 'Madoc-Jones', 'Cunégonde', '07.04.1968', 'amadocjones2r@addthis.com', 0, '+352 683 974 8678', 1, 'cmadocjones2r', 'cZEQvmDAUr2d', 1);

-- StudentTests

INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (19, 8, 1, 15.41, 0.17);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (89, 8, 0, 47.54, 0.18);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (35, 6, 1, 97.49, 0.49);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (29, 3, 0, 50.18, 0.5);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (9, 3, 1, 47.56, 0.94);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (67, 6, 0, 34.32, 0.08);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (7, 2, 1, 12.36, 0.33);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (65, 5, 0, 52.69, 0.99);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (94, 8, 0, 54.75, 0.98);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (30, 3, 0, 30.37, 0.77);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (5, 2, 1, 83.51, 0.78);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (82, 3, 1, 69.15, 0.8);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (25, 7, 0, 51.73, 0.88);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (65, 5, 1, 81.45, 0.52);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (11, 3, 1, 39.3, 0.47);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (39, 6, 0, 37.41, 0.97);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (26, 6, 1, 61.5, 0.32);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (65, 8, 0, 74.2, 0.96);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (68, 3, 1, 84.24, 0.28);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (90, 1, 1, 75.9, 0.54);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (64, 8, 1, 80.07, 0.68);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (38, 7, 1, 2.86, 0.71);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (87, 2, 1, 96.68, 0.24);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (12, 7, 1, 89.33, 0.66);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (54, 1, 1, 73.57, 0.35);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (68, 3, 0, 54.53, 0.4);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (88, 8, 0, 65.31, 0.07);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (73, 1, 1, 15.86, 0.62);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (64, 8, 1, 82.17, 0.76);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (32, 3, 0, 79.22, 0.26);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (69, 1, 1, 49.39, 0.94);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (58, 8, 0, 77.39, 0.2);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (52, 6, 0, 69.38, 0.67);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (18, 7, 0, 83.08, 0.4);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (22, 6, 0, 12.11, 0.73);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (80, 1, 1, 5.44, 0.37);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (48, 2, 0, 80.45, 0.77);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (76, 4, 0, 79.99, 0.22);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (43, 5, 0, 22.24, 0.85);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (47, 8, 0, 64.15, 0.03);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (42, 3, 0, 51.64, 0.02);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (83, 5, 1, 97.35, 0.93);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (98, 2, 1, 33.67, 0.07);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (48, 6, 1, 62.13, 0.03);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (70, 7, 0, 92.93, 0.44);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (89, 8, 1, 17.67, 0.7);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (50, 6, 1, 36.86, 0.41);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (50, 2, 0, 47.85, 0.74);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (31, 2, 0, 44.53, 0.23);
INSERT INTO dbo.StudentTests (UserId, TestId, AllowToPass, PCA, IsRemoved) VALUES (56, 5, 1, 69.18, 0.4);

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
