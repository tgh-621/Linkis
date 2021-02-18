SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for linkis_develop_application
-- ----------------------------
DROP TABLE IF EXISTS `linkis_develop_application`;
CREATE TABLE `linkis_develop_application` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `source` varchar(50) DEFAULT NULL COMMENT 'Source of the development application',
  `version` varchar(50) DEFAULT NULL,
  `description` text,
  `user_id` bigint(20) DEFAULT NULL,
  `is_published` bit(1) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `org_id` bigint(20) DEFAULT NULL COMMENT 'Organization ID',
  `visibility` bit(1) DEFAULT NULL,
  `is_transfer` bit(1) DEFAULT NULL COMMENT 'Reserved word',
  `initial_org_id` bigint(20) DEFAULT NULL,
  `json_path` varchar(255) DEFAULT NULL COMMENT 'Path of the jason file which is used for data development in the front-end. ',
  `isAsh` bit(1) DEFAULT NULL COMMENT 'If it is active',
  `pic` varchar(255) DEFAULT NULL,
  `star_num` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for linkis_project_list
-- ----------------------------
DROP TABLE IF EXISTS `linkis_project_list`;
CREATE TABLE `linkis_project_list` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL COMMENT 'Project service name which needs to be initialized',
  `is_project_need_init` bit(1) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL COMMENT 'URL used to initialize a project',
  `is_user_need_init` bit(1) DEFAULT NULL,
  `is_project_inited` bit(1) DEFAULT NULL,
  `json` text COMMENT 'Data provided by project to the front-end would be jsonized after initialization.',
  `level` tinyint(255) DEFAULT NULL COMMENT 'Marks the importance of the project. When encounter initialization failure, if a user tried to log in, the project would report an error if its level is greater than 4, otherwise, grey the corresponding function button',
  `user_init_url` varchar(255) DEFAULT NULL COMMENT 'URL used to initialize a user',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for linkis_project_user
-- ----------------------------
DROP TABLE IF EXISTS `linkis_project_user`;
CREATE TABLE `linkis_project_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `project_id` bigint(20) DEFAULT NULL,
  `json` varchar(255) DEFAULT NULL COMMENT 'Data returned by initializing a user would be jsonized',
  `user_id` bigint(20) DEFAULT NULL,
  `is_init_success` bit(1) DEFAULT NULL,
  `is_new_feature` bit(1) DEFAULT NULL COMMENT 'If this project is a new function to the user',
  PRIMARY KEY (`id`),
  UNIQUE KEY `project_id` (`project_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for linkis_user
-- ----------------------------
DROP TABLE IF EXISTS `linkis_user`;
CREATE TABLE `linkis_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) DEFAULT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `admin` tinyint(1) DEFAULT NULL COMMENT 'If it is an administrator',
  `active` tinyint(1) DEFAULT NULL COMMENT 'If it is active',
  `name` varchar(255) DEFAULT NULL COMMENT 'User name',
  `description` varchar(255) DEFAULT NULL,
  `department` varchar(255) DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL COMMENT 'Path of the avator',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_by` bigint(20) DEFAULT '0',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_by` bigint(20) DEFAULT '0',
  `is_first_login` bit(1) DEFAULT NULL COMMENT 'If it is the first time to log in',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

SET FOREIGN_KEY_CHECKS=0;


-- ----------------------------
-- Table structure for linkis_application
-- ----------------------------
DROP TABLE IF EXISTS `linkis_application`;
CREATE TABLE `linkis_application` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL COMMENT 'Can be one of the following: execute_application_name(in table linkis_task), request_application_name(i.e. creator), general configuration',
  `chinese_name` varchar(50) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;


-- ----------------------------
-- Table structure for linkis_config_key_tree
-- ----------------------------
DROP TABLE IF EXISTS `linkis_config_key_tree`;
CREATE TABLE `linkis_config_key_tree` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key_id` bigint(20) DEFAULT NULL,
  `tree_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `key_id` (`key_id`),
  KEY `tree_id` (`tree_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;


