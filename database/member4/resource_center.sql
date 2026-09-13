-- ============================================================
-- AGRISPHERE AI
-- MEMBER 4 - RESOURCE CENTER
-- COMPLETE DATABASE SETUP + DEMO DATA
-- ============================================================
--
-- Modules:
-- 1. Equipment Rental
-- 2. Labour Hiring
-- 3. Manufacturer Marketplace
-- 4. Government Schemes
-- 5. Insurance
-- 6. Agricultural Loans
--
-- NOTE:
-- Demo data in this file is for academic/project purposes.
-- Real-world scheme, insurance and loan information should
-- always be verified from official sources.
--
-- ============================================================


-- ============================================================
-- DATABASE
-- ============================================================

CREATE DATABASE IF NOT EXISTS agrisphere_resource_center;

USE agrisphere_resource_center;


-- ============================================================
-- 1. EQUIPMENT TABLE
-- ============================================================

CREATE TABLE IF NOT EXISTS equipment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50) NOT NULL,
    description TEXT,
    owner_name VARCHAR(100),
    location VARCHAR(100),
    rent_per_day DECIMAL(10,2),
    availability BOOLEAN DEFAULT TRUE,
    image_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 2. WORKERS TABLE
-- ============================================================

CREATE TABLE IF NOT EXISTS workers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    skill VARCHAR(100) NOT NULL,
    experience_years INT DEFAULT 0,
    location VARCHAR(100),
    daily_wage DECIMAL(10,2),
    availability BOOLEAN DEFAULT TRUE,
    rating DECIMAL(2,1) DEFAULT 0.0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 3. MANUFACTURERS TABLE
-- ============================================================

CREATE TABLE IF NOT EXISTS manufacturers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    location VARCHAR(100),
    phone VARCHAR(15),
    email VARCHAR(150),
    website VARCHAR(255),
    specialization VARCHAR(150),
    rating DECIMAL(2,1) DEFAULT 0.0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 4. RENTAL REQUESTS TABLE
-- ============================================================

CREATE TABLE IF NOT EXISTS rental_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    equipment_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    customer_phone VARCHAR(15),
    rental_date DATE NOT NULL,
    number_of_days INT NOT NULL,
    total_cost DECIMAL(10,2) NOT NULL,
    status VARCHAR(30) DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (equipment_id)
        REFERENCES equipment(id)
);


-- ============================================================
-- 5. HIRING REQUESTS TABLE
-- ============================================================

CREATE TABLE IF NOT EXISTS hiring_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    worker_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    customer_phone VARCHAR(15),
    hiring_date DATE NOT NULL,
    number_of_days INT NOT NULL,
    total_cost DECIMAL(10,2) NOT NULL,
    status VARCHAR(30) DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (worker_id)
        REFERENCES workers(id)
);


-- ============================================================
-- 6. GOVERNMENT SCHEMES TABLE
-- ============================================================

CREATE TABLE IF NOT EXISTS government_schemes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    eligibility TEXT,
    benefits TEXT,
    application_process TEXT,
    official_website VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 7. SCHEME REQUESTS TABLE
-- ============================================================

CREATE TABLE IF NOT EXISTS scheme_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    scheme_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    customer_phone VARCHAR(15) NOT NULL,
    location VARCHAR(100) NOT NULL,
    remarks TEXT,
    status VARCHAR(30) DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (scheme_id)
        REFERENCES government_schemes(id)
);


-- ============================================================
-- 8. INSURANCE TABLE
-- ============================================================

CREATE TABLE IF NOT EXISTS insurance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    coverage TEXT,
    eligibility TEXT,
    benefits TEXT,
    application_process TEXT,
    official_website VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 9. INSURANCE REQUESTS TABLE
-- ============================================================

CREATE TABLE IF NOT EXISTS insurance_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    insurance_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    customer_phone VARCHAR(15) NOT NULL,
    location VARCHAR(100) NOT NULL,
    remarks TEXT,
    status VARCHAR(30) DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (insurance_id)
        REFERENCES insurance(id)
);


-- ============================================================
-- 10. LOANS TABLE
-- ============================================================

CREATE TABLE IF NOT EXISTS loans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    loan_amount VARCHAR(100),
    interest_rate VARCHAR(100),
    eligibility TEXT,
    benefits TEXT,
    application_process TEXT,
    official_website VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 11. LOAN REQUESTS TABLE
-- ============================================================

