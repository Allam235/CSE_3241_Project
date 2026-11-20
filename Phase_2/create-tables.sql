PRAGMA foreign_keys = ON;

--Clubs and Facilities

CREATE TABLE CLUB (
    club_id INTEGER NOT NULL,
    location_name TEXT NOT NULL,
    street_address TEXT NOT NULL,
    main_phone_number TEXT NOT NULL,
    opening_date TEXT NOT NULL,
    locker_price REAL NOT NULL,
    PRIMARY KEY (club_id)
) STRICT;

CREATE TABLE FACILITY_AREA (
    club_id INTEGER NOT NULL,
    area_code TEXT NOT NULL,
    area_name TEXT NOT NULL,
    maximum_occupancy INTEGER NOT NULL,
    PRIMARY KEY (club_id, area_code),
    FOREIGN KEY (club_id) REFERENCES CLUB(club_id)
) STRICT;

--Membership

CREATE TABLE MEMBERSHIP_TIER (
    tier_code TEXT NOT NULL,
    tier_name TEXT NOT NULL,
    tire_monthly_pass REAL NOT NULL,
    PRIMARY KEY (tier_code)
) STRICT;

CREATE TABLE MEMBER (
    member_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone_number TEXT NOT NULL,
    date_of_birth TEXT NOT NULL,
    enrollment_date TEXT NOT NULL,
    membership_status TEXT NOT NULL,
    club_id INTEGER NOT NULL,
    tier_code TEXT NOT NULL,
    PRIMARY KEY (member_id),
    FOREIGN KEY (club_id) REFERENCES CLUB(club_id),
    FOREIGN KEY (tier_code) REFERENCES MEMBERSHIP_TIER(tier_code)
) STRICT;

CREATE TABLE EMERGENCY_CONTACT (
    member_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    relation TEXT NOT NULL,
    number TEXT NOT NULL,
    PRIMARY KEY (member_id),
    FOREIGN KEY (member_id) REFERENCES MEMBER(member_id)
) STRICT;

CREATE TABLE MEMBERSHIP_COST (
    tier_code TEXT NOT NULL,
    club_id INTEGER NOT NULL,
    monthly_base_fee REAL NOT NULL,
    PRIMARY KEY (tier_code, club_id),
    FOREIGN KEY (tier_code) REFERENCES MEMBERSHIP_TIER(tier_code),
    FOREIGN KEY (club_id) REFERENCES CLUB(club_id)
) STRICT;

CREATE TABLE CHECK_IN (
    check_in_id TEXT NOT NULL,
    check_in_timestamp TEXT NOT NULL,
    member_id INTEGER NOT NULL,
    club_id INTEGER NOT NULL,
    PRIMARY KEY (check_in_id),
    FOREIGN KEY (member_id) REFERENCES MEMBER(member_id),
    FOREIGN KEY (club_id) REFERENCES CLUB(club_id)
) STRICT;

--Staff

CREATE TABLE STAFF (
    staff_id INTEGER NOT NULL,
    employee_name TEXT NOT NULL,
    hire_date TEXT NOT NULL,
    salary REAL NOT NULL,
    role TEXT NOT NULL,
    club_id INTEGER NOT NULL,
    PRIMARY KEY (staff_id),
    FOREIGN KEY (club_id) REFERENCES CLUB(club_id)
) STRICT;

CREATE TABLE STAFF_SHIFT (
    shift_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,
    club_id INTEGER NOT NULL,
    shift_date TEXT NOT NULL,
    start_time TEXT NOT NULL,
    end_time TEXT NOT NULL,
    PRIMARY KEY (shift_id),
    FOREIGN KEY (staff_id) REFERENCES STAFF(staff_id),
    FOREIGN KEY (club_id) REFERENCES CLUB(club_id)
) STRICT;

--Staff Subclasses

CREATE TABLE FRONT_DESK (
    staff_id INTEGER NOT NULL,
    PRIMARY KEY (staff_id),
    FOREIGN KEY (staff_id) REFERENCES STAFF(staff_id)
) STRICT;

CREATE TABLE GENERAL_MANAGER (
    staff_id INTEGER NOT NULL,
    managed_club_id INTEGER NOT NULL,
    PRIMARY KEY (staff_id),
    FOREIGN KEY (staff_id) REFERENCES STAFF(staff_id),
    FOREIGN KEY (managed_club_id) REFERENCES CLUB(club_id)
) STRICT;

