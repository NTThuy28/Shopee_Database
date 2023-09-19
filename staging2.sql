CREATE TABLE category (
    category_id INT,
    category_name VARCHAR(50),
    shopid BIGINT
);

CREATE TABLE shop (
    shopid BIGINT,
    userid INT,
    username VARCHAR(50),
    shop_name VARCHAR(50),
    follower_around_number VARCHAR(50),
    follower_count INT,
    create_date DATE,
    create_time TIME,
    rating_star FLOAT,
    item_count INT,
    response_rate INT,
    rating_normal INT,
    rating_bad INT,
    rating_good INT,
    is_shopee_verified VARCHAR(10),
    is_mart VARCHAR(20),
    is_preferred_plus_seller VARCHAR(10)
);

CREATE TABLE shop_category (
    shop_category_id INT,
    display_name VARCHAR(255),
    shopid BIGINT,
    total INT
);

CREATE TABLE shop_category (
    shop_category_id INT,
    display_name VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    shopid BIGINT,
    total INT
);

CREATE TABLE product (
    itemid BIGINT NOT NULL PRIMARY KEY,
    product_name VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    product_creation_date DATE,
    product_creation_time TIME,
    name_tier_variation VARCHAR(50),
    option_variation TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci, 
    shopid BIGINT,
    currency VARCHAR(5),
    stock INT,
    sold INT,
    historical_sold INT,
    shop_location VARCHAR(50),
    liked_count INT,
    brand VARCHAR(50),
    item_status VARCHAR(10),
    price INT,
    price_min INT,
    price_max INT,
    has_lowest_price_guarantee VARCHAR(10),
    show_discount INT,
    is_adult VARCHAR(10),
    is_cc_installment_payment_eligible VARCHAR(10),
    show_free_shipping VARCHAR(10),
    can_use_bundle_deal VARCHAR(10),
    can_use_wholesale VARCHAR(10),
    has_model_with_available_shopee_stock VARCHAR(10),
    can_use_cod VARCHAR(10),
    voucher_id BIGINT,
    voucher_code VARCHAR(30),
    voucher_cash_discount INT,
    voucher_percentage INT,
    voucher_coin_refund INT,
    add_on_deal_id INT,
    add_on_deal_label VARCHAR(20),
    bundle_deal_id INT,
    buy INT,
    get_off_cash INT,
    get_off_percentage INT,
    hidden_promotion_price VARCHAR(20),
    deep_promotion_price INT,
    exclusive_price_promotion_id BIGINT,
    exclusive_save_amount INT,
    exclusive_label VARCHAR(50),
    exclusive_model_ep_price INT,
    exclusive_model_ep_discount INT,
    discount_condition_code VARCHAR(20),
    discount_condition_percentage INT,
    discount_condition_cash INT,
    condition_discount INT, 
    cmt_count INT,
    rating_star FLOAT,
    rating_count INT,
    rcount_with_context INT,
    rcount_with_image INT,
    rating_count_1 INT,
    rating_count_2 INT,
    rating_count_3 INT,
    rating_count_4 INT,
    rating_count_5 INT,
    score FLOAT,
    is_on_flash_sale VARCHAR(10),
    flash_sale_ongoing_sold_count INT,
    flash_sale_stock INT,
    flash_sale_counts INT
);

select * from shopee_staging2.category;
select * from shopee_staging2.shop;
select * from shopee_staging2.shop_category;
select * from shopee_staging2.product;

delete from shopee_staging2.category;
delete from shopee_staging2.shop;
delete from shopee_staging2.shop_category;
delete from shopee_staging2.product;