CREATE TABLE IF NOT EXISTS loan_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    customer_phone VARCHAR(15) NOT NULL,
    location VARCHAR(100) NOT NULL,
    remarks TEXT,
    status VARCHAR(30) DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (loan_id)
        REFERENCES loans(id)
);


-- ============================================================
-- DEMO DATA
-- ============================================================


-- ============================================================
-- 50 EQUIPMENT DEMO RECORDS
-- ============================================================

INSERT INTO equipment
(name, type, description, owner_name, location, rent_per_day, availability)
VALUES
('Mahindra Tractor 575 DI', 'Tractor',
 '55 HP agricultural tractor suitable for ploughing and field preparation.',
 'Rajesh Patel', 'Bhopal', 2500.00, TRUE),

('Swaraj 744 FE', 'Tractor',
 'Heavy-duty tractor suitable for farming and transportation.',
 'Ramesh Verma', 'Indore', 2700.00, TRUE),

('John Deere 5310', 'Tractor',
 'Agricultural tractor suitable for multiple farming operations.',
 'Amit Sharma', 'Sehore', 3000.00, TRUE),

('Sonalika DI 750 III', 'Tractor',
 'Powerful tractor suitable for large agricultural fields.',
 'Mohan Singh', 'Dewas', 2800.00, TRUE),

('New Holland 3630', 'Tractor',
 'Versatile tractor for ploughing, sowing and transportation.',
 'Vijay Yadav', 'Vidisha', 2900.00, TRUE),

('Rotavator 6 Feet', 'Tillage',
 'Rotary tillage equipment for soil preparation.',
 'Suresh Patel', 'Bhopal', 1200.00, TRUE),

('Rotavator 7 Feet', 'Tillage',
 'Heavy-duty soil preparation machine.',
 'Dinesh Sharma', 'Indore', 1400.00, TRUE),

('Disc Plough', 'Plough',
 'Agricultural implement for primary soil tillage.',
 'Ravi Kumar', 'Sehore', 900.00, TRUE),

('Cultivator 11 Tyne', 'Cultivator',
 'Cultivator for loosening and preparing soil.',
 'Deepak Verma', 'Dewas', 850.00, TRUE),

('Seed Drill Machine', 'Sowing',
 'Machine for uniform seed placement.',
 'Arjun Patel', 'Bhopal', 1500.00, TRUE),

('Multi Crop Planter', 'Sowing',
 'Planter suitable for different agricultural crops.',
 'Manoj Singh', 'Indore', 1700.00, TRUE),

('Power Tiller', 'Tiller',
 'Compact machine for small and medium agricultural fields.',
 'Kailash Yadav', 'Sehore', 1600.00, TRUE),

('Sprayer Machine', 'Sprayer',
 'Agricultural spraying equipment for crops.',
 'Rakesh Patel', 'Vidisha', 700.00, TRUE),

('Battery Sprayer', 'Sprayer',
 'Portable battery-operated agricultural sprayer.',
 'Nitin Sharma', 'Bhopal', 450.00, TRUE),

('Boom Sprayer', 'Sprayer',
 'Large-area crop spraying equipment.',
 'Prakash Verma', 'Indore', 1100.00, TRUE),

('Water Pump 5 HP', 'Irrigation',
 'Water pump suitable for agricultural irrigation.',
 'Harish Singh', 'Sehore', 800.00, TRUE),

('Diesel Water Pump', 'Irrigation',
 'Diesel-powered irrigation water pump.',
 'Gopal Yadav', 'Dewas', 900.00, TRUE),

('Submersible Pump', 'Irrigation',
 'Electric pump for agricultural water supply.',
 'Sachin Patel', 'Bhopal', 750.00, TRUE),

('Laser Land Leveller', 'Land Leveller',
 'Precision land levelling equipment.',
 'Pankaj Sharma', 'Indore', 3500.00, TRUE),

('Power Harrow', 'Tillage',
 'Machine for fine soil preparation.',
 'Rohit Verma', 'Sehore', 1800.00, TRUE),

('Combine Harvester', 'Harvester',
 'Machine for harvesting and threshing crops.',
 'Ashok Singh', 'Vidisha', 6000.00, TRUE),

('Mini Combine Harvester', 'Harvester',
 'Compact harvesting machine for smaller farms.',
 'Vikas Yadav', 'Bhopal', 4500.00, TRUE),

('Reaper Binder', 'Harvester',
 'Machine for cutting and binding crops.',
 'Naresh Patel', 'Indore', 2500.00, TRUE),

('Paddy Transplanter', 'Planting',
 'Machine for transplanting rice seedlings.',
 'Ramesh Sharma', 'Sehore', 2200.00, TRUE),

