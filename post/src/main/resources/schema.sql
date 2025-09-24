-- 学院信息表
create table if not exists college
(
    college_id char(19) primary key comment '学院ID',
    college_name varchar(70) not null comment '学院名称',
    create_time datetime not null default current_timestamp comment '创建时间',
    update_time datetime not null default current_timestamp comment '更新时间',
    index(college_name)

);
-- 类别表
create table if not exists category
(
    category_id char(19) primary key comment '类别id',
    college_id varchar(70) not null comment '所属学院id',
    category_name varchar(50) unique not null comment '类别名称',
    weighted_score_ratio JSON not null comment '加权平均成绩占比',
    other_score_ratio JSON not null comment '细则成绩占比',
    create_time datetime not null default current_timestamp comment '创建时间',
    update_time datetime not null default current_timestamp comment '更新时间',
    index(category_name)

);
-- 专业表
create table if not exists major
(
    major_id char(19) primary key comment '专业id',
    major_name varchar(70) unique not null comment '专业名称',
    category_id char(19) not null comment '所属类别id',
    create_time datetime not null default current_timestamp comment '创建时间',
    update_time datetime not null default current_timestamp comment '更新时间',
    index(major_name)
);
-- 用户表
create table if not exists user
(
    user_id char(19) primary key comment '学号/工号',
    user_name varchar(70) not null comment '姓名',
    password varchar(100) not null comment '密码',
    role varchar(70) not null comment '角色（导员，学生，超级管理员）',
    college_id char(19) not null comment '所属学院id',
    category_id char(19) not null comment '所属类别id',
    major_id char(19) not null comment '所属专业id',
    phone_number char(11) not null comment '联系电话',
    email varchar(20) not null comment '邮箱',
    create_time datetime not null default current_timestamp comment '创建时间',
    update_time datetime not null default current_timestamp comment '更新时间',
    index(user_id,user_name)

);
-- 用户与类别关系表
create table if not exists user_category_relation
(
    relation_id char(19) primary key comment '关系记录ID',
    user_id char(19) not null comment '用户ID（关联user表）',
    category_id char(19) not null comment '类别ID（关联category表）',
    permission_type varchar(20) not null default 'read' comment '权限类型（read:只读, manage:管理）',
    create_time datetime not null default current_timestamp comment '创建时间',
    update_time datetime not null default current_timestamp comment '更新时间',
    index (user_id, permission_type)
);
-- 指标点表
create table if not exists rule_node
(
    rule_node_id char(19) primary key comment '指标节点id',
    category_id char(19) not null comment '所属类别id',
    level tinyint(10) not null comment '指标层级',
    parent_node_id char(19) not null default '0' comment '父指标id（二级及以上指标关联上级指标，一级指标为NULL)',
    rule_node_name varchar(70) not null comment '指标名称',
    max_score decimal(5,2) not null comment '指标加分上限',
    department varchar(70) comment '认定部门',
    score_rule text not null comment '计分规则',
    create_time datetime not null default current_timestamp comment '创建时间',
    update_time datetime not null default current_timestamp comment '更新时间',
    index(category_id,rule_node_name)
);
-- 指标等级表
create table if not exists rule_node_level
(
    level_id char(19) primary key comment '等级id',
    category_id char(19) not null comment '所属类别id',
    rule_node_id char(19) not null comment '关联指标节点id',
    level_name varchar(70) not null comment '等级名称（eg.第一等级一等奖）',
    level_score decimal(5,2) not null comment '等级加分（第一等级一等奖50分）',
    level_desc text comment '描述',
    create_time datetime not null default current_timestamp comment '创建时间',
    update_time datetime not null default current_timestamp comment '更新时间',
    index(category_id,level_name)
);
-- 学生加分记录表
create table if not exists student_record
(
    record_id char(19) primary key comment '加分记录id',
    student_id char(19) not null comment '关联学生学号（user表中，role=学生）',
    category_id char(19) not null comment '所属类别id',
    major_id char(19) not null comment '所属专业id',
    weighted_score decimal(5,2) comment '加权平均成绩',
    ranking int not null comment '专业排名',
    total_score decimal(5,2) comment '总成绩',
    rule_node_id char(19) not null comment '指标节点id',
    level_id char(19) not null comment '等级id',
    teacher_score decimal(5,2) comment '导员打分',
    status tinyint default 0 comment '审核状态（0=待提交，1=待导员审核，2=导员审核通过，3=导员审核不通过',
    remark text comment '审核备注（导员填写）',
    teacher_id char(19) not null comment '审核导员工号（关联user表，role=导员）',
    create_time datetime not null default current_timestamp comment '创建时间',
    update_time datetime not null default current_timestamp comment '更新时间',
    index(student_id,status)
);
-- 申报材料表
create table application_material
(
    material_id char(19) primary key comment '材料id',
    student_id char(19) not null comment '学生id（关联user表，role=学生）',
    record_id char(19) not null comment '加分记录id（关联学生加分记录表）',
    material_name varchar(70) not null comment '材料名称',
    material_path varchar(100) not null comment '材料存储路径',
    material_type varchar(70) not null comment '材料类型（）',
    is_required tinyint default 1 comment '强制提交材料',
    create_time datetime not null default current_timestamp comment '创建时间',
    update_time datetime not null default current_timestamp comment '更新时间',
    index(material_name,record_id)

);
-- 审核日志表
create table if not exists review_log
(
    log_id         char(19) primary key comment '日志id',
    teacher_id     char(19)    not null comment '审核导员工号（关联user表，role=导员）',
    student_id     char(19)    not null comment '被审核学生学号（关联user表，role=学生）',
    record_id      char(19)    not null comment '加分记录id',
    material_id    char(19)    not null comment '审核材料材料id',
    review_result  varchar(70) not null comment '审核结果',
    review_time    time        not null comment '审核时间',
    review_comment text comment '审核备注',
    create_time    datetime    not null default current_timestamp comment '创建时间',
    update_time    datetime    not null default current_timestamp comment '更新时间',
    index (teacher_id, review_time)
);
