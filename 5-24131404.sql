

DROP TABLE IF EXISTS `Справка+`;
CREATE TABLE `Справка+` (
 `Слк` CHAR(4) NOT NULL,
 `Код` CHAR(3) NOT NULL,
 `Название` VARCHAR(50) NOT NULL,
 `Содержание` VARCHAR(100) NULL,
 `Слк_родитель` CHAR(4) NULL,
 `Код_родитель` CHAR(3) NULL,
 CONSTRAINT `ПК_СПР` PRIMARY KEY (`Слк`, `Код`),
 CONSTRAINT `ВК1_СПР_СПР` FOREIGN KEY (`Слк_родитель`, `Код_родитель`)
 REFERENCES `Справка+` (`Слк`, `Код`)
);
INSERT INTO `Справка+` VALUES
 ('ВПрт', '001', 'академическая', 'академическая претензия', NULL, NULL),
 ('Вд', '001', 'паспорт', 'документ удостоверяющий личность', NULL, NULL),
 ('ДОЛ', 'про', 'профессор', 'профессср кафедры', NULL, NULL),
 ('ДОЛ', 'доц', 'доцент', 'доцент кафедры', NULL, NULL),
 ('ДОЛ', 'лаб', 'лаборант', NULL, NULL, NULL),
 ('КатА', '001', 'бюджет', 'бюджетная основа обучения', NULL, NULL),
 ('КатА', '002', 'контракт', 'контрактная основа обучения', NULL, NULL),
 ('Льг', '001', 'сирота', 'дети-сироты', NULL, NULL),
 ('Фак', '001', 'ФИРТ', 'факультет информатики и робототехники', NULL, NULL),
 ('Каф', '001', 'АСУ', 'кафедра автоматизированных систем управления', 'Фак', '001'),
 ('Напр', '001', 'программирование', 'направление программирования', 'Фак', '001');
SELECT "=== Справка+ Table Content ===" AS '';
SELECT * FROM `Справка+`;


DROP TABLE IF EXISTS `Сотрудник%ПЕРС`;
CREATE TABLE `Сотрудник%ПЕРС` (
 `Код` CHAR(10) NOT NULL PRIMARY KEY,
 `Паспорт` CHAR(10) NOT NULL UNIQUE,
 `ФИО` VARCHAR(50) NOT NULL,
 `Слк_ДОЛ` CHAR(4) NOT NULL DEFAULT 'ДОЛ',
 `Код_ДОЛ` CHAR(3) NOT NULL,
 CONSTRAINT `ВК1_СОТ_СПР` FOREIGN KEY (`Слк_ДОЛ`, `Код_ДОЛ`) REFERENCES `Справка+` (`Слк`, `Код`)
);
INSERT INTO `Сотрудник%ПЕРС` VALUES
 ('001-П', '345678', 'Петров А. А.', 'ДОЛ', 'про'),
 ('002-П', '456789', 'Боширов Р. Р.', 'ДОЛ', 'доц'),
 ('099-В', '567890', 'Исаев М. М.', 'ДОЛ', 'лаб');
SELECT "=== Сотрудник%ПЕРС Table Content ===" AS '';
SELECT * FROM `Сотрудник%ПЕРС`;


DROP TABLE IF EXISTS `Секретарь:СОТ`;
CREATE TABLE `Секретарь:СОТ` (
 `Слк_Каф` CHAR(4) NOT NULL DEFAULT 'Каф',
 `Код_Каф` CHAR(3) NOT NULL,
 `КодСК:СОТ` CHAR(10) NOT NULL PRIMARY KEY REFERENCES `Сотрудник%ПЕРС` (`Код`),
CONSTRAINT `ВК1_Ск_СПР` FOREIGN KEY (`Слк_Каф`, `Код_Каф`) REFERENCES `Справка+` (`Слк`, `Код`)
);
INSERT INTO `Секретарь:СОТ` VALUES
 ('Каф', '001', '001-П');
SELECT "=== Секретарь:СОТ Table Content ===" AS '';
SELECT * FROM `Секретарь:СОТ`;


