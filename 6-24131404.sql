

DROP TABLE IF EXISTS `Справка+`;
CREATE TABLE `Справка+` (
 `Ид` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `Слк` CHAR(4) NOT NULL,
 `Код` CHAR(3) NOT NULL,
 `Название` VARCHAR(50) NOT NULL,
 `Содержание` VARCHAR(100) NULL,
 `Ид_родитель` INT NULL REFERENCES `Справка+` (`Ид`),
 CONSTRAINT `Ун1_СПР` UNIQUE (`Слк`, `Код`)
);

INSERT INTO `Справка+` (`Слк`, `Код`, `Название`, `Содержание`, `Ид_родитель`) VALUES
 ('ВПрт', '001', 'академическая', 'академическая претензия', NULL),
 ('Вд', '001', 'паспорт', 'документ удостоверяющий личность', NULL),
 ('ДОЛ', 'про', 'профессор', 'профессср кафедры', NULL),
 ('ДОЛ', 'доц', 'доцент', 'доцент кафедры', NULL),
 ('ДОЛ', 'лаб', 'лаборант', NULL, NULL),
 ('КатА', '001', 'бюджет', 'бюджетная основа обучения', NULL),
 ('КатА', '002', 'контракт', 'контрактная основа обучения', NULL),
 ('Льг', '001', 'сирота', 'дети-сироты', NULL),
 ('Фак', '001', 'ФИРТ', 'факультет информатики и робототехники', NULL);

INSERT INTO `Справка+` (`Слк`, `Код`, `Название`, `Содержание`, `Ид_родитель`) 
SELECT 'Каф', '001', 'АСУ', 'кафедра автоматизированных систем управления', `Ид` 
FROM `Справка+` WHERE `Слк` = 'Фак' AND `Код` = '001';

INSERT INTO `Справка+` (`Слк`, `Код`, `Название`, `Содержание`, `Ид_родитель`) 
SELECT 'Напр', '001', 'программирование', 'направление программирования', `Ид` 
FROM `Справка+` WHERE `Слк` = 'Фак' AND `Код` = '001';

SELECT "=== Справка+ Table Content ===" AS '';
SELECT * FROM `Справка+`;


DROP TABLE IF EXISTS `Сотрудник`;
CREATE TABLE `Сотрудник` (
 `Ид` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `Код` CHAR(10) NOT NULL UNIQUE,
 `Паспорт` CHAR(10) NOT NULL UNIQUE,
 `ФИО` VARCHAR(50) NOT NULL,
 `Ид_Должность` INT NOT NULL REFERENCES `Справка+` (`Ид`)
);

INSERT INTO `Сотрудник` (`Код`, `Паспорт`, `ФИО`, `Ид_Должность`) 
SELECT '001-П', '345678', 'Петров А. А.', `Ид` 
FROM `Справка+` WHERE `Слк` = 'ДОЛ' AND `Код` = 'про';

INSERT INTO `Сотрудник` (`Код`, `Паспорт`, `ФИО`, `Ид_Должность`) 
SELECT '002-П', '456789', 'Боширов Р. Р.', `Ид` 
FROM `Справка+` WHERE `Слк` = 'ДОЛ' AND `Код` = 'доц';

INSERT INTO `Сотрудник` (`Код`, `Паспорт`, `ФИО`, `Ид_Должность`) 
SELECT '099-В', '567890', 'Исаев М. М.', `Ид` 
FROM `Справка+` WHERE `Слк` = 'ДОЛ' AND `Код` = 'лаб';

SELECT "=== Сотрудник Table Content ===" AS '';
SELECT * FROM `Сотрудник`;



DROP TABLE IF EXISTS `Секретарь`;
CREATE TABLE `Секретарь` (
 `Ид` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `Ид_Кафедра` INT NOT NULL REFERENCES `Справка+` (`Ид`),
 `Ид_Сотрудник` INT NOT NULL UNIQUE REFERENCES `Сотрудник` (`Ид`)
);

INSERT INTO `Секретарь` (`Ид_Кафедра`, `Ид_Сотрудник`) 
SELECT s1.`Ид`, s2.`Ид` 
FROM `Справка+` s1, `Сотрудник` s2 
WHERE s1.`Слк` = 'Каф' AND s1.`Код` = '001' AND s2.`Код` = '001-П';