-- ----------------------------
-- Table structure for linkis_config_key_user
-- ----------------------------
DROP TABLE IF EXISTS `linkis_config_key_user`;
CREATE TABLE `linkis_config_key_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `application_id` bigint(20) DEFAULT NULL COMMENT 'Same as id in tale linkis_application, except that it cannot be the id of creator',
  `key_id` bigint(20) DEFAULT NULL,
  `user_name` varchar(50) DEFAULT NULL,
  `value` varchar(200) DEFAULT NULL COMMENT 'Value of the key',
  PRIMARY KEY (`id`),
  UNIQUE KEY `application_id_2` (`application_id`,`key_id`,`user_name`),
  KEY `key_id` (`key_id`),
  KEY `application_id` (`application_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- ----------------------------
-- Table structure for linkis_config_key
-- ----------------------------
DROP TABLE IF EXISTS `linkis_config_key`;
CREATE TABLE `linkis_config_key` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(50) DEFAULT NULL COMMENT 'Set key, e.g. spark.executor.instances',
  `description` varchar(200) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `application_id` bigint(20) DEFAULT NULL COMMENT 'Correlate with id in table linkis_application',
  `default_value` varchar(200) DEFAULT NULL COMMENT 'Adopted when user does not set key',
  `validate_type` varchar(50) DEFAULT NULL COMMENT 'Validate type, one of the following: None, NumInterval, FloatInterval, Include, Regex, OPF, Custom Rules',
  `validate_range` varchar(100) DEFAULT NULL COMMENT 'Validate range',
  `is_hidden` tinyint(1) DEFAULT NULL COMMENT 'Whether it is hidden from user. If set to 1(true), then user cannot modify, however, it could still be used in back-end',
  `is_advanced` tinyint(1) DEFAULT NULL COMMENT 'Whether it is an advanced parameter. If set to 1(true), parameters would be displayed only when user choose to do so',
  `level` tinyint(1) DEFAULT NULL COMMENT 'Basis for displaying sorting in the front-end. Higher the level is, higher the rank the parameter gets',
  `unit` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `application_id` (`application_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;


-- ----------------------------
-- Table structure for linkis_config_tree
-- ----------------------------
DROP TABLE IF EXISTS `linkis_config_tree`;
CREATE TABLE `linkis_config_tree` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `parent_id` bigint(20) DEFAULT NULL COMMENT 'Parent ID',
  `name` varchar(50) DEFAULT NULL COMMENT 'Application name or category name under general configuration',
  `description` varchar(200) DEFAULT NULL,
  `application_id` bigint(20) DEFAULT NULL COMMENT 'Same as id(in table linkis_application), except that it cannot be the id of creator',
  PRIMARY KEY (`id`),
  KEY `application_id` (`application_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;
SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for linkis_task
-- ----------------------------
DROP TABLE IF EXISTS `linkis_task`;
CREATE TABLE `linkis_task` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key, auto increment',
  `instance` varchar(50) DEFAULT NULL COMMENT 'An instance of Entrance, consists of IP address of the entrance server and port',
  `exec_id` varchar(50) DEFAULT NULL COMMENT 'execution ID, consists of jobID(generated by scheduler), executeApplicationName , creator and instance',
  `um_user` varchar(50) DEFAULT NULL COMMENT 'User name',
  `execution_code` text COMMENT 'Run script. When exceeding 6000 lines, script would be stored in HDFS and its file path would be stored in database',
  `progress` float DEFAULT NULL COMMENT 'Script execution progress, between zero and one',
  `log_path` varchar(200) DEFAULT NULL COMMENT 'File path of the log files',
  `result_location` varchar(200) DEFAULT NULL COMMENT 'File path of the result',
  `status` varchar(50) DEFAULT NULL COMMENT 'Script execution status, must be one of the following: Inited, WaitForRetry, Scheduled, Running, Succeed, Failed, Cancelled, Timeout',
  `created_time` datetime DEFAULT NULL COMMENT 'Creation time',
  `updated_time` datetime DEFAULT NULL COMMENT 'Update time',
  `run_type` varchar(50) DEFAULT NULL COMMENT 'Further refinement of execution_application_time, e.g, specifying whether to run pySpark or SparkR',
  `err_code` int(11) DEFAULT NULL COMMENT 'Error code. Generated when the execution of the script fails',
  `err_desc` text COMMENT 'Execution description. Generated when the execution of script fails',
  `execute_application_name` varchar(200) DEFAULT NULL COMMENT 'The service a user selects, e.g, Spark, Python, R, etc',
  `request_application_name` varchar(200) DEFAULT NULL COMMENT 'Parameter name for creator',
  `script_path` varchar(200) DEFAULT NULL COMMENT 'Path of the script in workspace',
  `params` text COMMENT 'Configuration item of the parameters',
  `engine_instance` varchar(50) DEFAULT NULL COMMENT 'An instance of engine, consists of IP address of the engine server and port',
  `engine_start_time` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `created_time` (`created_time`),
  KEY `um_user` (`um_user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `linkis_em_resource_meta_data`;
CREATE TABLE `linkis_em_resource_meta_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `em_application_name` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `em_instance` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `total_resource` varchar(2000) COLLATE utf8_bin DEFAULT NULL,
  `protected_resource` varchar(2000) COLLATE utf8_bin DEFAULT NULL,
  `resource_policy` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `used_resource` varchar(2000) COLLATE utf8_bin DEFAULT NULL,
  `left_resource` varchar(2000) COLLATE utf8_bin DEFAULT NULL,
  `locked_resource` varchar(2000) COLLATE utf8_bin DEFAULT NULL,
  `register_time` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `linkis_resource_lock`;
CREATE TABLE `linkis_resource_lock` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `em_application_name` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `em_instance` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lock_unique` (`user`,`em_application_name`,`em_instance`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `linkis_user_resource_meta_data`;
CREATE TABLE `linkis_user_resource_meta_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `ticket_id` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `creator` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `em_application_name` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `em_instance` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `engine_application_name` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `engine_instance` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `user_locked_resource` varchar(5000) COLLATE utf8_bin DEFAULT NULL,
  `user_used_resource` varchar(5000) COLLATE utf8_bin DEFAULT NULL,
  `resource_type` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `locked_time` bigint(20) DEFAULT NULL,
  `used_time` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `linkis_em_meta_data`;
CREATE TABLE `linkis_em_meta_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `em_name` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `resource_request_policy` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for linkis_udf_manager
-- ----------------------------
DROP TABLE IF EXISTS `linkis_udf_manager`;
CREATE TABLE `linkis_udf_manager` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for linkis_udf_shared_group
-- An entry would be added when a user share a function to other user group
-- ----------------------------
DROP TABLE IF EXISTS `linkis_udf_shared_group`;
CREATE TABLE `linkis_udf_shared_group` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `udf_id` bigint(20) NOT NULL,
  `shared_group` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for linkis_udf_shared_user
-- An entry would be added when a user share a function to another user
-- ----------------------------
DROP TABLE IF EXISTS `linkis_udf_shared_user`;
CREATE TABLE `linkis_udf_shared_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `udf_id` bigint(20) NOT NULL,
  `user_name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for linkis_udf_tree
-- ----------------------------
DROP TABLE IF EXISTS `linkis_udf_tree`;
CREATE TABLE `linkis_udf_tree` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `parent` bigint(20) NOT NULL,
  `name` varchar(200) DEFAULT NULL COMMENT 'Category name of the function. It would be displayed in the front-end',
  `user_name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `category` varchar(50) DEFAULT NULL COMMENT 'Used to distinguish between udf and function',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for linkis_udf_user_load_info
-- Used to store the function a user selects in the front-end
-- ----------------------------
DROP TABLE IF EXISTS `linkis_udf_user_load_info`;
CREATE TABLE `linkis_udf_user_load_info` (
  `udf_id` int(11) NOT NULL,
  `user_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for linkis_udf
-- ----------------------------
DROP TABLE IF EXISTS `linkis_udf`;
CREATE TABLE `linkis_udf` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_user` varchar(50) NOT NULL,
  `udf_name` varchar(255) NOT NULL,
  `udf_type` int(11) DEFAULT '0',
  `path` varchar(255) DEFAULT NULL COMMENT 'Path of the referenced function',
  `register_format` varchar(255) DEFAULT NULL,
  `use_format` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_expire` bit(1) DEFAULT NULL,
  `is_shared` bit(1) DEFAULT NULL,
  `tree_id` bigint(20) NOT NULL,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for linkis_var_key_user
-- ----------------------------
DROP TABLE IF EXISTS `linkis_var_key_user`;
CREATE TABLE `linkis_var_key_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `application_id` bigint(20) DEFAULT NULL COMMENT 'Reserved word',
  `key_id` bigint(20) DEFAULT NULL,
  `user_name` varchar(50) DEFAULT NULL,
  `value` varchar(200) DEFAULT NULL COMMENT 'Value of the global variable',
  PRIMARY KEY (`id`),
  UNIQUE KEY `application_id_2` (`application_id`,`key_id`,`user_name`),
  KEY `key_id` (`key_id`),
  KEY `application_id` (`application_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- ----------------------------
-- Table structure for linkis_var_key
-- ----------------------------
DROP TABLE IF EXISTS `linkis_var_key`;
CREATE TABLE `linkis_var_key` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(50) DEFAULT NULL COMMENT 'Key of the global variable',
  `description` varchar(200) DEFAULT NULL COMMENT 'Reserved word',
  `name` varchar(50) DEFAULT NULL COMMENT 'Reserved word',
  `application_id` bigint(20) DEFAULT NULL COMMENT 'Reserved word',
  `default_value` varchar(200) DEFAULT NULL COMMENT 'Reserved word',
  `value_type` varchar(50) DEFAULT NULL COMMENT 'Reserved word',
  `value_regex` varchar(100) DEFAULT NULL COMMENT 'Reserved word',
  PRIMARY KEY (`id`),
  KEY `application_id` (`application_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for linkis_mdq_access
-- ----------------------------
DROP TABLE IF EXISTS `linkis_mdq_access`;
CREATE TABLE `linkis_mdq_access` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `table_id` bigint(20) NOT NULL,
  `visitor` varchar(16) COLLATE utf8_bin NOT NULL,
  `fields` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `application_id` int(4) NOT NULL,
  `access_time` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for linkis_mdq_field
-- ----------------------------
DROP TABLE IF EXISTS `linkis_mdq_field`;
CREATE TABLE `linkis_mdq_field` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `table_id` bigint(20) NOT NULL,
  `name` varchar(64) COLLATE utf8_bin NOT NULL,
  `alias` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `type` varchar(64) COLLATE utf8_bin NOT NULL,
  `comment` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `express` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `rule` varchar(128) COLLATE utf8_bin DEFAULT NULL,
  `is_partition_field` tinyint(1) NOT NULL,
  `is_primary` tinyint(1) NOT NULL,
  `length` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for linkis_mdq_import
-- ----------------------------
DROP TABLE IF EXISTS `linkis_mdq_import`;
CREATE TABLE `linkis_mdq_import` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `table_id` bigint(20) NOT NULL,
  `import_type` int(4) NOT NULL,
  `args` varchar(255) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for linkis_mdq_lineage
-- ----------------------------
DROP TABLE IF EXISTS `linkis_mdq_lineage`;
CREATE TABLE `linkis_mdq_lineage` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `table_id` bigint(20) DEFAULT NULL,
  `source_table` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for linkis_mdq_table
-- ----------------------------
DROP TABLE IF EXISTS `linkis_mdq_table`;
CREATE TABLE `linkis_mdq_table` (
  `id` bigint(255) NOT NULL AUTO_INCREMENT,
  `database` varchar(64) COLLATE utf8_bin NOT NULL,
  `name` varchar(64) COLLATE utf8_bin NOT NULL,
  `alias` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `creator` varchar(16) COLLATE utf8_bin NOT NULL,
  `comment` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `product_name` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `project_name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `usage` varchar(128) COLLATE utf8_bin DEFAULT NULL,
  `lifecycle` int(4) NOT NULL,
  `use_way` int(4) NOT NULL,
  `is_import` tinyint(1) NOT NULL,
  `model_level` int(4) NOT NULL,
  `is_external_use` tinyint(1) NOT NULL,
  `is_partition_table` tinyint(1) NOT NULL,
  `is_available` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `database` (`database`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for linkis_mdq_table_info
-- ----------------------------
DROP TABLE IF EXISTS `linkis_mdq_table_info`;
CREATE TABLE `linkis_mdq_table_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `table_id` bigint(20) NOT NULL,
  `table_last_update_time` datetime NOT NULL,
  `row_num` bigint(20) NOT NULL,
  `file_num` int(11) NOT NULL,
  `table_size` varchar(32) COLLATE utf8_bin NOT NULL,
  `partitions_num` int(11) NOT NULL,
  `update_time` datetime NOT NULL,
  `field_num` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

drop table if exists `linkis_resources`;
CREATE TABLE if not exists `linkis_resources` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `resource_id` varchar(50) NOT NULL COMMENT '资源id，资源的uuid',
  `is_private` TINYINT(1) DEFAULT 0 COMMENT '资源是否私有，0表示私有，1表示公开',
  `resource_header` TINYINT(1) DEFAULT 0 COMMENT '分类，0表示未分类，1表示已分类',
	`downloaded_file_name` varchar(200) DEFAULT NULL COMMENT '下载时的文件名',
	`sys` varchar(100) NOT NULL COMMENT '所属系统',
	`create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
	`owner` varchar(200) NOT NULL COMMENT '资源所属者',
	`is_expire` TINYINT(1) DEFAULT 0 COMMENT '是否过期，0表示不过期，1表示过期',
	`expire_type` varchar(50) DEFAULT null COMMENT '过期类型，date指到指定日期过期，TIME指时间',
	`expire_time` varchar(50) DEFAULT null COMMENT '过期时间，默认一天',
	`max_version` int(20) DEFAULT 10 COMMENT '默认为10，指保留最新的10个版本',
	`update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
	`updator` varchar(50) DEFAULT NULL COMMENT '更新者',
	`enable_flag` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态，1：正常，0：冻结',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;


drop table if exists `linkis_resources_version`;
CREATE TABLE if not exists `linkis_resources_version` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `resource_id` varchar(50) NOT NULL COMMENT '资源id，资源的uuid',
  `file_md5` varchar(32) NOT NULL COMMENT '文件的md5摘要',
  `version` varchar(20) NOT NULL COMMENT '资源版本（v 加上 五位数字）',
	`size` int(10) NOT NULL COMMENT '文件大小',
	`start_byte` BIGINT(20) UNSIGNED NOT NULL DEFAULT 0,
	`end_byte` BIGINT(20) UNSIGNED NOT NULL DEFAULT 0,
	`resource` varchar(2000) NOT NULL COMMENT '资源内容（文件信息 包括 路径和文件名）',
	`description` varchar(2000) DEFAULT NULL COMMENT '描述',
	`start_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '开始时间',
	`end_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '结束时间',
	`client_ip` varchar(200) NOT NULL COMMENT '客户端ip',
	`updator` varchar(50) DEFAULT NULL COMMENT '修改者',
	`enable_flag` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态，1：正常，0：冻结',
	unique key `resource_id_version`(`resource_id`, `version`),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



drop table if exists `linkis_resources_permission`;
CREATE TABLE if not exists `linkis_resources_permission` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `resource_id` varchar(50) NOT NULL COMMENT '资源id，资源的uuid',
  `permission` varchar(10) NOT NULL COMMENT '权限代码',
	`create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
	`system` varchar(50) default "dss" COMMENT '创建者',
	`update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
	`updator` varchar(50) NOT NULL COMMENT '更新者',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



drop table if exists `linkis_resources_download_history`;
CREATE TABLE if not exists `linkis_resources_download_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
	`start_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '开始时间',
	`end_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '结束时间',
	`client_ip` varchar(200) NOT NULL COMMENT '客户端ip',
	`state` TINYINT(1) NOT NULL COMMENT '下载状态，0下载成功，1下载失败',
	 `resource_id` varchar(50) not null,
	 `version` varchar(20) not null,
	`downloader` varchar(50) NOT NULL COMMENT '下载者',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;




-- 创建资源任务表,包括上传,更新,下载
drop table if exists `linkis_resources_task`;
CREATE TABLE if not exists `linkis_resources_task` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `resource_id` varchar(50) DEFAULT NULL COMMENT '资源id，资源的uuid',
  `version` varchar(20) DEFAULT NULL COMMENT '当前操作的资源版本号',
  `operation` varchar(20) NOT NULL COMMENT '操作类型.upload = 0, update = 1',
  `state` varchar(20) NOT NULL DEFAULT 'Schduled' COMMENT '任务当前状态:Schduled, Running, Succeed, Failed,Cancelled',
  `submit_user` varchar(20) NOT NULL DEFAULT '' COMMENT '任务提交用户名',
  `system` varchar(20) DEFAULT 'dss' COMMENT '子系统名 wtss',
  `instance` varchar(50) NOT NULL COMMENT '物料库实例',
  `client_ip` varchar(50) DEFAULT NULL COMMENT '请求IP',
  `extra_params` text COMMENT '额外关键信息.如批量删除的资源IDs及versions,删除资源下的所有versions',
  `err_msg` varchar(2000) DEFAULT NULL COMMENT '任务失败信息.e.getMessage',
  `start_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `last_update_time` datetime NOT NULL COMMENT '最后更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for linkis_cs_context_map
-- ----------------------------
DROP TABLE IF EXISTS `linkis_cs_context_map`;
CREATE TABLE `linkis_cs_context_map` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(128) DEFAULT NULL,
  `context_scope` varchar(32) DEFAULT NULL,
  `context_type` varchar(32) DEFAULT NULL,
  `props` text,
  `value` text,
  `context_id` int(11) DEFAULT NULL,
  `keywords` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `key` (`key`,`context_id`,`context_type`),
  KEY `keywords` (`keywords`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for linkis_cs_context_map_listener
-- ----------------------------
DROP TABLE IF EXISTS `linkis_cs_context_map_listener`;
CREATE TABLE `linkis_cs_context_map_listener` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `listener_source` varchar(255) DEFAULT NULL,
  `key_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for linkis_cs_context_history
-- ----------------------------
DROP TABLE IF EXISTS `linkis_cs_context_history`;
CREATE TABLE `linkis_cs_context_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `context_id` int(11) DEFAULT NULL,
  `source` text,
  `context_type` varchar(32) DEFAULT NULL,
  `history_json` text,
  `keyword` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `keyword` (`keyword`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for linkis_cs_context_id
-- ----------------------------
DROP TABLE IF EXISTS `linkis_cs_context_id`;
CREATE TABLE `linkis_cs_context_id` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(32) DEFAULT NULL,
  `application` varchar(32) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `expire_type` varchar(32) DEFAULT NULL,
  `expire_time` datetime DEFAULT NULL,
  `instance` varchar(32) DEFAULT NULL,
  `backup_instance` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `instance` (`instance`),
  KEY `backup_instance` (`backup_instance`(191)),
  KEY `instance_2` (`instance`,`backup_instance`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for linkis_cs_context_listener
-- ----------------------------
DROP TABLE IF EXISTS `linkis_cs_context_listener`;
CREATE TABLE `linkis_cs_context_listener` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `listener_source` varchar(255) DEFAULT NULL,
  `context_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;




-- ----------------------------
-- Table structure for linkis_datasource
-- ----------------------------
CREATE TABLE IF NOT EXISTS `linkis_datasource` (
   `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
   `datasource_name` VARCHAR(100) NOT NULL COMMENT 'Data source name',
   `datasource_type_id` BIGINT(20) DEFAULT NULL COMMENT 'Data source type id',
   `datasource_desc` VARCHAR(200) DEFAULT NULL COMMENT 'Data source description',
   `create_identify` VARCHAR(20) DEFAULT 'BDP' COMMENT 'Example: project name',
	`create_system` VARCHAR(20) DEFAULT 'BDP' COMMENT 'Create system',
	`create_user` VARCHAR(50) DEFAULT NULL COMMENT 'Creator',
	`parameter` TEXT COMMENT 'Connect parameters',
	`create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`modify_user` VARCHAR(50) DEFAULT NULL COMMENT 'Modify user',
	`modify_time` DATETIME DEFAULT NULL COMMENT 'Modify time',
	`datasource_env_id` BIGINT(20) DEFAULT NULL,
	PRIMARY KEY (`id`)
 ) ENGINE=InnoDB AUTO_INCREMENT=140 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for linkis_datasource_env
-- ----------------------------
CREATE TABLE IF NOT EXISTS `linkis_datasource_env` (
	`id` BIGINT(20) NOT NULL AUTO_INCREMENT,
	`env_name` VARCHAR(100) NOT NULL COMMENT 'Environment name',
    `env_desc` VARCHAR(200) DEFAULT NULL COMMENT 'Description',
	`create_user` VARCHAR(50) DEFAULT NULL COMMENT 'Creator',
	`parameter` TEXT NOT NULL COMMENT 'Connect parameters',
	`create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`modify_user` VARCHAR(50) DEFAULT NULL COMMENT 'Modify user',
	`modify_time` DATETIME DEFAULT NULL COMMENT 'Modify time',
	PRIMARY KEY (`id`)
 ) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for linkis_datasource_type_key
-- ----------------------------
CREATE TABLE IF NOT EXISTS `linkis_datasource_type_key` (
	`id` BIGINT(20) NOT NULL AUTO_INCREMENT,
	`key` VARCHAR(50) DEFAULT NULL COMMENT 'Key of variable',
	`description` VARCHAR(200) DEFAULT NULL COMMENT 'Description',
	`name` VARCHAR(50) DEFAULT NULL COMMENT 'Option name of column in page',
	`data_source_type_id` BIGINT(20) DEFAULT NULL COMMENT 'Type id',
	`require` TINYINT(1) DEFAULT '0',
	`scope` VARCHAR(50) DEFAULT NULL COMMENT 'Scope',
	`default_value` VARCHAR(200) DEFAULT NULL COMMENT 'Default value',
	`value_type` VARCHAR(50) DEFAULT NULL COMMENT 'Value type',
	`value_regex` VARCHAR(100) DEFAULT NULL COMMENT 'Value regex',
	`ref_id` BIGINT(20) DEFAULT NULL COMMENT 'Related id',
	`ref_value` VARCHAR(100) DEFAULT NULL COMMENT 'Related value',
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for linkis_datasource_type
-- ----------------------------
CREATE TABLE IF NOT EXISTS `linkis_datasource_type` (
	`id` BIGINT(20) NOT NULL AUTO_INCREMENT,
	`icon` VARCHAR(50) DEFAULT NULL COMMENT 'Icon',
	`description` VARCHAR(200) DEFAULT NULL COMMENT 'Description',
	`name` VARCHAR(50) DEFAULT NULL COMMENT 'Name',
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for linkis_datasource_type_env
-- ----------------------------
CREATE TABLE IF NOT EXISTS `linkis_datasource_type_env` (
	`id` BIGINT(20) NOT NULL AUTO_INCREMENT,
	`data_source_type_id` BIGINT(20) DEFAULT NULL COMMENT 'Type id',
	`env_id` BIGINT(20) DEFAULT NULL COMMENT 'Environment id',
	PRIMARY KEY (`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;