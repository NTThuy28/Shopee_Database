Drop table if exists dim_location;

CREATE TABLE dim_location (
    location_id INT NOT NULL PRIMARY KEY,
    location_name VARCHAR(50)
);

Drop table if exists dim_category;

CREATE TABLE dim_category (
    category_id INT NOT NULL PRIMARY KEY,
    category_name VARCHAR(50)
);
Drop table if exists dim_shop;

CREATE TABLE dim_shop (
    shopid BIGINT NOT NULL PRIMARY KEY,
    userid INT,
    username VARCHAR(50),
    shop_name VARCHAR(50),
    follower VARCHAR(20),
    is_shopee_verified VARCHAR(10),
    show_official_shop_label_x VARCHAR(10),
    show_shopee_verified_label VARCHAR(10),
    show_official_shop_label_in_title VARCHAR(10),
    is_mart VARCHAR(10),
    is_preferred_plus_seller VARCHAR(10)
);

Drop table if exists dim_follower;

create table dim_follower(
follower_id INT NOT NULL PRIMARY KEY,
follower_around_number VARCHAR(50)
);

Drop table if exists dim_shop_category;

create table dim_shop_category(
shop_category_id INT NOT NULL PRIMARY KEY,
display_name VARCHAR(255),
shopid BIGINT
);

Drop table if exists dim_product;

create table dim_product(
  itemid BIGINT NOT NULL PRIMARY KEY,
  shopid BIGINT,
  product_name VARCHAR(255), 
  name_tier_variation VARCHAR(50),
  option_variation TEXT,
  currency VARCHAR(5),
  item_status VARCHAR(10),
  location VARCHAR(50),
  is_adult VARCHAR(10),
  is_cc_installment_payment_eligible VARCHAR(10),
  show_free_shipping VARCHAR(10),
  can_use_wholesale VARCHAR(10),
  has_model_with_available_shopee_stock VARCHAR(10),
  can_use_cod VARCHAR(10)
);
Drop table if exists dim_date_create;

CREATE TABLE dim_date_create (  #hỏi lại cái tạo dim từ procedure
  date_id VARCHAR(30) PRIMARY KEY,
  itemid BIGINT,
  hour_create TIME,
  day_create INT,
  day_of_week_create VARCHAR(10),
  month_create VARCHAR(10),
  quarter_create VARCHAR(2),
  year_create INT
);

Drop table if exists dim_brand;

CREATE TABLE dim_brand (
  brand_id INT NOT NULL PRIMARY KEY,
  brand_name VARCHAR(50)
);
Drop table if exists dim_flash_sale;

CREATE TABLE dim_flash_sale (
  flash_sale_id INT NOT NULL PRIMARY KEY,
  is_on_flash_sale Varchar(10)
);

#Tạo fact
Drop table if exists fact_overview;

CREATE TABLE fact_overview (
  overview_id INT not null PRIMARY KEY,
  location_name VARCHAR(50),
  category_id INT,
  shopid BIGINT,
  shop_category_id INT,
  itemid BIGINT,
  date_id varchar(30),
  brand_name VARCHAR(50),
  is_on_flash_sale VARCHAR(10),
  follower_around_number VARCHAR(50)
);

Drop table if exists fact_revenue;

CREATE TABLE fact_revenue (
    revenue_id INT NOT NULL PRIMARY KEY,
    location_name VARCHAR(50),
    category_id INT,
    shopid BIGINT,
    itemid BIGINT,
    date_id VARCHAR(50),
    brand_name VARCHAR(50),
	follower_around_number VARCHAR(50)
);

Drop table if exists fact_rating;

CREATE TABLE fact_rating ( 
  rating_id INT NOT NULL PRIMARY KEY,
  itemid BIGINT,
  shopid BIGINT,
  follower_around_number VARCHAR(50)
);
Drop table if exists fact_promotion;

CREATE TABLE fact_promotion (
  promotion_id INT PRIMARY KEY,
  itemid BIGINT,
  shopid BIGINT
);

#Create view for dim
CREATE VIEW v_dim_shop AS

SELECT
    shopid,
    userid,
    username,
    shop_name,
    follower_count AS follower,
    is_shopee_verified,
    is_mart,
    is_preferred_plus_seller
FROM shopee_staging2.shop;


create view location AS
select Distinct 
shop_location 
from shopee_staging2.product;

#View location
CREATE VIEW v_dim_location AS

SELECT 
    row_number() OVER () AS location_id,
     shop_location AS location_name
FROM location;