('Vegetable Planter', 'Planting',
 'Machine for vegetable crop planting.',
 'Karan Verma', 'Dewas', 1400.00, TRUE),

('Fertilizer Spreader', 'Fertilizer',
 'Equipment for uniform fertilizer application.',
 'Mahesh Singh', 'Bhopal', 650.00, TRUE),

('Manure Spreader', 'Fertilizer',
 'Machine for spreading farm manure.',
 'Om Prakash', 'Indore', 1000.00, TRUE),

('Chaff Cutter', 'Feed Equipment',
 'Machine for cutting animal fodder.',
 'Bharat Yadav', 'Sehore', 600.00, TRUE),

('Mini Chaff Cutter', 'Feed Equipment',
 'Compact fodder cutting machine.',
 'Sunil Patel', 'Bhopal', 450.00, TRUE),

('Threshing Machine', 'Threshing',
 'Machine for separating grains from harvested crops.',
 'Mukul Sharma', 'Vidisha', 1800.00, TRUE),

('Wheat Thresher', 'Threshing',
 'Thresher designed for wheat crops.',
 'Anil Verma', 'Indore', 1900.00, TRUE),

('Maize Sheller', 'Processing',
 'Machine for removing maize kernels.',
 'Tarun Singh', 'Bhopal', 1000.00, TRUE),

('Groundnut Decorticator', 'Processing',
 'Machine for separating groundnut kernels.',
 'Ravi Yadav', 'Sehore', 1200.00, TRUE),

('Potato Harvester', 'Harvester',
 'Equipment for harvesting potatoes.',
 'Devendra Patel', 'Dewas', 2000.00, TRUE),

('Sugarcane Cutter', 'Harvester',
 'Agricultural cutting equipment for sugarcane.',
 'Jitendra Sharma', 'Indore', 2300.00, TRUE),

('Farm Trailer', 'Transport',
 'Trailer for transporting agricultural materials.',
 'Ramesh Singh', 'Bhopal', 1300.00, TRUE),

('Tractor Trolley', 'Transport',
 'Trolley for farm transportation.',
 'Mohan Yadav', 'Sehore', 1200.00, TRUE),

('Agricultural Trailer', 'Transport',
 'Heavy-duty trailer for agricultural goods.',
 'Sanjay Patel', 'Vidisha', 1500.00, TRUE),

('Brush Cutter', 'Cutting',
 'Portable machine for cutting grass and weeds.',
 'Akash Sharma', 'Bhopal', 500.00, TRUE),

('Power Weeder', 'Weeder',
 'Machine for weed removal between crop rows.',
 'Rajat Verma', 'Indore', 900.00, TRUE),

('Mini Power Weeder', 'Weeder',
 'Compact machine for small farms.',
 'Lokesh Singh', 'Sehore', 750.00, TRUE),

('Drip Irrigation Kit', 'Irrigation',
 'Basic irrigation equipment for efficient water use.',
 'Madan Yadav', 'Bhopal', 400.00, TRUE),

('Sprinkler Irrigation Set', 'Irrigation',
 'Sprinkler system for crop irrigation.',
 'Rohit Patel', 'Dewas', 550.00, TRUE),

('Solar Water Pump', 'Irrigation',
 'Solar-powered agricultural irrigation pump.',
 'Sandeep Sharma', 'Indore', 1800.00, TRUE),

('Crop Cutting Machine', 'Harvesting',
 'Machine for crop cutting operations.',
 'Kishore Verma', 'Bhopal', 1700.00, TRUE),

('Portable Generator', 'Power Equipment',
 'Generator for agricultural electrical requirements.',
 'Naveen Singh', 'Sehore', 1000.00, TRUE),

('Electric Motor Pump', 'Irrigation',
 'Electric motor pump for farm irrigation.',
 'Yash Yadav', 'Indore', 700.00, TRUE),

('Seed Cleaner', 'Processing',
 'Machine for cleaning and grading seeds.',
 'Rajendra Patel', 'Bhopal', 900.00, TRUE),

('Grain Cleaner', 'Processing',
 'Equipment for cleaning harvested grains.',
 'Pradeep Sharma', 'Vidisha', 1000.00, TRUE);


-- ============================================================
-- 50 WORKER DEMO RECORDS
-- ============================================================