CREATE TABLE MAINTENANCE_PERSONNEL (
    staff_id INTEGER NOT NULL,
    PRIMARY KEY (staff_id),
    FOREIGN KEY (staff_id) REFERENCES STAFF(staff_id)
) STRICT;

CREATE TABLE TRAINER (
    staff_id INTEGER NOT NULL,
    training_specialty TEXT NOT NULL,
    bio TEXT NOT NULL,
    PRIMARY KEY (staff_id),
    FOREIGN KEY (staff_id) REFERENCES STAFF(staff_id)
) STRICT;

--Trainer Subclasses

CREATE TABLE SENIOR_PERSONAL_TRAINERS (
    staff_id INTEGER NOT NULL,
    PRIMARY KEY (staff_id),
    FOREIGN KEY (staff_id) REFERENCES TRAINER(staff_id)
) STRICT;

CREATE TABLE JUNIOR_PERSONAL_TRAINERS (
    staff_id INTEGER NOT NULL,
    mentor_id INTEGER,
    PRIMARY KEY (staff_id),
    FOREIGN KEY (staff_id) REFERENCES TRAINER(staff_id),
    FOREIGN KEY (mentor_id)
        REFERENCES SENIOR_PERSONAL_TRAINERS(staff_id)
) STRICT;

--Training and Fitness Classes

CREATE TABLE CATALOG_TRAINING (
    unique_code TEXT NOT NULL,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    intensity_rating INTEGER NOT NULL,
    PRIMARY KEY (unique_code)
) STRICT;

CREATE TABLE GROUP_TRAINING (
    class_session_id INTEGER NOT NULL,
    unique_code TEXT NOT NULL,
    club_id INTEGER NOT NULL,
    area_code TEXT NOT NULL,
    trainer_id INTEGER NOT NULL,
    session_date TEXT NOT NULL,
    start_time TEXT NOT NULL,
    end_time TEXT NOT NULL,
    PRIMARY KEY (class_session_id),
    FOREIGN KEY (unique_code)
        REFERENCES CATALOG_TRAINING(unique_code),
    FOREIGN KEY (club_id) REFERENCES CLUB(club_id),
    FOREIGN KEY (trainer_id) REFERENCES TRAINER(staff_id),
    FOREIGN KEY (club_id, area_code)
        REFERENCES FACILITY_AREA(club_id, area_code)
) STRICT;

CREATE TABLE TRAINING_REGISTRATION (
    registration_id INTEGER NOT NULL,
    class_session_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    registration_timestamp TEXT NOT NULL,
    status TEXT NOT NULL,
    PRIMARY KEY (registration_id),
    FOREIGN KEY (class_session_id)
        REFERENCES GROUP_TRAINING(class_session_id),
    FOREIGN KEY (member_id) REFERENCES MEMBER(member_id)
) STRICT;

CREATE TABLE PERSONAL_TRAINING (
    session_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,
    date TEXT NOT NULL,
    time_slot TEXT NOT NULL,
    duration INTEGER NOT NULL,
    status TEXT NOT NULL,
    session_fee REAL NOT NULL,
    trainer_notes TEXT,
    PRIMARY KEY (session_id),
    FOREIGN KEY (member_id) REFERENCES MEMBER(member_id),
    FOREIGN KEY (staff_id) REFERENCES TRAINER(staff_id)
) STRICT;

--Lockers

CREATE TABLE LOCKER (
    club_id INTEGER NOT NULL,
    locket_location TEXT NOT NULL,
    locker_number TEXT NOT NULL,
    combination_code TEXT NOT NULL,
    PRIMARY KEY (club_id, locker_number),
    FOREIGN KEY (club_id) REFERENCES CLUB(club_id)
) STRICT;

CREATE TABLE LOCKER_RENTAL (
    rental_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    club_id INTEGER NOT NULL,
    locker_number TEXT NOT NULL,
    start_date TEXT NOT NULL,
    end_date TEXT,
    monthly_rate REAL NOT NULL,
    PRIMARY KEY (rental_id),
    FOREIGN KEY (member_id) REFERENCES MEMBER(member_id),
    FOREIGN KEY (club_id, locker_number)
        REFERENCES LOCKER(club_id, locker_number)
) STRICT;

--Pro Shop
CREATE TABLE PRO_Shop (
    club_id INTEGER NOT NULL,
    store_name TEXT NOT NULL,
    square_footage INTEGER NOT NULL,
    PRIMARY KEY (club_id),
    FOREIGN KEY (club_id) REFERENCES CLUB(club_id)
)STRICT;

