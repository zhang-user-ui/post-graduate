#拼接材料存储路径
explain
select
    concat_ws(
    '/',
    co.college_name,
    c.category_name,
    m.major_name,
    concat(u.user_name,'-',u.user_id)
    ) as material_path
from user u
left join major m on u.major_id = m.major_id
left join category c on c.category_id = u.category_id
left join college co on co.college_id = u.college_id
where u.user_id = 'STU2022001' and u.role = '学生';

#拼接材料加分记录的材料文件名
select
    concat(
    concat_ws(
    '-',
    rn.rule_node_name,
    rnl.level_name,
    sr.record_id
    ),
    '.',
    lower(am.material_type)
    ) as material_filename
from student_record sr
left join rule_node rn on sr.rule_node_id = rn.rule_node_id
left join rule_node_level rnl on rnl.rule_node_id = sr.rule_node_id
left join application_material am on am.record_id = sr.record_id
where sr.record_id = 'REC2024003'