INSERT INTO workers
(name, phone, skill, experience_years, location, daily_wage, availability, rating)
VALUES
('Ramesh Kumar', '9000000001', 'Tractor Operator', 8, 'Bhopal', 700.00, TRUE, 4.5),
('Suresh Patel', '9000000002', 'Tractor Operator', 10, 'Indore', 750.00, TRUE, 4.7),
('Mohan Singh', '9000000003', 'Harvesting Worker', 6, 'Sehore', 600.00, TRUE, 4.2),
('Rajesh Yadav', '9000000004', 'Irrigation Worker', 5, 'Dewas', 550.00, TRUE, 4.1),
('Vijay Sharma', '9000000005', 'Farm Labourer', 7, 'Bhopal', 500.00, TRUE, 4.0),
('Amit Verma', '9000000006', 'Sprayer Operator', 4, 'Indore', 600.00, TRUE, 4.3),
('Ravi Patel', '9000000007', 'Tractor Mechanic', 9, 'Sehore', 900.00, TRUE, 4.8),
('Deepak Singh', '9000000008', 'Farm Labourer', 5, 'Vidisha', 500.00, TRUE, 4.0),
('Arjun Yadav', '9000000009', 'Seeder Operator', 6, 'Bhopal', 650.00, TRUE, 4.4),
('Manoj Patel', '9000000010', 'Harvester Operator', 8, 'Indore', 850.00, TRUE, 4.6),
('Kailash Sharma', '9000000011', 'Irrigation Worker', 5, 'Sehore', 550.00, TRUE, 4.1),
('Rakesh Verma', '9000000012', 'Farm Labourer', 4, 'Dewas', 480.00, TRUE, 3.9),
('Nitin Singh', '9000000013', 'Tractor Operator', 7, 'Bhopal', 700.00, TRUE, 4.5),
('Prakash Yadav', '9000000014', 'Pesticide Sprayer', 5, 'Indore', 600.00, TRUE, 4.2),
('Harish Patel', '9000000015', 'Farm Labourer', 8, 'Sehore', 520.00, TRUE, 4.1),
('Gopal Sharma', '9000000016', 'Tractor Operator', 12, 'Vidisha', 800.00, TRUE, 4.9),
('Sachin Verma', '9000000017', 'Harvesting Worker', 6, 'Bhopal', 600.00, TRUE, 4.3),
('Pankaj Singh', '9000000018', 'Irrigation Worker', 7, 'Indore', 580.00, TRUE, 4.4),
('Rohit Yadav', '9000000019', 'Farm Labourer', 3, 'Sehore', 450.00, TRUE, 3.8),
('Ashok Patel', '9000000020', 'Tractor Mechanic', 11, 'Dewas', 950.00, TRUE, 4.8),
('Vikas Sharma', '9000000021', 'Seeder Operator', 5, 'Bhopal', 620.00, TRUE, 4.2),
('Naresh Verma', '9000000022', 'Farm Labourer', 6, 'Indore', 500.00, TRUE, 4.0),
('Karan Singh', '9000000023', 'Harvesting Worker', 8, 'Sehore', 650.00, TRUE, 4.5),
('Mahesh Yadav', '9000000024', 'Tractor Operator', 9, 'Vidisha', 750.00, TRUE, 4.7),
('Om Prakash', '9000000025', 'Irrigation Worker', 4, 'Bhopal', 520.00, TRUE, 4.0),
('Bharat Patel', '9000000026', 'Farm Labourer', 7, 'Indore', 500.00, TRUE, 4.1),
('Sunil Sharma', '9000000027', 'Sprayer Operator', 6, 'Sehore', 650.00, TRUE, 4.3),
('Mukul Verma', '9000000028', 'Tractor Operator', 10, 'Dewas', 750.00, TRUE, 4.6),
('Anil Singh', '9000000029', 'Harvester Operator', 9, 'Bhopal', 850.00, TRUE, 4.7),
('Tarun Yadav', '9000000030', 'Farm Labourer', 5, 'Indore', 490.00, TRUE, 4.0),
('Devendra Patel', '9000000031', 'Tractor Mechanic', 13, 'Sehore', 1000.00, TRUE, 4.9),
('Jitendra Sharma', '9000000032', 'Harvesting Worker', 7, 'Bhopal', 620.00, TRUE, 4.3),
('Sanjay Verma', '9000000033', 'Irrigation Worker', 6, 'Indore', 560.00, TRUE, 4.2),
('Akash Singh', '9000000034', 'Farm Labourer', 4, 'Dewas', 480.00, TRUE, 3.9),
('Rajat Yadav', '9000000035', 'Tractor Operator', 8, 'Sehore', 720.00, TRUE, 4.5),
('Lokesh Patel', '9000000036', 'Sprayer Operator', 5, 'Bhopal', 600.00, TRUE, 4.2),
('Madan Sharma', '9000000037', 'Seeder Operator', 7, 'Indore', 650.00, TRUE, 4.4),
('Rohit Verma', '9000000038', 'Farm Labourer', 6, 'Sehore', 500.00, TRUE, 4.0),
('Sandeep Singh', '9000000039', 'Harvesting Worker', 8, 'Vidisha', 680.00, TRUE, 4.5),
('Kishore Yadav', '9000000040', 'Tractor Operator', 11, 'Bhopal', 800.00, TRUE, 4.8),
('Naveen Patel', '9000000041', 'Irrigation Worker', 5, 'Indore', 550.00, TRUE, 4.1),
('Yash Sharma', '9000000042', 'Farm Labourer', 3, 'Sehore', 450.00, TRUE, 3.8),
('Rajendra Verma', '9000000043', 'Tractor Mechanic', 10, 'Dewas', 900.00, TRUE, 4.7),
('Pradeep Singh', '9000000044', 'Harvester Operator', 7, 'Bhopal', 800.00, TRUE, 4.5),
('Vivek Yadav', '9000000045', 'Sprayer Operator', 6, 'Indore', 620.00, TRUE, 4.3),
('Shivam Patel', '9000000046', 'Farm Labourer', 5, 'Sehore', 480.00, TRUE, 4.0),
('Rajan Sharma', '9000000047', 'Tractor Operator', 9, 'Bhopal', 730.00, TRUE, 4.6),
('Ankit Verma', '9000000048', 'Irrigation Worker', 4, 'Dewas', 520.00, TRUE, 4.1),
('Gaurav Singh', '9000000049', 'Harvesting Worker', 6, 'Indore', 620.00, TRUE, 4.3),
('Varun Yadav', '9000000050', 'Farm Labourer', 7, 'Bhopal', 510.00, TRUE, 4.1);


