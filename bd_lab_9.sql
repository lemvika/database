/*1. Розробити та перевірити скалярну (scalar) функцію, що повертає загальну вартість книг виданих в певному році.*/
CREATE FUNCTION avgPrice(yearParam INT)
RETURNS DECIMAL
DETERMINISTIC
RETURN (
    SELECT SUM(book.price)
    FROM book
    WHERE YEAR(book.datee) = yearParam);

-- SELECT avgPrice(2000);


/*2. Розробити і перевірити табличну (inline) функцію, яка повертає список книг виданих в певному році.
- mysql doesn't support returning tables from function*/

CREATE FUNCTION getbook(yearParam INT)
RETURNS TABLE
DETERMINISTIC
RETURN (
   SELECT *
   FROM book
   WHERE YEAR(book.datee) = yearParam);


/*3. Розробити і перевірити функцію типу multi-statement, яка буде:
a. приймати в якості вхідного параметра рядок, що містить список назв видавництв, розділених символом ‘;’;
b. виділяти з цього рядка назву видавництва;
c. формувати нумерований список назв видавництв.*/

/*This function also should return table, what isn't supported by MySQL*/


/*4. Виконати набір операцій по роботі з SQL курсором: оголосити курсор;
	a. використовувати змінну для оголошення курсору;
	b. відкрити курсор;
	c. переприсвоїти курсор іншої змінної;
	d. виконати вибірку даних з курсору;
	e. закрити курсор;
5. звільнити курсор. Розробити курсор для виводу списка книг виданих у визначеному році.

4, 5 - but MySQL has limited support of returning tables*/

/*links to documentation:
https://dev.mysql.com/doc/refman/5.7/en/create-function-loadable.html
https://stackoverflow.com/questions/23421771/how-to-return-table-from-mysql-function
*/


DELIMITER $$
CREATE PROCEDURE getBook (
	INOUT bookNamesList varchar(4000),
    IN publishedYear INT)
BEGIN
    DECLARE finished INTEGER DEFAULT 0;
    DECLARE currBookName varchar(255) DEFAULT "";

    DEClARE yearbook 
        CURSOR FOR 
            SELECT book_name FROM book WHERE YEAR(book.datee) = publishedYear;

    DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;

    OPEN yearbook;
    getbookLoop: LOOP
        FETCH yearbook INTO currBookName;
        IF finished = 1 THEN 
            LEAVE getbookLoop;
        ELSE
            SET bookNamesList = CONCAT(bookNamesList, ', ', currBookName);
        END IF;
    END LOOP getbookLoop;
    CLOSE yearbook;

END $$ DELIMITER ;

SET @bookNames = '';
CALL getBook(@bookNames, 2000);