SELECT "=== Секретарь Table Content ===" AS '';
SELECT * FROM `Секретарь`;


DROP TABLE IF EXISTS `Руководитель`;
CREATE TABLE `Руководитель` (
 `Ид` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `Ид_Сотрудник` INT NOT NULL UNIQUE REFERENCES `Сотрудник` (`Ид`)
);

INSERT INTO `Руководитель` (`Ид_Сотрудник`) 
SELECT `Ид` FROM `Сотрудник` WHERE `Код` = '002-П';

SELECT "=== Руководитель Table Content ===" AS '';
SELECT * FROM `Руководитель`;


DROP TABLE IF EXISTS `Член_комиссии`;
CREATE TABLE `Член_комиссии` (
 `Ид` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `Ид_Сотрудник` INT NOT NULL UNIQUE REFERENCES `Сотрудник` (`Ид`)
);

INSERT INTO `Член_комиссии` (`Ид_Сотрудник`) 
SELECT `Ид` FROM `Сотрудник` WHERE `Код` = '099-В';

SELECT "=== Член_комиссии Table Content ===" AS '';
SELECT * FROM `Член_комиссии`;


DROP TABLE IF EXISTS `Абитуриент`;
CREATE TABLE `Абитуриент` (
 `Ид` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `Код` CHAR(10) NOT NULL UNIQUE,
 `Паспорт` CHAR(10) NOT NULL UNIQUE,
 `ФИО` VARCHAR(50) NOT NULL,
 `Дата_подачи_документов` DATE NOT NULL,
 `Дата_возврата_документов` DATE NULL,
 `Ид_Категория` INT NOT NULL REFERENCES `Справка+` (`Ид`),
 `Ид_Секретарь_принял` INT NOT NULL REFERENCES `Секретарь` (`Ид`),
 `Ид_Секретарь_возвратил` INT NULL REFERENCES `Секретарь` (`Ид`)
);

INSERT INTO `Абитуриент` (`Код`, `Паспорт`, `ФИО`, `Дата_подачи_документов`, `Дата_возврата_документов`, `Ид_Категория`, `Ид_Секретарь_принял`, `Ид_Секретарь_возвратил`) 
SELECT '001-Б', '123456', 'Иванов И. И.', '2025-06-15', NULL, s1.`Ид`, s2.`Ид`, NULL
FROM `Справка+` s1, `Секретарь` s2, `Сотрудник` s3
WHERE s1.`Слк` = 'КатА' AND s1.`Код` = '001' AND s3.`Код` = '001-П' AND s2.`Ид_Сотрудник` = s3.`Ид`;

INSERT INTO `Абитуриент` (`Код`, `Паспорт`, `ФИО`, `Дата_подачи_документов`, `Дата_возврата_документов`, `Ид_Категория`, `Ид_Секретарь_принял`, `Ид_Секретарь_возвратил`) 
SELECT '002-К', '234567', 'Сидоров С. С.', '2025-06-20', NULL, s1.`Ид`, s2.`Ид`, NULL
FROM `Справка+` s1, `Секретарь` s2, `Сотрудник` s3
WHERE s1.`Слк` = 'КатА' AND s1.`Код` = '002' AND s3.`Код` = '001-П' AND s2.`Ид_Сотрудник` = s3.`Ид`;

SELECT "=== Абитуриент Table Content ===" AS '';
SELECT * FROM `Абитуриент`;


DROP TABLE IF EXISTS `Документ_абитуриента`;
CREATE TABLE `Документ_абитуриента` (
 `Ид` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `Номер` CHAR(10) NOT NULL,
 `Ид_Абитуриент` INT NOT NULL REFERENCES `Абитуриент` (`Ид`),
 `Реквизиты` VARCHAR(100) NOT NULL,
 `Ид_Вид_документа` INT NOT NULL REFERENCES `Справка+` (`Ид`),
 CONSTRAINT `Ун1_Документ` UNIQUE (`Номер`, `Ид_Абитуриент`)
);

INSERT INTO `Документ_абитуриента` (`Номер`, `Ид_Абитуриент`, `Реквизиты`, `Ид_Вид_документа`) 
SELECT 'ДОК001', a.`Ид`, 'серия 1234 номер 567890', s.`Ид`
FROM `Абитуриент` a, `Справка+` s
WHERE a.`Код` = '001-Б' AND s.`Слк` = 'Вд' AND s.`Код` = '001';

