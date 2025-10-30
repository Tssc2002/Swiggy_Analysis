# 🍴 Swiggy Data Analysis Project  

### 📊 Comprehensive Data Analytics Case Study using SQL, Excel, Power BI & Python  

This project demonstrates **end-to-end analytics and storytelling** using Swiggy-like food delivery data.  
It combines **SQL, Excel, Power BI, and Python** to uncover deep business insights — from raw data to dashboards and machine learning-driven patterns.

---

## 📁 Project Structure  

```
Swiggy_Analysis/
│
├── data/
│   ├── users.xlsx
│   ├── restaurant.xlsx
│   ├── menu.xlsx
│   ├── orders.xlsx
│   ├── orders_Type.xlsx
│   └── food.xlsx
│
├── sql/
│   └── Swiggy_EDA.sql
│
├── python/
│   └── Swiggy_Analysis.ipynb
│
├── dashboard/
│   └── Swiggy_Insights.pbix
│
├── reports/
│   └── Summary_Report.pdf
│
└── README.md
```

---

## 🧠 Objectives  

- Understand user behavior, order frequency, and retention trends  
- Analyze top restaurants, cuisines, and revenue streams  
- Evaluate delivery type performance (Pickup vs Delivery)  
- Predict order demand and analyze feature importance  
- Build an **interactive Power BI dashboard** for management insights  

---

## 🧩 Datasets Overview  

| File Name | Description |
|------------|--------------|
| `users.xlsx` | Contains user demographics and app activity |
| `restaurant.xlsx` | Restaurant details (location, ratings, cuisine type) |
| `menu.xlsx` | Menu items, pricing, and restaurant linkage |
| `food.xlsx` | Food categories and ingredients metadata |
| `orders.xlsx` | Transaction-level order details |
| `orders_Type.xlsx` | Delivery type details (Pickup / Delivery) |

---

## 🧮 Data Analysis Process  

### 🔹 Step 1: Data Loading  
All Excel files were loaded into **SQL Server** for cleaning and relational joins.

### 🔹 Step 2: Data Cleaning  
- Removed duplicates, handled nulls, and standardized categorical entries  
- Enforced foreign key constraints between tables  

### 🔹 Step 3: SQL Exploratory Data Analysis  
Key metrics derived using SQL queries:  
- Active users & order frequency  
- Restaurant performance by rating, cuisine, and city  
- Delivery time vs rating correlation  
- Revenue contribution per restaurant  
- Cohort retention and customer repeat rate  

---

## 🐍 Python Analysis  

Python was used for **data visualization, statistical analysis, and feature engineering** beyond SQL & Power BI capabilities.  

### 🔸 Libraries Used  
- **Pandas** → Data preprocessing, joins, aggregations  
- **Matplotlib / Seaborn** → Visualization (heatmaps, trends, category analysis)  
- **Scikit-learn** → Feature importance estimation using Random Forest  
- **NumPy** → Numerical transformations  
- **Jupyter Notebook** → For structured, step-by-step analysis  

### 🔸 Analysis Performed  
1. **Data Preprocessing:**  
   - Merged datasets and validated schema integrity  
   - Converted timestamps and extracted date features (month, weekday, hour)

2. **Exploratory Analysis:**  
   - Revenue & order count per city  
   - Correlation between delivery time and ratings  
   - Distribution of order amounts  
   - Outlier detection in pricing  

3. **Feature Engineering:**  
   - Derived metrics like *Avg Order Value*, *Customer Lifetime Orders*, and *Order Frequency*  

4. **Predictive Analysis (Optional):**  
   - Used Random Forest to estimate feature importance in predicting total order value  
   - Visualized top predictors such as *Delivery Time*, *Discount*, and *Restaurant Rating*  

---

## 📊 Power BI Dashboard  

Interactive dashboard featuring:  
- KPIs: Total Orders, Active Users, Total Revenue, Avg Order Value  
- Order trend by weekday/hour  
- Top Restaurants by revenue  
- Cuisines by popularity  
- Delivery type comparison  
- Regional performance and satisfaction trends  

---

## 📈 Key Insights  

- **Top Cuisine:** North Indian & Fast Food dominate major metros  
- **High Repeat Rate:** 35% of users order 5+ times/month  
- **Revenue Driver:** Zesty Grillhouse leads in monthly revenue  
- **Best Delivery Slot:** 7 PM – 9 PM  
- **Correlation:** Lower delivery time = higher customer rating  

---

## 🛠️ Tools & Technologies  

| Tool | Purpose |
|------|----------|
| **SQL Server** | Data cleaning, transformation & EDA |
| **Excel** | Data validation & verification |
| **Python (Pandas, Seaborn, Scikit-learn)** | Advanced analytics & feature modeling |
| **Power BI** | Visualization and dashboard |
| **GitHub** | Version control & collaboration |

---

## 🚀 How to Use  

1. Clone the repository  
   ```bash
   git clone https://github.com/Tssc2002/Swiggy_Analysis.git
   ```
2. Run `Swiggy_EDA.sql` in SQL Server  
3. Open `python/Swiggy_Analysis.ipynb` to run Python analysis  
4. Load cleaned data into Power BI and open `Swiggy_Insights.pbix`  

---

## 💡 Future Enhancements  

- Add **machine learning pipeline** for order prediction  
- Deploy **interactive Power BI dashboard** on web  
- Add **API integration** for real-time restaurant data  

---

## 👨‍💻 Author  

**Sri Sai Chowadry Thati**  
Data Analyst | SQL | Power BI | Excel | Python  
srisaichowdary1210@gmail.com