CREATE TABLE ITEM (
    item_code TEXT NOT NULL,
    item_name TEXT NOT NULL,
    category TEXT NOT NULL,
    standard_retail_price REAL NOT NULL,
    PRIMARY KEY (item_code)
) STRICT;

CREATE TABLE SHOP_INVENTORY (
    club_id INTEGER NOT NULL,
    item_code TEXT NOT NULL,
    quantity_in_stock INTEGER NOT NULL,
    PRIMARY KEY (club_id, item_code),
    FOREIGN KEY (club_id) REFERENCES PRO_SHOP(club_id),
    FOREIGN KEY (item_code) REFERENCES ITEM(item_code)
)STRICT;

CREATE TABLE SHOP_TRANSACTION (
    purchase_id INTEGER NOT NULL,
    club_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,
    purchase_timestamp TEXT NOT NULL,
    payment_choice TEXT NOT NULL,
    PRIMARY KEY (purchase_id),
    FOREIGN KEY (club_id) REFERENCES CLUB(club_id),
    FOREIGN KEY (member_id) REFERENCES MEMBER(member_id),
    FOREIGN KEY (staff_id) REFERENCES STAFF(staff_id)
) STRICT;

CREATE TABLE PURCHASE_ITEM (
    purchase_id INTEGER NOT NULL,
    item_code TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price REAL NOT NULL,
    PRIMARY KEY (purchase_id, item_code),
    FOREIGN KEY (purchase_id)
        REFERENCES SHOP_TRANSACTION(purchase_id),
    FOREIGN KEY (item_code) REFERENCES ITEM(item_code)
) STRICT;

-- Saved Payment Methods

CREATE TABLE CREDIT_CARD (
    card_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    token TEXT NOT NULL,
    expiration_date TEXT NOT NULL,
    billing_code TEXT NOT NULL,
    is_auto_pay INTEGER NOT NULL,
    PRIMARY KEY (card_id),
    FOREIGN KEY (member_id) REFERENCES MEMBER(member_id),
    CHECK (is_auto_pay IN (0, 1))
) STRICT;

CREATE TABLE ACH_ACCOUNT (
    account_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    bank_name TEXT NOT NULL,
    acc_holder_name TEXT NOT NULL,
    acc_type TEXT NOT NULL,
    routing_number TEXT NOT NULL,
    masked_bank_acc_number TEXT NOT NULL,
    is_auto_pay INTEGER NOT NULL,
    PRIMARY KEY (account_id),
    FOREIGN KEY (member_id) REFERENCES MEMBER(member_id),
    CHECK (is_auto_pay IN (0, 1))
) STRICT;

-- Invoices

CREATE TABLE INVOICE (
    invoice_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    billing_date TEXT NOT NULL,
    billing_period TEXT NOT NULL,
    total_balance_due REAL NOT NULL,
    PRIMARY KEY (invoice_id),
    FOREIGN KEY (member_id) REFERENCES MEMBER(member_id)
) STRICT;

CREATE TABLE INVOICE_LINE_ITEM (
    invoice_id INTEGER NOT NULL,
    line_item_id INTEGER NOT NULL,
    description TEXT NOT NULL,
    amount REAL NOT NULL,
    charge_type TEXT NOT NULL,
    PRIMARY KEY (invoice_id, line_item_id),
    FOREIGN KEY (invoice_id) REFERENCES INVOICE(invoice_id)
) STRICT;

-- Payments

CREATE TABLE PAYMENT (
    payment_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    staff_id INTEGER,
    payment_timestamp TEXT NOT NULL,
    amount REAL NOT NULL,
    status TEXT NOT NULL,
    payment_method TEXT NOT NULL,
    card_id INTEGER,
    account_id INTEGER,
    PRIMARY KEY (payment_id),
    FOREIGN KEY (member_id) REFERENCES MEMBER(member_id),
    FOREIGN KEY (staff_id) REFERENCES STAFF(staff_id),
    FOREIGN KEY (card_id) REFERENCES CREDIT_CARD(card_id),
    FOREIGN KEY (account_id) REFERENCES ACH_ACCOUNT(account_id)
) STRICT;

CREATE TABLE PAYMENT_ALLOCATION (
    payment_id INTEGER NOT NULL,
    invoice_id INTEGER NOT NULL,
    allocated_amount REAL NOT NULL,
    PRIMARY KEY (payment_id, invoice_id),
    FOREIGN KEY (payment_id) REFERENCES PAYMENT(payment_id),
    FOREIGN KEY (invoice_id) REFERENCES INVOICE(invoice_id)
) STRICT;