INSERT INTO `Документ_абитуриента` (`Номер`, `Ид_Абитуриент`, `Реквизиты`, `Ид_Вид_документа`) 
SELECT 'ДОК002', a.`Ид`, 'серия 2345 номер 678901', s.`Ид`
FROM `Абитуриент` a, `Справка+` s
WHERE a.`Код` = '002-К' AND s.`Слк` = 'Вд' AND s.`Код` = '001';

SELECT "=== Документ_абитуриента Table Content ===" AS '';
SELECT * FROM `Документ_абитуриента`;


DROP TABLE IF EXISTS `Направление_абитуриента`;
CREATE TABLE `Направление_абитуриента` (
 `Ид` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `Ид_Абитуриент` INT NOT NULL REFERENCES `Абитуриент` (`Ид`),
 `Ид_Направление` INT NOT NULL REFERENCES `Справка+` (`Ид`),
 `Дата_время_выбора` DATETIME  NULL,
 `Рейтинг_абитуриента` INT NOT NULL,
 `Ид_Секретарь_зарегистрировал` INT NOT NULL REFERENCES `Секретарь` (`Ид`),
 CONSTRAINT `Ун1_Направление` UNIQUE (`Ид_Абитуриент`, `Ид_Направление`)
);
INSERT INTO `Направление_абитуриента` (`Ид_Абитуриент`, `Ид_Направление`, `Дата_время_выбора`, `Рейтинг_абитуриента`, `Ид_Секретарь_зарегистрировал`) 
SELECT a.`Ид`, s.`Ид`, '2025-06-15 10:30:00', 85, sec.`Ид`
FROM `Абитуриент` a, `Справка+` s, `Секретарь` sec, `Сотрудник` sotr
WHERE a.`Код` = '001-Б' AND s.`Слк` = 'Напр' AND s.`Код` = '001' 
  AND sotr.`Код` = '001-П' AND sec.`Ид_Сотрудник` = sotr.`Ид`;
INSERT INTO `Направление_абитуриента` (`Ид_Абитуриент`, `Ид_Направление`, `Дата_время_выбора`, `Рейтинг_абитуриента`, `Ид_Секретарь_зарегистрировал`) 
SELECT a.`Ид`, s.`Ид`, '2025-06-20 11:45:00', 92, sec.`Ид`
FROM `Абитуриент` a, `Справка+` s, `Секретарь` sec, `Сотрудник` sotr
WHERE a.`Код` = '002-К' AND s.`Слк` = 'Напр' AND s.`Код` = '001' 
  AND sotr.`Код` = '001-П' AND sec.`Ид_Сотрудник` = sotr.`Ид`;

SELECT "=== Направление_абитуриента Table Content ===" AS '';
SELECT * FROM `Направление_абитуриента`;


DROP TABLE IF EXISTS `Приказ_зачисления`;
CREATE TABLE `Приказ_зачисления` (
 `Ид` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `Регномер` CHAR(10) NOT NULL UNIQUE,
 `Дата_приказа` DATE NOT NULL,
 `Ид_Руководитель` INT NOT NULL REFERENCES `Руководитель` (`Ид`)
);

INSERT INTO `Приказ_зачисления` (`Регномер`, `Дата_приказа`, `Ид_Руководитель`) 
SELECT 'ПР001', '2025-07-01', r.`Ид`
FROM `Руководитель` r, `Сотрудник` s
WHERE s.`Код` = '002-П' AND r.`Ид_Сотрудник` = s.`Ид`;

SELECT "=== Приказ_зачисления Table Content ===" AS '';
SELECT * FROM `Приказ_зачисления`;


DROP TABLE IF EXISTS `Зачисленный_абитуриент`;
CREATE TABLE `Зачисленный_абитуриент` (
 `Ид` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `Ид_Абитуриент` INT NOT NULL UNIQUE REFERENCES `Абитуриент` (`Ид`),
 `Ид_Направление` INT NOT NULL REFERENCES `Направление_абитуриента` (`Ид`),
 `Ид_Приказ` INT NOT NULL REFERENCES `Приказ_зачисления` (`Ид`)
);

INSERT INTO `Зачисленный_абитуриент` (`Ид_Абитуриент`, `Ид_Направление`, `Ид_Приказ`) 
SELECT a.`Ид`, n.`Ид`, p.`Ид`
FROM `Абитуриент` a, `Направление_абитуриента` n, `Приказ_зачисления` p
WHERE a.`Код` = '001-Б' AND n.`Ид_Абитуриент` = a.`Ид` AND p.`Регномер` = 'ПР001';