DROP TABLE IF EXISTS `Руководитель_подписавший_приказ:СОТ`;
CREATE TABLE `Руководитель_подписавший_приказ:СОТ` (
 `КодРУК:СОТ` CHAR(10) NOT NULL PRIMARY KEY REFERENCES `Сотрудник%ПЕРС` (`Код`)
);
INSERT INTO `Руководитель_подписавший_приказ:СОТ` VALUES
 ('002-П');
SELECT "===Руководитель_подписавший_приказ:СОТ Table Content ===" AS '';
SELECT * FROM `Руководитель_подписавший_приказ:СОТ`;


DROP TABLE IF EXISTS `Член_комиссии:СОТ`;
CREATE TABLE `Член_комиссии:СОТ` (
 `КодЧЛК:СОТ` CHAR(10) NOT NULL PRIMARY KEY REFERENCES `Сотрудник%ПЕРС` (`Код`)
);
INSERT INTO `Член_комиссии:СОТ` VALUES
 ('099-В');
SELECT "=== Член_комиссии:СОТ Table Content ===" AS '';
SELECT * FROM `Член_комиссии:СОТ`;


DROP TABLE IF EXISTS `Абитуриент%ПЕРС`;
CREATE TABLE `Абитуриент%ПЕРС` (
 `Код` CHAR(10) NOT NULL PRIMARY KEY,
 `Паспорт` CHAR(10) NOT NULL UNIQUE,
 `ФИО` VARCHAR(50) NOT NULL,
 `Дата_подачи_документов` DATE NOT NULL,
 `Дата_возврата_документов` DATE NULL,
 `Слк_КатА` CHAR(4) NOT NULL DEFAULT 'КатА',
 `Код_КатА` CHAR(3) NOT NULL,
 `Код_СЕК_принял` CHAR(10) NOT NULL,
 `Код_СЕК_возвратил` CHAR(10) NULL,
 CONSTRAINT `ВК1_АБ_СПР` FOREIGN KEY (`Слк_КатА`, `Код_КатА`) REFERENCES `Справка+` (`Слк`, `Код`),
 CONSTRAINT `ВК2_АБ_СЕК_принял` FOREIGN KEY (`Код_СЕК_принял`) REFERENCES `Секретарь:СОТ` (`КодСк:СОТ`),
 CONSTRAINT `ВК3_АБ_СЕК_возвратил` FOREIGN KEY (`Код_СЕК_возвратил`) REFERENCES `Секретарь:СОТ` (`КодСк:СОТ`)
);
INSERT INTO `Абитуриент%ПЕРС` VALUES
 ('001-Б', '123456', 'Иванов И. И.', '2025-06-15', NULL, 'КатА', '001', '001-П', NULL),
 ('002-К', '234567', 'Сидоров С. С.', '2025-06-20', NULL, 'КатА', '002', '001-П', NULL);
SELECT "=== Абитуриент%ПЕРС Table Content ===" AS '';
SELECT * FROM `Абитуриент%ПЕРС`;


DROP TABLE IF EXISTS `Документ_абитуриента`;
CREATE TABLE `Документ_абитуриента` (
 `Номер` CHAR(10) NOT NULL,
 `Код_АБ` CHAR(10) NOT NULL,
 `Реквизиты` VARCHAR(100) NOT NULL,
 `Слк_Вд` CHAR(4) NOT NULL DEFAULT 'Вд',
 `Код_Вд` CHAR(3) NOT NULL,
 CONSTRAINT `ПК_ДОК` PRIMARY KEY (`Номер`, `Код_АБ`),
 CONSTRAINT `ВК1_ДОК_АБ` FOREIGN KEY (`Код_АБ`) REFERENCES `Абитуриент%ПЕРС` (`Код`),
 CONSTRAINT `ВК2_ДОК_СПР` FOREIGN KEY (`Слк_Вд`, `Код_Вд`) REFERENCES `Справка+` (`Слк`, `Код`)
);
INSERT INTO `Документ_абитуриента` VALUES
 ('ДОК001', '001-Б', 'серия 1234 номер 567890', 'Вд', '001'),
 ('ДОК002', '002-К', 'серия 2345 номер 678901', 'Вд', '001');