#View category
CREATE VIEW category AS
    SELECT DISTINCT
        category_id, category_name
    FROM
        shopee_staging2.category;

CREATE VIEW v_dim_category AS

SELECT 
     category_id,
     category_name
FROM category;

#View shop_category
CREATE VIEW v_dim_shop_category AS

SELECT  
     shop_category_id,
     display_name
FROM shopee_staging2.shop_category;

#View product
CREATE VIEW v_dim_product AS

SELECT 
     itemid,
  shopid,
  product_name, 
  name_tier_variation,
  option_variation,
  currency ,
  item_status ,
  shop_location AS location_name,
  is_adult,
  is_cc_installment_payment_eligible,
  show_free_shipping,
  can_use_wholesale ,
  has_model_with_available_shopee_stock,
  can_use_cod 
FROM shopee_staging2.product;


#view brand
create view brand AS

select Distinct 
brand 
from shopee_staging2.product;

CREATE VIEW v_dim_brand AS

SELECT 
     row_number() OVER () AS brand_id,
     brand AS brand_name
FROM brand;


#view flash sale
CREATE VIEW flash_sale AS
    SELECT DISTINCT
        is_on_flash_sale
    FROM
        shopee_staging2.product;

CREATE VIEW v_dim_flash_sale AS

SELECT 
     row_number() OVER () AS flash_sale_id,
     is_on_flash_sale
FROM flash_sale;

#view follower
create view follower AS

select Distinct 
follower_around_number 
from shopee_staging2.shop;

CREATE VIEW v_dim_follower AS

SELECT 
     row_number() OVER () AS follower_id,
     follower_around_number
FROM follower;


# Date
CREATE VIEW v_dim_date_create AS
SELECT
    CONCAT(product_creation_date, ' ', product_creation_time) AS date_id,
    itemid,
    product_creation_time AS hour_create,
    DAY(product_creation_date) AS day_create,
    CASE DAYOFWEEK(product_creation_date)
        WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday'
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
        WHEN 7 THEN 'Saturday'
    END AS day_of_week_create,
    DATE_FORMAT(product_creation_date, '%M') AS month_create,
    CONCAT('Q', QUARTER(product_creation_date)) AS quarter_create,
    YEAR(product_creation_date) AS year_create
FROM
    shopee_staging2.product;

#insert into fact

#select * from fact_overview;

INSERT INTO olap_shopee.fact_overview (
  location_name,
  category_id,
  shopid,
  shop_category_id,
  itemid,
  date_id,
  brand_name,
  is_on_flash_sale,
  follower_around_number
)
SELECT shop_location,
  category_id,
  s.shopid,
  shop_category_id,
  p.itemid,
  TIMESTAMP(CONCAT(product_creation_date, ' ', product_creation_time)) AS date_id,
  brand,
  is_on_flash_sale,
  follower_around_number
FROM ((shopee_staging2.shop as s JOIN shopee_staging2.product as p ON s.shopid = p.shopid) 
LEFT JOIN shopee_staging2.category as c ON s.shopid = c.shopid) LEFT JOIN shopee_staging2.shop_category AS sc ON s.shopid = sc.shopid;

select * from fact_overview;

INSERT INTO olap_shopee.fact_promotion (
  itemid,
  shopid
)
SELECT itemid,
  shopid
FROM shopee_staging2.product;

INSERT INTO olap_shopee.fact_rating (
  itemid,
  shopid,
  follower_around_number
)
SELECT itemid,
  s.shopid,
  follower_around_number
FROM shopee_staging2.product as p JOIN shopee_staging2.shop as s WHERE s.shopid = p.shopid;


INSERT INTO olap_shopee.fact_revenue (
  location_name,
  category_id,
  shopid,
  itemid,
  date_id,
  brand_name,
  follower_around_number
)
SELECT shop_location,
  category_id,
  s.shopid,
  p.itemid,
  product_creation_date,
  brand,
  follower_around_number
FROM (shopee_staging2.shop as s JOIN shopee_staging2.product as p ON s.shopid = p.shopid) LEFT JOIN shopee_staging2.category as c ON s.shopid = c.shopid;

select * from fact_revenue;
select * from fact_overview;
select * from fact_promotion;
select * from fact_rating;

select * from v_dim_brand;
select * from v_dim_category;
select * from v_dim_date_create;
select * from v_dim_flash_sale;
select * from v_dim_follower;
select * from v_dim_location;
select * from v_dim_product;
select * from v_dim_shop;
select * from v_dim_shop_category;