-- ============================================================
-- 30 MANUFACTURER DEMO RECORDS
-- ============================================================

INSERT INTO manufacturers
(name, description, location, phone, email, website, specialization, rating)
VALUES
('AgroTech Machinery', 'Agricultural machinery manufacturer and supplier.', 'Bhopal', '9100000001', 'contact@agrotech.example.com', 'https://example.com', 'Tractors and Implements', 4.5),
('Kisan Machinery Works', 'Supplier of farming equipment and machinery.', 'Indore', '9100000002', 'contact@kisanmachinery.example.com', 'https://example.com', 'Farm Machinery', 4.4),
('GreenField Equipment', 'Manufacturer of modern agricultural equipment.', 'Sehore', '9100000003', 'contact@greenfield.example.com', 'https://example.com', 'Irrigation Equipment', 4.3),
('FarmPro Industries', 'Agricultural equipment manufacturing company.', 'Dewas', '9100000004', 'contact@farmpro.example.com', 'https://example.com', 'Harvesting Machinery', 4.6),
('Bharat Agro Machines', 'Supplier of agricultural machines and tools.', 'Bhopal', '9100000005', 'contact@bharatagro.example.com', 'https://example.com', 'Tillage Equipment', 4.2),
('Shakti Farm Solutions', 'Farm machinery and irrigation solutions provider.', 'Indore', '9100000006', 'contact@shakti.example.com', 'https://example.com', 'Irrigation Systems', 4.4),
('Modern Agro Works', 'Agricultural machinery and farm tools supplier.', 'Sehore', '9100000007', 'contact@modernagro.example.com', 'https://example.com', 'Farm Implements', 4.1),
('Kisan Power Equipment', 'Manufacturer of power-operated agricultural machines.', 'Vidisha', '9100000008', 'contact@kisanpower.example.com', 'https://example.com', 'Power Equipment', 4.3),
('Rural Machinery Solutions', 'Agricultural machinery solutions for farmers.', 'Bhopal', '9100000009', 'contact@ruralmachinery.example.com', 'https://example.com', 'Tractors', 4.5),
('AgriMax Industries', 'Supplier of crop production equipment.', 'Indore', '9100000010', 'contact@agrimax.example.com', 'https://example.com', 'Crop Equipment', 4.6),
('FarmCare Machines', 'Manufacturer of farming and harvesting equipment.', 'Sehore', '9100000011', 'contact@farmcare.example.com', 'https://example.com', 'Harvesting', 4.2),
('Shree Agro Industries', 'Agricultural equipment and machinery supplier.', 'Dewas', '9100000012', 'contact@shreeagro.example.com', 'https://example.com', 'Agricultural Tools', 4.1),
('Kisan Vikas Machinery', 'Supplier of agricultural machinery.', 'Bhopal', '9100000013', 'contact@kisanvikas.example.com', 'https://example.com', 'Farm Machinery', 4.4),
('AgriWorks India', 'Agricultural machinery and equipment provider.', 'Indore', '9100000014', 'contact@agriworks.example.com', 'https://example.com', 'Tractors', 4.5),
('Green Agro Systems', 'Agricultural irrigation and machinery solutions.', 'Sehore', '9100000015', 'contact@greenagro.example.com', 'https://example.com', 'Irrigation', 4.3),
('FarmTech Solutions', 'Technology-oriented agricultural machinery supplier.', 'Bhopal', '9100000016', 'contact@farmtech.example.com', 'https://example.com', 'Smart Farm Equipment', 4.7),
('Rajasthan Agro Machines', 'Manufacturer of agricultural implements.', 'Indore', '9100000017', 'contact@ramachines.example.com', 'https://example.com', 'Implements', 4.2),
('Central India Agro', 'Agricultural machinery distributor.', 'Bhopal', '9100000018', 'contact@centralagro.example.com', 'https://example.com', 'Farm Machinery', 4.4),
('Kisan Shakti Industries', 'Manufacturer of agricultural power equipment.', 'Dewas', '9100000019', 'contact@kisanshakti.example.com', 'https://example.com', 'Power Tillers', 4.5),
('Agro Bharat Solutions', 'Supplier of agricultural machinery and tools.', 'Sehore', '9100000020', 'contact@agrobharat.example.com', 'https://example.com', 'Farm Equipment', 4.1),
('Rural Agro Machines', 'Agricultural machinery manufacturer.', 'Vidisha', '9100000021', 'contact@ruralagro.example.com', 'https://example.com', 'Harvesters', 4.6),
('FarmMaster Industries', 'Manufacturer of farm machinery and implements.', 'Bhopal', '9100000022', 'contact@farmmaster.example.com', 'https://example.com', 'Tillage Machinery', 4.3),
('AgriServe Equipment', 'Agricultural equipment supplier.', 'Indore', '9100000023', 'contact@agriserv.example.com', 'https://example.com', 'Irrigation', 4.2),
('Kisan Mitra Machines', 'Agricultural machinery solutions provider.', 'Sehore', '9100000024', 'contact@kisanmitra.example.com', 'https://example.com', 'Crop Machinery', 4.4),
('Shiv Agro Machines', 'Manufacturer of agricultural implements.', 'Dewas', '9100000025', 'contact@shivagro.example.com', 'https://example.com', 'Farm Implements', 4.3),
('AgriPower Industries', 'Manufacturer of power-driven agricultural equipment.', 'Bhopal', '9100000026', 'contact@agripower.example.com', 'https://example.com', 'Power Equipment', 4.5),
('Green Harvest Systems', 'Agricultural harvesting equipment supplier.', 'Indore', '9100000027', 'contact@greenharvest.example.com', 'https://example.com', 'Harvesting Machinery', 4.6),
('FarmLink Machinery', 'Agricultural machinery and equipment supplier.', 'Sehore', '9100000028', 'contact@farmlink.example.com', 'https://example.com', 'Agricultural Machinery', 4.2),
('AgroVision Equipment', 'Modern agricultural equipment provider.', 'Bhopal', '9100000029', 'contact@agrovision.example.com', 'https://example.com', 'Modern Farm Equipment', 4.7),
('Kisan Equipment Hub', 'Agricultural machinery marketplace supplier.', 'Indore', '9100000030', 'contact@kisanequipment.example.com', 'https://example.com', 'Farm Machinery', 4.4);


