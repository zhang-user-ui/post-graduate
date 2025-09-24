#查找根节点
explain#全表查询
select *
from rule_node rn
where rn.parent_node_id = '0';

#根据根节点查找子节点
explain
select *
from rule_node rn join rule_node_level rnl
where rn.category_id = 'CAT000001' and rn.rule_node_id = 'RUL000001';
