-- 超级管理员查看指定类别下的所有学生信息
explain
select *
from user u
left join major m on u.major_id = m.major_id
left join category c on u.category_id = c.category_id
left join college col on c.college_id = col.college_id
where u.role = '学生' and c.category_id = 'CAT00000';