SELECT "=== Документ_абитуриента Table Content ===" AS '';
SELECT * FROM `Документ_абитуриента`;


DROP TABLE IF EXISTS `Направление_абитуриента`;
CREATE TABLE `Направление_абитуриента` (
 `Код_АБ` CHAR(10) NOT NULL,
 `Слк_Напр` CHAR(4) NOT NULL DEFAULT 'Напр',
 `Код_Напр` CHAR(3) NOT NULL,
 `Дата_время_выбора` DATETIME  NULL,
 `Рейтинг_абитуриента` INT NOT NULL,
 `Код_СЕК_зарегистрировал` CHAR(10) NOT NULL,
 CONSTRAINT `ПК_НАП` PRIMARY KEY (`Код_АБ`, `Слк_Напр`, `Код_Напр`),
 CONSTRAINT `ВК1_НАП_АБ` FOREIGN KEY (`Код_АБ`) REFERENCES `Абитуриент%ПЕРС` (`Код`),
 CONSTRAINT `ВК2_НАП_СПР` FOREIGN KEY (`Слк_Напр`, `Код_Напр`) REFERENCES `Справка+` (`Слк`, `Код`),
 CONSTRAINT `ВК3_НАП_СЕК` FOREIGN KEY (`Код_СЕК_зарегистрировал`) REFERENCES `Секретарь:СОТ` (`КодСк:СОТ`)
);
INSERT INTO `Направление_абитуриента` VALUES
 ('001-Б', 'Напр', '001', '2025-06-15 10:30:00', 85, '001-П'),
 ('002-К', 'Напр', '001', '2025-06-20 11:45:00', 92, '001-П');
SELECT "=== Направление_абитуриента Table Content ===" AS '';
SELECT * FROM `Направление_абитуриента`;


DROP TABLE IF EXISTS `Приказ_зачисления`;
CREATE TABLE `Приказ_зачисления` (
 `Регномер` CHAR(10) NOT NULL PRIMARY KEY,
 `Дата_приказа` DATE NOT NULL,
 `Код_РУК` CHAR(10) NOT NULL,
 CONSTRAINT `ВК1_ПРИ_ЗАЧ_РУК` FOREIGN KEY (`Код_РУК`) REFERENCES `Руководитель_подписавший_приказ:СОТ` (`КодРУК:СОТ`)
);
INSERT INTO `Приказ_зачисления` VALUES
 ('ПР001', '2025-07-01', '002-П');
SELECT "=== Приказ_зачисления Table Content ===" AS '';
SELECT * FROM `Приказ_зачисления`;


DROP TABLE IF EXISTS `Зачисленный_абитуриент`;
CREATE TABLE `Зачисленный_абитуриент` (
 `Код_АБ` CHAR(10) NOT NULL PRIMARY KEY REFERENCES `Абитуриент%ПЕРС` (`Код`),
 `Слк_Напр` CHAR(4) NOT NULL DEFAULT 'Напр',
 `Код_Напр` CHAR(3) NOT NULL,
 `Код_ПРИ` CHAR(10) NOT NULL,
 CONSTRAINT `ВК1_ЗАЧ_НАП` FOREIGN KEY (`Слк_Напр`, `Код_Напр`) REFERENCES `Направление_абитуриента` (`Слк_Напр`, `Код_Напр`),
 CONSTRAINT `ВК2_ЗАЧ_ПРИ` FOREIGN KEY (`Код_ПРИ`) REFERENCES `Приказ_зачисления` (`Регномер`)
);
INSERT INTO `Зачисленный_абитуриент` VALUES
 ('001-Б', 'Напр', '001', 'ПР001');
SELECT "=== Зачисленный_абитуриент Table Content ===" AS '';
SELECT * FROM `Зачисленный_абитуриент`;


