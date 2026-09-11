# AgriSphere AI - Member 4 Resource Center

## Overview

Member 4 is responsible for the Resource Center module of AgriSphere AI.

The Resource Center provides farmers with access to agricultural equipment,
skilled labour, manufacturers, government schemes, insurance information,
and agricultural loan information.

---

## Features

The Resource Center contains six major modules:

1. Equipment Rental
2. Labour Hiring
3. Manufacturer Marketplace
4. Government Schemes
5. Insurance
6. Agricultural Loans

---

## Technology Stack

### Frontend
- HTML
- CSS
- JavaScript

### Backend
- Python
- Flask
- Flask-CORS

### Database
- MySQL

---

# 1. Equipment Rental

Farmers can browse agricultural equipment available for rental.

### Features

- View available equipment
- View equipment details
- Check location
- Check rent per day
- Check availability
- Submit rental request

### Main Database Tables

- `equipment`
- `rental_requests`

---

# 2. Labour Hiring

Farmers can find agricultural workers based on their skills and location.

### Features

- View workers
- View worker skills
- View experience
- View location
- View daily wage
- View availability
- View rating
- Submit hiring request

### Main Database Tables

- `workers`
- `hiring_requests`

---

# 3. Manufacturer Marketplace

Farmers can explore agricultural machinery manufacturers and suppliers.

### Features

- View manufacturers
- View specialization
- View description
- View location
- View contact information
- View website
- View rating

### Main Database Table

- `manufacturers`

---

# 4. Government Schemes

Farmers can explore government agricultural schemes and financial assistance.

### Features

- View available schemes
- View scheme description
- View eligibility
- View benefits
- View application process
- View official website
- Submit assistance request

### Main Database Tables

- `government_schemes`
- `scheme_requests`

---

# 5. Insurance

Farmers can explore agricultural and farming insurance options.

### Features

- View insurance options
- View coverage
- View eligibility
- View benefits
- View application process
- View official website
- Submit insurance assistance request

### Main Database Tables

- `insurance`
- `insurance_requests`

---

# 6. Agricultural Loans

Farmers can explore different agricultural loan options.

### Features

- View loan options
- View loan amount information
- View interest rate information
- View eligibility
- View benefits
- View application process
- Submit loan assistance request
- Calculate estimated EMI

### Main Database Tables

- `loans`
- `loan_requests`

---

# EMI Calculator

The Agricultural Loans page contains a simple client-side EMI calculator.

The user enters:

- Loan Amount
- Annual Interest Rate
- Loan Tenure

The calculator displays:

- Monthly EMI
- Total Interest
- Total Amount Payable

The EMI calculation is performed using JavaScript and does not require
a database request.

---

# Backend API Structure

The Resource Center backend uses Flask Blueprints.

### Equipment

```text
GET /api/resource/equipment
GET /api/resource/equipment/<id>
POST /api/resource/equipment/<id>/rent