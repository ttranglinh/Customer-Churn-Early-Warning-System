CREATE TABLE raw.members (
    msno TEXT,
    city INTEGER,
    bd INTEGER,
    gender TEXT,
    registered_via INTEGER,
    registration_init_time INTEGER
);

CREATE TABLE raw.transactions (
    msno TEXT,
    payment_method_id INTEGER,
    payment_plan_days INTEGER,
    plan_list_price INTEGER,
    actual_amount_paid INTEGER,
    is_auto_renew INTEGER,
    transaction_date INTEGER,
    membership_expire_date INTEGER,
    is_cancel INTEGER
);

CREATE TABLE raw.user_logs (
    msno TEXT,
    date INTEGER,
    num_25 INTEGER,
    num_50 INTEGER,
    num_75 INTEGER,
    num_985 INTEGER,
    num_100 INTEGER,
    num_unq INTEGER,
    total_secs NUMERIC
);

CREATE TABLE raw.train (
    msno TEXT,
    is_churn INTEGER
);