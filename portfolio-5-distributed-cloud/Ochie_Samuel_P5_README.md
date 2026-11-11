# Portfolio 5: Distributed and Cloud Database Architecture Report
**Student Name:** Samuel Ochie (ID: 301930377)  
**Case Study:** Library Management System  

---

## 1. Executive Summary & Objectives
To support seamless catalogue searches, instantaneous book checkouts, and high-volume concurrent access across multiple campuses or regions, the Library Management System is architected as a distributed, fault-tolerant cloud application. 

This design targets **99.99% availability**, sub-50ms query latency, and zero data loss during regional outages.

---

## 2. Cloud Infrastructure Topology
The proposed cloud deployment utilizes a multi-tier, multi-region architecture hosted on a major cloud provider (e.g., AWS):

1. **Global Traffic Management (DNS & CDN):**
   * **AWS Route 53** uses latency-based routing to direct user requests to the nearest regional data center.
   * Static assets (book cover images, front-end portal bundles) are cached globally via a Content Delivery Network (**CloudFront**).

2. **Application Compute Tier:**
   * Incoming traffic hits regional **Application Load Balancers (ALB)**.
   * Stateless backend container services run inside an **Auto-Scaling Group (ASG)** across multiple **Availability Zones (AZs)**, automatically scaling up during peak exam periods when student loan requests surge.

3. **Caching Layer:**
   * A distributed **Redis Cache Cluster** is deployed in front of the database layer to cache frequent catalogue searches, ISBN lookups, and active session tokens, reducing database CPU load by over 60%.

---

## 3. Distributed Database Strategy & Replication
To prevent single points of failure and handle heavy read/write imbalances:

* **Primary-Replica (Master-Slave) Architecture:**
  * **Primary Write Node:** Handles all write-heavy operations, such as new member registrations, book check-outs (`Loans`), and fine payments.
  * **Asynchronous Read Replicas:** Multiple read nodes distributed across secondary availability zones handle read-heavy operations, such as catalogue searches (`SELECT` queries on `Books` and `Categories`).
* **Multi-Region Replication:**
  * Cross-region replication ensures that if an entire data center experiences an outage, a secondary region can be promoted to primary status with minimal Recovery Point Objective (RPO).

---

## 4. Scalability, Sharding, and Partitioning
As the library system scales to millions of historical circulation logs over decades:
* **Horizontal Sharding:** The massive `Loans` and `Fines` tables are horizontally sharded based on `BorrowerID` hash ranges or regional campus branches. This ensures that historical query performance remains constant regardless of dataset size.
* **NoSQL Integration for Document Stores:** Unstructured audit logs and borrower notification archives are offloaded to distributed NoSQL document stores (such as MongoDB Atlas global clusters) featuring automatic chunk-based data distribution.

---

## 5. Consistency, Availability, and the CAP Theorem
In a globally distributed library system, network partitions (`P`) are inevitable. Following the **CAP Theorem**:
* **CP Configuration for Financial & Inventory Data:** Operations involving book inventory stock decrements and overdue fine settlements prioritize **Consistency (C)** over absolute availability. Using two-phase commits and distributed locks ensures a book's stock quantity can never drop below zero due to race conditions.
* **AP Configuration for Catalogue Browsing:** Public catalogue searches prioritize **Availability (A)** and partition tolerance, allowing students to browse book lists even if a regional replica node is temporarily out of sync.