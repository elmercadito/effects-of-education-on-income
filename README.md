# Effects of Education on Income – ML Analysis Using NLSY97 Data

This project uses data from the National Longitudinal Survey of Youth 1997 (NLSY97) to apply econometric and machine learning techniques to estimate the causal effect of educational attainment on individual income levels.

## 📁 Contents

- `education_income_analysis.R` – Main R script containing all data preprocessing, modelling, and analysis steps.
- `report.pdf` – Final write-up summarizing the methodology, results, and interpretations.

## 🧠 Objective

To assess how higher education affects income levels in the United States using modern statistical learning tools, and to compare traditional econometric models (e.g., OLS) with machine learning methods (e.g., LASSO, Random Forest, Double Machine Learning).

## 📊 Methods

- Double Machine Learning (DDML)
- LASSO Regression
- Random Forest
- Ordinary Least Squares (OLS)
- Covariate control using: GPA, parental income, weeks worked, age, parental education, and more

## 📈 Key Finding

After controlling for key confounders, we estimate that holding a college degree is associated with an increase in annual income ranging from **$4,200 to $5,100**. Traditional OLS models tended to **overstate** the income premium of education compared to machine learning methods.

## 🧮 Data

- Source: National Longitudinal Survey of Youth 1997 (NLSY97), U.S. Bureau of Labour Statistics
- This analysis uses publicly available, anonymized data.
- Raw data is not included due to size and licensing, but all processing steps are reproducible from the R script.

## 📄 License

This project is released under the MIT License. See `LICENSE` for details.

## 📬 Contact

For questions or collaborations, please reach out via (https://github.com/elmercadito).