DROP TABLE IF EXISTS `Документ_подтверждающий_льготу`;
CREATE TABLE `Документ_подтверждающий_льготу` (
 `Номер_ДОК` CHAR(10) NOT NULL,
 `Код_ДОК` CHAR(10) NOT NULL,
 CONSTRAINT `ПК_ДОК_ЛЬГ` PRIMARY KEY (`Номер_ДОК`, `Код_ДОК`),
 CONSTRAINT `ВК1_ДОК_ЛЬГ_ДОК` FOREIGN KEY (`Номер_ДОК`, `Код_ДОК`) REFERENCES `Документ_абитуриента` (`Номер`, `Код_АБ`)
);
INSERT INTO `Документ_подтверждающий_льготу` VALUES
 ('ДОК001', '001-Б');
SELECT "=== Документ_подтверждающий_льготу Table Content ===" AS '';
SELECT * FROM `Документ_подтверждающий_льготу`;


DROP TABLE IF EXISTS `Льгота_абитуриента`;
CREATE TABLE `Льгота_абитуриента` (
 `Код_ЗАЧ` CHAR(10) NOT NULL,
 `Слк_Льг` CHAR(4) NOT NULL DEFAULT 'Льг',
 `Код_Льг` CHAR(3) NOT NULL,
 `Номер_ДОК_ЛЬГ` CHAR(10) NOT NULL,
 `Код_ДОК_ЛЬГ` CHAR(10) NOT NULL,
 CONSTRAINT `ПК_ЛЬГ` PRIMARY KEY (`Код_ЗАЧ`, `Слк_Льг`, `Код_Льг`),
 CONSTRAINT `ВК1_ЛЬГ_ЗАЧ` FOREIGN KEY (`Код_ЗАЧ`) REFERENCES `Зачисленный_абитуриент` (`Код_АБ`),
 CONSTRAINT `ВК2_ЛЬГ_ДОК_ЛЬГ` FOREIGN KEY (`Номер_ДОК_ЛЬГ`, `Код_ДОК_ЛЬГ`) REFERENCES `Документ_подтверждающий_льготу` (`Номер_ДОК`, `Код_ДОК`),
 CONSTRAINT `ВК3_ЛЬГ_СПР` FOREIGN KEY (`Слк_Льг`, `Код_Льг`) REFERENCES `Справка+` (`Слк`, `Код`)
);
INSERT INTO `Льгота_абитуриента` VALUES
 ('001-Б', 'Льг', '001', 'ДОК001', '001-Б');
SELECT "=== Льгота_абитуриента Table Content ===" AS '';
SELECT * FROM `Льгота_абитуриента`;


DROP TABLE IF EXISTS `Приказ_апелляционной_комиссии`;
CREATE TABLE `Приказ_апелляционной_комиссии` (
 `Регномер` CHAR(10) NOT NULL PRIMARY KEY,
 `Дата_приказа` DATE NOT NULL,
 `Код_РУК` CHAR(10) NOT NULL,
 CONSTRAINT `ВК1_ПРИ_АПЛ_РУК` FOREIGN KEY (`Код_РУК`) REFERENCES `Руководитель_подписавший_приказ:СОТ` (`КодРУК:СОТ`)
);
INSERT INTO `Приказ_апелляционной_комиссии` VALUES
 ('ПР002', '2025-07-02', '002-П');
SELECT "=== Приказ_апелляционной_комиссии Table Content ===" AS '';
SELECT * FROM `Приказ_апелляционной_комиссии`;


DROP TABLE IF EXISTS `Апелляционная_комиссия`;
CREATE TABLE `Апелляционная_комиссия` (
 `Регномер` CHAR(10) NOT NULL PRIMARY KEY,
 `Код_ПРИ` CHAR(10) NOT NULL,
 CONSTRAINT `ВК1_АПЛ_К_ПРИ` FOREIGN KEY (`Код_ПРИ`) REFERENCES `Приказ_апелляционной_комиссии` (`Регномер`)
);
INSERT INTO `Апелляционная_комиссия` VALUES
 ('АК001', 'ПР002');
SELECT "=== Апелляционная_комиссия Table Content ===" AS '';
SELECT * FROM `Апелляционная_комиссия`;


