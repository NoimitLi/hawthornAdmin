-- 机构表
CREATE TABLE organization (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '机构ID',
    name VARCHAR(100) NOT NULL COMMENT '机构名称',
    code VARCHAR(50) NOT NULL UNIQUE COMMENT '机构编码',
    type TINYINT NOT NULL DEFAULT 1 COMMENT '机构类型',
    parent_id BIGINT DEFAULT NULL COMMENT '父机构ID',
    region_code VARCHAR(50) COMMENT '归属区域编码',
    region_name VARCHAR(100) COMMENT '归属区域名称',
    is_available TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否可用: 0-否, 1-是',
    FOREIGN KEY (parent_id) REFERENCES organization(id) ON DELETE SET NULL
) COMMENT='机构表';

-- 角色表
CREATE TABLE role (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '角色ID',
    name VARCHAR(100) NOT NULL COMMENT '角色名称',
    code VARCHAR(50) NOT NULL UNIQUE COMMENT '角色编码',
    description VARCHAR(500) COMMENT '备注描述',
    is_available TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否可用: 0-否, 1-是',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) COMMENT='角色表';

-- 岗位表
CREATE TABLE post (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '岗位ID',
    name VARCHAR(100) NOT NULL COMMENT '岗位名称',
    code VARCHAR(50) NOT NULL UNIQUE COMMENT '岗位编码',
    type TINYINT NOT NULL DEFAULT 1 COMMENT '岗位类型: 1-管理岗, 2-技术岗, 3-业务岗, 4-支持岗',
    is_available TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否可用: 0-否, 1-是',
    sort_order INT DEFAULT 0 COMMENT '岗位排序',
    description VARCHAR(500) COMMENT '备注描述',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) COMMENT='岗位表';

-- 用户表
CREATE TABLE user_info (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '登录用户名',
    password VARCHAR(100) NOT NULL COMMENT '登录密码',
    real_name VARCHAR(50) NOT NULL COMMENT '真实姓名',
    avatar VARCHAR(255) COMMENT '头像URL',
    email VARCHAR(100) COMMENT '邮箱',
    phone VARCHAR(20) COMMENT '手机号',
    organization_id BIGINT COMMENT '所属机构ID',
    post_id BIGINT COMMENT '岗位ID',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0-禁用, 1-启用, 2-锁定',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (organization_id) REFERENCES organization(id) ON DELETE SET NULL,
    FOREIGN KEY (post_id) REFERENCES post(id) ON DELETE SET NULL
) COMMENT='用户表';

-- 用户角色关联表
CREATE TABLE user_role (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '关联ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    role_id BIGINT NOT NULL COMMENT '角色ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    created_by BIGINT COMMENT '创建人',
    UNIQUE KEY uk_user_role (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES user_info(id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES role(id) ON DELETE CASCADE
) COMMENT='用户角色关联表';

-- 权限表
CREATE TABLE permission (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '权限ID',
    name VARCHAR(100) NOT NULL COMMENT '权限名称',
    code VARCHAR(100) NOT NULL UNIQUE COMMENT '权限编码',
    type TINYINT NOT NULL DEFAULT 1 COMMENT '权限类型: 1-菜单, 2-按钮, 3-接口, 4-数据',
    is_available TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否可用: 0-否, 1-是',
    description VARCHAR(500) COMMENT '备注描述',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) COMMENT='权限表';

-- 角色权限关联表
CREATE TABLE role_permission (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '关联ID',
    role_id BIGINT NOT NULL COMMENT '角色ID',
    permission_id BIGINT NOT NULL COMMENT '权限ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    UNIQUE KEY uk_role_permission (role_id, permission_id),
    FOREIGN KEY (role_id) REFERENCES role(id) ON DELETE CASCADE,
    FOREIGN KEY (permission_id) REFERENCES permission(id) ON DELETE CASCADE
) COMMENT='角色权限关联表';

-- 菜单表
CREATE TABLE menu (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '菜单ID',
    name VARCHAR(100) NOT NULL COMMENT '菜单名称',
    icon VARCHAR(50) COMMENT '图标',
    type TINYINT NOT NULL DEFAULT 1 COMMENT '类型: 1-目录, 2-菜单, 3-按钮',
    parent_id BIGINT DEFAULT NULL COMMENT '父菜单ID',
    path VARCHAR(500) COMMENT '菜单路由',
    component VARCHAR(100) COMMENT '前端组件',
    sort_order INT DEFAULT 0 COMMENT '排序号',
    is_visible TINYINT NOT NULL DEFAULT 1 COMMENT '是否显示: 0-否, 1-是',
    permission_code VARCHAR(100) COMMENT '权限标志',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0-禁用, 1-启用',
    remark VARCHAR(500) COMMENT '备注',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (parent_id) REFERENCES menu(id) ON DELETE SET NULL
) COMMENT='菜单表';

-- 区域表
CREATE TABLE region (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '区域ID',
    name VARCHAR(100) NOT NULL COMMENT '区域名称',
    code VARCHAR(50) NOT NULL UNIQUE COMMENT '区域编码',
    type TINYINT NOT NULL DEFAULT 1 COMMENT '区域类型: 1-国家, 2-省份, 3-城市, 4-区县, 5-乡镇',
    parent_id BIGINT DEFAULT NULL COMMENT '父区域ID',
    full_path VARCHAR(500) COMMENT '完整路径',
    sort_order INT DEFAULT 0 COMMENT '排序号',
    remark VARCHAR(500) COMMENT '备注',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0-禁用, 1-启用',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (parent_id) REFERENCES region(id) ON DELETE SET NULL
) COMMENT='区域表';

-- 基地风采表
CREATE TABLE base_showcase (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '基地ID',
    title VARCHAR(200) NOT NULL COMMENT '基地风采标题',
    cover_image VARCHAR(500) NOT NULL COMMENT '封面图片URL',
    images TEXT COMMENT '图片集合(JSON数组格式)',
    introduction TEXT COMMENT '简介',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) COMMENT='基地风采表';

-- 产品类型表
CREATE TABLE product_type (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '产品类型ID',
    name VARCHAR(100) NOT NULL COMMENT '产品类型名称',
    code VARCHAR(50) NOT NULL UNIQUE COMMENT '产品类型编码',
    icon VARCHAR(200) COMMENT '图标',
    description VARCHAR(500) COMMENT '描述',
    sort_order INT DEFAULT 0 COMMENT '排序号',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0-禁用, 1-启用'
) COMMENT='产品类型表';

-- 产区分布表
CREATE TABLE production_area (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '产区ID',
    product_type_id BIGINT NOT NULL COMMENT '产品类型ID',
    region_code VARCHAR(50) NOT NULL COMMENT '区域编码',
    description TEXT COMMENT '产区描述',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0-禁用, 1-启用',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY uk_product_region (product_type_id, region_code),
    FOREIGN KEY (product_type_id) REFERENCES product_type(id) ON DELETE CASCADE
) COMMENT='产区分布表';

-- 种植规模表
CREATE TABLE planting_scale (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '记录ID',
    product_type_id BIGINT NOT NULL COMMENT '产品类型ID',
    planting_year INT NOT NULL COMMENT '种植年份',
    planting_quantity DECIMAL(12, 2) NOT NULL COMMENT '种植数量(亩/株)',
    unit VARCHAR(20) NOT NULL DEFAULT '亩' COMMENT '单位: 亩/株/棵',
    FOREIGN KEY (product_type_id) REFERENCES product_type(id) ON DELETE CASCADE
) COMMENT='种植规模表';

-- 预估产量产值表
CREATE TABLE production_forecast (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '记录ID',
    product_type_id BIGINT NOT NULL COMMENT '产品类型ID',
    forecast_year INT NOT NULL COMMENT '预估年份',
    estimated_yield DECIMAL(12, 2) NOT NULL COMMENT '预估产量(吨)',
    estimated_value DECIMAL(15, 2) NOT NULL COMMENT '预估产值(元)',
    FOREIGN KEY (product_type_id) REFERENCES product_type(id) ON DELETE CASCADE
) COMMENT='预估产量产值表';

-- 上市周期表
CREATE TABLE marketing_period (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '记录ID',
    product_type_id BIGINT NOT NULL COMMENT '产品类型ID',
    year INT NOT NULL COMMENT '年份',
    start_date DATE NOT NULL COMMENT '上市开始时间',
    end_date DATE NOT NULL COMMENT '上市结束时间',
    FOREIGN KEY (product_type_id) REFERENCES product_type(id) ON DELETE CASCADE
) COMMENT='上市周期表';

-- 录像机表
CREATE TABLE camera (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '录像机ID',
    name VARCHAR(100) NOT NULL COMMENT '录像机名称',
    device_code VARCHAR(50) NOT NULL UNIQUE COMMENT '设备编码',
    install_position VARCHAR(200) NOT NULL COMMENT '安装位置',
    ip_address VARCHAR(50) COMMENT 'IP地址',
    rtsp_url VARCHAR(500) COMMENT 'RTSP流地址',
    longitude DECIMAL(10, 6) COMMENT '经度',
    latitude DECIMAL(10, 6) COMMENT '纬度',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0-离线, 1-在线, 2-故障',
    is_enabled TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否启用: 0-否, 1-是',
    last_maintenance_date DATE COMMENT '最后维护日期',
    maintenance_notes VARCHAR(500) COMMENT '维护备注',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) COMMENT='录像机表';

-- 用户主体表 (客户表)
CREATE TABLE sales_record (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '销售ID',
    product_type_id BIGINT NOT NULL COMMENT '产品类型ID',
    sales_date DATE NOT NULL COMMENT '销售日期',
    sales_type TINYINT NOT NULL COMMENT '销售类型: 1-零售, 2-批发, 3-电商, 4-出口',
    sales_quantity DECIMAL(10, 2) NOT NULL COMMENT '销售量',
    sales_amount DECIMAL(12, 2) NOT NULL COMMENT '销售额(元)',
    unit_price DECIMAL(8, 2) COMMENT '单价(元/公斤)',
    customer_id BIGINT COMMENT '客户ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (product_type_id) REFERENCES product_type(id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customer(id) ON DELETE SET NULL
) COMMENT='销售记录表';

-- 销售记录表 (必须在customer表之后创建)
CREATE TABLE target_customer (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '记录ID',
    product_type_id BIGINT NOT NULL COMMENT '产品类型ID',
    record_date DATE NOT NULL COMMENT '记录日期',
    province_code VARCHAR(50) NOT NULL COMMENT '省份编码',
    province_name VARCHAR(100) NOT NULL COMMENT '省份名称',
    city_code VARCHAR(50) NOT NULL COMMENT '城市编码',
    city_name VARCHAR(100) NOT NULL COMMENT '城市名称',
    sales_quantity DECIMAL(10, 2) NOT NULL COMMENT '销售量',
    sales_amount DECIMAL(12, 2) NOT NULL COMMENT '销售额(元)',
    customer_count INT DEFAULT 0 COMMENT '客户数量',
    description VARCHAR(500) COMMENT '描述',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY uk_product_date_city (product_type_id, record_date, city_code),
    FOREIGN KEY (product_type_id) REFERENCES product_type(id) ON DELETE CASCADE
) COMMENT='区域销量表';

-- 区域销量表
CREATE TABLE market_quotation (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '行情ID',
    product_type_id BIGINT NOT NULL COMMENT '产品类型ID',
    quotation_date DATE NOT NULL COMMENT '行情日期',
    avg_price DECIMAL(8, 2) NOT NULL COMMENT '平均价格(元/公斤)',
    min_price DECIMAL(8, 2) COMMENT '最低价格',
    max_price DECIMAL(8, 2) COMMENT '最高价格',
    market_trend TINYINT COMMENT '市场趋势: 1-上涨, 2-下跌, 3-平稳',
    trading_volume DECIMAL(10, 2) COMMENT '交易量(吨)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (product_type_id) REFERENCES product_type(id) ON DELETE CASCADE
) COMMENT='市场行情表';

-- 市场行情表
CREATE TABLE customer (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '客户ID',
    name VARCHAR(200) NOT NULL COMMENT '主体名称',
    contact_address VARCHAR(500) COMMENT '联系地址',
    type TINYINT NOT NULL DEFAULT 1 COMMENT '客户类型: 1-个人, 2-企业, 3-合作社, 4-经销商',
    contact_person VARCHAR(100) NOT NULL COMMENT '联系人',
    contact_phone VARCHAR(20) NOT NULL COMMENT '联系电话',
    email VARCHAR(100) COMMENT '邮箱',
    province_code VARCHAR(50) COMMENT '省份编码',
    province_name VARCHAR(100) COMMENT '省份名称',
    city_code VARCHAR(50) COMMENT '城市编码',
    city_name VARCHAR(100) COMMENT '城市名称',
    credit_rating TINYINT DEFAULT 3 COMMENT '信用评级: 1-A, 2-B, 3-C, 4-D',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0-禁用, 1-启用',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) COMMENT='用户主体表';