-- ============================================================
-- 10 GOVERNMENT SCHEME DEMO RECORDS
-- ============================================================

INSERT INTO government_schemes
(name, description, eligibility, benefits, application_process, official_website)
VALUES

('PM-KISAN',
 'Income support scheme for eligible farmer families.',
 'Eligible landholding farmer families as per applicable government rules.',
 'Provides financial support to eligible beneficiaries.',
 'Apply through the designated government portal or authorized service center.',
 'https://pmkisan.gov.in/'),

('Pradhan Mantri Fasal Bima Yojana',
 'Crop insurance scheme providing protection against specified crop losses.',
 'Eligible farmers growing notified crops in notified areas.',
 'Insurance coverage against eligible crop-related risks.',
 'Farmers can apply through notified channels within applicable deadlines.',
 'https://pmfby.gov.in/'),

('Kisan Credit Card',
 'Credit facility designed to provide timely agricultural credit.',
 'Eligible farmers and agricultural borrowers subject to lender rules.',
 'Access to credit for agricultural and related activities.',
 'Application can be made through participating banks and financial institutions.',
 'https://www.india.gov.in/'),

('PM-KUSUM',
 'Scheme supporting solar energy applications in agriculture.',
 'Eligible farmers and other categories as defined under the scheme.',
 'Supports solar pumps and renewable energy solutions for agriculture.',
 'Application is handled through designated state agencies and portals.',
 'https://mnre.gov.in/'),