DROP TABLE IF EXISTS `Заседание_комиссии`;
CREATE TABLE `Заседание_комиссии` (
 `Номер` CHAR(10) NOT NULL,
 `Регномер_АПЛ_К` CHAR(10) NOT NULL,
 `Дата` DATE NOT NULL,
 CONSTRAINT `ПК_ЗАС` PRIMARY KEY (`Номер`, `Регномер_АПЛ_К`),
 CONSTRAINT `ВК1_ЗАС_АПЛ_К` FOREIGN KEY (`Регномер_АПЛ_К`) REFERENCES `Апелляционная_комиссия` (`Регномер`)
);
INSERT INTO `Заседание_комиссии` VALUES
 ('001', 'АК001', '2025-07-05');
SELECT "=== Заседание_комиссии Table Content ===" AS '';
SELECT * FROM `Заседание_комиссии`;


DROP TABLE IF EXISTS `Апеллянт`;
CREATE TABLE `Апеллянт` (
 `Код` CHAR(10) NOT NULL PRIMARY KEY REFERENCES `Абитуриент%ПЕРС` (`Код`)
);
INSERT INTO `Апеллянт` VALUES
 ('002-К');
SELECT "=== Апеллянт Table Content ===" AS '';
SELECT * FROM `Апеллянт`;


DROP TABLE IF EXISTS `Апелляция`;
CREATE TABLE `Апелляция` (
 `Регномер` CHAR(10) NOT NULL PRIMARY KEY,
 `Код_АПЛ_Т` CHAR(10) NOT NULL,
 `Номер_ЗАС` CHAR(10) NOT NULL,
 `Регномер_ЗАС` CHAR(10) NOT NULL,
 `Содержание_претензии` TEXT NOT NULL,
 `Решение_комиссии` TEXT NULL,
 `Слк_ВПрт` CHAR(4) NOT NULL DEFAULT 'ВПрт',
 `Код_ВПрт` CHAR(3) NOT NULL,
 CONSTRAINT `ВК1_АПЛ_АПЛ_Т` FOREIGN KEY (`Код_АПЛ_Т`) REFERENCES `Апеллянт` (`Код`),
 CONSTRAINT `ВК2_АПЛ_ЗАС` FOREIGN KEY (`Номер_ЗАС`, `Регномер_ЗАС`) REFERENCES `Заседание_комиссии` (`Номер`, `Регномер_АПЛ_К`),
 CONSTRAINT `ВК3_АПЛ_СПР` FOREIGN KEY (`Слк_ВПрт`, `Код_ВПрт`) REFERENCES `Справка+` (`Слк`, `Код`)
);
INSERT INTO `Апелляция` VALUES
 ('АП001', '002-К', '001', 'АК001', 'Несогласие с результатами экзамена', 'Отклонена', 'ВПрт', '001');
SELECT "=== Апелляция Table Content ===" AS '';
SELECT * FROM `Апелляция`;


DROP TABLE IF EXISTS `Члены_комиссии_на_заседании`;
CREATE TABLE `Члены_комиссии_на_заседании` (
 `Код_ЧЛК` CHAR(10) NOT NULL,
 `Номер_ЗАС` CHAR(10) NOT NULL,
 `Регномер_ЗАС` CHAR(10) NOT NULL,
 `Роль` VARCHAR(50) NOT NULL,
 CONSTRAINT `ПК_ЧЛ_ЗАС` PRIMARY KEY (`Код_ЧЛК`, `Номер_ЗАС`, `Регномер_ЗАС`),
 CONSTRAINT `ВК1_ЧЛ_ЗАС_ЧЛК` FOREIGN KEY (`Код_ЧЛК`) REFERENCES `Член_комиссии:СОТ` (`КодЧЛК:СОТ`),
 CONSTRAINT `ВК2_ЧЛ_ЗАС_ЗАС` FOREIGN KEY (`Номер_ЗАС`, `Регномер_ЗАС`) REFERENCES `Заседание_комиссии` (`Номер`, `Регномер_АПЛ_К`)
);
INSERT INTO `Члены_комиссии_на_заседании` VALUES
 ('099-В', '001', 'АК001', 'эксперт');
SELECT "=== Члены_комиссии_на_заседании Table Content ===" AS '';
SELECT * FROM `Члены_комиссии_на_заседании`;


