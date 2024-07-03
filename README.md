# **Project Overview:**

This project aims to create a personal finance management app that helps users track and manage their expenses automatically. The app integrates with bank email notifications to update transactions in real-time and presents the data in a user-friendly iOS interface.

## **Key Features:**

### **Automated Transaction Updates:**
The app listens for incoming bank email notifications and automatically extracts transaction details using AWS SES and Lambda.

**GraphQL API:**
A flexible and efficient GraphQL API, powered by AWS AppSync or Apollo Server, allows for managing transactions and querying data.

**Database Storage:**
Transactions and user data are stored in Amazon DynamoDB, ensuring scalability and reliability.

**iOS Application:**
A native iOS app built with SwiftUI displays the user's transaction data in an intuitive and visually appealing interface.
Users can view, update, and manage their transactions easily.

## **Technical Stack:**
### **Backend:**
- AWS SES, AWS SNS, AWS Lambda (Email Processing)
- AWS AppSync or Apollo Server (GraphQL API)
- TypeScript (Backend Language)

### **Database:**
- Amazon DynamoDB

### **Frontend:**
- SwiftUI (iOS UI)
- Apollo Client for Swift (GraphQL Integration)
