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
    FOREIGN KEY (managed_club_id) REFERENCES CLUB(club_id),
    UNIQUE (managed_club_id)
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
    FOREIGN KEY (member_id) REFERENCES MEMBER(member_id),
    UNIQUE (class_session_id, member_id)
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