SELECT "=== Зачисленный_абитуриент Table Content ===" AS '';
SELECT * FROM `Зачисленный_абитуриент`;


DROP TABLE IF EXISTS `Документ_подтверждающий_льготу`;
CREATE TABLE `Документ_подтверждающий_льготу` (
 `Ид` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `Ид_Документ` INT NOT NULL UNIQUE REFERENCES `Документ_абитуриента` (`Ид`)
);

INSERT INTO `Документ_подтверждающий_льготу` (`Ид_Документ`) 
SELECT d.`Ид`
FROM `Документ_абитуриента` d, `Абитуриент` a
WHERE d.`Номер` = 'ДОК001' AND a.`Код` = '001-Б' AND d.`Ид_Абитуриент` = a.`Ид`;

SELECT "=== Документ_подтверждающий_льготу Table Content ===" AS '';
SELECT * FROM `Документ_подтверждающий_льготу`;


DROP TABLE IF EXISTS `Льгота_абитуриента`;
CREATE TABLE `Льгота_абитуриента` (
 `Ид` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `Ид_Зачисленный` INT NOT NULL REFERENCES `Зачисленный_абитуриент` (`Ид`),
 `Ид_Льгота` INT NOT NULL REFERENCES `Справка+` (`Ид`),
 `Ид_Документ_льгота` INT NOT NULL REFERENCES `Документ_подтверждающий_льготу` (`Ид`),
 CONSTRAINT `Ун1_Льгота` UNIQUE (`Ид_Зачисленный`, `Ид_Льгота`)
);

INSERT INTO `Льгота_абитуриента` (`Ид_Зачисленный`, `Ид_Льгота`, `Ид_Документ_льгота`) 
SELECT z.`Ид`, s.`Ид`, dl.`Ид`
FROM `Зачисленный_абитуриент` z, `Справка+` s, `Документ_подтверждающий_льготу` dl, `Документ_абитуриента` d, `Абитуриент` a
WHERE a.`Код` = '001-Б' AND z.`Ид_Абитуриент` = a.`Ид` 
  AND s.`Слк` = 'Льг' AND s.`Код` = '001'
  AND d.`Номер` = 'ДОК001' AND d.`Ид_Абитуриент` = a.`Ид` AND dl.`Ид_Документ` = d.`Ид`;

SELECT "=== Льгота_абитуриента Table Content ===" AS '';
SELECT * FROM `Льгота_абитуриента`;


DROP TABLE IF EXISTS `Приказ_апелляционной_комиссии`;
CREATE TABLE `Приказ_апелляционной_комиссии` (
 `Ид` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `Регномер` CHAR(10) NOT NULL UNIQUE,
 `Дата_приказа` DATE NOT NULL,
 `Ид_Руководитель` INT NOT NULL REFERENCES `Руководитель` (`Ид`)
);

INSERT INTO `Приказ_апелляционной_комиссии` (`Регномер`, `Дата_приказа`, `Ид_Руководитель`) 
SELECT 'ПР002', '2025-07-02', r.`Ид`
FROM `Руководитель` r, `Сотрудник` s
WHERE s.`Код` = '002-П' AND r.`Ид_Сотрудник` = s.`Ид`;

SELECT "=== Приказ_апелляционной_комиссии Table Content ===" AS '';
SELECT * FROM `Приказ_апелляционной_комиссии`;


DROP TABLE IF EXISTS `Апелляционная_комиссия`;
CREATE TABLE `Апелляционная_комиссия` (
 `Ид` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `Регномер` CHAR(10) NOT NULL UNIQUE,
 `Ид_Приказ` INT NOT NULL REFERENCES `Приказ_апелляционной_комиссии` (`Ид`)
);

INSERT INTO `Апелляционная_комиссия` (`Регномер`, `Ид_Приказ`) 
SELECT 'АК001', p.`Ид`
FROM `Приказ_апелляционной_комиссии` p
WHERE p.`Регномер` = 'ПР002';

SELECT "=== Апелляционная_комиссия Table Content ===" AS '';
SELECT * FROM `Апелляционная_комиссия`;


