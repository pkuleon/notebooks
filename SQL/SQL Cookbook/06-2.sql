-- 6.8 按字符串中的部分内容排序
-- Q：按照姓名的最后两个字符排序：
-- 解决方案：substr 函数 
select ename ,substr(ename,length(ename)-1) 
  from emp 
 order by substr(ename,length(ename)-1); 

-- 6.9 按字符串中的数值排序
create view v_6_2 as 
       select m.ename||'  '||cast(m.empno as char(4))||'  '||t.dname as data 
        from emp m, dept t
       where m.deptno = t.deptno; 
       
select data,translate(data,'0123456789','##########'),
       replace(
       translate(data,'0123456789','##########'),
                 '#'),
       translate(data,
         replace(
       translate(data,'0123456789','##########'),
                 '#'),rpad('#',20,'#'))            
                 
  from v_6_2 
       order by 
       replace(
       translate(data,
         replace(
       translate(data,'0123456789','##########'),
                 '#'),rpad('#',20,'#')),'#');       
                 
-- 6.10 根据表中的行创建一个分隔列表
-- Q：要求将表中的行作为一个分隔列表中的值，分解符可能是逗号而不是通常使用的竖线。
-- MySQL 使用 group_concat 来构建分隔列表
select deptno,
       group_concat(ename order by empno separator,',') as emps 
  from emp 
 group by deptno;      

-- Oracle 使用 sys_connect_by_path 
select deptno,
       ltrim(sys_connect_by_path(ename,','),',') emps 
  from (
  select deptno,
         ename,
         row_number() over 
                      (partition by deptno order by empno ) rn,
         count(*) over
                  (partition by deptno) cnt 
    from emp 
    ) 
 where level = cnt 
 start with rn = 1 
 connect by prior deptno = deptno and prior rn = rn-1;                                            

-- 要理解Oracle查询，首先要对它进行拆分。
-- 单独运行内联视图，就可以得到每个员工的如下信息：
-- 所在部门、姓名、按empno升序在部门中的序号以及部门员工数 。

select deptno,
       ename,
       row_number() over 
                    (partition by deptno order by empno) rn,
       count(1) over (partition by deptno ) cnt 
  from emp;                  
 
-- 6.11 


 
