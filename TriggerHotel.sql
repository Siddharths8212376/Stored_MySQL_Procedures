/*mysql> describe Book;
+-------------+-------------+------+-----+---------+-------+
| Field       | Type        | Null | Key | Default | Extra |
+-------------+-------------+------+-----+---------+-------+
| bid         | int(11)     | NO   | PRI | NULL    |       |
| hid         | int(11)     | YES  | MUL | NULL    |       |
| book_date   | date        | YES  |     | NULL    |       |
| rcat        | varchar(40) | YES  |     | NULL    |       |
| nrooms      | int(11)     | YES  |     | NULL    |       |
| vacate_date | date        | YES  |     | NULL    |       |
+-------------+-------------+------+-----+---------+-------+
6 rows in set (0.00 sec)

mysql> describe Hotel_info;
+--------------+-------------+------+-----+---------+-------+
| Field        | Type        | Null | Key | Default | Extra |
+--------------+-------------+------+-----+---------+-------+
| hid          | int(11)     | NO   | PRI | NULL    |       |
| room_cat     | varchar(40) | YES  |     | NULL    |       |
| rent         | int(11)     | YES  |     | NULL    |       |
| availability | int(11)     | YES  |     | NULL    |       |
+--------------+-------------+------+-----+---------+-------+
4 rows in set (0.00 sec)*/

delimiter // 
create trigger insertTrig after insert on Book 
for each row
begin
update Hotel_info set availability=availability-NEW.nrooms where Hotel_info.hid=NEW.hid;
end//

delimiter //
drop procedure if exists vacdat;
create procedure vacdat(b_id int)
begin
declare done int default 0;
declare vacdat date;
declare bdate date;

declare cur cursor for select book_date from Book where bid=b_id;
declare continue handler for not found set done=1;
open cur;
readloop:loop
fetch cur into bdate;
if done=1 then
leave readloop;
end if;
set vacdat=date_add(bdate, interval 7 day);
end loop;
update Book set vacate_date=vacdat where bid=b_id;
close cur;
end//