('Soil Health Card Scheme',
 'Provides farmers with information about soil health and nutrient requirements.',
 'Farmers whose agricultural land is covered under the programme.',
 'Helps farmers understand soil nutrients and fertilizer requirements.',
 'Soil samples are collected and tested through designated facilities.',
 'https://soilhealth.dac.gov.in/'),

('e-NAM',
 'Electronic national agriculture market platform connecting agricultural markets.',
 'Farmers and market participants associated with participating markets.',
 'Improves access to agricultural markets and price information.',
 'Registration and participation is through the e-NAM platform and markets.',
 'https://www.enam.gov.in/'),

('Agriculture Infrastructure Fund',
 'Financing support for eligible agricultural infrastructure projects.',
 'Eligible beneficiaries and projects according to scheme guidelines.',
 'Facilitates investment in post-harvest and agricultural infrastructure.',
 'Applications are submitted through the designated online system.',
 'https://agriinfra.dac.gov.in/'),

('Pradhan Mantri Krishi Sinchayee Yojana',
 'Programme supporting improved irrigation and water-use efficiency.',
 'Eligible beneficiaries under applicable components.',
 'Supports irrigation development and efficient water management.',
 'Implementation and applications are handled through designated authorities.',
 'https://pmksy.gov.in/'),

('Paramparagat Krishi Vikas Yojana',
 'Supports promotion of organic farming practices.',
 'Farmers participating in eligible organic farming programmes.',
 'Encourages sustainable and organic agricultural practices.',
 'Application is managed through designated agricultural departments.',
 'https://pgsindia-ncof.gov.in/'),

('National Mission for Sustainable Agriculture',
 'Supports sustainable agricultural practices and resource conservation.',
 'Eligible farmers and agricultural stakeholders under applicable programmes.',
 'Promotes sustainable farming, soil management and efficient resource use.',
 'Implementation is through relevant government departments.',
 'https://agriculture.gov.in/');


-- ============================================================
-- 5 INSURANCE DEMO RECORDS
-- ============================================================

INSERT INTO insurance
(name, description, coverage, eligibility, benefits, application_process, official_website)
VALUES

('Pradhan Mantri Fasal Bima Yojana',
 'Crop insurance support for eligible notified crops.',
 'Coverage against specified crop losses and risks according to policy terms.',
 'Eligible farmers cultivating notified crops.',
 'Financial protection against covered crop losses.',
 'Apply through authorized channels within applicable crop-season deadlines.',
 'https://pmfby.gov.in/'),

('Weather Based Crop Insurance',
 'Insurance based on specified weather parameters.',
 'Coverage depends on notified weather-related conditions and policy terms.',
 'Farmers growing eligible notified crops.',
 'Protection against specified weather-related risks.',
 'Application through participating insurers or authorized channels.',
 'https://www.india.gov.in/'),

('Crop Insurance Assistance',
 'Agricultural insurance assistance for eligible crop activities.',
 'Coverage depends on selected policy and notified conditions.',
 'Eligible agricultural producers according to applicable policy rules.',
 'Helps reduce financial impact of covered crop losses.',
 'Contact the participating insurer or authorized service center.',
 'https://www.india.gov.in/'),

('Agricultural Insurance Support',
 'Insurance information and assistance for agricultural activities.',
 'Coverage varies according to the selected insurance product.',
 'Eligibility varies by policy and agricultural activity.',
 'Risk protection for eligible agricultural activities.',
 'Submit application through the relevant insurer or authorized channel.',
 'https://www.india.gov.in/'),

('Livestock Insurance',
 'Insurance protection for eligible livestock.',
 'Coverage depends on livestock category and policy conditions.',
 'Eligible livestock owners subject to applicable rules.',
 'Financial protection against covered livestock risks.',
 'Application through participating insurers or local authorized agencies.',
 'https://www.india.gov.in/');


