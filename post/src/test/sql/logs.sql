#查询学生的审核日志
explain
select *
from review_log rl
left join user t on rl.teacher_id = t.user_id
where rl.student_id = 'STU2022003';
