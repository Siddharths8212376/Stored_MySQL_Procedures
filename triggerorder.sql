/*mysql> describe ordrn;
+-------+-------------+------+-----+---------+----------------+
| Field | Type        | Null | Key | Default | Extra          |
+-------+-------------+------+-----+---------+----------------+
| oid   | int(11)     | NO   | PRI | NULL    | auto_increment |
| oname | varchar(40) | YES  |     | NULL    |                |
| mid   | int(11)     | YES  | MUL | NULL    |                |
| qty   | int(11)     | YES  |     | NULL    |                |
+-------+-------------+------+-----+---------+----------------+
4 rows in set (0.00 sec)

mysql> describe stock_update;
+----------+---------+------+-----+---------+----------------+
| Field    | Type    | Null | Key | Default | Extra          |
+----------+---------+------+-----+---------+----------------+
| sid      | int(11) | NO   | PRI | NULL    | auto_increment |
| itid     | int(11) | YES  | MUL | NULL    |                |
| quantity | int(11) | YES  |     | NULL    |                |
+----------+---------+------+-----+---------+----------------+
3 rows in set (0.00 sec)*/



delimiter //
create trigger trig after insert on ordrn
for each row
begin
update mat_master set stock=stock-NEW.qty where mat_master.mid=NEW.mid;
end//


delimiter //
drop procedure if exists update_stock;
create procedure update_stock(name varchar(40) , m_id int, q_ty int)
begin
insert into ordrn values(null,name,m_id,q_ty);
end//