-- ============================================================
-- 10 AGRICULTURAL LOAN DEMO RECORDS
-- ============================================================

INSERT INTO loans
(name, description, loan_amount, interest_rate, eligibility, benefits, application_process, official_website)
VALUES

('Kisan Credit Card (KCC)',
 'Credit facility for eligible farmers to meet agricultural and related expenses.',
 'As per lender assessment and applicable KCC limits',
 'As per lender and applicable government guidelines',
 'Eligible farmers and agricultural borrowers subject to lender rules.',
 'Flexible agricultural credit for eligible farming requirements.',
 'Apply through participating banks or financial institutions.',
 'https://www.india.gov.in/'),

('Agriculture Infrastructure Fund',
 'Financing support for eligible agricultural infrastructure projects.',
 'As per project and lender assessment',
 'As per applicable scheme and lender terms',
 'Eligible beneficiaries and infrastructure projects.',
 'Supports investment in agricultural infrastructure.',
 'Application through the designated financing platform.',
 'https://agriinfra.dac.gov.in/'),

('Pradhan Mantri Mudra Yojana',
 'Credit support for eligible micro and small business activities.',
 'As per applicable lender category and assessment',
 'As per lender terms',
 'Eligible micro and small entrepreneurs according to scheme rules.',
 'Supports income-generating business activities.',
 'Apply through participating banks and financial institutions.',
 'https://www.mudra.org.in/'),

('Farm Mechanization Loan',
 'Loan facility for purchasing eligible agricultural machinery.',
 'As per lender assessment',
 'As per lender terms',
 'Farmers meeting lender eligibility requirements.',
 'Helps finance agricultural machinery and equipment.',
 'Apply through participating financial institutions.',
 'https://www.india.gov.in/'),

('Dairy Farming Loan',
 'Financing option for eligible dairy farming activities.',
 'As per project cost and lender assessment',
 'As per lender terms',
 'Eligible dairy farmers and applicants.',
 'Supports dairy animals and related infrastructure.',
 'Apply through participating banks or financial institutions.',
 'https://www.nabard.org/'),

('Agri Business Loan',
 'Financing support for eligible agriculture-related businesses.',
 'As per business plan and lender assessment',
 'As per lender terms',
 'Eligible agricultural entrepreneurs and businesses.',
 'Supports establishment or expansion of agriculture-related businesses.',
 'Submit application and required documents to a participating lender.',
 'https://www.india.gov.in/'),

('Crop Production Loan',
 'Short-term credit for eligible crop production activities.',
 'As per crop, land and lender assessment',
 'As per lender terms',
 'Eligible farmers according to applicable lending rules.',
 'Supports seeds, fertilizers, labour and other crop expenses.',
 'Apply through participating agricultural banks.',
 'https://www.india.gov.in/'),

('Livestock Loan',
 'Financing option for eligible livestock-related activities.',
 'As per project cost and lender assessment',
 'As per lender terms',
 'Eligible livestock farmers and entrepreneurs.',
 'Supports purchase and management of eligible livestock activities.',
 'Apply through participating financial institutions.',
 'https://www.nabard.org/'),

('Agri Gold Loan',
 'Loan facility against eligible gold assets for agricultural requirements.',
 'As per gold value and lender assessment',
 'As per lender terms',
 'Eligible applicants meeting lender requirements.',
 'Provides access to funds against eligible security.',
 'Apply through participating banks or financial institutions.',
 'https://www.india.gov.in/'),

('Education Loan for Agricultural Studies',
 'Education financing option for eligible agricultural education programmes.',
 'As per course and lender assessment',
 'As per lender terms',
 'Eligible students meeting lender requirements.',
 'Supports eligible education-related expenses.',
 'Apply through the relevant bank or financial institution.',
 'https://www.vidyalakshmi.co.in/');


-- ============================================================
-- VERIFY RECORD COUNTS
-- ============================================================

SELECT 'Equipment' AS module, COUNT(*) AS total_records
FROM equipment

UNION ALL

SELECT 'Workers', COUNT(*)
FROM workers

UNION ALL

SELECT 'Manufacturers', COUNT(*)
FROM manufacturers

UNION ALL

SELECT 'Government Schemes', COUNT(*)
FROM government_schemes

UNION ALL

SELECT 'Insurance', COUNT(*)
FROM insurance

UNION ALL

SELECT 'Loans', COUNT(*)
FROM loans;


-- ============================================================
-- END OF RESOURCE CENTER DATABASE
-- ============================================================