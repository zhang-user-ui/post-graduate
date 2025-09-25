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

#导员查看自己管理专业下所有学生成绩统计信息,按排名排序
explain
select
    m.major_name as 专业名称,
    u.user_name as 学生姓名,
    avg(sr.weighted_score) as 加权成绩,
    min(sr.ranking) as 专业排名,
    sum(case when sr.status = 2 then sr.teacher_score else 0 end) as 已认定成绩,
    sum(case when sr.status = 2 then 1 else 0 end) as 已认定项,
    sum(case when sr.status = 1 then 1 else 0 end) as 待审核项,
    sum(case when sr.status = 3 then 1 else 0 end) as 已驳回项,
    count(*) as 总提交项
from student_record sr
         left join user u on sr.student_id = u.user_id
         left join major m on u.major_id = m.major_id
where sr.teacher_id = 'TCH000001' and u.role = '学生' and u.major_id = 'MAJ000001' and u.category_id = 'CAT000001'
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


