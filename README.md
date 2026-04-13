# UniFlow – Prototype Information System

## 📌 Project Overview
This mobile application is a functional prototype developed as part of the digital transformation strategy for **BrightWave Enterprises**. The system is designed to support university students in managing their academic workload, improving operational efficiency, and aiding decision-making regarding assignment priorities.

## 🚀 Key Features
* **Sticky Header Dashboard:** Assignments are organized by Year and Semester using advanced Flutter Slivers for better data visualization.
* **Persistent Storage:** Uses a local **SQLite** database to manage assignment records.
* **Detailed Analytics View:** A dedicated screen for each assignment displaying complexity scores, weight percentages, and due dates to support better planning.
* **Task Management:** Ability to track status (Planned, In Progress, Done) and evaluate progress.

## 🛠 Tech Stack
* **Framework:** Flutter (Dart)
* **Database:** SQLite (sqflite package)
* **State Management:** FutureBuilder for asynchronous data handling

## 📊 Data Analysis & Business Value
The prototype allows for analyzing trends within academic data, such as:
* **Workload Distribution:** Identifying semesters with the highest concentration of high-complexity tasks.
* **Strategic Prioritization:** Helping users focus on assignments with higher grade weighting (weight_percent).

## 🏁 How to Run
1. Clone the repository.
2. Ensure Flutter is installed.
3. Run `flutter pub get`.
4. Launch the app using `flutter run`.
