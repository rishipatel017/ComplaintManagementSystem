# Complaint Management System (CMS)

A **Complaint Management System** is a Java-based web application developed using **Java Servlets, JSP, Maven, MySQL, HTML, CSS, JavaScript, and Bootstrap**. The system enables students/users to register, log in, submit complaints, monitor complaint status, and allows administrators to manage complaints efficiently through a dedicated dashboard.

---

# Project Overview

The Complaint Management System is designed to digitize the complaint handling process in educational institutions or organizations. Instead of maintaining complaints manually, users can submit complaints online, while administrators can review, update, and resolve complaints through an admin panel.

The application follows the **MVC (Model-View-Controller)** architecture for better maintainability and scalability.

---

# Features

## User Module

* User Registration
* Secure Login
* Submit Complaint
* View Submitted Complaints
* Complaint Details
* Withdraw Complaint
* View Dashboard
* Submit Feedback
* Logout

---

## Admin Module

* Secure Admin Login
* View All Complaints
* View Complaint Details
* Update Complaint Status
* Manage Complaints
* Generate Audit Reports
* View Dashboard
* Logout

---

# Technology Stack

## Frontend

* HTML5
* CSS3
* Bootstrap 5
* JavaScript
* JSP (Java Server Pages)

---

## Backend

* Java
* Java Servlets
* JDBC
* Maven

---

## Database

* MySQL

---

## Build Tool

* Apache Maven

---

## Server

* Apache Tomcat 9+

---

# Project Architecture

```
Client (Browser)
        │
        ▼
 JSP Pages + Bootstrap UI
        │
        ▼
Java Servlets (Controller Layer)
        │
        ▼
DAO Layer (JDBC)
        │
        ▼
MySQL Database
```

---

# Project Structure

```
ComplaintManagementSystem
│
├── src
│   ├── main
│   │   ├── java
│   │   │
│   │   └── in.ac.adit.cms
│   │       ├── controller
│   │       ├── dao
│   │       ├── model
│   │       ├── util
│   │       └── filter
│   │
│   ├── resources
│   │      cmsdb.sql
│   │
│   └── webapp
│       └── WEB-INF
│           ├── web.xml
│           └── jsp
│
├── pom.xml
└── README.md
```

---

# MVC Components

## Controller Layer

Servlets responsible for handling HTTP requests.

* LoginServlet
* RegisterServlet
* DashboardServlet
* ComplaintListServlet
* ComplaintDetailServlet
* SubmitComplaintServlet
* WithdrawComplaintServlet
* FeedbackServlet
* AdminComplaintServlet
* AuditReportServlet
* LogoutServlet

---

## DAO Layer

Handles all database operations using JDBC.

### ComplaintDAO

Responsible for:

* Add Complaint
* Fetch Complaints
* Update Complaint
* Delete Complaint
* Complaint Details

### UserDAO

Responsible for:

* User Registration
* User Login
* User Validation

---

## Model Layer

### User.java

Contains:

* User ID
* Name
* Email
* Password
* Role

### Complaint.java

Contains:

* Complaint ID
* Title
* Description
* Category
* Status
* Date
* User ID

---

## Utility Layer

### DBUtil.java

Responsible for:

* Database Connection
* JDBC Configuration
* Connection Management

---

## Filter

### NoCacheFilter.java

Prevents browser caching after logout for better security.

---

# JSP Pages

| Page                  | Description          |
| --------------------- | -------------------- |
| login.jsp             | User Login           |
| register.jsp          | User Registration    |
| student_dashboard.jsp | Student Dashboard    |
| admin_dashboard.jsp   | Admin Dashboard      |
| submit.jsp            | Submit Complaint     |
| list.jsp              | Complaint List       |
| detail.jsp            | Complaint Details    |
| admin_list.jsp        | Admin Complaint List |

---

# Database

Database Name

```
cmsdb
```

Import

```
src/main/resources/cmsdb.sql
```

---

# Database Tables (Example)

## users

| Field    | Type    |
| -------- | ------- |
| id       | INT     |
| name     | VARCHAR |
| email    | VARCHAR |
| password | VARCHAR |
| role     | VARCHAR |

---

## complaints

| Field          | Type    |
| -------------- | ------- |
| complaint_id   | INT     |
| title          | VARCHAR |
| description    | TEXT    |
| category       | VARCHAR |
| status         | VARCHAR |
| complaint_date | DATE    |
| user_id        | INT     |

---

## feedback

| Field       | Type |
| ----------- | ---- |
| feedback_id | INT  |
| user_id     | INT  |
| feedback    | TEXT |

---

# Application Workflow

```
User Registration
        │
        ▼
User Login
        │
        ▼
Dashboard
        │
        ▼
Submit Complaint
        │
        ▼
Complaint Stored in MySQL
        │
        ▼
Admin Views Complaint
        │
        ▼
Admin Updates Status
        │
        ▼
User Views Updated Status
```

---

# Bootstrap Components Used

* Navbar
* Cards
* Buttons
* Forms
* Tables
* Alerts
* Badges
* Modal
* Grid System
* Responsive Layout

---

# Frontend Technologies

* HTML5
* CSS3
* Bootstrap
* JavaScript
* JSP

---

# Backend Technologies

* Java
* Servlet API
* JDBC
* Maven

---

# Security Features

* Session Management
* Login Authentication
* Role-Based Access (Admin/User)
* No Cache Filter
* Logout Session Invalidation

---

# Maven Dependencies

Typical dependencies include:

* Servlet API
* JSTL
* MySQL Connector/J

---

# Prerequisites

* Java JDK 8 or above
* Apache Maven
* Apache Tomcat 9+
* MySQL Server
* Eclipse IDE (or IntelliJ IDEA)

---

# Installation

## Clone Repository

```bash
git clone <repository-url>
```

---

## Import Project

Import the project as an **Existing Maven Project** in Eclipse.

---

## Create Database

```sql
CREATE DATABASE cmsdb;
```

Import:

```
cmsdb.sql
```

---

## Configure Database

Update database credentials inside:

```
DBUtil.java
```

Example:

```java
private static final String URL = "jdbc:mysql://localhost:3306/cmsdb";
private static final String USER = "root";
private static final String PASSWORD = "your_password";
```

---

## Build Project

```bash
mvn clean install
```

---

## Deploy

Deploy the generated WAR file on Apache Tomcat.

---

## Run

```
http://localhost:8080/ComplaintManagementSystem
```

---

# Future Enhancements

* Email Notifications
* SMS Notifications
* Complaint Attachments
* Complaint Categories
* Search & Filter
* Pagination
* Complaint Priority
* Admin Analytics Dashboard
* REST API
* Spring Boot Migration
* Hibernate/JPA Integration
* JWT Authentication
* Responsive Mobile UI

---

# Learning Outcomes

This project demonstrates practical implementation of:

* Java Servlets
* JSP
* MVC Architecture
* JDBC
* Maven
* MySQL
* Session Handling
* Authentication
* CRUD Operations
* Bootstrap Responsive Design
* DAO Design Pattern

---

# Author

**Name:** *Rishi Patel*

**Course:** Bachelor of Engineering (Computer Engineering)

**Institute:** ADIT (A.D. Patel Institute of Technology)

---

# License

This project is developed for educational purposes and can be freely modified and extended for learning and academic use.