DROP TABLE IF EXISTS `Заседание_комиссии`;
CREATE TABLE `Заседание_комиссии` (
 `Ид` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `Номер` CHAR(10) NOT NULL,
 `Ид_Апелляционная_комиссия` INT NOT NULL REFERENCES `Апелляционная_комиссия` (`Ид`),
 `Дата` DATE NOT NULL,
 CONSTRAINT `Ун1_Заседание` UNIQUE (`Номер`, `Ид_Апелляционная_комиссия`)
);

INSERT INTO `Заседание_комиссии` (`Номер`, `Ид_Апелляционная_комиссия`, `Дата`) 
SELECT '001', a.`Ид`, '2025-07-05'
FROM `Апелляционная_комиссия` a
WHERE a.`Регномер` = 'АК001';

SELECT "=== Заседание_комиссии Table Content ===" AS '';
SELECT * FROM `Заседание_комиссии`;


DROP TABLE IF EXISTS `Апеллянт`;
CREATE TABLE `Апеллянт` (
 `Ид` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `Ид_Абитуриент` INT NOT NULL UNIQUE REFERENCES `Абитуриент` (`Ид`)
);

INSERT INTO `Апеллянт` (`Ид_Абитуриент`) 
SELECT `Ид` FROM `Абитуриент` WHERE `Код` = '002-К';

SELECT "=== Апеллянт Table Content ===" AS '';
SELECT * FROM `Апеллянт`;


DROP TABLE IF EXISTS `Апелляция`;
CREATE TABLE `Апелляция` (
 `Ид` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `Регномер` CHAR(10) NOT NULL UNIQUE,
 `Ид_Апеллянт` INT NOT NULL REFERENCES `Апеллянт` (`Ид`),
 `Ид_Заседание` INT NOT NULL REFERENCES `Заседание_комиссии` (`Ид`),
 `Содержание_претензии` TEXT NOT NULL,
 `Решение_комиссии` TEXT NULL,
 `Ид_Вид_претензии` INT NOT NULL REFERENCES `Справка+` (`Ид`)
);

INSERT INTO `Апелляция` (`Регномер`, `Ид_Апеллянт`, `Ид_Заседание`, `Содержание_претензии`, `Решение_комиссии`, `Ид_Вид_претензии`) 
SELECT 'АП001', ap.`Ид`, z.`Ид`, 'Несогласие с результатами экзамена', 'Отклонена', s.`Ид`
FROM `Апеллянт` ap, `Заседание_комиссии` z, `Апелляционная_комиссия` ak, `Справка+` s
WHERE ap.`Ид_Абитуриент` = (SELECT `Ид` FROM `Абитуриент` WHERE `Код` = '002-К')
  AND z.`Номер` = '001' AND ak.`Регномер` = 'АК001' AND z.`Ид_Апелляционная_комиссия` = ak.`Ид`
  AND s.`Слк` = 'ВПрт' AND s.`Код` = '001';

SELECT "=== Апелляция Table Content ===" AS '';
SELECT * FROM `Апелляция`;


DROP TABLE IF EXISTS `Члены_комиссии_на_заседании`;
CREATE TABLE `Члены_комиссии_на_заседании` (
 `Ид` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `Ид_Член_комиссии` INT NOT NULL REFERENCES `Член_комиссии` (`Ид`),
 `Ид_Заседание` INT NOT NULL REFERENCES `Заседание_комиссии` (`Ид`),
 `Роль` VARCHAR(50) NOT NULL,
 CONSTRAINT `Ун1_Члены_заседание` UNIQUE (`Ид_Член_комиссии`, `Ид_Заседание`)
);

INSERT INTO `Члены_комиссии_на_заседании` (`Ид_Член_комиссии`, `Ид_Заседание`, `Роль`) 
SELECT ch.`Ид`, z.`Ид`, 'эксперт'
FROM `Член_комиссии` ch, `Заседание_комиссии` z, `Апелляционная_комиссия` ak, `Сотрудник` s
WHERE s.`Код` = '099-В' AND ch.`Ид_Сотрудник` = s.`Ид`
  AND z.`Номер` = '001' AND ak.`Регномер` = 'АК001' AND z.`Ид_Апелляционная_комиссия` = ak.`Ид`;

SELECT "=== Члены_комиссии_на_заседании Table Content ===" AS '';
SELECT * FROM `Члены_комиссии_на_заседании`;


