-- 导员获取自己管理的类别
explain
select *
from user_category_relation ucr
    inner join category c ON ucr.category_id = c.category_id
    inner join college col ON c.college_id = col.college_id
    inner join     user u ON ucr.user_id = u.user_id
where u.role = '导员'
  and ucr.permission_type = 'manage'
  and u.user_id = 'TCH000001';


#导员查询审核状态信息
explain
select
    u.user_id,
    u.user_name,
    m.major_name,
    rn.rule_node_name,
    rnl.level_name,
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
where sr.teacher_id = 'TCH000003'
