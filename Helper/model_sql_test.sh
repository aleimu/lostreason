// sql常用命令

drop table runoob_tbl ;
create table student( 
id number primary key, 
name varchar2(50) not null);//建表 

create view view_name as 
select * from table_name;//建视图 
create unique index index_name on tablename(col_name);//建索引 
insert into tablename {column1,column2,…} values(exp1,exp2,…);//插入 
insert into viewname {column1,column2,…} values(exp1,exp2,…);//插入视图实际影响表 
update tablename set name=’zang 3’ condition;//更新数据 
delete from tablename where condition;//删除 
grant (select,delete,…) on (对象) to user_name [with grant option];//授权 
revoke (权限表) on(对象) from user_name [with revoke option] //撤权 
列出工作人员及其领导的名字： 
select e.name, s.name from employee e s 
where e.supername=s.name
show create table student; #查看建表语句
desc student; #查看表结构

/*
MySQL保存boolean值时用1代表TRUE，0代表FALSE。boolean在mysql里的类型为tinyint(1)。MySQL里有四个常量：true,false,TRUE,FALSE分别代表1,0,1,0。
create table test
(
   id int primary key,
   bl boolean
)
这样是可以创建成功。查看建表后的语句会发现，mysql把它替换成tinyint(1)


int[(m)] [unsigned] [zerofill]   m默认为11,占4个字节
普通大小的整数。带符号的范围是-2147483648到2147483647。无符号的范围是0到4294967295。
bigint[(m)] [unsigned] [zerofill] m默认为20,占8个字节
大整数。带符号的范围是-9223372036854775808到9223372036854775807。无符号的范围是0到18446744073709551615。
注意：这里的m代表的并不是存储在数据库中的具体的长度，以前总是会误以为int(3)只能存储3个长度的数字，int(11)就会存储11个长度的数字，这是大错特错的。

tinyint(1) 和 tinyint(4) 中的1和4并不表示存储长度，只有字段指定zerofill是有用，
如tinyint(4)，如果实际值是2，如果列指定了zerofill，查询结果就是0002，左边用0来填充。


char是一种固定长度的类型，varchar则是一种可变长度的类型，它们的区别是：
char(m)类型的数据列里，每个值都占用m个字节，如果某个长度小于m，mysql就会在它的右边用空格字符补足．
（在检索操作中那些填补出来的空格字符将被去掉）
在varchar(m)类型的数据列里，每个值只占用刚好够用的字节再加上一个用来记录其长度的字节（即总长度为l+1字节）．
*/

// comment 是添加注释的意思
// 雪球/微博/微信：0/1/2

/*用户表*/
create table if not exists `account` (
  `user_id` int primary key auto_increment comment '账号索引，唯一',
  `username` varchar(255) not null comment '用户名，电话号等',
  `password` varchar(255) not null comment '登陆时必须的参数',
  `status` tinyint(1) not null comment '账号是否可用',
  `create_time` timestamp not null default current_timestamp on update current_timestamp comment '账号创建的时间',
  `last_login` time not null comment '上次登陆时间',
  `account_type` tinyint(1) not null comment '账号的类型，雪球/微博/微信：0/1/2',
  `cookie` varchar(1200) default null comment '登陆状态的cookie，对外提供登陆保持'
) engine=innodb default charset=utf8;

/*基础的增删改查操作*/
insert into account values(null,'lgj','passwd_lgj',1,null,'2018-04-03 14:28:08',1,"ikut=6399; baiduid=7a6fcff0b2b0c7b45df3e0e025ed0e75:fg=1; bidupsid=7a6fcff0b2b0c7b45df3e0e025ed0e75; pstm=1522986530; hm_lvt_6859ce5aaf00fb00387e6434e4fcc925=1522989588,1522990333; hm_lpvt_6859ce5aaf00fb00387e6434e4fcc925=1522990333; psino=5; h_ps_pssid=1429_21083_20882_20927; bdorz=b490b5ebf6f3cd402e515d22bcda1598");
insert into account values(null,'lgj1','passwd_lgj1',2,null,'2018-04-03 14:28:08',0,"baiduid=7a6fcff0b2b0c7b45df3e0e025ed0e75:fg=1; bidupsid=7a6fcff0b2b0c7b45df3e0e025ed0e75; pstm=1522986530; panweb=1; bdorz=b490b5ebf6f3cd402e515d22bcda1598; bdrcvfr[fewj1vr5u3d]=i67x6tjhwwyf0; psino=5; h_ps_pssid=1429_21083_20882_20927; hm_lvt_7a3960b6f067eb0085b7f96ff5e660b0=1522987626,1522987708; hm_lpvt_7a3960b6f067eb0085b7f96ff5e660b0=1522996283; hm_lvt_f5f83a6d8b15775a02760dc5f490bc47=1522996284; hm_lpvt_f5f83a6d8b15775a02760dc5f490bc47=1522996284");
delete from account where userid=2;
select user_id,username,password,status,account_type,cookie from account where user_id=1;

/*公众号表*/
create table if not exists `public`(
    public_id int primary key auto_increment comment '公众号索引id',
    public_name varchar(100) not null comment '公众号名字',
    status tinyint(1) not null comment '公众号订阅状态未订阅，已订阅，拉黑:0,1,2',
    public_type tinyint not null comment '公众号类型 雪球/微博/微信：0/1/2',
    article_number int(3) not null comment '公众号发文总数', 
    last_published timestamp not null default current_timestamp on update current_timestamp comment '最近一次的发文时间',
    subscriber int not null comment '订阅者,account.user_id,不漏订阅,不重复订阅'
) engine=innodb default charset=utf8;

insert into public values(null,"知乎财经",1,2,1000,null,1);
insert into public values(null,"知乎",122,120,102200,null,1);
select  public_name, status, public_type, article_number, last_published, subscriber from public where public_id=1;
delete from public where public_id=2;



