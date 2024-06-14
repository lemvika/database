/*Реалізувати набір тригерів, що реалізують такі ділові правила:*/
/*1. Кількість тем може бути в діапазоні від 5 до 10*/
DELIMITER $$
CREATE TRIGGER trig1 BEFORE DELETE ON topic
FOR EACH ROW
    IF (SELECT COUNT(*) FROM topic) > 10
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Кількість більша 10';
    ELSEIF (select count(*) from topic) < 5
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Кількість менша за 5';
END IF;
$$ DELIMITER ;


/*2. Новинкою може бути тільки книга видана в поточному році.*/
DELIMITER $$
CREATE TRIGGER trig2 BEFORE UPDATE ON book
IF (NEW.new && YEAR(NEW.datee) != YEAR(NOW()))
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Новинкою може бути лише книга видана в поточному році';
END IF
$$ DELIMITER ;


/*3. Книга з кількістю сторінок до 100 не може коштувати більше 10 $, до 200 - 20 $, до 300 - 30 $.*/
DELIMITER $$
CREATE TRIGGER trig3 BEFORE UPDATE ON book
IF (
    (NEW.price > 10 AND NEW.pages < 100) OR
    (NEW.price > 20 AND NEW.pages < 200) OR
    (NEW.price > 30 AND NEW.pages < 300))
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Несумісна ціна та кількість сторінок';
END IF
$$ DELIMITER ;


/*4. Видавництво "BHV" не випускає книги накладом меншим 5000, а видавництво Diasoft - 10000*/
DELIMITER $$
CREATE TRIGGER trig4 BEFORE UPDATE ON book
IF (
    (NEW.id_publishing = 1 AND NEW.circulation < 5000) OR
    (NEW.id_publishing = 5 AND NEW.circulation < 1000))
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Занадто мале значення circulation для вказаного видавництва';
END IF;
$$ DELIMITER ;


/*5. Книги з однаковим кодом повинні мати однакові дані.*/
DELIMITER $$
CREATE TRIGGER trig5 BEFORE INSERT ON book
FOR EACH ROW
BEGIN
    SET @recordsCount = 0;
    SELECT COUNT(*) INTO @recordsCount
    FROM book
    WHERE code = NEW.code AND (
        n != NEW.n OR
        new != NEW.new OR
        name != NEW.name OR
        price != NEW.price OR
        id_publisher != NEW.id_publishing OR
        pages != NEW.pages_count OR
        format != NEW.format OR
        date != NEW.datee OR
        circulation != NEW.circulation OR
        id_topic != NEW.id_topic OR
        id_category != NEW.id_category);

    IF (@recordsCount != 0) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Книги з однаоквим кодом мають мати однакові дані';
    END IF;
END $$ DELIMITER ;


/*6. При спробі видалення книги видається інформація про кількість видалених рядків. Якщо користувач не "dbo", то видалення забороняється.*/
DELIMITER $$
CREATE TRIGGER trig6 BEFORE DELETE ON book
FOR EACH ROW
BEGIN
    IF (REGEXP_SUBSTR(TRIM(CURRENT_USER()), '^[^\@]+') != 'root') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Лише користувачу dbo дозволено видаляти книги';
    ELSE
        SET @columnsCount = 0;
        SELECT count(*) INTO @columnsCount FROM information_schema.`COLUMNS`
        WHERE table_name = 'book' AND TABLE_SCHEMA = "labs";
    END IF;
END $$ DELIMITER ;


/*7. Користувач "dbo" не має права змінювати ціну книги.*/
DELIMITER $$
CREATE TRIGGER trig7 BEFORE UPDATE ON book
FOR EACH ROW
BEGIN
    IF (REGEXP_SUBSTR(TRIM(CURRENT_USER()), '^[^\@]+') = 'root' AND NEW.price != NEW.price) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Користувач не має права змінювати ціну книги';
    END IF;
END $$ DELIMITER ;


/*8. Видавництва ДМК і Еком підручники не видають.*/
DELIMITER $$
CREATE TRIGGER trig8 BEFORE INSERT ON book
FOR EACH ROW
BEGIN
    IF ((NEW.id_publishing IN (5, 7)) AND NEW.id_category = 1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Вказані видавництва не видають підручники';
    END IF;
END $$ DELIMITER ;


/*9. Видавництво не може випустити більше 10 новинок протягом одного місяця поточного року*/
DELIMITER $$
CREATE TRIGGER trig9 BEFORE INSERT ON book
FOR EACH ROW
BEGIN
    SET @publisher_novelties_count = 0;
    SELECT COUNT(*) INTO @publisher_novelties_count
    FROM book
    WHERE NEW.id_publishing = NEW.id_publishing AND NEW.new AND YEAR(NOW()) = YEAR(NEW.datee) AND MONTH(NOW()) = MONTH(NEW.datee);
    IF (NEW.new AND @publisher_novelties_count IS NOT NULL AND @publisher_novelties_count > 10) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Видавництво не може видати більше 10 новинок за місяць';
    END IF;
END $$ DELIMITER ;


/*10. Видавництво BHV не випускає книги формату 60х88/16.*/
DELIMITER $$
CREATE TRIGGER trig10 BEFORE UPDATE ON book
FOR EACH ROW
BEGIN
    IF (NEW.id_publishing = 1 AND NEW.format = 3) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Вказане видавництво не видає кнниги в даному форматі';
    END IF;
END $$ DELIMITER ;