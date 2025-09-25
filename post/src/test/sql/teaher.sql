-- 导员获取自己管理的类别
explain
select co.college_name,c.category_name,c.weighted_score_ratio, c.other_score_ratio
from user_category_relation ucr
    left join category c on ucr.category_id = c.category_id
    left join college co on c.college_id = co.college_id
    left join user u on ucr.user_id = u.user_id
where u.role = '导员'
  and ucr.permission_type = 'manage'
  and u.user_id = 'TCH000001';

#学院管理员获取类别信息
explain
select co.college_name,c.category_name, c.weighted_score_ratio, c.other_score_ratio
from category c
left join college co on co.college_id = c.college_id
order by co.college_name,c.category_name;

#学院管理员修改推免规则
update rule_node rn
    left join user a on a.category_id = rn.category_id
    left join college c on c.college_id = a.college_id
set max_score = 20.00 #原来是10
where rule_node_name = '科技竞赛I'
  and a.user_id = 'ADM000001'
  and a.role = '计算机与控制工程学院管理员';

#学院管理员查询专业下全部学生的统计信息
explain
select
    m.major_name as 专业名称,
    u.user_name as 学生姓名,
    sum(case when sr.status = 2 then sr.teacher_score else 0 end) as 已认定成绩,
    sum(case when sr.status = 2 then 1 else 0 end) as 已认定项,
    sum(case when sr.status = 1 then 1 else 0 end) as 待审核项,
    sum(case when sr.status = 3 then 1 else 0 end) as 已驳回项,
    count(*) as 总提交项
from student_record sr
left join user u on sr.student_id = u.user_id
left join major m on u.major_id = m.major_id
where u.role = '学生'
group by m.major_name, u.user_name;

#导员查询审核状态信息
explain
select
    u.user_id,
    u.user_name,
    m.major_name,
    sr.weighted_score,
    sr.ranking,
    case sr.status
        when 0 then '待提交'
        when 1 then '待审核'
        when 2 then '审核通过'
        when 3 then '审核不通过'
        end as 审核状态，
from student_record sr
         left join user u on sr.student_id = u.user_id and u.role = '学生'
         left join major m on sr.major_id = m.major_id
         left join rule_node rn on sr.rule_node_id = rn.rule_node_id
         left join rule_node_level rnl on sr.level_id = rnl.level_id
         left join application_material am on sr.record_id = am.record_id
where sr.teacher_id = 'TCH000003';


