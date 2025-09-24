-- 学生查询所属类别下的所有一级指标信息
explain
select
    rn.rule_node_id,
    rn.rule_node_name,
    rn.max_score,
    rn.department,
    rn.score_rule,
    rnl.level_id,
    rnl.level_name,
    rnl.level_score,
    rnl.level_desc,
    c.category_id,
    c.category_name
from rule_node rn
left join category c on rn.category_id = c.category_id
left join rule_node_level rnl on rn.rule_node_id = rnl.rule_node_id
and rn.category_id = rnl.category_id
left join user u ON c.category_id = u.category_id
where rn.level = 1
  and rn.parent_node_id = '0'
  and u.user_id = 'STU2022001';

#学生查询审核状态信息
select
    sr.record_id,
    sr.weighted_score,
    sr.ranking,
case sr.status
when 0 then '待提交'
when 1 then '待导员审核'
when 2 then '审核通过'
when 3 then '审核不通过'
end as 审核状态，
from student_record sr
left join rule_node rn on sr.rule_node_id = rn.rule_node_id
left join rule_node_level rnl on rnl.level_id = sr.level_id
left join application_material am on am.record_id = sr.record_id
left join user t on sr.teacher_id = t.user_id
left join review_log rl on rl.record_id = sr.record_id
where sr.student_id = 'STU2022005'
GROUP BY
    sr.record_id,sr.weighted_score, sr.ranking, sr.status



