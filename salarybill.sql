/* mysql> describe salary_bill;
+-----------+---------+------+-----+---------+-------+
| Field     | Type    | Null | Key | Default | Extra |
+-----------+---------+------+-----+---------+-------+
| eid       | int(11) | YES  | MUL | NULL    |       |
| total_sal | int(11) | YES  |     | NULL    |       |
| incr_date | date    | YES  |     | NULL    |       |
+-----------+---------+------+-----+---------+-------+
3 rows in set (0.05 sec)

mysql> describe Employee;
+-----------+---------+------+-----+---------+-------+
| Field     | Type    | Null | Key | Default | Extra |
+-----------+---------+------+-----+---------+-------+
| eid       | int(11) | NO   | PRI | NULL    |       |
| basic_pay | int(11) | YES  |     | NULL    |       |
| da        | int(11) | YES  |     | NULL    |       |
| hra       | int(11) | YES  |     | NULL    |       |
| doj       | date    | YES  |     | NULL    |       |
+-----------+---------+------+-----+---------+-------+
5 rows in set (0.00 sec)*/


delimiter //
drop procedure if exists calc_sal;
create procedure calc_sal(e_id int)
begin
declare done int default 0;
declare Da int;
declare Hra int;
declare DOJ date;
declare bpay int;
declare tsa int;
declare diffdate int;
declare incdate date;

declare cur cursor for select basic_pay, da , hra, doj from Employee where eid=e_id;
declare continue handler for not found set done=1;
open cur;
readloop:loop
fetch cur into bpay,Da,Hra,DOJ;
if done=1 then 
leave readloop;
end if;
select bpay,Da,Hra;
set tsa=bpay+Da+Hra;

set diffdate=datediff('2019/12/30',curdate());
set incdate=date_add(curdate(), interval diffdate day);

end loop;
close cur;
select tsa,incdate;
update salary_bill set total_sal=tsa where eid=e_id;
update salary_bill set incr_date=incdate where eid=e_id;

end //
